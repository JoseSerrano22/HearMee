//
//  AVAudioPlayerNode+Extension.m
//  HearMee
//
//  Created by jose1009 on 8/3/21.
//

#import "AVAudioPlayerNode+Extension.h"

@implementation AVAudioPlayerNode (Extension)

+(void)typeOfAudioFilter:(NSString * _Nullable)filterName withAudioFile:(AVAudioFile * _Nullable)audioFile withAudioEngine:(AVAudioEngine * _Nullable)audioEngine withAudioPlayerNode:(AVAudioPlayerNode * _Nullable)audioPlayerNode withAudioPlayer:(AVAudioPlayer * _Nullable)player withURL:(NSURL * _Nullable)url {
    
    [audioEngine attachNode:audioPlayerNode];
    
    AVAudioUnitTimePitch *const changeRatePitchNode = [[AVAudioUnitTimePitch alloc] init];
    AVAudioUnitDistortion *const echoNode = [[AVAudioUnitDistortion alloc] init];
    AVAudioUnitReverb *const reverbNode = [[AVAudioUnitReverb alloc] init];
    
    if ([filterName isEqualToString:@"slow"]){
        
        changeRatePitchNode.rate = 0.5;
        
        [audioEngine attachNode:changeRatePitchNode];
        
        [audioEngine connect:audioPlayerNode to:changeRatePitchNode format:audioFile.processingFormat];
        [audioEngine connect:changeRatePitchNode to:audioEngine.outputNode format:audioFile.processingFormat];
        
        [self playAudioPlayerNode:audioPlayerNode withAudioEngine:audioEngine withAudioFile:audioFile];
        
    } else if ([filterName isEqualToString:@"fast"]){
        
        changeRatePitchNode.rate = 2.0;
        
        [audioEngine attachNode:changeRatePitchNode];
        
        [audioEngine connect:audioPlayerNode to:changeRatePitchNode format:audioFile.processingFormat];
        [audioEngine connect:changeRatePitchNode to:audioEngine.outputNode format:audioFile.processingFormat];
        
        [self playAudioPlayerNode:audioPlayerNode withAudioEngine:audioEngine withAudioFile:audioFile];
        
    } else if ([filterName isEqualToString:@"highPitch"]){
        
        changeRatePitchNode.pitch = 1000;
        
        [audioEngine attachNode:changeRatePitchNode];
        
        [audioEngine connect:audioPlayerNode to:changeRatePitchNode format:audioFile.processingFormat];
        [audioEngine connect:changeRatePitchNode to:audioEngine.outputNode format:audioFile.processingFormat];
        
        [self playAudioPlayerNode:audioPlayerNode withAudioEngine:audioEngine withAudioFile:audioFile];
        
    } else if ([filterName isEqualToString:@"lowPitch"]){
        
        changeRatePitchNode.rate = .90;
        changeRatePitchNode.pitch = -400;
        [reverbNode loadFactoryPreset:AVAudioUnitReverbPresetMediumHall];
        [reverbNode setWetDryMix:16];
        
        [audioEngine attachNode:changeRatePitchNode];
        [audioEngine attachNode:reverbNode];
        
        [audioEngine connect:audioPlayerNode to:changeRatePitchNode format:audioFile.processingFormat];
        [audioEngine connect:changeRatePitchNode to:reverbNode format:audioFile.processingFormat];
        [audioEngine connect:reverbNode to:audioEngine.outputNode format:audioFile.processingFormat];
        
        [self playAudioPlayerNode:audioPlayerNode withAudioEngine:audioEngine withAudioFile:audioFile];
        
    } else if ([filterName isEqualToString:@"echo"]){
        
        [echoNode loadFactoryPreset:AVAudioUnitDistortionPresetMultiEcho1];
        
        [audioEngine attachNode:echoNode];
        
        [audioEngine connect:audioPlayerNode to:echoNode format:audioFile.processingFormat];
        [audioEngine connect:echoNode to:audioEngine.outputNode format:audioFile.processingFormat];
        
        [self playAudioPlayerNode:audioPlayerNode withAudioEngine:audioEngine withAudioFile:audioFile];
        
    } else if ([filterName isEqualToString:@"reverb"]){
        
        [reverbNode loadFactoryPreset:AVAudioUnitReverbPresetCathedral];
        [reverbNode setWetDryMix:50];
        
        [audioEngine attachNode:reverbNode];
        
        [audioEngine connect:audioPlayerNode to:reverbNode format:audioFile.processingFormat];
        [audioEngine connect:reverbNode to:audioEngine.outputNode format:audioFile.processingFormat];
        
        [self playAudioPlayerNode:audioPlayerNode withAudioEngine:audioEngine withAudioFile:audioFile];
    
    }else{

        player.volume = 10.0;
        [player play];
    }
}

+(void)playAudioPlayerNode:(AVAudioPlayerNode * _Nullable)audioPlayerNode withAudioEngine:(AVAudioEngine * _Nullable)audioEngine withAudioFile:(AVAudioFile * _Nullable)audioFile{

    [audioPlayerNode stop];
    [audioPlayerNode scheduleFile:audioFile atTime:nil completionHandler:nil];

    [audioEngine startAndReturnError:nil];
    [audioPlayerNode setVolume:10.0];
    [audioPlayerNode play];
}

@end
