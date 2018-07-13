//
//  HKFloatManager.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/6.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKFloatManager.h"
#import "HKFloatAreaView.h"
#import "HKTransitionPush.h"
#import "HKTransitionPop.h"
#import "HKMarco.h"
#import "NSObject+hkvc.h"


#import <objc/runtime.h>


#define kFloatAreaR  SCREEN_WIDTH * 0.45
#define kFloatMargin 30
#define kCoef        1.2
#define kBallSizeR   60

@interface HKFloatManager () <HKFloatBallDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, strong) HKFloatAreaView *floatArea;
@property(nonatomic, strong) HKFloatAreaView *cancelFloatArea;
@property(nonatomic, strong) UIViewController *tempFloatViewController;

@property(nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePan;
@property(nonatomic, strong) CADisplayLink *link;
@property(nonatomic, assign) BOOL showFloatBall;
@property(nonatomic, strong) NSMutableArray<NSString *> *floatVcClass;

@end

@implementation HKFloatManager

+ (instancetype)shared {
    static HKFloatManager *floatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatManager = [[super allocWithZone:nil] init];
        floatManager.floatVcClass = [NSMutableArray array];
        [floatManager hk_currentNavigationController].interactivePopGestureRecognizer.delegate = floatManager;
        [floatManager hk_currentNavigationController].delegate = floatManager;
    });
    return floatManager;
}

+ (void)addFloatVcs:(NSArray<NSString *> *)vcClass {
    [vcClass enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (![[HKFloatManager shared].floatVcClass containsObject:obj]) {
            [[HKFloatManager shared].floatVcClass addObject:obj];
        }
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self hk_currentNavigationController].viewControllers.count > 1) {
        [[HKFloatManager shared] beginScreenEdgePanBack:gestureRecognizer];
        return YES;
    }
    return NO;
}

#pragma mark - Action

- (void)beginScreenEdgePanBack:(UIGestureRecognizer *)gestureRecognizer {

    if ([self.floatVcClass containsObject:NSStringFromClass([[self hk_currentViewController] class])]) {
        self.edgePan = (UIScreenEdgePanGestureRecognizer *) gestureRecognizer;
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [kWindow addSubview:self.floatArea];
        self.tempFloatViewController = [self hk_currentViewController];
    }
}

- (void)panBack:(CADisplayLink *)link {
    if (self.edgePan.state == UIGestureRecognizerStateChanged) {
        CGPoint tPoint = [self.edgePan translationInView:kWindow];
        CGFloat x = MAX(SCREEN_WIDTH + kFloatMargin - kCoef * tPoint.x, SCREEN_WIDTH - kFloatAreaR);
        CGFloat y = MAX(SCREEN_HEIGHT + kFloatMargin - kCoef * tPoint.x, SCREEN_HEIGHT - kFloatAreaR);
        CGRect rect = CGRectMake(x, y, kFloatAreaR, kFloatAreaR);
        self.floatArea.frame = rect;

        CGPoint touchPoint = [kWindow convertPoint:[self.edgePan locationInView:kWindow] toView:self.floatArea];

        if (touchPoint.x > 0 && touchPoint.y > 0) {
            if (!self.showFloatBall) {
                if (pow((kFloatAreaR - touchPoint.x), 2) + pow((kFloatAreaR - touchPoint.y), 2) <= pow((kFloatAreaR), 2)) {
                    self.showFloatBall = YES;
                } else {
                    if (self.showFloatBall) {
                        self.showFloatBall = NO;
                    }
                }
            }
        } else {
            if (self.showFloatBall) {
                self.showFloatBall = NO;
            }
        }
    } else if (self.edgePan.state == UIGestureRecognizerStatePossible) {
        [UIView animateWithDuration:0.5 animations:^{
            self.floatArea.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT, kFloatAreaR, kFloatAreaR);
        }                completion:^(BOOL finished) {
            [self.floatArea removeFromSuperview];
            self.floatArea = nil;
            [self.link invalidate];
            self.link = nil;
            if (self.showFloatBall) {
                self.floatViewController = self.tempFloatViewController;
                if ([self haveIconImage]) {
                    self.floatBall.iconImageView.image = [self.floatViewController valueForKey:@"hk_iconImage"];
                }
                self.floatBall.alpha = 1;
                [kWindow addSubview:self.floatBall];
            }
        }];
    }
}

#pragma mark - HKFloatBallDelegate

- (void)floatBallDidClick:(HKFloatBall *)floatBall {
    [[self hk_currentNavigationController] pushViewController:self.floatViewController animated:YES];
}

- (void)floatBallBeginMove:(HKFloatBall *)floatBall {
    if (!_cancelFloatArea) {
        [kWindow insertSubview:self.cancelFloatArea atIndex:1];
        [UIView animateWithDuration:0.5 animations:^{
            self.cancelFloatArea.frame = CGRectMake(SCREEN_WIDTH - kFloatAreaR, SCREEN_HEIGHT - kFloatAreaR, kFloatAreaR, kFloatAreaR);
        }];
    }
    CGPoint center_ball = [kWindow convertPoint:self.floatBall.center toView:self.cancelFloatArea];
    if (pow((kFloatAreaR - center_ball.x), 2) + pow((kFloatAreaR - center_ball.y), 2) <= pow((kFloatAreaR), 2)) {
        if (!self.cancelFloatArea.highlight) {
            self.cancelFloatArea.highlight = YES;
        }
    } else {
        if (self.cancelFloatArea.highlight) {
            self.cancelFloatArea.highlight = NO;
        }
    }
}

- (void)floatBallEndMove:(HKFloatBall *)floatBall {

    if (self.cancelFloatArea.highlight) {
        self.tempFloatViewController = nil;
        self.floatViewController = nil;
        [self.floatBall removeFromSuperview];
        self.floatBall = nil;
    }

    [UIView animateWithDuration:0.5 animations:^{
        self.cancelFloatArea.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT, kFloatAreaR, kFloatAreaR);
    }                completion:^(BOOL finished) {
        [self.cancelFloatArea removeFromSuperview];
        self.cancelFloatArea = nil;
    }];
}

#pragma UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {

    UIViewController *vc = self.floatViewController;
    if (vc) {
        if (operation == UINavigationControllerOperationPush) {
            if (toVC != vc) {
                return nil;
            }
            HKTransitionPush *transition = [[HKTransitionPush alloc] init];
            return transition;
        } else if (operation == UINavigationControllerOperationPop) {
            if (fromVC != vc) {
                return nil;
            }
            HKTransitionPop *transition = [[HKTransitionPop alloc] init];
            return transition;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (BOOL)haveIconImage {
    BOOL have = NO;
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self.floatViewController class], &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        const char *nameChar = ivar_getName(ivar);
        NSString *nameStr = [NSString stringWithFormat:@"%s", nameChar];
        if ([nameStr isEqualToString:@"_hk_iconImage"]) {
            have = YES;
        }
    }
    free(ivars);
    return have;
}

#pragma mark - Setter

- (void)setShowFloatBall:(BOOL)showFloatBall {
    _showFloatBall = showFloatBall;
    self.floatArea.highlight = showFloatBall;
}

#pragma mark - Lazy

- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(panBack:)];
    }
    return _link;
}

- (HKFloatAreaView *)floatArea {
    if (!_floatArea) {
        _floatArea = [[HKFloatAreaView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH + kFloatMargin, SCREEN_HEIGHT + kFloatMargin, kFloatAreaR, kFloatAreaR)];
        _floatArea.style = HKFloatAreaViewStyle_default;
    };
    return _floatArea;
}

- (HKFloatAreaView *)cancelFloatArea {
    if (!_cancelFloatArea) {
        _cancelFloatArea = [[HKFloatAreaView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT, kFloatAreaR, kFloatAreaR)];;
        _cancelFloatArea.style = HKFloatAreaViewStyle_cancel;
    };
    return _cancelFloatArea;
}

- (HKFloatBall *)floatBall {
    if (!_floatBall) {
        _floatBall = [[HKFloatBall alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kBallSizeR - 15, SCREEN_HEIGHT / 3, kBallSizeR, kBallSizeR)];
        _floatBall.delegate = self;
    };
    return _floatBall;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [HKFloatManager shared];
}

- (id)copyWithZone:(NSZone *)zone {
    return [HKFloatManager shared];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [HKFloatManager shared];
}
@end
