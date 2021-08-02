//
//  PostCollectionCell.m
//  HearMee
//
//  Created by jose1009 on 7/14/21.
//

#import "PostCollectionCell.h"

@implementation PostCollectionCell

-(void)setPost:(Post *)post{
    
    _post = post;
    
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.postImage.image = [UIImage imageWithData:data];
        }
    }];
}

@end
