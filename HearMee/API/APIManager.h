//
//  APIManager.h
//  HearMee
//
//  Created by jose1009 on 7/21/21.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "ChatMessage.h"
#import "Channels.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)shared;

- (void)fetchAllPosts:(void(^)(NSArray *posts, NSError *error))completion;

- (void)fetchAllChannels:(void(^)(NSArray *channel, NSError *error))completion;

- (void)fetchAllMessage:(void(^)(NSArray *messages, NSError *error))completion withChannel:(Channels * _Nullable)channel;

- (void)fetchAllProfile:(void(^)(NSArray *posts, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
