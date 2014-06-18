//
//  JRSViewController.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "JRSViewController.h"
#import "TumblrDataManager.h"

@implementation JRSViewController
{
    id observer_;
    NSString *currentBlog_;
    NSString *officialBlogName_;
    int currentPage_;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer_];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
                                                                          // TODO: update fetched results controller
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

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        NSString *blog = [alertView textFieldAtIndex:0].text;
        if (blog.length > 0)
        {
//            if ([blog rangeOfString:@".tumblr.com" options:NSCaseInsensitiveSearch].location == NSNotFound)
//            {
//                blog = [blog stringByAppendingString:@".tumblr.com"];
//            }
            if ([blog isEqualToString:@"currentBlog"])
            {
                currentPage_++;
            }
            else
            {
                currentBlog_ = [blog copy];
                officialBlogName_ = nil;
                currentPage_ = 0;
            }
            [TumblrDataManager loadTumblrForName:blog page:currentPage_];
        }
    }
}

@end
