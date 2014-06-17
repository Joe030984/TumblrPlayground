//
//  QuotePost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "QuotePost.h"


@implementation QuotePost

@dynamic text;
@dynamic source;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate
{
    [super updateWithDictionary:dictionary inContext:context fullUpdate:fullUpdate];
    
    if (dictionary[@"text"] != nil)
    {
        self.text = dictionary[@"text"];
    }
    else if (fullUpdate)
    {
        self.text = nil;
    }
    
    if (dictionary[@"source"] != nil)
    {
        self.source = dictionary[@"source"];
    }
    else if (fullUpdate)
    {
        self.source = nil;
    }
}

@end
