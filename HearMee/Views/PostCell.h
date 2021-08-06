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
#import "AVAudioPlayerNode+Extension.h"
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *const profileImage;
@property (weak, nonatomic) IBOutlet UILabel *const usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *const timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *const postImage;
@property (weak, nonatomic) IBOutlet UIButton *const likeButton;
@property (weak, nonatomic) IBOutlet UILabel *const likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *const commentButton;
@property (weak, nonatomic) IBOutlet UILabel *const commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *const captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *const playAudioButton;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;

@property (strong, nonatomic) Post *post;
@property (nonatomic,strong) AVAudioPlayer *const player;
@property (strong,nonatomic) AVAudioEngine *const audioEngine;
@property (strong, nonatomic)  AVAudioPlayerNode *const audioPlayerNode;
@property (strong,nonatomic) AVAudioFile *const audioFile;

-(void)setPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
