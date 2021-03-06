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
#import "AVAudioPlayerNode+Extension.h"
#import "CommentCell.h"
#import "APIManager.h"
#import "LSAnimator.h"

@interface DetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *const profileImage;
@property (weak, nonatomic) IBOutlet UILabel *const usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *const timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *const postImage;
@property (weak, nonatomic) IBOutlet UIButton *const likeButton;
@property (weak, nonatomic) IBOutlet UILabel *const likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *const commentButton;
@property (weak, nonatomic) IBOutlet UILabel *const commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *const bookmarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *const captionLabel;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *const visualEffectView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UITableView *const tableView;
@property (nonatomic,strong) AVAudioPlayer *const player;
@property (strong,nonatomic) AVAudioEngine *const audioEngine;
@property (strong, nonatomic)  AVAudioPlayerNode *const audioPlayerNode;
@property (strong,nonatomic) AVAudioFile *const audioFile;
@property (strong, nonatomic) NSMutableArray *const commentArray;
@property (nonatomic, strong) UIRefreshControl *const refreshControl;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self _setPostFromCell];
    [self _fetchComments];
    
    UITapGestureRecognizer *const tapGesturePost = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(_favoriteGestureDidTap:)];
    tapGesturePost.numberOfTapsRequired = 2;
    [self.visualEffectView addGestureRecognizer:tapGesturePost];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(_fetchComments) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

#pragma mark - Private

-(void)_setPostFromCell{
    
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

- (void)_fetchComments {
    
    [[APIManager shared] fetchAllComments:^(NSArray * _Nonnull comments, NSError * _Nonnull error) {
        
        if (comments){
            self.commentArray = (NSMutableArray *) comments;
            [self.tableView reloadData];
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    } withPost:self.post];
}

- (IBAction)_backDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_commentDidTap:(id)sender {
    [self _showInputAlertComment];
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

-(void)_favoriteGestureDidTap: (id)sender{
    
    LSAnimator *heartAnimator = [LSAnimator animatorWithView:self.likeImage];
    self.likeImage.alpha = 1;
    heartAnimator.transformScale(1.7).bounce.spring.makeOpacity(0).animateWithCompletion(1.5, ^{
        heartAnimator.transformScale(1/1.7).animate(0.1);
    });
    
    if(!self.likeButton.selected) {
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
            
            NSString *const filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"AudioMemo.acc"];
            [data writeToFile:filePath atomically:YES];
            NSArray *const pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
            NSString *const documentsDirectory = [pathArray objectAtIndex:0];
            NSString *const soundPath = [documentsDirectory stringByAppendingPathComponent:@"AudioMemo.acc"];
            
            NSURL *soundUrl;
            if ([[NSFileManager defaultManager] fileExistsAtPath:soundPath]){
                soundUrl = [NSURL fileURLWithPath:soundPath isDirectory:NO];
            }
            
            [self _initAudioWithUrl:soundUrl];
            [AVAudioPlayerNode typeOfAudioFilter:self.post.filterName withAudioFile:self.audioFile withAudioEngine:self.audioEngine withAudioPlayerNode:self.audioPlayerNode withAudioPlayer:self.player withURL:soundUrl];
        }
    }];
}

-(void)_initAudioWithUrl:(NSURL * _Nullable)url{
    self.audioFile = [[AVAudioFile alloc] initForReading:url error:nil];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.audioPlayerNode = [[AVAudioPlayerNode alloc] init];
}

-(void)_showInputAlertComment {
    UIAlertController *const alertVC = [UIAlertController alertControllerWithTitle:@"Comment" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        {
            textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        }
    }];
    
    UIAlertAction *const cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:cancelAction];
    
    UIAlertAction *const action = [UIAlertAction actionWithTitle:@"Post" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *const comment = alertVC.textFields[0].text;
        
        [Comment postComment:comment withPostID:self.post withCompletion:nil];
        self.post.commentCount = [NSNumber numberWithInteger:([self.post.commentCount intValue] + 1)];
        self.commentLabel.text = [NSString stringWithFormat:@"%@", self.post.commentCount];
    }];
    
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:true completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *const cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    Comment *const comment = self.commentArray[indexPath.row];
    cell.comment = comment;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
