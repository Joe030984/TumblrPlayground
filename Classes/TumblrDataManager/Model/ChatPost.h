//
//  ChatPost.h
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TumblrPost.h"


@interface ChatPost : TumblrPost

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSOrderedSet *dialogue;
@end

@interface ChatPost (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inDialogueAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDialogueAtIndex:(NSUInteger)idx;
- (void)insertDialogue:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDialogueAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDialogueAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceDialogueAtIndexes:(NSIndexSet *)indexes withDialogue:(NSArray *)values;
- (void)addDialogueObject:(NSManagedObject *)value;
- (void)removeDialogueObject:(NSManagedObject *)value;
- (void)addDialogue:(NSOrderedSet *)values;
- (void)removeDialogue:(NSOrderedSet *)values;
@end
