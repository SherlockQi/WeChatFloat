//
//  HKSecondViewController.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/5/31.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKSecondViewController.h"
#import "HKFloatManager.h"

@interface HKSecondViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation HKSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_imageView];
    _imageView.image = self.image;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    [[HKFloatManager shared] beginScreenEdgePanBack:gestureRecognizer];
    return YES;
}

@end
