//
//  AudioFilterViewController.m
//  HearMee
//
//  Created by jose1009 on 7/26/21.
//

#import "AudioFilterViewController.h"
#import "PostRecordViewController.h"
#import "AVAudioPlayerNode+Extension.h"
#import "Post.h"

@interface AudioFilterViewController ()

@property (strong,nonatomic) AVAudioEngine *const audioEngine;
@property (strong, nonatomic) AVAudioPlayerNode *const audioPlayerNode;
@property (strong, nonatomic) NSString *const filterName;
@property (strong, nonatomic) AVAudioPlayer *const player;

@end

@implementation AudioFilterViewController

#pragma mark - private

- (IBAction)_backDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_slowDidTap:(id)sender {
    
    self.filterName = @"slow";
    [self _initAudio];
    [AVAudioPlayerNode typeOfAudioFilter:self.filterName withAudioFile:self.audioFile withAudioEngine:self.audioEngine withAudioPlayerNode:self.audioPlayerNode withAudioPlayer:self.player withURL:nil];
}

- (IBAction)_fastDidTap:(id)sender {
    self.filterName = @"fast";
    [self _initAudio];
    [AVAudioPlayerNode typeOfAudioFilter:self.filterName withAudioFile:self.audioFile withAudioEngine:self.audioEngine withAudioPlayerNode:self.audioPlayerNode withAudioPlayer:self.player withURL:nil];
}

- (IBAction)_highPitchDidTap:(id)sender {
    
    self.filterName = @"highPitch";
    [self _initAudio];
    [AVAudioPlayerNode typeOfAudioFilter:self.filterName withAudioFile:self.audioFile withAudioEngine:self.audioEngine withAudioPlayerNode:self.audioPlayerNode withAudioPlayer:self.player withURL:nil];
}

- (IBAction)_lowPitchDidTap:(id)sender {
    
    self.filterName = @"lowPitch";
    [self _initAudio];
    [AVAudioPlayerNode typeOfAudioFilter:self.filterName withAudioFile:self.audioFile withAudioEngine:self.audioEngine withAudioPlayerNode:self.audioPlayerNode withAudioPlayer:self.player withURL:nil];
}

- (IBAction)_echoDidTap:(id)sender {
    
    self.filterName = @"echo";
    [self _initAudio];
    [AVAudioPlayerNode typeOfAudioFilter:self.filterName withAudioFile:self.audioFile withAudioEngine:self.audioEngine withAudioPlayerNode:self.audioPlayerNode withAudioPlayer:self.player withURL:nil];
}

- (IBAction)_reverbDidTap:(id)sender {
    
    self.filterName = @"reverb";
    [self _initAudio];
    [AVAudioPlayerNode typeOfAudioFilter:self.filterName withAudioFile:self.audioFile withAudioEngine:self.audioEngine withAudioPlayerNode:self.audioPlayerNode withAudioPlayer:self.player withURL:nil];
}

-(void)_initAudio{
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.audioPlayerNode = [[AVAudioPlayerNode alloc] init];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"postSegue"]){
        UINavigationController *const nav = [segue destinationViewController];
        PostRecordViewController *const postRecordVC = (PostRecordViewController *)[nav topViewController];
        postRecordVC.audioFile = self.audioFile;
        postRecordVC.filterName = self.filterName;
    }
}

@end
