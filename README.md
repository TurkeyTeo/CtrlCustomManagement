# CtrlCustomManagement

我们大多数情况都会使用NavigationController和 TabbarController去管理自己的VC。他们都属于容器控制器（*一个控制器包含其他一个或多个控制器时，前者为容器控制器 (Container View Controller)，后者为子控制器 (Child View Controller）*）。

#### 1. 基本使用

##### 添加子控制器

```objective-c
    TTPageScrollViewController *pageVC = [[TTPageScrollViewController alloc] init];
    pageVC.viewControllers = @[[FirstViewController new],[SecondViewController new],[ThirdViewController new]];
```



*说明：*

```objective-c
//usingSpringWithDamping：它的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显。 initialSpringVelocity：初始的速度，数值越大一开始移动越快。值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况。
+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);
```