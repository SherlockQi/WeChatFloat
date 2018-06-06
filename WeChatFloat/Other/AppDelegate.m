//
//  AppDelegate.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/5/31.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "Marco.h"
#import "AppDelegate.h"
#import "HKHomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    HKHomeViewController *firendListVc = [[HKHomeViewController alloc]init];
    self.naviController = [[HKNavigationController alloc]initWithRootViewController:firendListVc];
    self.window.rootViewController = self.naviController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
