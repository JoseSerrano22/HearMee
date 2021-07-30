//
//  ChatMessage.m
//  HearMee
//
//  Created by jose1009 on 7/19/21.
//

#import "ChatMessage.h"

@implementation ChatMessage

@dynamic author;
@dynamic message;
@dynamic createdAt;
@dynamic channelID;

+ (nonnull NSString *)parseClassName {
    return @"ChatMessage";
}

+ (void) postMessage: ( NSString * _Nullable )message withChannelID:(PFObject* _Nonnull)channelID withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    ChatMessage *newMessage = [ChatMessage new];
    newMessage.author = [PFUser currentUser];
    newMessage.message = message;
    newMessage.channelID = channelID;
    newMessage.createdAt = [NSDate date];
    [newMessage saveInBackgroundWithBlock: completion];
}

@end
