//
//  PhotoPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/17/14.
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
    
    // Remove and delete old photo objects
    for (TumblrPhoto *photo in [self.photos copy])
    {
        [self removePhotosObject:photo];
        [context deleteObject:photo];
    }
    
    // Create and add all the new photo objects
    int index = 0;
    for (NSDictionary *photoDict in dictionary[@"photos"])
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TumblrPhoto"
                                                  inManagedObjectContext:context];
        TumblrPhoto *photo = (TumblrPhoto *)[[NSManagedObject alloc] initWithEntity:entity
                                                              insertIntoManagedObjectContext:context];
        photo.index = @(index);
        
        if (photoDict[@"caption"] != nil && photoDict[@"caption"] != [NSNull null])
        {
            photo.caption = photoDict[@"caption"];
        }
        
        if (photoDict[@"width"] != nil && photoDict[@"width"] != [NSNull null])
        {
            photo.width = photoDict[@"width"];
        }
        
        if (photoDict[@"height"] != nil && photoDict[@"height"] != [NSNull null])
        {
            photo.height = photoDict[@"height"];
        }
        
        if (photoDict[@"url"] != nil && photoDict[@"url"] != [NSNull null])
        {
            photo.url = photoDict[@"url"];
        }
        
        [self addPhotosObject:photo];
        
        index++;
    }
}

@end
