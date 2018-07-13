//
//  HKFloatAreaView.h
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/4.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HKFloatAreaViewStyle_default,
    HKFloatAreaViewStyle_cancel,
} HKFloatAreaViewStyle;


@interface HKFloatAreaView : UIView
@property(nonatomic, assign) BOOL highlight;
@property(nonatomic, assign) HKFloatAreaViewStyle style;
@end
