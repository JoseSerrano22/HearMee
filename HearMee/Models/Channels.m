//
//  Channels.m
//  HearMee
//
//  Created by jose1009 on 7/20/21.
//

#import "Channels.h"

@implementation Channels

@dynamic title;
@dynamic caption;
@dynamic image;

+ (nonnull NSString *)parseClassName {
    return @"Channels";
}

+ (void) postChannelTitle: ( NSString * _Nullable )title withImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Channels *newChannel = [Channels new];
    
    newChannel.title = title;
    newChannel.image = [self getPFFileFromImage:image];
    newChannel.caption = caption;
    [newChannel saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {

    if (!image) {return nil;}
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {return nil;}
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
