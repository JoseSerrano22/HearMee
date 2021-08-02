//
//  CommentCell.m
//  HearMee
//
//  Created by jose1009 on 8/2/21.
//

#import "CommentCell.h"

@implementation CommentCell

-(void)setComment:(Comment *)comment{
    
    _comment = comment;
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
        PFUser *const messageAuthor = self.comment.author;
        [messageAuthor fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            PFFileObject *const image = messageAuthor[@"profile_image"];
            NSURL *const url = [NSURL URLWithString:image.url];
            [self.profileImage setImageWithURL:url];
        }];
    
    self.commentLabel.text = comment.comment;
    self.usernameLabel.text = comment.author.username;
    
    NSString *const createdAtOriginalString = self.timestampLabel.text = [NSString stringWithFormat:@"%@", comment.createdAt];
    NSDateFormatter *const formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
    NSDate *const date = [formatter dateFromString:createdAtOriginalString];
    NSDate *const now = [NSDate date];
    NSInteger timeApart = [now hoursFrom:date];
    
    if (timeApart >= 24) {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.timestampLabel.text = [formatter stringFromDate:date];
    }
    else {
        self.timestampLabel.text = date.shortTimeAgoSinceNow;
    }
}

@end
