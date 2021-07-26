//
//  ChannelsCell.h
//  HearMee
//
//  Created by jose1009 on 7/20/21.
//

#import <UIKit/UIKit.h>
#import "Channels.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChannelsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *channelImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (strong, nonatomic) Channels *channel;

-(void)setChannel:(Channels *)channel;
@end

NS_ASSUME_NONNULL_END
