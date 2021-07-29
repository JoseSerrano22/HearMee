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

-(void)getPodcastwithCompletion:(void (^)(NSArray *podcasts, NSError *error))completion withNamePodcast:(NSString * _Nullable)name{
    
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?media=podcast&term=%@", name];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               completion(nil,error);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSArray *dictionaries = dataDictionary[@"results"];
               NSArray *podcast = [Podcast podcastsWithDictionaries:dictionaries];
               completion(podcast, nil);

           }
       }];
    [task resume];
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
