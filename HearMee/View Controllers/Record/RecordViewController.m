//
//  RecordViewController.m
//  HearMee
//
//  Created by jose1009 on 7/13/21.
//

#import "RecordViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "FeedViewController.h"
#import "AudioFilterViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DORDoneHUD.h"
#import "UIImage+Extension.h"
#import "Parse/Parse.h"
#import "PFObject.h"
#import "AppDelegate.h"
#import "Post.h"

@interface RecordViewController () < AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *const playButton;
@property (weak, nonatomic) IBOutlet UIButton *const recordButton;
@property (weak, nonatomic) IBOutlet UIButton *const backwardButtton;
@property (weak, nonatomic) IBOutlet UIButton *const forwardButton;
@property (weak, nonatomic) IBOutlet UIImageView *const profileImage;
@property (nonatomic,strong) NSArray *const path;
@property (nonatomic,retain) AVAudioRecorder *const recorder;
@property (nonatomic,strong) AVAudioPlayer *const player;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *const currentUser = PFUser.currentUser;
    [currentUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        PFFileObject *const image = currentUser[@"profile_image"];
        NSURL *const url = [NSURL URLWithString:image.url];
        [self.profileImage setImageWithURL:url];
    }];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    
    // Set the audio file
    self.path = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"AudioMemo.acc",nil];
    NSURL *const url = [NSURL fileURLWithPathComponents:self.path];
    
    // Setup audio session
    AVAudioSession *const session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *const setting = [[NSMutableDictionary alloc]init];
    [setting setValue:[NSNumber numberWithInteger:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [setting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [setting setValue:[NSNumber numberWithInteger:2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
    self.recorder.meteringEnabled = YES;
    self.recorder.delegate = self;
    [self.recorder prepareToRecord];
    
}

#pragma mark - Private

- (IBAction)_playDidTap:(id)sender {
    
    if (!self.recorder.recording){
        
        if(!self.player.isPlaying){
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
            [self.player setDelegate:self];
            self.player.volume = 10.0;
            [self.player play];
            [self.playButton setImage:[UIImage imageNamed:@"pause-1.png"] forState:UIControlStateNormal];
            
        } else{
            [self.player pause];
            [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            
        }
    }
}

- (IBAction)_recordDidTap:(id)sender {
    
    if (self.player.playing) { [self.player stop]; }
    
    if (!self.recorder.recording) {
        
        AVAudioSession *const session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [self.recorder record];
        [self.recordButton setImage:[UIImage imageNamed:@"Stop.png"] forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [self.recorder stop];
        AVAudioSession *const audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        [self.recordButton setImage:[UIImage imageNamed:@"RecordButton.png"] forState:UIControlStateNormal];
    }
    
    [self.playButton setHidden:NO];
    [self.backwardButtton setHidden:NO];
    [self.forwardButton setHidden:NO];
}

- (IBAction)_backwardDidTap:(id)sender {

    NSTimeInterval time = self.player.currentTime;
    time -= 3;

    if (time < 0){
        [self.player stop];
      } else {
          self.player.currentTime = time;
      }
}

- (IBAction)_forwardDidTap:(id)sender {

    NSTimeInterval time = self.player.currentTime;
    time += 3;

    if (time > self.player.duration){
        [self.player stop];
      } else {
          self.player.currentTime = time;
      }
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self.playButton setHidden:NO];
    
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [DORDoneHUD show:self.view message:@"Completed"];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"audioFilterSegue"]){
        UINavigationController *const nav = [segue destinationViewController];
        AudioFilterViewController *const audioFilterVC = (AudioFilterViewController *)[nav topViewController];
        audioFilterVC.audioFile = [[AVAudioFile alloc] initForReading:self.recorder.url error:nil];
    }
}

@end
