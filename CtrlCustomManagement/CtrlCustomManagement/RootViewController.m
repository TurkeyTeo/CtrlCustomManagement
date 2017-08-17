//
//  RootViewController.m
//  CtrlCustomManagement
//
//  Created by Teo on 2017/8/16.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "RootViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController
{
    UIViewController *currentVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    FirstViewController *child1 = [[FirstViewController alloc] init];
    SecondViewController *child2 = [[SecondViewController alloc] init];
    [self displayContentController:child1];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cycleFromViewController:child1 toViewController:child2];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideContentController:child1];
    });
}



//添加子控制器
- (void)displayContentController:(UIViewController *)vc{
    [self addChildViewController:vc];
    //    注意，容器控制器的 addChildViewController: 方法会调用子控制器的 willMoveToParentViewController: 方法，因此不需要写子控制器的 willMoveToParentViewController: 方法。
    vc.view.frame = self.view.frame;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

//移除子控制器
- (void)hideContentController:(UIViewController *)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
    //    注意，子控制器的 removeFromParentViewController 方法会调用 didMoveToParentViewController: 方法，不用写 didMoveToParentViewController: 方法。
    
}

//子控制器之间的转变
- (void)cycleFromViewController:(UIViewController *)oldVC
               toViewController:(UIViewController *)newVC{
    
    // Prepare the two view controllers for the change.
    [oldVC willMoveToParentViewController:nil];
    [self addChildViewController:newVC];
    
    // Get the start frame of the new view controller and the end frame
    // for the old view controller. Both rectangles are offscreen.
    newVC.view.frame = self.view.frame;
    CGRect endFrame = self.view.frame;
    
    // Queue up the transition animation.
    [self transitionFromViewController:oldVC toViewController:newVC duration:0.4 options:0 animations:^{
        // Animate the views to their final positions.
        newVC.view.frame = oldVC.view.frame;
        oldVC.view.frame = endFrame;
        
    } completion:^(BOOL finished) {
        // Remove the old view controller and send the final
        // notification to the new view controller.
        [oldVC removeFromParentViewController];
        [newVC didMoveToParentViewController:self];
    }];
    
}

//提示：当你的VC是在UINavigationController或者其他容器控制器中时，必须返回YES，否则程序会奔溃
//- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
//    return YES;
//}


@end
