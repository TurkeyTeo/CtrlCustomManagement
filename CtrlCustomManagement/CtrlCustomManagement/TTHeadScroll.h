//
//  TTHeadScroll.h
//  CtrlCustomManagement
//
//  Created by Teo on 2017/8/16.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTHeadScroll : UIScrollView

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *tipView;

- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSMutableArray *)buttonArray;

- (void)updateTipView:(NSInteger)index;

@end
