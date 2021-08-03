//
//  DORDoneHUDView.m
//  DORDoneHUD
//
//  Created by Pawel Bednorz on 23/09/15.
//  Copyright © 2015 Droids on Roids. All rights reserved.
//

#import "DORDoneHUDView.h"

@interface DORDoneHUDView()
@property (strong, nonatomic) CAShapeLayer *lineLayer;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIView *blurView;
@end

@implementation DORDoneHUDView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)drawCheck:(void (^)(void))completionBlock {
    CGRect canvasFrame = CGRectMake(
                                 self.frame.size.width / 4,
                                 !self.messageText ? self.frame.size.height / 3 : self.frame.size.height / 5 * 2,
                                 self.frame.size.width / 2,
                                    self.frame.size.height / 3);
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(canvasFrame.origin.x, canvasFrame.origin.y + canvasFrame.size.height / 2)];
    [path addLineToPoint:CGPointMake(canvasFrame.origin.x + canvasFrame.size.width / 3, canvasFrame.origin.y)];
    [path addLineToPoint:CGPointMake(canvasFrame.origin.x + canvasFrame.size.width, canvasFrame.origin.y + canvasFrame.size.height)];
    self.lineLayer.frame = self.bounds;
    self.lineLayer.geometryFlipped = YES;
    self.lineLayer.path = path.CGPath;
    
    [self.layer addSublayer:self.lineLayer];
    [self animate:^{
        completionBlock();
    }];
}

- (void)clear {
    [self.lineLayer removeFromSuperlayer];
    [self.lineLayer removeAllAnimations];
    self.lineLayer.path = nil;
    
    self.messageText = nil;
    if (self.messageLabel) {
        [self.messageLabel removeFromSuperview];
        self.messageLabel = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.blurView) {
        self.blurView.frame = self.bounds;
    }
}

#pragma mark - Setters

-(void)setMessageText:(NSString *)messageText {
    _messageText = messageText;
    if (_messageText.length > 0) {
        self.messageLabel.text = _messageText;
    }
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        CGRect frame = CGRectMake(8, (self.frame.size.height / 5 * 4 - 10), self.frame.size.width - 16, 20);
        _messageLabel = [[UILabel alloc] initWithFrame:frame];
        _messageLabel.numberOfLines = 1;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _messageLabel.textColor = UIColor.blackColor;
        dispatch_async(dispatch_get_main_queue(), ^{
           [self addSubview:_messageLabel]; 
        });
    }
    return _messageLabel;
}

#pragma mark - Private methods

- (void)initialize {
    self.clipsToBounds = YES;
    
    self.lineLayer = [CAShapeLayer new];
    self.lineLayer.fillColor = UIColor.clearColor.CGColor;
    self.lineLayer.anchorPoint = CGPointMake(0, 0);
    self.lineLayer.lineJoin = kCALineJoinRound;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.contentsScale = self.layer.contentsScale;
    self.lineLayer.lineWidth = 8;
    self.lineLayer.strokeColor = UIColor.blackColor.CGColor;
    
    // Generate blur view
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    } else {
        self.blurView = [UIView new];
        self.blurView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    }

    [self insertSubview:self.blurView atIndex:0];
    self.blurView.frame = self.bounds;
}

- (void)animate:(void (^)(void))completionBlock {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.2;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0];
    [CATransaction begin];
    if (completionBlock) {
        [CATransaction setCompletionBlock:completionBlock];
    }
    [self.lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    [CATransaction commit];
}

@end
