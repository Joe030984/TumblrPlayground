//
//  JRSViewController.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "JRSViewController.h"
#import "TumblrDataManager.h"
#import "TumblrPost.h"

static const CGFloat sc_loadMoreOffset = 150.0; //!< Offset from the top of content to start infinite scroll loading

@implementation JRSViewController
{
    id observer_;
    NSString *currentBlog_;
    NSString *officialBlogName_;
    int currentPage_;
    BOOL loading_;
    
    NSFetchedResultsController *fetchedResultsController_;
    UITableView *tableView_;
    UIRefreshControl *refresh_;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer_];
    fetchedResultsController_.delegate = nil;
    tableView_.dataSource = nil;
    tableView_.delegate = nil;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView_ = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView_.dataSource = self;
    tableView_.delegate = self;
    [self.view addSubview:tableView_];
    
    refresh_ = [[UIRefreshControl alloc] init];
    refresh_.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh"];
    [refresh_ addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [tableView_ addSubview:refresh_];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:[TumblrDataManager class]
                                                                action:@selector(deleteAllTumblrPosts)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Load"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(loadBlog)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    __weak typeof(self) weakSelf = self;
    observer_ = [[NSNotificationCenter defaultCenter] addObserverForName:BlogNameUpdateNotification
                                                                  object:nil
                                                                   queue:[NSOperationQueue mainQueue]
                                                              usingBlock:^(NSNotification *note) {
                                                                  __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                  if (strongSelf != nil)
                                                                  {
                                                                      if ([note.userInfo[@"providedName"] isEqualToString:strongSelf->currentBlog_])
                                                                      {
                                                                          strongSelf->officialBlogName_ = note.userInfo[@"officialName"];
                                                                          [strongSelf->tableView_ reloadData];
                                                                          [strongSelf->refresh_ endRefreshing];
                                                                          strongSelf->loading_ = NO;
                                                                      }
                                                                  }
                                                              }];
}

#pragma mark - Private Class Methods

- (void)loadBlog
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What blog do you want to see?"
                                                    message:@"Enter the username or tumblr URL of the blog to load"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Load", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)refresh
{
    if (!loading_)
    {
        loading_ = YES;
        currentPage_ = 0;
        [TumblrDataManager loadTumblrForName:currentBlog_ page:currentPage_];
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController_ == nil && officialBlogName_ != nil)
    {
        fetchedResultsController_ = [TumblrDataManager tumblrPostFetchedResultsControllerForBlog:officialBlogName_];
        fetchedResultsController_.delegate = self;
        
        NSError *error = nil;
        if (![fetchedResultsController_ performFetch:&error])
        {
            NSLog(@"Could not fetch Conversations: (%ld) %@", (long)error.code, error.localizedDescription);
            fetchedResultsController_ = nil;
        }
    }
    return fetchedResultsController_;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // If we are close enough to the bottom of the content to load more, the content isn't smaller than one page,
    // and we aren't currently loading more from the API, tell the TumblrDataManager to load the next page of content.
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - sc_loadMoreOffset &&
        scrollView.contentSize.height > scrollView.frame.size.height &&
        !loading_)
    {
        loading_ = YES;
        [TumblrDataManager loadTumblrForName:currentBlog_ page:++currentPage_];
    }
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row < self.fetchedResultsController.fetchedObjects.count)
    {
        TumblrPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"JRS - selected post: %@", post);
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.fetchedResultsController.fetchedObjects.count)
    {
        TumblrPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        static NSString *cellReuseId = @"TumblrPostCellResuseId";
        UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:cellReuseId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseId];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"Type: %@", post.type];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Timestamp: %@",
                                     [NSDate dateWithTimeIntervalSince1970:[post.timestamp doubleValue]]];
        return cell;
    }
    else
    {
        static NSString *cellReuseId = @"EmptyCellReuseId";
        UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:cellReuseId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseId];
        }
        return cell;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate Methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [tableView_ reloadData];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        NSString *blog = [alertView textFieldAtIndex:0].text;
        if (blog.length > 0)
        {
            if ([blog isEqualToString:@"currentBlog"])
            {
                currentPage_++;
            }
            else
            {
                currentBlog_ = [blog copy];
                officialBlogName_ = nil;
                currentPage_ = 0;
                fetchedResultsController_.delegate = nil;
                fetchedResultsController_ = nil;
                [tableView_ reloadData];
            }
            [TumblrDataManager loadTumblrForName:blog page:currentPage_];
        }
    }
}

@end
