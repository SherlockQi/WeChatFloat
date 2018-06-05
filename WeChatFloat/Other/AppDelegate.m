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
#import "HKFloatAreaView.h"
#import "HKFloatBall.h"


#define kFloatAreaR  SCREEN_WIDTH * 0.45
#define kFloatMargin 30
#define kCoef        1.2
#define kBallSizeR   60

@interface AppDelegate ()<HKFloatBallDelegate>

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePan;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) HKFloatAreaView *floatArea;
@property (nonatomic, strong) HKFloatAreaView *cancelFloatArea;
@property (nonatomic, strong) HKFloatBall *floatBall;


@property (nonatomic, assign) BOOL showFloatBall;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    HKHomeViewController *firendListVc = [[HKHomeViewController alloc]init];
    self.naviController = [[HKNavigationController alloc]initWithRootViewController:firendListVc];
    self.window.rootViewController = self.naviController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Action

- (void)beginScreenEdgePanBack:(UIGestureRecognizer *)gestureRecognizer{
    self.edgePan = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.window addSubview:self.floatArea];
}
- (void)panBack:(CADisplayLink *)link {
    if (self.edgePan.state == UIGestureRecognizerStateChanged) {
        CGPoint tPoint =  [self.edgePan translationInView:self.window];
        CGFloat x = MAX(SCREEN_WIDTH + kFloatMargin - kCoef * tPoint.x,SCREEN_WIDTH - kFloatAreaR);
        CGFloat y = MAX(SCREEN_HEIGHT + kFloatMargin - kCoef * tPoint.x,SCREEN_HEIGHT - kFloatAreaR);
        CGRect rect = CGRectMake(x, y, kFloatAreaR, kFloatAreaR);
        self.floatArea.frame = rect;
        
        CGPoint touchPoint = [self.window convertPoint:[self.edgePan locationInView:self.window]  toView:self.floatArea];
        
        if (touchPoint.x > 0 && touchPoint.y > 0) {
            if (!self.showFloatBall) {
                if (pow((kFloatAreaR - touchPoint.x), 2) + pow((kFloatAreaR - touchPoint.y), 2)  <= pow((kFloatAreaR), 2)) {
                    self.showFloatBall = YES;
                }else{
                    if (self.showFloatBall) {
                        self.showFloatBall = NO;
                    }
                }
            }
        }else{
            if (self.showFloatBall) {
                self.showFloatBall = NO;
            }
        }
    }else  if (self.edgePan.state == UIGestureRecognizerStatePossible) {
        [self.floatArea removeFromSuperview];
        self.floatArea = nil;
        [self.link invalidate];
        self.link = nil;      
        if (self.showFloatBall) {        
            [self.window addSubview:self.floatBall];
        }
    } 
}
#pragma mark - HKFloatBallDelegate
- (void)floatBallDidClick:(HKFloatBall *)floatBall{
    
}
- (void)floatBallBeginMove:(HKFloatBall *)floatBall{
    [self.window  insertSubview:self.cancelFloatArea atIndex:1];
    CGPoint center_ball = [self.window convertPoint:self.floatBall.center toView:self.cancelFloatArea];
    if (pow((kFloatAreaR - center_ball.x), 2) + pow((kFloatAreaR - center_ball.y), 2)  <= pow((kFloatAreaR), 2)) {
        NSLog(@"------");
        if (!self.cancelFloatArea.highlight) {
            self.cancelFloatArea.highlight = YES;
        }
    }else{
        if (self.cancelFloatArea.highlight) {
            self.cancelFloatArea.highlight = NO;
        }
    }
}
-(void)floatBallEndMove:(HKFloatBall *)floatBall{
    
    if (self.cancelFloatArea.highlight) {
        [self.floatBall removeFromSuperview];
        self.floatBall = nil;
    }
    [self.cancelFloatArea removeFromSuperview];
    self.cancelFloatArea = nil;
    
}
#pragma mark - Setter 

- (void)setShowFloatBall:(BOOL)showFloatBall{
    _showFloatBall = showFloatBall;
      self.floatArea.highlight = showFloatBall;
}
#pragma mark - Lazy

-(CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(panBack:)];
    }
    return _link;
}
-(HKFloatAreaView *)floatArea{
    if (!_floatArea) {
        _floatArea = [[HKFloatAreaView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH + kFloatMargin, SCREEN_HEIGHT + kFloatMargin, kFloatAreaR, kFloatAreaR)];
        _floatArea.style = HKFloatAreaViewStyle_default;
    };
    return _floatArea;
}
-(HKFloatAreaView *)cancelFloatArea{
    if (!_cancelFloatArea) {
        _cancelFloatArea = [[HKFloatAreaView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - kFloatAreaR,SCREEN_HEIGHT - kFloatAreaR, kFloatAreaR, kFloatAreaR)];;
        _cancelFloatArea.style = HKFloatAreaViewStyle_cancel;
    };
    return _cancelFloatArea;
}
-(HKFloatBall *)floatBall{
    if (!_floatBall) {
        _floatBall = [[HKFloatBall alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - kBallSizeR - 15, SCREEN_HEIGHT /3, kBallSizeR, kBallSizeR)];
        _floatBall.delegate = self;
    };
    return _floatBall;
}

@end
