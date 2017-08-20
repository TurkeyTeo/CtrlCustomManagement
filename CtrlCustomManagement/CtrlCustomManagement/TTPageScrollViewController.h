//
//  TTPageScrollViewController.h
//  CtrlCustomManagement
//
//  Created by Teo on 2017/8/16.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPageScrollViewController : UIViewController

@property (nonatomic, strong) NSArray <UIViewController *> *viewControllers;    //装载viewController的集合
@property (nonatomic, assign) BOOL isTitleBarShow;          //是否显示标题栏

@end
