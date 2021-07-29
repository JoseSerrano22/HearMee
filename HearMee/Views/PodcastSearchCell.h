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

@property (weak, nonatomic) IBOutlet UIImageView *podcastImage;
@property (weak, nonatomic) IBOutlet UILabel *podcastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;

@property (strong, nonatomic) NSURL *trackViewUrl;

@property (nonatomic, strong) Podcast *podcast;

@end

NS_ASSUME_NONNULL_END
