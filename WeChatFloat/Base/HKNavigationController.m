//
//  HKNavigationController.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/5/31.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKNavigationController.h"
#import "HKTransitionPush.h"
#import "HKTransitionPop.h"
//#import "AppDelegate.h"
#import "HKFloatManager.h"

@interface HKNavigationController ()<UINavigationControllerDelegate>

@end

@implementation HKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.delegate = self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    
    UIViewController *vc  = [HKFloatManager shared].floatViewController;
    if (!vc) {
        return nil;
    }
    if(operation==UINavigationControllerOperationPush)
    {
        if (toVC != vc) {
            return nil;
        }
        HKTransitionPush *transition = [[HKTransitionPush alloc]init];
        return transition;
    }
    else if(operation==UINavigationControllerOperationPop)
    {
        if (fromVC != vc) {
            return nil;
        }
        HKTransitionPop *transition = [[HKTransitionPop alloc]init];
        return transition;
    }
    else
    {
        return nil;
    }
    
}
@end
