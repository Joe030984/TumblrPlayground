//
//  VideoPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "VideoPost.h"


@implementation VideoPost

@dynamic caption;
@dynamic player;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate
{
    [super updateWithDictionary:dictionary inContext:context fullUpdate:fullUpdate];
    
    if (dictionary[@"caption"] != nil)
    {
        self.caption = dictionary[@"caption"];
    }
    else if (fullUpdate)
    {
        self.caption = nil;
    }
    
    if (dictionary[@"player"] != nil && [dictionary[@"player"] count] > 0)
    {
        self.player = [dictionary[@"player"] lastObject][@"embed_code"];
    }
    else if (fullUpdate)
    {
        self.player = nil;
    }
}

@end
