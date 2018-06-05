//
//  AppDelegate.h
//  WeChatFloat
//
//  Created by HeiKki on 2018/5/31.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKNavigationController.h"
#import "HKFloatBall.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) HKNavigationController *naviController;
@property (nonatomic, strong) HKFloatBall *floatBall;
@property (nonatomic, strong) UIViewController *tempFloatViewController;
@property (nonatomic, strong) UIViewController *floatViewController;

- (void)beginScreenEdgePanBack:(UIGestureRecognizer *)gestureRecognizer;
@end

