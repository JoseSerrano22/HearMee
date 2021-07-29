//
//  PodcastSearchCell.m
//  HearMee
//
//  Created by jose1009 on 7/28/21.
//

#import "PodcastSearchCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PodcastSearchCell

-(void)setPodcast:(Podcast *) podcast{
    _podcast = podcast;
    
    self.podcastNameLabel.text = podcast.trackName;
    self.artistLabel.text = podcast.artistName;
    self.genreLabel.text = podcast.primaryGenreName;
    self.trackViewUrl = podcast.trackViewUrl;
    
    self.podcastImage.image = nil;
    if (podcast.imageURL != nil) {
        [self.podcastImage setImageWithURL:podcast.imageURL];
    }
}

@end
