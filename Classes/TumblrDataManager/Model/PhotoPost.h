//
//  PhotoPost.h
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TumblrPost.h"

@class TumblrPhoto;

@interface PhotoPost : TumblrPost

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSSet *photos;
@end

@interface PhotoPost (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(TumblrPhoto *)value;
- (void)removePhotosObject:(TumblrPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
