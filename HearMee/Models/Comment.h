//
//  Comment.h
//  HearMee
//
//  Created by jose1009 on 8/1/21.
//

#import "Parse/Parse.h"
#import "PFObject.h"

@interface Comment : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (strong, nonatomic) NSString *comment;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) PFObject *postID;

+ (void) postComment: ( NSString * _Nullable )comment withPostID:(PFObject* _Nonnull)postID withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
