//
//  RecordViewController.m
//  HearMee
//
//  Created by jose1009 on 7/13/21.
//

#import "RecordViewController.h"
#import "AVFoundation/AVFoundation.h"

@interface RecordViewController () < AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *const playButton;
@property (weak, nonatomic) IBOutlet UIButton *const stopButton;
@property (weak, nonatomic) IBOutlet UIButton *const recordButton;

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,retain) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide the Stop and Play button when application launches
    [self.playButton setHidden:YES];
    [self.stopButton setHidden:YES];
    
    // Set the audio file
    NSArray *const pathComponents = [NSArray arrayWithObjects:
                                     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                     @"MyAudioMemo.acc",
                                     nil];
    
    NSURL *const outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *const session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *const recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    
    // Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

- (IBAction)_playDidTap:(id)sender {
    if (!self.recorder.recording){
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
//        NSData* data = [NSData dataWithContentsOfURL:recorder.url] ;
//        player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        [self.player setDelegate:self];
        [self.player play];
    }
}

- (IBAction)_stopDidTap:(id)sender {
    [self.recorder stop];
    AVAudioSession *const audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (IBAction)_recordDidTap:(id)sender {
    if (self.player.playing) { [self.player stop]; }
    
    if (!self.recorder.recording) {
        AVAudioSession *const session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [self.recorder record];
        [self.recordButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [self.recorder pause];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    [self.stopButton setHidden:NO];
    [self.playButton setHidden:NO];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self.stopButton setHidden:NO];
    [self.playButton setHidden:NO];
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    UIAlertController *const alertPrompt = [UIAlertController
                                            alertControllerWithTitle:@"Completed"
                                            message:@"The Recording has been Finished"
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *const action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
    [alertPrompt addAction:action];
    [self presentViewController:alertPrompt animated:YES completion:nil];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
