//
//  HKFloatManager.h
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/6.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HKNavigationController.h"
#import "HKFloatBall.h"

@interface HKFloatManager : NSObject


//@property (nonatomic, strong) HKNavigationController *naviController;
@property (nonatomic, strong) HKFloatBall *floatBall;
@property (nonatomic, strong) UIViewController *tempFloatViewController;
@property (nonatomic, strong) UIViewController *floatViewController;


+ (instancetype)shared;
- (void)beginScreenEdgePanBack:(UIGestureRecognizer *)gestureRecognizer;

@end
