//
//  ChannelsCell.m
//  HearMee
//
//  Created by jose1009 on 7/20/21.
//

#import "ChannelsCell.h"

@implementation ChannelsCell

-(void)setChannel:(Channels *)channel{
    _channel = channel;
    
    self.captionLabel.text = channel.caption;
    self.titleLabel.text = channel.title;
    
    [channel.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.channelImage.image = [UIImage imageWithData:data];
        }
    }];
}
@end
