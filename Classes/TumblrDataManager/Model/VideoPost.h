//
//  VideoPost.h
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TumblrPost.h"

@interface VideoPost : TumblrPost

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * player;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate;

@end
