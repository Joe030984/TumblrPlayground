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
            if ([blog rangeOfString:@".tumblr.com" options:NSCaseInsensitiveSearch].location == NSNotFound)
            {
                blog = [blog stringByAppendingString:@".tumblr.com"];
            }
            [TumblrDataManager loadTumblrForName:blog more:NO];
        }
    }
}

@end
