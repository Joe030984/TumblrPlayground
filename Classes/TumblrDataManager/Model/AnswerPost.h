//
//  AnswerPost.h
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TumblrPost.h"

@interface AnswerPost : TumblrPost

@property (nonatomic, retain) NSString * asking_name;
@property (nonatomic, retain) NSString * asking_url;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * answer;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate;

@end
