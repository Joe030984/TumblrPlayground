//
//  TumblrPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "TumblrPost.h"


@implementation TumblrPost

@dynamic blog_name;
@dynamic identifier;
@dynamic timestamp;
@dynamic type;
@dynamic source_url;
@dynamic source_title;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate
{
    if (dictionary == nil || context == nil)
    {
        return;
    }
    
    if (dictionary[@"blog_name"] != nil)
    {
        self.blog_name = dictionary[@"blog_name"];
    }
    else if (fullUpdate)
    {
        self.blog_name = nil;
    }
    
    if (dictionary[@"id"] != nil)
    {
        self.identifier = dictionary[@"id"];
    }
    else if (fullUpdate)
    {
        self.identifier = nil;
    }
    
    if (dictionary[@"timestamp"] != nil)
    {
        self.timestamp = dictionary[@"timestamp"];
    }
    else if (fullUpdate)
    {
        self.timestamp = nil;
    }
    
    if (dictionary[@"type"] != nil)
    {
        self.type = dictionary[@"type"];
    }
    else if (fullUpdate)
    {
        self.type = nil;
    }
    
    if (dictionary[@"source_url"] != nil)
    {
        self.source_url = dictionary[@"source_url"];
    }
    else if (fullUpdate)
    {
        self.source_url = nil;
    }
    
    if (dictionary[@"source_title"] != nil)
    {
        self.source_title = dictionary[@"source_title"];
    }
    else if (fullUpdate)
    {
        self.source_title = nil;
    }
}

@end
