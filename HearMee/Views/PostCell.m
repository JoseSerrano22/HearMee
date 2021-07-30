//
//  PostCell.m
//  HearMee
//
//  Created by jose1009 on 7/14/21.
//

#import "PostCell.h"

@implementation PostCell

-(void)setPost:(Post *)post{
    
    _post = post;
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    PFUser *const postAuthor = self.post.author;
    
    [postAuthor fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        PFFileObject *const image = postAuthor[@"profile_image"];
        NSURL *const url = [NSURL URLWithString:image.url];
        [self.profileImage setImageWithURL:url];
    }];
    
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.postImage.image = [UIImage imageWithData:data];
        }
    }];
    
    self.captionLabel.text = post.caption;
    self.usernameLabel.text = post.author.username;
    self.likeLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    self.commentLabel.text = [NSString stringWithFormat:@"%@", self.post.commentCount];
    self.likeButton.selected = [self.post.likedByUsername containsObject:PFUser.currentUser.objectId];
    
    NSString *const createdAtOriginalString = self.timestampLabel.text = [NSString stringWithFormat:@"%@", post.createdAt];
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

#pragma mark - Private

- (IBAction)_didTapFavorite:(id)sender {
    
    if(self.likeButton.selected){
        self.likeButton.selected = false;
        [self.likeButton setSelected:NO];
        self.post.likeCount = [NSNumber numberWithInteger:([self.post.likeCount intValue] - 1)];
        [self.post unlike];
        
    } else if(!self.likeButton.selected) {
        self.likeButton.selected = true;
        [self.likeButton setSelected:YES];
        self.post.likeCount = [NSNumber numberWithInteger:([self.post.likeCount intValue] + 1)];
        if(!self.post.likedByUsername) {
            self.post.likedByUsername = [NSMutableArray new];
        }
        [self.post like];
    }
    self.likeLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
}

- (IBAction)_playAudioDidTap:(id)sender {
    
    [self.post fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            
            PFFileObject *const audioObject = self.post.audio;
            NSURL *const url = [NSURL URLWithString:audioObject.url];
            NSData *const data = [NSData dataWithContentsOfURL:url];
            
            NSString *const filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"AudioMemo.acc"];
            [data writeToFile:filePath atomically:YES];
            NSArray *const pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
            NSString *const documentsDirectory = [pathArray objectAtIndex:0];
            NSString *const soundPath = [documentsDirectory stringByAppendingPathComponent:@"AudioMemo.acc"];
            
            NSURL *soundUrl;
            if ([[NSFileManager defaultManager] fileExistsAtPath:soundPath]){
                soundUrl = [NSURL fileURLWithPath:soundPath isDirectory:NO];
            }
            
            [self _typeOfAudioFilter:self.post.filterName withURL:soundUrl];
        }
    }];
}

- (IBAction)_backwardDidTap:(id)sender {
    
    NSTimeInterval time = self.player.currentTime;
    time -= 3;
    
    if (time < 0){
        [self.player stop];
    } else {
        self.player.currentTime = time;
    }
}

- (IBAction)_forwardDidTap:(id)sender {
    
    NSTimeInterval time = self.player.currentTime;
    time += 3;
    
    if (time > self.player.duration){
        [self.player stop];
    } else {
        self.player.currentTime = time;
    }
}

-(void)_typeOfAudioFilter:(NSString * _Nullable)filterName withURL:(NSURL * _Nonnull)url {
    
    self.audioFile = [[AVAudioFile alloc] initForReading:url error:nil];
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.audioPlayerNode = [[AVAudioPlayerNode alloc] init];
    [self.audioEngine attachNode:self.audioPlayerNode];
    
    AVAudioUnitTimePitch *const changeRatePitchNode = [[AVAudioUnitTimePitch alloc] init];
    AVAudioUnitDistortion *const echoNode = [[AVAudioUnitDistortion alloc] init];
    AVAudioUnitReverb *const reverbNode = [[AVAudioUnitReverb alloc] init];
    
    if ([filterName isEqualToString:@"slow"]){
        
        changeRatePitchNode.rate = 0.5;
        
        [self.audioEngine attachNode:changeRatePitchNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    } else if ([filterName isEqualToString:@"fast"]){
        
        changeRatePitchNode.rate = 2.0;
        
        [self.audioEngine attachNode:changeRatePitchNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    } else if ([filterName isEqualToString:@"highPitch"]){
        
        changeRatePitchNode.pitch = 1000;
        
        [self.audioEngine attachNode:changeRatePitchNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:changeRatePitchNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    } else if ([filterName isEqualToString:@"lowPitch"]){
        
        changeRatePitchNode.rate = .90;
        changeRatePitchNode.pitch = -400;
        [reverbNode loadFactoryPreset:AVAudioUnitReverbPresetMediumHall];
        [reverbNode setWetDryMix:16];
        
        [self.audioEngine attachNode:changeRatePitchNode];
        [self.audioEngine attachNode:reverbNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:changeRatePitchNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:changeRatePitchNode to:reverbNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:reverbNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    } else if ([filterName isEqualToString:@"echo"]){
        
        [echoNode loadFactoryPreset:AVAudioUnitDistortionPresetMultiEcho1];
        
        [self.audioEngine attachNode:echoNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:echoNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:echoNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    } else if ([filterName isEqualToString:@"reverb"]){
        
        [reverbNode loadFactoryPreset:AVAudioUnitReverbPresetCathedral];
        [reverbNode setWetDryMix:50];
        
        [self.audioEngine attachNode:reverbNode];
        
        [self.audioEngine connect:self.audioPlayerNode to:reverbNode format:self.audioFile.processingFormat];
        [self.audioEngine connect:reverbNode to:self.audioEngine.outputNode format:self.audioFile.processingFormat];
        
        [self.audioPlayerNode stop];
        [self.audioPlayerNode scheduleFile:self.audioFile atTime:nil completionHandler:nil];
        
        [self.audioEngine startAndReturnError:nil];
        [self.audioPlayerNode setVolume:10.0];
        [self.audioPlayerNode play];
        
    }else{
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.player.volume = 10.0;
        [self.player play];
    }
}

@end
