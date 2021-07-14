//
//  PostCell.h
//  HearMee
//
//  Created by jose1009 on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse/Parse.h"
#import "DateTools.h"
#import "AVFoundation/AVFoundation.h"
#import "UIImageView+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *playAudioButton;


@property (strong, nonatomic) Post *post;

-(void)setPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
