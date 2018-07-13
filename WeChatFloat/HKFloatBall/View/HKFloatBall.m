//
//  HKFloatBall.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/4.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKFloatBall.h"
#import "HKMarco.h"

#define margin 10

@interface HKFloatBall ()


@end

@implementation HKFloatBall

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _iconImageView.backgroundColor = [UIColor yellowColor];
        _iconImageView.layer.borderWidth = 8;
        _iconImageView.layer.borderColor = [UIColor grayColor].CGColor;
        _iconImageView.layer.cornerRadius = self.bounds.size.width / 2;
        _iconImageView.layer.masksToBounds = YES;
    };
    return _iconImageView;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.center = [touches.anyObject locationInView:[UIApplication sharedApplication].keyWindow];
    if ([self.delegate respondsToSelector:@selector(floatBallBeginMove:)]) {
        [self.delegate floatBallBeginMove:self];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endTouch:[touches.anyObject locationInView:[UIApplication sharedApplication].keyWindow]];
    if ([self.delegate respondsToSelector:@selector(floatBallEndMove:)]) {
        [self.delegate floatBallEndMove:self];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endTouch:[touches.anyObject locationInView:[UIApplication sharedApplication].keyWindow]];
    if ([self.delegate respondsToSelector:@selector(floatBallEndMove:)]) {
        [self.delegate floatBallEndMove:self];
    }
}

- (void)endTouch:(CGPoint)point {
    CGRect frame = self.frame;
    if (point.x > SCREEN_WIDTH / 2) {
        frame.origin.x = SCREEN_WIDTH - frame.size.width - margin;
    } else {
        frame.origin.x = margin;
    }
    if (frame.origin.y > SCREEN_HEIGHT - 64) {
        frame.origin.y = SCREEN_HEIGHT - 64;
    } else if (frame.origin.y < 20) {
        frame.origin.y = 20;
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    }];
}

- (void)tap:(UIGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(floatBallDidClick:)]) {
        [self.delegate floatBallDidClick:self];
    }
}
@end
