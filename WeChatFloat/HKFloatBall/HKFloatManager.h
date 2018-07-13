//
//  HKFloatManager.h
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/6.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HKFloatBall.h"

@interface HKFloatManager : NSObject
@property(nonatomic, strong) HKFloatBall *floatBall;
@property(nonatomic, strong) UIViewController *floatViewController;

+ (instancetype)shared;

+ (void)addFloatVcs:(NSArray<NSString *> *)vcClass;//注意.在导航控制器实例化之后调用
- (void)beginScreenEdgePanBack:(UIGestureRecognizer *)gestureRecognizer;

@end


/*
 分析
 知识点:
 1.监听侧滑返回
 2.自定义push/pop动画

 上述两个方面,分别利用 interactivePopGestureRecognizer 和 navigationController.delegate 实现
 **/


/*注:1  ****** 没有出现动画 ****** 
 如遇到 navigationController.delegate 在别的地方被调用
 
 可在代理方法
 - (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
 animationControllerForOperation:(UINavigationControllerOperation)operation
 fromViewController:(UIViewController *)fromVC
 toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);
 
 最前方插入下方代码
 
UIViewController *vc  = self.floatViewController;
if (vc) {
    if(operation==UINavigationControllerOperationPush){
        if (toVC != vc) {
            return nil;
        }
        HKTransitionPush *transition = [[HKTransitionPush alloc]init];
        return transition;
    }else if(operation==UINavigationControllerOperationPop){
        if (fromVC != vc) {
            return nil;
        }
        HKTransitionPop *transition = [[HKTransitionPop alloc]init];
        return transition;
    }else{
        return nil;
    }
}
 **/

/*注:2   ****** 不出现右下视图 ****** 
 如其它牛逼第三方设置了 interactivePopGestureRecognizer
 
 可以在interactivePopGestureRecognizer代理中调用该方法 并删除HKFloatManager.m 中的第45行
 
 [[HKFloatManager shared] beginScreenEdgePanBack:gestureRecognizer];
 
 如FDFullscreenPopGesture
 可以在 UINavigationController+FDFullscreenPopGesture.m 的
 - (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer 返回 YES 前
 调用 [[HKFloatManager shared] beginScreenEdgePanBack:gestureRecognizer];
 并删除本项目 HKFloatManager.m 第45行
 **/
