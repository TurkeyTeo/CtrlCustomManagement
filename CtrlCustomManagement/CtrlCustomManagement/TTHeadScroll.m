//
//  TTHeadScroll.m
//  CtrlCustomManagement
//
//  Created by Teo on 2017/8/16.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "TTHeadScroll.h"

@implementation TTHeadScroll

- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSMutableArray *)buttonArray{
    self = [super initWithFrame:frame];
    if (self) {
        _buttons = buttonArray;
        [self initWithButtons];
    }
    return self;
}

- (void)initWithButtons{
    CGFloat offsetX = 0;
    for (UIButton *btn in _buttons) {
        btn.frame = CGRectMake(offsetX, 0, btn.frame.size.width, btn.frame.size.height);
        offsetX += btn.bounds.size.width;
        [self addSubview:btn];
    }
    self.tipView.backgroundColor = [UIColor redColor];
}

- (UIView *)tipView{
    if (!_tipView) {
        UIButton *button = _buttons.firstObject;
        CGFloat width = button.frame.size.width;
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 3, width, 3)];
        [self addSubview:_tipView];
    }
    return _tipView;
}

- (void)setContentSizeWithButtons{
    UIButton *btn = _buttons.lastObject;
    CGFloat offsetX = btn.frame.size.width + btn.frame.origin.x;
    self.contentSize = CGSizeMake(offsetX, self.frame.size.height);
}

- (void)updateTipView:(NSInteger)index{
    UIButton *btn = [self.buttons objectAtIndex:index];
    
    //    usingSpringWithDamping：它的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显。
    //    initialSpringVelocity：初始的速度，数值越大一开始移动越快。值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况。
    [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.tipView.frame = CGRectMake(btn.frame.origin.x, self.tipView.frame.origin.y, self.tipView.frame.size.width, self.tipView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
}


@end
