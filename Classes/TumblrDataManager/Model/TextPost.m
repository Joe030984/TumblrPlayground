//
//  TextPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "TextPost.h"


@implementation TextPost

@dynamic title;
@dynamic body;

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
}

@end
