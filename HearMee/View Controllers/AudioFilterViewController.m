//
//  AudioFilterViewController.m
//  HearMee
//
//  Created by jose1009 on 7/26/21.
//

#import "AudioFilterViewController.h"

@interface AudioFilterViewController ()
@property (strong,nonatomic) AVAudioEngine *audioEngine;
@end

@implementation AudioFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)_shareDidTap:(id)sender {
}

- (IBAction)_backDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_slowDidTap:(id)sender {
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    AVAudioPlayerNode *audioPlayerNode = [[AVAudioPlayerNode alloc] init];
    
    [self.audioEngine attachNode:audioPlayerNode];
    
    AVAudioUnitTimePitch *changeRatePitchNode = [[AVAudioUnitTimePitch alloc] init];
    
//    changeRatePitchNode.pitch = 1.0;
    changeRatePitchNode.rate = 0.5;
    
    [self.audioEngine attachNode:changeRatePitchNode];
    
    [self.audioEngine connect:audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
    [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
    
    [audioPlayerNode stop];
    [audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
    
    [self.audioEngine startAndReturnError:nil];
    [audioPlayerNode setVolume:10.0];
    [audioPlayerNode play];
}

- (IBAction)_fastDidTap:(id)sender {
    self.audioEngine = [[AVAudioEngine alloc] init];
    AVAudioPlayerNode *audioPlayerNode = [[AVAudioPlayerNode alloc] init];
    
    [self.audioEngine attachNode:audioPlayerNode];
    
    AVAudioUnitTimePitch *changeRatePitchNode = [[AVAudioUnitTimePitch alloc] init];
    
//    changeRatePitchNode.pitch = 1.0;
    changeRatePitchNode.rate = 1.75;
    
    [self.audioEngine attachNode:changeRatePitchNode];
    
    [self.audioEngine connect:audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
    [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
    
    [audioPlayerNode stop];
    [audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
    
    [self.audioEngine startAndReturnError:nil];
    [audioPlayerNode setVolume:10.0];
    [audioPlayerNode play];
}

- (IBAction)_highPitchDidTap:(id)sender {
}

- (IBAction)_lowPitchDidTap:(id)sender {
}

- (IBAction)_parrotDidTap:(id)sender {
}

- (IBAction)_echoDidTap:(id)sender {
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
