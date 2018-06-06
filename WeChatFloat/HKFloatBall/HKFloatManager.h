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
@property (nonatomic, strong) HKFloatBall *floatBall;
+ (instancetype)shared;
+ (void)addFloatVc:(NSString *)vcClass;
@end
