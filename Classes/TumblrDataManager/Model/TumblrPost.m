//
//  TumblrPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "TumblrPost.h"

@implementation TumblrPost

@dynamic blog_name;
@dynamic identifier;
@dynamic timestamp;
@dynamic type;
@dynamic source_url;
@dynamic source_title;

+ (NSString *)subclassEntityNameForType:(NSString *)type
{
    static NSDictionary *entityMap = nil;
    static dispatch_once_t entityToken;
    dispatch_once(&entityToken, ^(void) {
        entityMap = @{@"answer" : @"AnswerPost",
                      @"audio"  : @"AudioPost",
                      @"chat"   : @"ChatPost",
                      @"link"   : @"LinkPost",
                      @"photo"  : @"PhotoPost",
                      @"quote"  : @"QuotePost",
                      @"text"   : @"TextPost",
                      @"video"  : @"VideoPost"};
    });
    return entityMap[type] ?: @"TumblrPost";
}

+ (TumblrPost *)updatedTumblrPostWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate
{
    if (context == nil || dictionary[@"id"] == nil || dictionary[@"id"] == [NSNull null])
    {
        return nil;
    }
    
    TumblrPost *tumblrPost = nil;
    
    // Try to find an existing TumblrPost with an idenfitier matching the data in the update dictionary. If
    // a match is found, update that TumblrPost and return it. Otherwise, create a new TumblrPost (the
    // appropriate subclass), update it using the update dictionary, and return the newly created object.
    NSString *entityName = [TumblrPost subclassEntityNameForType:dictionary[@"type"]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"(identifier == %@)", dictionary[@"id"]];
    NSError *error = nil;
    NSArray *items = [context executeFetchRequest:request error:&error];
    if (error != nil)
    {
        NSLog(@"An error occurred attempting to fetch TumblrPost: (%ld) %@",
              (long)error.code, error.localizedDescription);
    }
    if (items.count > 0)
    {
        tumblrPost = items[0];
    }
    else
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                                  inManagedObjectContext:context];
        tumblrPost = (TumblrPost *)[[NSManagedObject alloc] initWithEntity:entity
                                            insertIntoManagedObjectContext:context];
    }
    [tumblrPost updateWithDictionary:dictionary inContext:context fullUpdate:fullUpdate];
    return tumblrPost;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate
{
    if (dictionary == nil || context == nil)
    {
        return;
    }
    
    if (dictionary[@"blog_name"] != nil && dictionary[@"blog_name"] != [NSNull null])
    {
        self.blog_name = dictionary[@"blog_name"];
    }
    else if (fullUpdate)
    {
        self.blog_name = nil;
    }
    
    if (dictionary[@"id"] != nil && dictionary[@"id"] != [NSNull null])
    {
        self.identifier = [NSString stringWithFormat:@"%@", dictionary[@"id"]];
    }
    else if (fullUpdate)
    {
        self.identifier = nil;
    }
    
    if (dictionary[@"timestamp"] != nil && dictionary[@"timestamp"] != [NSNull null])
    {
        self.timestamp = dictionary[@"timestamp"];
    }
    else if (fullUpdate)
    {
        self.timestamp = nil;
    }
    
    if (dictionary[@"type"] != nil && dictionary[@"type"] != [NSNull null])
    {
        self.type = dictionary[@"type"];
    }
    else if (fullUpdate)
    {
        self.type = nil;
    }
    
    if (dictionary[@"source_url"] != nil && dictionary[@"source_url"] != [NSNull null])
    {
        self.source_url = dictionary[@"source_url"];
    }
    else if (fullUpdate)
    {
        self.source_url = nil;
    }
    
    if (dictionary[@"source_title"] != nil && dictionary[@"source_title"] != [NSNull null])
    {
        self.source_title = dictionary[@"source_title"];
    }
    else if (fullUpdate)
    {
        self.source_title = nil;
    }
}

@end
