//
//  NSObject+hkvc.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/6.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "NSObject+hkvc.h"

@implementation NSObject (hkvc)
- (UIViewController *)hk_currentViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController *) vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *) vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

- (UINavigationController *)hk_currentNavigationController {
    return [self hk_currentViewController].navigationController;
}

- (UITabBarController *)hk_currentTabBarController {
    return [self hk_currentViewController].tabBarController;
}

@end
