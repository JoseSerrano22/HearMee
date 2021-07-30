//
//  AudioFilterViewController.m
//  HearMee
//
//  Created by jose1009 on 7/26/21.
//

#import "AudioFilterViewController.h"
#import "PostRecordViewController.h"
#import "Post.h"

@interface AudioFilterViewController ()

@property (strong,nonatomic) AVAudioEngine *audioEngine;
@property (strong, nonatomic)  AVAudioPlayerNode *audioPlayerNode;
@property (strong, nonatomic) NSString *filterName;

@end

@implementation AudioFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
}

- (IBAction)_backDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_slowDidTap:(id)sender {
    
    self.filterName = @"slow";
    [self _typeOfAudioFilter:self.filterName];
}

- (IBAction)_fastDidTap:(id)sender {
    
    self.filterName = @"fast";
    [self _typeOfAudioFilter:self.filterName];
}

- (IBAction)_highPitchDidTap:(id)sender {
    
    self.filterName = @"highPitch";
    [self _typeOfAudioFilter:self.filterName];
}

- (IBAction)_lowPitchDidTap:(id)sender {
    
    self.filterName = @"lowPitch";
    [self _typeOfAudioFilter:self.filterName];
}

- (IBAction)_echoDidTap:(id)sender {
    
    self.filterName = @"echo";
    [self _typeOfAudioFilter:self.filterName];
}

- (IBAction)_reverbDidTap:(id)sender {
    
    self.filterName = @"reverb";
    [self _typeOfAudioFilter:self.filterName];
}

-(void)_typeOfAudioFilter:(NSString * _Nullable)filterName {
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.audioPlayerNode = [[AVAudioPlayerNode alloc] init];
    [self.audioEngine attachNode:self.audioPlayerNode];
    
    AVAudioUnitTimePitch *const changeRatePitchNode = [[AVAudioUnitTimePitch alloc] init];
    AVAudioUnitDistortion *const echoNode = [[AVAudioUnitDistortion alloc] init];
    AVAudioUnitReverb *const reverbNode = [[AVAudioUnitReverb alloc] init];
    
    if ([filterName isEqualToString:@"slow"]){
        
        changeRatePitchNode.rate = 0.5;
        
        [self.audioEngine attachNode:changeRatePitchNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    } else if ([filterName isEqualToString:@"fast"]){
        
        changeRatePitchNode.rate = 2.0;
        
        [self.audioEngine attachNode:changeRatePitchNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    } else if ([filterName isEqualToString:@"highPitch"]){
        
        changeRatePitchNode.pitch = 1000;
        
        [self.audioEngine attachNode:changeRatePitchNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    } else if ([filterName isEqualToString:@"lowPitch"]){
        
        changeRatePitchNode.rate = .90;
        changeRatePitchNode.pitch = -400;
        [reverbNode loadFactoryPreset:AVAudioUnitReverbPresetMediumHall];
        [reverbNode setWetDryMix:16];
        
        [self.audioEngine attachNode:changeRatePitchNode];
        [self.audioEngine attachNode:reverbNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:changeRatePitchNode to:reverbNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:reverbNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    } else if ([filterName isEqualToString:@"echo"]){
        
        [echoNode loadFactoryPreset:AVAudioUnitDistortionPresetMultiEcho1];
        
        [self.audioEngine attachNode:echoNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:echoNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:echoNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    } else if ([filterName isEqualToString:@"reverb"]){
        
        [reverbNode loadFactoryPreset:AVAudioUnitReverbPresetCathedral];
        [reverbNode setWetDryMix:50];
        
        [self.audioEngine attachNode:reverbNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:reverbNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:reverbNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    }
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
