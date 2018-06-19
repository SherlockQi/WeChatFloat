# WeChatFloat
仿微信浮窗功能


![image](https://github.com/SherlockQi/HKNote/blob/master/image/WeChatFloat.gif)


微信的大佬一定用了了不起的技术,我这里只是实现效果.


简单写了一个库,一句代码即可实现效果
https://github.com/SherlockQi/WeChatFloat
```
//在AppDelegate中将类名传入即可
[HKFloatManager addFloatVcs:@[@"HKSecondViewController"]];

 还需要注意以下两个代理 
 实现监听侧滑返回  interactivePopGestureRecognizer
 实现自定义push/pop动画  navigationController.delegate
 如被占用 可以将本项目中的实现代码进行移植.
```

使用到的技术点

监听侧滑返回
```   
//设置边缘侧滑代理
self.navigationController.interactivePopGestureRecognizer.delegate = self;

//当开始侧滑pop时调用此方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    /* 判断是否开启边缘侧滑返回 **/
    if (self.navigationController.viewControllers.count > 1) {
         [self beginScreenEdgePanBack:gestureRecognizer];
        return YES;
    }
    return NO;
}
/* UIScreenEdgePanGestureRecognizer
@property(nullable, nonatomic, readonly) UIGestureRecognizer *interactivePopGestureRecognizer NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
/*! This subclass of UIPanGestureRecognizer only recognizes if the user slides their finger
    in from the bezel on the specified edge. */
//NS_CLASS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED @interface UIScreenEdgePanGestureRecognizer : UIPanGestureRecognizer
**/
//利用CADisplayLink 来实现监听返回手势
- (void)beginScreenEdgePanBack:(UIGestureRecognizer *)gestureRecognizer{
         /*
          * 引用 gestureRecognizer
          * 开启 CADisplayLink
          * 显示右下视图
          **/
    self.edgePan = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(panBack:)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [[UIApplication sharedApplication].keyWindow addSubview:self.floatArea];
}
//此方法中进行操作
- (void)panBack:(CADisplayLink *)link {
    //判断手势状态
    if (self.edgePan.state == UIGestureRecognizerStateChanged) {//移动过程
       /*
        * 改变右下视图 frame
        * 判断手指是否进入右下视图中
        **/
    //手指在屏幕上的位置    
    CGPoint tPoint =  [self.edgePan translationInView:kWindow];
     ...根据tPoint设置右下视图 frame...
    //手指在右下视图上的位置(若 x>0 && y>0 说明此时手指在右下视图上)
    CGPoint touchPoint = [kWindow convertPoint:[self.edgePan locationInView:kWindow]  toView:self.floatArea];
    if (touchPoint.x > 0 && touchPoint.y > 0) {
              ...
                //由于右下视图是1/4圆 所以需要这步判断   
                if (pow((kFloatAreaR - touchPoint.x), 2) + pow((kFloatAreaR - touchPoint.y), 2)  <= pow((kFloatAreaR), 2)) {
                    self.showFloatBall = YES;
                }
              ...
    }else  if(self.edgePan.state == UIGestureRecognizerStatePossible) {
       /*
        * 停止CADisplayLink
        * 隐藏右下视图
        * 显示/隐藏浮窗
        **/
        [self.link invalidate];
        if (self.showFloatBall) {        
                self.floatBall.iconImageView.image=  [self.floatViewController valueForKey:@"hk_iconImage"];
                [kWindow addSubview:self.floatBall];
         }
    } 
}
```
监听浮窗移动/点击
```
#import "HKFloatBall.h" 类为浮窗视图类
//点击浮窗后让代理push之前保留起来的控制器
- (void)tap:(UIGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(floatBallDidClick:)]) {
        [self.delegate floatBallDidClick:self];
     }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  ...结束监听...
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  ...结束监听...
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /*
    * 改变浮窗 frame
    * 改变右下视图 frame
    * 判断浮窗center 是否在右下视图之上
    **/
    CGPoint center_ball = [kWindow convertPoint:self.floatBall.center toView:self.cancelFloatArea];
    if (pow((kFloatAreaR - center_ball.x), 2) + pow((kFloatAreaR - center_ball.y), 2)  <= pow((kFloatAreaR), 2)) {
        if (!self.cancelFloatArea.highlight) {
            self.cancelFloatArea.highlight = YES;
        }
    }
}
}
```
自定义push/pop动画
```
 //设置navigationController代理
 self.navigationController.delegate = self;

#pragma UINavigationControllerDelegate
//push/pop 时会调用此代理方法
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    ... 判断是否执行动画 若 return nil 则执行原始 push/pop 动画...
   //HKTransitionPush HKTransitionPop 是自己写的两个动画类,需要实现<UIViewControllerAnimatedTransitioning>
    if(operation==UINavigationControllerOperationPush)  {
        return [[HKTransitionPush alloc]init];
    } else if(operation==UINavigationControllerOperationPop){
        return [[HKTransitionPop alloc]init];
    }
}
```
```
HKTransitionPush HKTransitionPop 代码类似已HKTransitionPush为例
#import "HKTransitionPush.h"
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return kAuration;//动画时间
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
   //获取上下文
    self.transitionContext = transitionContext;
    
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contView = [transitionContext containerView];
    [contView addSubview:fromVC.view];
    [contView addSubview:toVC.view];
    
    //添加遮罩视图
    [fromVC.view addSubview:self.coverView];

    //浮窗的 frame push时这个是起始 frame ,pop时是结束时的 frame
    CGRect floatBallRect = [HKFloatManager shared].floatBall.frame;

    //开始/结束时的曲线 
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithRoundedRect:CGRectMake(floatBallRect.origin.x, floatBallRect.origin.y,floatBallRect.size.width , floatBallRect.size.height) cornerRadius:floatBallRect.size.height/2];
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT) cornerRadius:floatBallRect.size.width/2];
    
    //.layer.mask 是部分显示的原因
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath; 
    toVC.view.layer.mask = maskLayer;

    //动画类
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = kAuration;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];

    //隐藏浮窗
    [UIView animateWithDuration:kAuration animations:^{
        [HKFloatManager shared].floatBall.alpha = 0;   
    }];
}
#pragma mark - CABasicAnimation的Delegate
//动画完成后代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:YES];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    [self.coverView removeFromSuperview];
    
}
-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.5;
    };
    return _coverView;
}
```

解耦
```    
将所有代码集中在 #import "HKFloatManager.h" 中
```
```
//在AppDelegate中将类名传入即可,在该类控制器侧滑返回时启动浮窗功能(需要在实例化导航控制器之后)
[HKFloatManager addFloatVcs:@[@"HKSecondViewController"]];
```
```
若需要设置浮窗头像,设置该控制器的"hk_iconImage"
@property (nonatomic, strong) UIImage *hk_iconImage;
```
Tips


- 震动反馈
```
UIImpactFeedbackGenerator*impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium]; 
[impactLight impactOccurred];
 //    UIImpactFeedbackStyleLight,
 //    UIImpactFeedbackStyleMedium,
 //    UIImpactFeedbackStyleHeavy
```
- 分类获取当前控制器
```
#import "NSObject+hkvc.h"

@implementation NSObject (hkvc)
- (UIViewController *)hk_currentViewController
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    return vc;
}

- (UINavigationController *)hk_currentNavigationController
{
    return [self hk_currentViewController].navigationController;
}
- (UITabBarController *)hk_currentTabBarController
{
    return [self hk_currentViewController].tabBarController;
}

@end
```
- 判断控制器是否有"hk_iconImage"属性
```
- (BOOL)haveIconImage{
    BOOL have = NO;
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self.floatViewController class], &outCount);  
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        const char * nameChar = ivar_getName(ivar);
        NSString *nameStr =[NSString stringWithFormat:@"%s",nameChar];
        if([nameStr isEqualToString:@"_hk_iconImage"]) {
            have = YES;
        }
    }
    free(ivars);
    return have;
}
```
欢迎(跪求) Star.

