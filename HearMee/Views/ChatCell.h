//
//  ChatCell.h
//  HearMee
//
//  Created by jose1009 on 7/19/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "DateTools.h"
#import "ChatMessage.h"
#import "UIImageView+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *const profileImage;
@property (weak, nonatomic) IBOutlet UILabel *const usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *const messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *const timestampLabel;
@property (weak, nonatomic) IBOutlet UIView *const bubbleView;

@property (strong, nonatomic) ChatMessage *message;

-(void)setMessage:(ChatMessage *)message;

@end

NS_ASSUME_NONNULL_END
