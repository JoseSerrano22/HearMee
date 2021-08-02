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

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@property (strong, nonatomic) Comment *comment;

-(void)setComment:(Comment *)comment;

@end

NS_ASSUME_NONNULL_END
