//
//  NSObject+hkvc.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/6.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "NSObject+hkvc.h"

@implementation NSObject (hkvc)
- (UIViewController *)hk_currentViewController
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
//    while (vc.presentedViewController)
//    {
//        vc = vc.presentedViewController;
//        
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
//    }
    return vc;
}

- (UINavigationController *)hk_currentNavigationController
{
    return [self hk_currentViewController].navigationController;
}
- (UITabBarController *)hk_currentTabBarController
{
    return [self hk_currentViewController].tabBarController;
}

@end
