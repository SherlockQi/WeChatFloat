//
//  AppDelegate.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/5/31.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKMarco.h"
#import "AppDelegate.h"
#import "HKHomeViewController.h"
#import "HKFloatManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HKHomeViewController *firendListVc = [[HKHomeViewController alloc] init];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:firendListVc];
    naviController.navigationBar.tintColor = [UIColor whiteColor];
    naviController.navigationBar.barStyle = UIBarStyleBlack;
    self.window.rootViewController = naviController;
    [self.window makeKeyAndVisible];

    [HKFloatManager addFloatVcs:@[@"HKSecondViewController"]];
    return YES;
}

@end
