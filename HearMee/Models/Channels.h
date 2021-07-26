//
//  Channels.h
//  HearMee
//
//  Created by jose1009 on 7/20/21.
//

#import "Parse/Parse.h"
#import "PFObject.h"

@interface Channels : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *title;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;


+ (void) postChannelTitle: ( NSString * _Nullable )title withImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
