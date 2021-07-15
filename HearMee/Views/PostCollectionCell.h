//
//  PostCollectionCell.h
//  HearMee
//
//  Created by jose1009 on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *const postImage;

@property (nonatomic, strong) Post *post;

-(void)setPost:(Post *)post;
@end

NS_ASSUME_NONNULL_END
