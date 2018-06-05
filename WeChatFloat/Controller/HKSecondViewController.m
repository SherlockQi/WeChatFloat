//
//  HKSecondViewController.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/5/31.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKSecondViewController.h"
#import "AppDelegate.h"

@interface HKSecondViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation HKSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_imageView];
    _imageView.image = self.image;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc  = appDelegate.floatViewController;
    if (self == vc && appDelegate.floatBall) {
        [UIView animateWithDuration:0.5 animations:^{
            appDelegate.floatBall.alpha = 0;   
        }];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc  = appDelegate.floatViewController;
    if (self == vc && appDelegate.floatBall) {
        [UIView animateWithDuration:0.5 animations:^{
            appDelegate.floatBall.alpha = 1;   
        }];
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate beginScreenEdgePanBack:gestureRecognizer];
    return YES;
}


@end
