//
//  PostRecordViewController.h
//  HearMee
//
//  Created by jose1009 on 7/30/21.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostRecordViewController : UIViewController

@property (strong, nonatomic) AVAudioFile *audioFile;
@property (strong, nonatomic) NSString *filterName;

@end

NS_ASSUME_NONNULL_END
