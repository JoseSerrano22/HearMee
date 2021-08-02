//
//  Comment.m
//  HearMee
//
//  Created by jose1009 on 8/1/21.
//

#import "Comment.h"

@implementation Comment

@dynamic author;
@dynamic comment;
@dynamic createdAt;
@dynamic postID;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

+ (void) postComment: ( NSString * _Nullable )comment withPostID:(PFObject* _Nonnull)postID withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    Comment *newComment = [Comment new];
    newComment.author = [PFUser currentUser];
    newComment.comment = comment;
    newComment.postID = postID;
    newComment.createdAt = [NSDate date];
    [newComment saveInBackgroundWithBlock: completion];
}

@end
