//
//  AVAudioPlayerNode+Extension.h
//  HearMee
//
//  Created by jose1009 on 8/3/21.
//

#import <AVFAudio/AVFAudio.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAudioPlayerNode (Extension)

+(void)typeOfAudioFilter:(NSString * _Nullable)filterName withAudioFile:(AVAudioFile * _Nullable)audioFile withAudioEngine:(AVAudioEngine * _Nullable)audioEngine withAudioPlayerNode:(AVAudioPlayerNode * _Nullable)audioPlayerNode withAudioPlayer:(AVAudioPlayer * _Nullable)player withURL:(NSURL * _Nullable)url;

+(void)playAudioPlayerNode:(AVAudioPlayerNode * _Nullable)audioPlayerNode withAudioEngine:(AVAudioEngine * _Nullable)audioEngine withAudioFile:(AVAudioFile * _Nullable)audioFile;

@end

NS_ASSUME_NONNULL_END
