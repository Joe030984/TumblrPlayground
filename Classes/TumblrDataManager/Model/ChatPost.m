//
//  ChatPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "ChatPost.h"


@implementation ChatPost

@dynamic title;
@dynamic body;
@dynamic dialogue;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate
{
    [super updateWithDictionary:dictionary inContext:context fullUpdate:fullUpdate];
    
    if (dictionary[@"title"] != nil)
    {
        self.title = dictionary[@"title"];
    }
    else if (fullUpdate)
    {
        self.title = nil;
    }
    
    if (dictionary[@"body"] != nil)
    {
        self.body = dictionary[@"body"];
    }
    else if (fullUpdate)
    {
        self.body = nil;
    }
    
    for (NSDictionary *dialogue in dictionary[@"dialogue"])
    {
        // Create dialogue object with the photo
    }
}

@end
