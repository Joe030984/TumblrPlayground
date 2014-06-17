//
//  TumblrDialogue.h
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatPost;

@interface TumblrDialogue : NSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phrase;
@property (nonatomic, retain) ChatPost *chat_post;

@end
