//
//  TTPageScrollViewController.h
//  CtrlCustomManagement
//
//  Created by Teo on 2017/8/16.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPageScrollViewController : UIViewController

@property (nonatomic, strong) NSMutableArray <UIViewController *> *viewControllers;    //装载viewController的集合

- (void)isTitleViewShouldShow:(BOOL)show;           //是否隐藏顶部标题栏； 默认不显示


/**
 初始化

 @param viewControllers viewControllers数据源
 @param show 是否显示标题栏
 */
- (instancetype)initWithViewControllers:(NSMutableArray <UIViewController *> *)viewControllers isTitleViewShouldShow:(BOOL)show;

@end
