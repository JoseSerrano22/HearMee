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
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@property (strong, nonatomic) ChatMessage *message;
-(void)setMessage:(ChatMessage *)message;
@end

NS_ASSUME_NONNULL_END
