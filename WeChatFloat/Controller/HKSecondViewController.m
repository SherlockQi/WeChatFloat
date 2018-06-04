//
//  HKSecondViewController.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/5/31.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKSecondViewController.h"
#import "AppDelegate.h"

@interface HKSecondViewController ()<UIGestureRecognizerDelegate>


@end

@implementation HKSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"SECOND";

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate beginScreenEdgePanBack:gestureRecognizer];
    return YES;
}


@end
