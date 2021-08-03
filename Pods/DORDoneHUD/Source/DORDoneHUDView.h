//
//  DORDoneHUDView.h
//  DORDoneHUD
//
//  Created by Pawel Bednorz on 23/09/15.
//  Copyright © 2015 Droids on Roids. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DORDoneHUDView : UIView
@property (strong, nonatomic) NSString *messageText;
- (void)drawCheck:(void (^)(void))completionBlock;
- (void)clear;
@end
