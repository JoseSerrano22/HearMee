//
//  DetailsViewController.m
//  HearMee
//
//  Created by jose1009 on 7/15/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "AVFoundation/AVFoundation.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (nonatomic,strong) AVAudioPlayer *const player;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.post);
    PFUser *const user = self.post.author;
    
    self.usernameLabel.text = user.username;
    self.captionLabel.text = self.post.caption;
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    PFUser *const postAuthor = self.post.author;
    [postAuthor fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        PFFileObject *const image = postAuthor[@"profile_image"];
        NSURL *const url = [NSURL URLWithString:image.url];
        [self.profileImage setImageWithURL:url];
    }];
    
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.postImage.image = [UIImage imageWithData:data];
        }
    }];
    
    self.likeLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    self.commentLabel.text = [NSString stringWithFormat:@"%@", self.post.commentCount];
    self.likeButton.selected = [self.post.likedByUsername containsObject:PFUser.currentUser.objectId];
    
    NSString *const createdAtOriginalString = self.timestampLabel.text = [NSString stringWithFormat:@"%@", self.post.createdAt];
    NSDateFormatter *const formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
    
    NSDate *const date = [formatter dateFromString:createdAtOriginalString];
    NSDate *const now = [NSDate date];
    NSInteger timeApart = [now hoursFrom:date];
    
    if (timeApart >= 24) {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.timestampLabel.text = [formatter stringFromDate:date];
    }
    else {
        self.timestampLabel.text = date.shortTimeAgoSinceNow;
    }
}

#pragma mark - Private
- (IBAction)_backDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_didTapFavorite:(id)sender {
    if(self.likeButton.selected){
        self.likeButton.selected = false;
        [self.likeButton setSelected:NO];
        self.post.likeCount = [NSNumber numberWithInteger:([self.post.likeCount intValue] - 1)];
        [self.post unlike];
        
    } else if(!self.likeButton.selected) {
        self.likeButton.selected = true;
        [self.likeButton setSelected:YES];
        self.post.likeCount = [NSNumber numberWithInteger:([self.post.likeCount intValue] + 1)];
        
        if(!self.post.likedByUsername) {
            self.post.likedByUsername = [NSMutableArray new];
        }
        [self.post like];
    }
    self.likeLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    
}

- (IBAction)_playAudioDidTap:(id)sender {
    
    [self.post fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            PFFileObject *const audioObject = self.post.audio;
            NSURL *const url = [NSURL URLWithString:audioObject.url];
            NSData *const data = [NSData dataWithContentsOfURL:url];
            self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
            self.player.volume = 10.0;
            [self.player play];
        }
    }];
    
}

@end
