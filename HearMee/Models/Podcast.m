//
//  Podcast.m
//  HearMee
//
//  Created by jose1009 on 7/28/21.
//

#import "Podcast.h"

@implementation Podcast

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    self.artistName = dictionary[@"artistName"];
    self.primaryGenreName = dictionary[@"primaryGenreName"];
    self.trackName = dictionary[@"trackName"];
    
    NSString *stringTrackViewUrl = dictionary[@"trackViewUrl"];
    self.trackViewUrl = [NSURL URLWithString:stringTrackViewUrl];

    NSString *stringImageURL = dictionary[@"artworkUrl600"];
    self.imageURL = [NSURL URLWithString:stringImageURL];

    return self;
}

+ (NSArray *)podcastsWithDictionaries:(NSArray *)dictionaries {
    // Implement this function
    NSMutableArray *podcasts = [[NSMutableArray alloc ] init];
    for (NSDictionary *dictionary in dictionaries) {
        Podcast *podcast = [[Podcast alloc] initWithDictionary:dictionary];
        [podcasts addObject:podcast];
    }
    return podcasts;
}

@end
