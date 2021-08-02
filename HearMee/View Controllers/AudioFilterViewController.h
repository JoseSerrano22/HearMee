//
//  AudioFilterViewController.h
//  HearMee
//
//  Created by jose1009 on 7/26/21.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioFilterViewController : UIViewController

@property (strong, nonatomic) AVAudioFile *audioFile;

@end

NS_ASSUME_NONNULL_END
