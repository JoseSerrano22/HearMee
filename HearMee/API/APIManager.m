//
//  APIManager.m
//  HearMee
//
//  Created by jose1009 on 7/21/21.
//

#import "APIManager.h"

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)fetchAllPosts:(void(^)(NSArray *posts, NSError *error))completion {
    PFQuery *const postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        completion(posts, error);
    }];
}

- (void)fetchAllChannels:(void(^)(NSArray *channel, NSError *error))completion {
    PFQuery *const channelQuery = [Channels query];
    [channelQuery orderByDescending:@"createdAt"];
    
    [channelQuery findObjectsInBackgroundWithBlock:^(NSArray<Channels *> * _Nullable channels, NSError * _Nullable error) {
        completion(channels, error);
    }];
}

- (void)fetchAllMessage:(void(^)(NSArray *messages, NSError *error))completion withChannel:(Channels * _Nullable)channel {
    PFQuery *const messageQuery = [ChatMessage query];
    [messageQuery orderByDescending:@"createdAt"];
    [messageQuery includeKey:@"author"];
    [messageQuery includeKey:@"channelID"];
    [messageQuery whereKey:@"channelID" equalTo:channel];
    
    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray<ChatMessage *> * _Nullable messages, NSError * _Nullable error) {
        completion(messages, error);
    }];
}

- (void)fetchAllProfile:(void(^)(NSArray *posts, NSError *error))completion {
    PFQuery *const postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        completion(posts, error);
    }];
}

@end
