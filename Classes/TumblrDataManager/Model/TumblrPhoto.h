//
//  TumblrPhoto.h
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/17/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoPost;

@interface TumblrPhoto : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) PhotoPost *photo_post;

@end
