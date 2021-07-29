//
//  Podcast.h
//  HearMee
//
//  Created by jose1009 on 7/28/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Podcast : NSObject

@property (strong, nonatomic) NSString *artistName;
//@property (strong, nonatomic) NSString *artistViewUrl;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *primaryGenreName;
@property (strong, nonatomic) NSString *trackName;
//@property (strong, nonatomic) NSNumber *trackCount;
@property (strong, nonatomic) NSURL *trackViewUrl;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)podcastsWithDictionaries:(NSArray *)dictionaries;

@end

typedef void (^FetchPodcastCompletionHandler)(NSArray<Podcast *> *podcast, NSError *error);

@interface Networker : NSObject

@end

NS_ASSUME_NONNULL_END
