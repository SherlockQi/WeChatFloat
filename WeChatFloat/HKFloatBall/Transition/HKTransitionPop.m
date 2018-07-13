//
//  HKTransitionPop.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/5.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKTransitionPop.h"
#import "HKFloatManager.h"
#import "HKMarco.h"

#define kAuration 0.5

@interface HKTransitionPop () <CAAnimationDelegate>
@property(nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property(nonatomic, strong) UIView *coverView;
@end

@implementation HKTransitionPop
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return kAuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *contView = [transitionContext containerView];
    [contView addSubview:toVC.view];
    [contView addSubview:fromVC.view];

    CGRect floatBallRect = [HKFloatManager shared].floatBall.frame;
    [toVC.view addSubview:self.coverView];

    UIBezierPath *maskStartBP = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(floatBallRect.origin.x, floatBallRect.origin.y, floatBallRect.size.width, floatBallRect.size.height) cornerRadius:floatBallRect.size.height / 2];

    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) cornerRadius:floatBallRect.size.width / 2];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskStartBP.CGPath;
    fromVC.view.layer.mask = maskLayer;

    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.toValue = (__bridge id) (maskStartBP.CGPath);
    maskLayerAnimation.fromValue = (__bridge id) ((maskFinalBP.CGPath));
    maskLayerAnimation.duration = kAuration;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];


    [UIView animateWithDuration:kAuration animations:^{
        self.coverView.alpha = 0;
    }];
    [UIView animateWithDuration:kAuration animations:^{
        [HKFloatManager shared].floatBall.alpha = 1;
    }];

}

#pragma mark - CABasicAnimation的Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transitionContext completeTransition:YES];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    [self.coverView removeFromSuperview];
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.5;
    };
    return _coverView;
}
@end
