//
//  HKBaseViewController.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/5/31.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKBaseViewController.h"

@interface HKBaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePan;

@end

@implementation HKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = self.navigationController.viewControllers.count != 1;
}
@end
