//
//  NSObject+hkvc.h
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/6.
//  Copyright © 2018年 HeiKki. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSObject (hkvc)
- (UIViewController *)hk_currentViewController;
- (UITabBarController *)hk_currentTabBarController;
- (UINavigationController *)hk_currentNavigationController;
@end
