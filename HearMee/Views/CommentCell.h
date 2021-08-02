//
//  CommentCell.h
//  HearMee
//
//  Created by jose1009 on 8/2/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "DateTools.h"
#import "Comment.h"
#import "UIImageView+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *const profileImage;
@property (weak, nonatomic) IBOutlet UILabel *const usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *const commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *const timestampLabel;

@property (strong, nonatomic) Comment *comment;

-(void)setComment:(Comment *)comment;

@end

NS_ASSUME_NONNULL_END
