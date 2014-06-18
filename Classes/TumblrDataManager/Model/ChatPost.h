//
//  ChatPost.h
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/17/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TumblrPost.h"

@class TumblrDialogue;

@interface ChatPost : TumblrPost

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *dialogue;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate;

@end

@interface ChatPost (CoreDataGeneratedAccessors)

- (void)addDialogueObject:(TumblrDialogue *)value;
- (void)removeDialogueObject:(TumblrDialogue *)value;
- (void)addDialogue:(NSSet *)values;
- (void)removeDialogue:(NSSet *)values;

@end
