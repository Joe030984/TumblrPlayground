//
//  LinkPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "LinkPost.h"


@implementation LinkPost

@dynamic title;
@dynamic url;
@dynamic link_description;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate
{
    [super updateWithDictionary:dictionary inContext:context fullUpdate:fullUpdate];
    
    if (dictionary[@"title"] != nil && dictionary[@"title"] != [NSNull null])
    {
        self.title = dictionary[@"title"];
    }
    else if (fullUpdate)
    {
        self.title = nil;
    }
    
    if (dictionary[@"url"] != nil && dictionary[@"url"] != [NSNull null])
    {
        self.url = dictionary[@"url"];
    }
    else if (fullUpdate)
    {
        self.url = nil;
    }
    
    if (dictionary[@"link_description"] != nil && dictionary[@"link_description"] != [NSNull null])
    {
        self.link_description = dictionary[@"link_description"];
    }
    else if (fullUpdate)
    {
        self.link_description = nil;
    }
}

@end
