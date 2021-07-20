//
//  ConversationsCell.h
//  HearMee
//
//  Created by jose1009 on 7/15/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConversationsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *const profileImage;
@property (weak, nonatomic) IBOutlet UILabel *const usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *const timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *const recentMessageLabel;

@end

NS_ASSUME_NONNULL_END
