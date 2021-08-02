//
//  ChatCell.m
//  HearMee
//
//  Created by jose1009 on 7/19/21.
//

#import "ChatCell.h"

@implementation ChatCell

-(void)setMessage:(ChatMessage *)message{
    
    _message = message;
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
        PFUser *const messageAuthor = self.message.author;
        [messageAuthor fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            PFFileObject *const image = messageAuthor[@"profile_image"];
            NSURL *const url = [NSURL URLWithString:image.url];
            [self.profileImage setImageWithURL:url];
        }];
    
    self.messageLabel.text = message.message;
    self.usernameLabel.text = message.author.username;
    self.bubbleView.layer.cornerRadius = 16;
    self.bubbleView.clipsToBounds = true;
    
    NSString *const createdAtOriginalString = self.timestampLabel.text = [NSString stringWithFormat:@"%@", message.createdAt];
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
