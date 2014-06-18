//
//  ChatPost.m
//  TumblrPlayground
//
//  Created by Joe Szymanski on 6/17/14.
//  Copyright (c) 2014 JoeSzymanski. All rights reserved.
//

#import "ChatPost.h"
#import "TumblrDialogue.h"

@implementation ChatPost

@dynamic body;
@dynamic title;
@dynamic dialogue;

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context fullUpdate:(BOOL)fullUpdate
{
    [super updateWithDictionary:dictionary inContext:context fullUpdate:fullUpdate];
    
    if (dictionary[@"title"] != nil && dictionary[@"title"] != [NSNull null])
    {
        self.title = dictionary[@"title"];
    }
    else if (fullUpdate)
    {
        self.title = nil;
    }
    
    if (dictionary[@"body"] != nil && dictionary[@"body"] != [NSNull null])
    {
        self.body = dictionary[@"body"];
    }
    else if (fullUpdate)
    {
        self.body = nil;
    }
    
    // Remove and delete old dialog objects
    for (TumblrDialogue *dialogue in [self.dialogue copy])
    {
        [self removeDialogueObject:dialogue];
        [context deleteObject:dialogue];
    }
    
    // Create and add all the new dialogue objects
    int index = 0;
    for (NSDictionary *dialogueDict in dictionary[@"dialogue"])
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TumblrDialogue"
                                                  inManagedObjectContext:context];
        TumblrDialogue *dialogue = (TumblrDialogue *)[[NSManagedObject alloc] initWithEntity:entity
                                                              insertIntoManagedObjectContext:context];
        dialogue.index = @(index);
        if (dialogueDict[@"label"] != nil && dialogueDict[@"label"] != [NSNull null])
        {
            dialogue.label = dialogueDict[@"label"];
        }
        
        if (dialogueDict[@"name"] != nil && dialogueDict[@"name"] != [NSNull null])
        {
            dialogue.name = dialogueDict[@"name"];
        }
        
        if (dialogueDict[@"phrase"] != nil && dialogueDict[@"phrase"] != [NSNull null])
        {
            dialogue.phrase = dialogueDict[@"phrase"];
        }
        [self addDialogueObject:dialogue];
        
        index++;
    }
}

@end
