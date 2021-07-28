//
//  AudioFilterViewController.m
//  HearMee
//
//  Created by jose1009 on 7/26/21.
//

#import "AudioFilterViewController.h"
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

- (IBAction)_shareDidTap:(id)sender {
    [Post postUserAudio:self.audioFile withFilter:self.filterName withImage:self.postImage withCaption:self.caption withCompletion:nil];
}

- (IBAction)_backDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_slowDidTap:(id)sender {
    
    self.filterName = @"slow";
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.audioPlayerNode = [[AVAudioPlayerNode alloc] init];
    
    
    [self.audioEngine attachNode:self.audioPlayerNode];
    
    AVAudioUnitTimePitch *changeRatePitchNode = [[AVAudioUnitTimePitch alloc] init];
    
    changeRatePitchNode.rate = 0.5;
    
    [self.audioEngine attachNode:changeRatePitchNode];
    
    [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
    [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
    
    [self.audioPlayerNode stop];
    [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
    
    [self.audioEngine startAndReturnError:nil];
    [self.audioPlayerNode setVolume:10.0];
    [self.audioPlayerNode play];
    

}

- (IBAction)_fastDidTap:(id)sender {
    
    self.filterName = @"fast";
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.audioPlayerNode = [[AVAudioPlayerNode alloc] init];
    
    [self.audioEngine attachNode:self.audioPlayerNode];
    
    AVAudioUnitTimePitch *changeRatePitchNode = [[AVAudioUnitTimePitch alloc] init];
    
    changeRatePitchNode.rate = 1.75;
    
    [self.audioEngine attachNode:changeRatePitchNode];
    
    [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
    [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
    
    [self.audioPlayerNode stop];
    [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
    
    [self.audioEngine startAndReturnError:nil];
    [self.audioPlayerNode setVolume:10.0];
    [self.audioPlayerNode play];
}

- (IBAction)_highPitchDidTap:(id)sender {
    
    self.filterName = @"highPitch";
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.audioPlayerNode = [[AVAudioPlayerNode alloc] init];
    
    [self.audioEngine attachNode:self.audioPlayerNode];
    
    AVAudioUnitTimePitch *changeRatePitchNode = [[AVAudioUnitTimePitch alloc] init];
    
    changeRatePitchNode.pitch = 1000;
    
    [self.audioEngine attachNode:changeRatePitchNode];
    
    [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
    [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
    
    [self.audioPlayerNode stop];
    [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
    
    [self.audioEngine startAndReturnError:nil];
    [self.audioPlayerNode setVolume:10.0];
    [self.audioPlayerNode play];
}

- (IBAction)_lowPitchDidTap:(id)sender {
}

- (IBAction)_echoDidTap:(id)sender {
}

- (IBAction)_reverbDidTap:(id)sender {
}

-(void)_connectAudioNodes:(NSArray *)nodes{
    for (int i=0; i < nodes.count-1; i++){
        [self.audioEngine connect:nodes[i] to:nodes[i+1] format:self.audioFile.processingFormat];
    }
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
