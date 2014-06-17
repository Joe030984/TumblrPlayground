//
//  TumblrDataManager.h
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TumblrDataManager : NSObject

/**
 * Convenience method to access the main managed object context for the persistant store.
 * This should be used for UI-related actions, like with NSFetchedResultsControllers.
 */
+ (NSManagedObjectContext *)mainManagedObjectContext;

/**
 * Convenience method to access the private managed object context for the persistant store.
 * This should be used when making CoreData changes on a background thread (such as handling
 * API responses).
 */
+ (NSManagedObjectContext *)privateManagedObjectContext;

#pragma mark - API Interaction Methods

//! Method to load a given Tumblr blog
+ (void)loadTumblrForName:(NSString *)blogName more:(BOOL)more;

@end
