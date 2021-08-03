//
//  DORDoneHUD.h
//  DORDoneHUD
//
//  Created by Pawel Bednorz on 23/09/15.
//  Copyright © 2015 Droids on Roids. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DORDoneHUD : NSObject
+ (void)show:(UIView *)view message:(NSString *)messageText completion:(void (^)(void))completionBlock;
+ (void)show:(UIView *)view message:(NSString *)messageText;
+ (void)show:(UIView *)view;
@end
