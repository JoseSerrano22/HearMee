//
//  PodcastSearchCell.h
//  HearMee
//
//  Created by jose1009 on 7/28/21.
//

#import <UIKit/UIKit.h>
#import "Podcast.h"

NS_ASSUME_NONNULL_BEGIN

@interface PodcastSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *const podcastImage;
@property (weak, nonatomic) IBOutlet UILabel *const podcastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *const artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *const genreLabel;

@property (strong, nonatomic) NSURL *const trackViewUrl;

@property (nonatomic, strong) Podcast *podcast;

@end

NS_ASSUME_NONNULL_END
