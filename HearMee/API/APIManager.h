//
//  APIManager.h
//  HearMee
//
//  Created by jose1009 on 7/21/21.
//

#import <Foundation/Foundation.h>
#import "Podcast.h"
#import "Post.h"
#import "ChatMessage.h"
#import "Channels.h"
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)shared;

-(void)getPodcastwithCompletion:(void (^)(NSArray *podcasts, NSError *error))completion withNamePodcast:(NSString * _Nullable)name;

- (void)fetchAllPosts:(void(^)(NSArray *posts, NSError *error))completion;

- (void)fetchAllChannels:(void(^)(NSArray *channel, NSError *error))completion;

- (void)fetchAllMessage:(void(^)(NSArray *messages, NSError *error))completion withChannel:(Channels * _Nullable)channel;

- (void)fetchAllComments:(void(^)(NSArray *comments, NSError *error))completion withPost:(Post * _Nullable)post;

- (void)fetchAllProfile:(void(^)(NSArray *posts, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
