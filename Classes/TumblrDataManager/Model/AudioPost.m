//
//  AudioPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "AudioPost.h"


@implementation AudioPost

@dynamic caption;
@dynamic player;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate
{
    [super updateWithDictionary:dictionary inContext:context fullUpdate:fullUpdate];
    
    if (dictionary[@"caption"] != nil && dictionary[@"caption"] != [NSNull null])
    {
        self.caption = dictionary[@"caption"];
    }
    else if (fullUpdate)
    {
        self.caption = nil;
    }
    
    if (dictionary[@"player"] != nil && dictionary[@"player"] != [NSNull null])
    {
        self.player = dictionary[@"player"];
    }
    else if (fullUpdate)
    {
        self.player = nil;
    }
}

@end
