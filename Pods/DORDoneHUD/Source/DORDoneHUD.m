//
//  DORDoneHUD.m
//  DORDoneHUD
//
//  Created by Pawel Bednorz on 23/09/15.
//  Copyright © 2015 Droids on Roids. All rights reserved.
//

//Views
#import "DORDoneHUDView.h"

//Interface
#import "DORDoneHUD.h"

@interface DORDoneHUD ()
@property (strong, nonatomic) DORDoneHUDView *doneView;
@end

@implementation DORDoneHUD

+ (instancetype)sharedInstance {
    static id sharedObject;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [self new];
    });

    return sharedObject;
}

+ (void)show:(UIView *)view message:(NSString *)messageText completion:(void (^)(void))completionBlock {
    [[DORDoneHUD sharedInstance] show:view message:messageText completion:completionBlock];
}

+ (void)show:(UIView *)view message:(NSString *)messageText {
    [DORDoneHUD show:view message:messageText completion:nil];
}

+ (void)show:(UIView *)view {
    [DORDoneHUD show:view message:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.doneView = [DORDoneHUDView new];
    }
    return self;
}

- (void)show:(UIView *)view message:(NSString *)messageText completion:(void (^)(void))completionBlock; {
    CGFloat doneViewWidth = fmin(view.frame.size.width, view.frame.size.height) / 2;
    CGFloat originX, originY;
    if ([UIDevice currentDevice ].systemVersion.floatValue >= 8.0) {
        originX = (view.frame.size.width - doneViewWidth) / 2;
        originY = (view.frame.size.height - doneViewWidth) / 2;
    } else {
        BOOL isLandscape = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
        originX = ((isLandscape ? view.frame.size.height : view.frame.size.width) - doneViewWidth) / 2;
        originY = ((isLandscape ? view.frame.size.width : view.frame.size.height) - doneViewWidth) / 2;
    }
    CGRect doneViewFrame = CGRectMake(originX, originY, doneViewWidth, doneViewWidth);
    self.doneView.layer.cornerRadius = 8.0;
    self.doneView.frame = doneViewFrame;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.doneView.alpha = 0.0;
        self.doneView.messageText = messageText;
        [view addSubview:self.doneView];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.doneView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.doneView drawCheck:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.2 animations:^{
                        self.doneView.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        [self.doneView removeFromSuperview];
                        [self.doneView clear];
                        if (completionBlock) {
                            completionBlock();
                        }
                    }];
                });
            }];
        }];
    });
}

@end
