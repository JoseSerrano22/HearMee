//
//  Post.h
//  HearMee
//
//  Created by jose1009 on 7/13/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "AVFoundation/AVFoundation.h"

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) PFFileObject *audio;
@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSMutableArray *likedByUsername;

+ (void) postUserAudio: ( AVAudioFile * _Nullable )audio withFilter:( NSString * _Nullable )filter withImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

- (void) like;
- (void) unlike;

@end


