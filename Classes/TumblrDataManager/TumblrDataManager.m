//
//  TumblrDataManager.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "TumblrDataManager.h"
#import "TMAPIClient.h"
#import "TumblrPost.h"

NSString * const BlogNameUpdateNotification = @"BlogNameUpdateNotification";

@implementation TumblrDataManager
{
    // Core Data instance variables
    NSManagedObjectModel *objectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
    NSManagedObjectContext *mainObjectContext_;
    NSManagedObjectContext *privateObjectContext_;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        [TMAPIClient sharedInstance].OAuthConsumerKey = @"dX4P8pl7xJz1lx9tgQXPVf2pJ0SKY6qDKo8hwtpFz6KcbO4lVt";
        [TMAPIClient sharedInstance].OAuthConsumerSecret = @"vCRKc77JXIpmHheZxAxQdBVAwXEhIVM7quhoDZdJIKDERs5Xt1";
    }
    return self;
}

//! Method to access the sharedInstance for the class. Shouldn't be used outside of categories.
+ (TumblrDataManager *)sharedInstance
{
    static dispatch_once_t pred;
    static TumblrDataManager *s_sharedInstance = nil;
    dispatch_once(&pred, ^(void) {
        s_sharedInstance = [[TumblrDataManager alloc] init];
    });
    return s_sharedInstance;
}

#pragma mark - Public Class Methods

+ (NSManagedObjectContext *)mainManagedObjectContext
{
    TumblrDataManager *manager = [TumblrDataManager sharedInstance];
    @synchronized(manager)
    {
        return [manager mainObjectContext];
    }
}

+ (NSManagedObjectContext *)privateManagedObjectContext
{
    TumblrDataManager *manager = [TumblrDataManager sharedInstance];
    @synchronized(manager)
    {
        if (manager->privateObjectContext_ == nil)
        {
            manager->privateObjectContext_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            manager->privateObjectContext_.persistentStoreCoordinator = [manager persistentStoreCoordinator];
            manager->privateObjectContext_.undoManager = nil;
            // Changes currently in memory take precendence over changes being merged in from the main persistant store
            manager->privateObjectContext_.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        }
        return manager->privateObjectContext_;
    }
}

#pragma mark - API Interaction Methods

+ (void)loadTumblrForName:(NSString *)blogName page:(int)page
{
    [[TumblrDataManager privateManagedObjectContext] performBlock:^(void) {
        [[TMAPIClient sharedInstance] posts:blogName
                                       type:nil
                                 parameters:@{@"offset" : @(page)}
                                   callback:^(NSDictionary *result, NSError *error) {
            if (error)
            {
                NSLog(@"An error occurred fetching %@: (%ld) %@",
                      blogName, (long)error.code, error.localizedDescription);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"An error occurred fetching the blog"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            NSManagedObjectContext *context = [TumblrDataManager privateManagedObjectContext];
            NSError *coreDataError = nil;
                                       
            [[NSNotificationCenter defaultCenter] postNotificationName:BlogNameUpdateNotification
                                                                object:[TumblrDataManager class]
                                                              userInfo:@{@"providedName" : blogName,
                                                                         @"officialName" : result[@"blog"][@"name"]}];
            
            // Gather a set of all post IDs to use for duplicate matching
            NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
            for (NSDictionary *post in result[@"posts"])
            {
                if (post[@"id"] == nil || post[@"id"] == [NSNull null])
                {
                    continue;
                }
                NSString *identifier = [NSString stringWithFormat:@"%@", post[@"id"]];
                identifiers[identifier] = post;
            }
            
            // Find all TumblrPosts that are both in the database and in the API response. These should be updated
            // directly rather than created so that there are no duplicates.
            NSFetchRequest *updateRequest = [NSFetchRequest fetchRequestWithEntityName:@"TumblrPost"];
            updateRequest.predicate = [NSPredicate predicateWithFormat:@"(identifier IN %@)", [identifiers allKeys]];
            coreDataError = nil;
            NSArray *items = [context executeFetchRequest:updateRequest error:&coreDataError];
            if (coreDataError != nil)
            {
                NSLog(@"An error occurred attempting to fetch TumblrPosts to update: (%ld) %@",
                      (long)coreDataError.code, coreDataError.localizedDescription);
            }
            
            // Update all matching TumblrPosts directly.
            for (TumblrPost *item in items)
            {
                NSDictionary *updateDict = [identifiers objectForKey:item.identifier];
                [item updateWithDictionary:updateDict inContext:context fullUpdate:YES];
                // Delete the API data about that TumblrPost from the caches so that no duplicates are created
                [identifiers removeObjectForKey:item.identifier];
            }
            
            // For any TumblrPosts left, we need to create new objects and store them in the database
            for (NSDictionary *post in [identifiers allValues])
            {
                // Creating the object also adds it to the database
                [TumblrPost updatedTumblrPostWithDictionary:post inContext:context fullUpdate:YES];
            }
            
            error = nil;
            [context save:&error];
            if (error != nil)
            {
                NSLog(@"An error occurred attempting to save TumblrPosts: (%ld) %@",
                      (long)error.code, error.localizedDescription);
            }
        }];
    }];
}

+ (NSFetchedResultsController *)tumblrPostFetchedResultsControllerForBlog:(NSString *)blog
{
    // Create a fetch request for all Conversations that are for the currently logged in member, sorted
    // by timestamp.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TumblrPost"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(blog_name == %@)", blog];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO]];
    fetchRequest.fetchBatchSize = 50;
    
    // Return an NSFetchedResultsController using the defined fetch request
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:[TumblrDataManager mainManagedObjectContext]
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
}

+ (void)deleteAllTumblrPosts
{
    [[TumblrDataManager privateManagedObjectContext] performBlock:^(void) {
        NSFetchRequest *deleteRequest = [NSFetchRequest fetchRequestWithEntityName:@"TumblrPost"];
        deleteRequest.includesPropertyValues = NO; // Only fetch the NSManagedObjectIDs
        NSError *error = nil;
        NSArray *items = [[TumblrDataManager privateManagedObjectContext] executeFetchRequest:deleteRequest error:&error];
        if (error != nil)
        {
            NSLog(@"An error occurred attempting to fetch TunblrPosts to delete: (%ld) %@",
                  (long)error.code, error.localizedDescription);
        }
        for (NSManagedObject *object in items)
        {
            [[TumblrDataManager privateManagedObjectContext] deleteObject:object];
        }
        error = nil;
        [[TumblrDataManager privateManagedObjectContext] save:&error];
        if (error != nil)
        {
            NSLog(@"An error occurred attempting to delete TumblrPosts: (%ld) %@",
                  (long)error.code, error.localizedDescription);
        }
    }];
}

#pragma mark - Private Class Methods

#pragma mark Core Data Methods

//! Lazy getter for the model of the data stored in the database
- (NSManagedObjectModel *)objectModel
{
    if (objectModel_ == nil)
    {
        // Create the NSManagedObjectModel only on the main thread
        if (![NSThread isMainThread])
        {
            [self performSelectorOnMainThread:@selector(objectModel)
                                   withObject:nil
                                waitUntilDone:YES];
            return objectModel_;
        }
        
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"TumblrPlayground" ofType:@"momd"];
        objectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    }
    return objectModel_;
}

//! Lazy getter for the Core Data store coordinator
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator_ == nil)
    {
        // Create the NSPersistentStoreCoordinator only on the main thread
        if (![NSThread isMainThread])
        {
            [self performSelectorOnMainThread:@selector(persistentStoreCoordinator)
                                   withObject:nil
                                waitUntilDone:YES];
            return persistentStoreCoordinator_;
        }
        // Get the paths to the SQLite file
        NSString *storePath = [[self sharedDocumentsPath] stringByAppendingPathComponent:@"TumblrPlayground.sqlite"];
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        
        // Define the Core Data version migration options
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @(YES),
                                  NSInferMappingModelAutomaticallyOption       : @(YES)};
        
        // Attempt to load the persistent store
        NSError *error = nil;
        persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.objectModel];
        if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:options
                                                               error:&error])
        {
#if DEBUG
            // In local DEBUG builds, just delete the database and start from scratch, which should
            // remove the need to delete the app when the CoreData model changes.
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
            persistentStoreCoordinator_ = nil;
            return [self persistentStoreCoordinator];
#else
            NSLog(@"Fatal error while creating persistent store: %@", error);
            abort();
#endif
        }
    }
    return persistentStoreCoordinator_;
}

//! Lazy getter for the primary object context for the database
- (NSManagedObjectContext *)mainObjectContext
{
    if (mainObjectContext_ == nil)
    {
        // Create the NSManagedObjectContext only on the main thread
        if (![NSThread isMainThread])
        {
            [self performSelectorOnMainThread:@selector(mainObjectContext)
                                   withObject:nil
                                waitUntilDone:YES];
            return mainObjectContext_;
        }
        
        mainObjectContext_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        mainObjectContext_.undoManager = nil;
        mainObjectContext_.persistentStoreCoordinator = self.persistentStoreCoordinator;
        // Changes already merged into the persistant store take precendence over changes made only in memory
        mainObjectContext_.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }
    return mainObjectContext_;
}

/**
 * Convenience method to get the path to the Library/Database directory to store the
 * Core Data files. This method creates the directory, if it doesn't already exist.
 */
- (NSString *)sharedDocumentsPath
{
    static NSString *s_sharedDocumentsPath = nil;
    if (s_sharedDocumentsPath == nil)
    {
        // Compose a path to the <Library>/Database directory
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        s_sharedDocumentsPath = [libraryPath stringByAppendingPathComponent:@"Database"];
        
        // Ensure the database directory exists
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL isDirectory = NO;
        if (![manager fileExistsAtPath:s_sharedDocumentsPath isDirectory:&isDirectory] || !isDirectory)
        {
            // If the directory doesn't exist, create it and mark it as encrypted
            NSError *error = nil;
            NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                             forKey:NSFileProtectionKey];
            [manager createDirectoryAtPath:s_sharedDocumentsPath
               withIntermediateDirectories:YES
                                attributes:attr
                                     error:&error];
            if (error != nil)
            {
                NSLog(@"Error creating directory path: %@", [error localizedDescription]);
            }
        }
    }
    return s_sharedDocumentsPath;
}

//! Notification handler to merge changes from other contexts
- (void)processMergeNotification:(NSNotification *)saveNotification
{
    // Don't process notifications from other Core Data stores
    if (![[saveNotification.object persistentStoreCoordinator] isEqual:[self persistentStoreCoordinator]])
    {
        return;
    }
    
    // Merge all changes into the appropriate context
    NSManagedObjectContext *context = [self mainObjectContext];
    if ([saveNotification.object isEqual:[self mainObjectContext]])
    {
        context = [TumblrDataManager privateManagedObjectContext];
    }
    
    __weak typeof(self) weakSelf = self;
    [context performBlockAndWait:^(void) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf != nil)
        {
            // Just in case, make sure this can only run one at a time
            @synchronized(context)
            {
                // Per http://www.mlsite.net/blog/?p=518, there is a potential bug in merging updates. If the information
                // held locally hasn't been faulted into memory, it isn't considered to have been changed, and so it won't
                // be properly updated.
                NSArray *updates = [[saveNotification.userInfo objectForKey:@"updated"] allObjects];
                for (NSInteger i = updates.count - 1; i >= 0; i--)
                {
                    [[context objectWithID:[[updates objectAtIndex:i] objectID]] willAccessValueForKey:nil];
                }
                
                // Once all the updated objects are faulted into memory, perform the merge
                [context mergeChangesFromContextDidSaveNotification:saveNotification];
            }
        }
    }];
}

@end
