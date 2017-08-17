//
//  FirstViewController.m
//  CtrlCustomManagement
//
//  Created by Teo on 2017/8/16.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor cyanColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated{
    NSLog(@"beginAppearanceTransition");
}

- (void)endAppearanceTransition{
    NSLog(@"endAppearanceTransition");
}

@end
