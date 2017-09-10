//
//  TTPageScrollViewController.m
//  CtrlCustomManagement
//
//  Created by Teo on 2017/8/16.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "TTPageScrollViewController.h"
#import "TTHeadScroll.h"
#import "FirstViewController.h"

@interface TTPageScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger selectedIndex;     //当前page标记
@property (nonatomic, strong) TTHeadScroll *headScroll;     //头部视图
@property (nonatomic, strong) UIScrollView *contentView;                        //滑动视图
@property (nonatomic, assign) NSInteger headHeight;       //头部视图高度
@property (nonatomic, assign) BOOL isTitleBarShow;          //是否显示标题栏

@end

@implementation TTPageScrollViewController

#pragma mark -- property

- (void)setViewControllers:(NSMutableArray<UIViewController *> *)viewControllers{
    //必须含有元素 && viewControllers中元素必须为viewController
    if (!viewControllers.count) {
        return;
    }
    
    for (id vc in viewControllers) {
        NSAssert([vc isKindOfClass:[UIViewController class]], @"viewControllers必须为viewController或其子类");
    }
    
    _viewControllers = viewControllers;
    
    if (self.isTitleBarShow) {
//        self.headHeight = 40;
        [self displayViewControllers];
        [self displayHeadScroll];
    }else{
//        self.headHeight = 0;
        [self displayViewControllers];
    }
    
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

- (void)setIsTitleBarShow:(BOOL)isTitleBarShow{
    _isTitleBarShow = isTitleBarShow;
    if (_isTitleBarShow) {
        self.headHeight = 40;
    }else
        self.headHeight = 0;
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

//添加头部视图
- (void)displayHeadScroll{
    
    if (self.headScroll) {
        return;
    }
    
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

//移除头部视图
- (void)removeHeadScroll{
    if (self.headScroll) {
        [self.headScroll removeFromSuperview];
        self.headScroll = nil;
    }
}


- (CGRect)calculateContentFrame:(NSInteger)index{
    return CGRectMake(self.contentView.frame.size.width * index, self.contentView.bounds.origin.x, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}


#pragma mark -- life cyc

- (instancetype)init{
    if ([super init]) {
        self.isTitleBarShow = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //add child VC
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVC)];
}

- (void)viewWillLayoutSubviews{

    self.contentView.frame = CGRectMake(0, self.headHeight, self.view.bounds.size.width, self.view.bounds.size.height - self.headHeight);
    NSUInteger i = 0;
    for (UIViewController *vc in _viewControllers) {
        vc.view.frame = [self calculateContentFrame:i++];
    }
    self.contentView.contentSize = CGSizeMake(self.view.bounds.size.width * i, self.contentView.bounds.size.height);

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
    [self.contentView scrollRectToVisible:CGRectMake(self.selectedIndex * self.contentView.frame.size.width, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height) animated:NO];
}

- (void)addVC{
    
//    NSMutableArray *temp = self.viewControllers;
//    [temp addObject:[FirstViewController new]];
//    self.viewControllers = temp;
//    [self isTitleViewShouldShow:self.isTitleBarShow];
}


#pragma mark -- public
/**
 初始化
 
 @param viewControllers viewControllers数据源
 @param show 是否显示标题栏
 */
- (instancetype)initWithViewControllers:(NSMutableArray <UIViewController *> *)viewControllers isTitleViewShouldShow:(BOOL)show{
    
    if (self = [super init]) {
        self.isTitleBarShow = show;
        self.viewControllers = viewControllers;
    }
    return self;
}


//是否隐藏顶部标题栏
- (void)isTitleViewShouldShow:(BOOL)show{
    
    self.isTitleBarShow = show;
    if (show) {
//        显示
        [self displayHeadScroll];
    }else{
//        隐藏
        [self removeHeadScroll];
    }
    
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
