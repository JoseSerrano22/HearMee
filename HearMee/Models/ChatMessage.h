//
//  ChatMessage.h
//  HearMee
//
//  Created by jose1009 on 7/19/21.
//
#import "Parse/Parse.h"
#import "PFObject.h"

@interface ChatMessage : PFObject <PFSubclassing>
@property (nonatomic, strong) PFUser *author;
@property (strong, nonatomic) NSString *message;
@property (nonatomic, strong) NSDate *createdAt;

+ (void) postMessage: ( NSString * _Nullable )message withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end
