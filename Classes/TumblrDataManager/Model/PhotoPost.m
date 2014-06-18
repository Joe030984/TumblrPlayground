//
//  PhotoPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "PhotoPost.h"
#import "TumblrPhoto.h"


@implementation PhotoPost

@dynamic caption;
@dynamic photos;

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
    
    for (NSDictionary *photo in dictionary[@"photos"])
    {
        // Create photo object with the photo
    }
}

@end
