//
//  HKFloatManager.h
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/6.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HKFloatBall.h"

@interface HKFloatManager : NSObject
@property (nonatomic, strong) HKFloatBall *floatBall;
+ (instancetype)shared;
+ (void)addFloatVcs:(NSArray<NSString *>*)vcClass;

/*
如其它牛逼第三方设置了 interactivePopGestureRecognizer
 
可以在interactivePopGestureRecognizer代理中调用该方法 并删除HKFloatManager.m 中的第45行
 
如FDFullscreenPopGesture
可以在 UINavigationController+FDFullscreenPopGesture.m 的
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer 返回 YES 前
调用 [[HKFloatManager shared] beginScreenEdgePanBack:gestureRecognizer];
并删除本项目 HKFloatManager.m 第45行
 **/
- (void)beginScreenEdgePanBack:(UIGestureRecognizer *)gestureRecognizer;
@end
