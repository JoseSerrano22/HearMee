//
//  RecordViewController.m
//  HearMee
//
//  Created by jose1009 on 7/13/21.
//

#import "RecordViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "FeedViewController.h"
#import "Parse/Parse.h"
#import "PFObject.h"
#import "AppDelegate.h"
#import "Post.h"

@interface RecordViewController () < AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *const playButton;
@property (weak, nonatomic) IBOutlet UIButton *const stopButton;
@property (weak, nonatomic) IBOutlet UIButton *const recordButton;

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;


@property (nonatomic,strong) NSArray *path;
@property (nonatomic,retain) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captionTextView.delegate = self;
    self.postImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *const tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(_tapImageGesture:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.postImage addGestureRecognizer:tapGesture1];
    
    // Hide the Stop and Play button when application launches
    [self.playButton setHidden:YES];
    [self.stopButton setHidden:YES];
    
    // Set the audio file
    self.path = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"AudioMemo.acc",nil];
    NSURL *url = [NSURL fileURLWithPathComponents:self.path];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *setting = [[NSMutableDictionary alloc]init];
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
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
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

- (IBAction)_shareDidTap:(id)sender {
//    NSData *audioData = [NSData dataWithContentsOfURL:self.recorder.url];
    AVAudioFile *audioFile = [[AVAudioFile alloc] initForReading:self.recorder.url error:nil];
    UIImage *const resizeImage = [self _resizeImage:self.postImage.image withSize:CGSizeMake(400, 400)];
    [Post postUserAudio:audioFile withImage:resizeImage withCaption:self.captionTextView.text withCompletion:nil];
}


- (UIImage *)_resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *const resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *const newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)_tapImageGesture: (id)sender {
    
    UIImagePickerController *const imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *const usernameAlert = [UIAlertController alertControllerWithTitle:@"Choose"
                                                                           message:@""
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *const takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    [usernameAlert addAction:takePhotoAction];
    
    UIAlertAction *const cameraRollAction = [UIAlertAction actionWithTitle:@"Camera Roll"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    [usernameAlert addAction:cameraRollAction];
    
    [self presentViewController:usernameAlert animated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *const editedImage = info[UIImagePickerControllerEditedImage];
    self.postImage.image = editedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write a caption..."]){
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a caption...";
    }
    [textView resignFirstResponder];
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self.stopButton setHidden:NO];
    [self.playButton setHidden:NO];
    
}

#pragma mark - AVAudioPlayerDelegate

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
