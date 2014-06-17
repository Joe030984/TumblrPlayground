//
//  TumblrPost.h
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TumblrPost : NSManagedObject

@property (nonatomic, retain) NSString * blog_name;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSNumber * total_posts;
@property (nonatomic, retain) NSString * source_url;
@property (nonatomic, retain) NSString * source_title;

@end
