//
//  AnswerPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/16/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "AnswerPost.h"


@implementation AnswerPost

@dynamic asking_name;
@dynamic asking_url;
@dynamic question;
@dynamic answer;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate
{
    [super updateWithDictionary:dictionary inContext:context fullUpdate:fullUpdate];
    
    if (dictionary[@"asking_name"] != nil)
    {
        self.asking_name = dictionary[@"asking_name"];
    }
    else if (fullUpdate)
    {
        self.asking_name = nil;
    }
    
    if (dictionary[@"asking_url"] != nil)
    {
        self.asking_url = dictionary[@"asking_url"];
    }
    else if (fullUpdate)
    {
        self.asking_url = nil;
    }
    
    if (dictionary[@"question"] != nil)
    {
        self.question = dictionary[@"question"];
    }
    else if (fullUpdate)
    {
        self.question = nil;
    }
    
    if (dictionary[@"answer"] != nil)
    {
        self.answer = dictionary[@"answer"];
    }
    else if (fullUpdate)
    {
        self.answer = nil;
    }
}

@end
