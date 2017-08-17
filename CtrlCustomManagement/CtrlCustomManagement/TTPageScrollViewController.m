//
//  TTPageScrollViewController.m
//  CtrlCustomManagement
//
//  Created by Teo on 2017/8/16.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "TTPageScrollViewController.h"
#import "TTHeadScroll.h"

@interface TTPageScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger selectedIndex;     //当前page标记
@property (nonatomic, strong) TTHeadScroll *headScroll;     //头部视图
@property (nonatomic, strong) UIScrollView *contentView;                        //滑动视图
@property (nonatomic, assign) NSInteger headHeight;       //头部视图高度

@end

@implementation TTPageScrollViewController

#pragma mark -- property

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers{
    //必须含有元素 && viewControllers中元素必须为viewController
    if (!viewControllers.count) {
        return;
    }
    
    for (id vc in viewControllers) {
        NSAssert([vc isKindOfClass:[UIViewController class]], @"viewControllers必须为viewController或其子类");
    }
    
    _viewControllers = viewControllers;
    
    self.headHeight = 40;
    [self displayViewControllers];
    [self displayHeadScroll];
    
}

- (UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headHeight, self.view.bounds.size.width, self.view.bounds.size.height - self.headHeight)];
        _contentView.delegate = self;
        _contentView.bounces = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.scrollsToTop = NO;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}


#pragma mark -- private
// addChildViewController
- (void)displayViewControllers{
    NSInteger i = 0;
    for (UIViewController *vc in _viewControllers) {
        [self addChildViewController:vc];
        //注意，容器控制器的 addChildViewController: 方法会调用子控制器的 willMoveToParentViewController: 方法，因此不需要写子控制器的 willMoveToParentViewController: 方法。
        vc.view.frame = [self calculateContentFrame:i++];
        [self.contentView addSubview:vc.view];
        [vc didMoveToParentViewController:self];
    }
    
    self.contentView.contentSize = CGSizeMake(self.view.bounds.size.width * i, self.contentView.bounds.size.height);
    
    self.selectedIndex = 0;
}

- (void)displayHeadScroll{
    NSInteger i = 0;
    NSMutableArray *btnArray = [NSMutableArray arrayWithCapacity:_viewControllers.count];
    for (UIViewController *vc in _viewControllers) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitle:(vc.title.length ? vc.title : [NSString stringWithFormat:@"标题 %ld", i+1]) forState:UIControlStateNormal];
        [button sizeToFit];
        
        CGFloat width = CGRectGetWidth(button.frame);
        if (width < self.contentView.bounds.size.width/_viewControllers.count) {
            width = self.contentView.bounds.size.width/_viewControllers.count;
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, width, button.frame.size.height);
        }
        
        [button addTarget:self action:@selector(headTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        [btnArray addObject:button];
        i++;
    }
    
    self.headScroll = [[TTHeadScroll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.headHeight) buttonArray:btnArray];
    [self.view addSubview:self.headScroll];
}



- (CGRect)calculateContentFrame:(NSInteger)index{
    return CGRectMake(self.contentView.frame.size.width * index, self.contentView.bounds.origin.x, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}


#pragma mark -- life cyc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- action

- (void)headTitleButtonClick:(UIButton *)btn{
    
    NSUInteger index = [self.headScroll.buttons indexOfObject:btn];
    self.selectedIndex = index;
    
    [self.headScroll updateTipView:self.selectedIndex];
    [self.contentView setContentOffset:CGPointMake(self.selectedIndex * self.contentView.frame.size.width, self.contentView.frame.origin.y) animated:NO];
}


#pragma mark -- delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView == self.contentView) {
        
        CGFloat x = targetContentOffset->x;
        CGFloat contentView_width = self.view.bounds.size.width;
        
        CGFloat contentViewMoveLength = x - _selectedIndex * contentView_width;
        
        if (contentViewMoveLength < - contentView_width * 0.5f) {
            // Move left
            --_selectedIndex;
        } else if (contentViewMoveLength > contentView_width * 0.5f) {
            // Move right
            ++_selectedIndex;
        }
        
        targetContentOffset->x = scrollView.contentOffset.x; // Stop
        [scrollView setContentOffset:CGPointMake(_selectedIndex * contentView_width, scrollView.contentOffset.y) animated:YES]; // Animate to destination with default velocity
        
        [self.headScroll updateTipView:self.selectedIndex];

    }
}


@end
