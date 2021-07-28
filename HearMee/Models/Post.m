//
//  Post.m
//  HearMee
//
//  Created by jose1009 on 7/13/21.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic audio;
@dynamic filterName;
@dynamic likeCount;
@dynamic commentCount;
@dynamic createdAt;
@dynamic likedByUsername;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserAudio: ( AVAudioFile * _Nullable )audio withImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.audio = [self getPFFileFromAudio:audio];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    newPost.createdAt = [NSDate date];
    newPost.likedByUsername = [NSMutableArray new];
    [newPost saveInBackgroundWithBlock: completion];
}

+ (void) postUserAudio: ( AVAudioFile * _Nullable )audio withFilter:( NSString * _Nullable )filter withImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.audio = [self getPFFileFromAudio:audio];
    newPost.filterName = filter;
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    newPost.createdAt = [NSDate date];
    newPost.likedByUsername = [NSMutableArray new];
    [newPost saveInBackgroundWithBlock: completion];
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {

    if (!image) {return nil;}
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {return nil;}
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (PFFileObject *)getPFFileFromAudio: ( AVAudioFile* _Nullable)audio {

    if (!audio) {return nil;}
    NSData *audioData = [NSData dataWithContentsOfURL:audio.url];
    if (!audioData) {return nil;}
    return [PFFileObject fileObjectWithName:@"AudioMemo.acc" data:audioData];
}

- (void)like {
    [self.likedByUsername addObject:PFUser.currentUser.objectId];
    [self setObject:self.likedByUsername forKey:@"likedByUsername"];
    [self saveInBackground];
}

- (void)unlike {
    [self.likedByUsername removeObject:PFUser.currentUser.objectId];
    [self setObject:self.likedByUsername forKey:@"likedByUsername"];
    [self saveInBackground];
}

@end
