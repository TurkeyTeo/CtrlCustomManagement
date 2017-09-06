# CtrlCustomManagement

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


我们大多数情况都会使用NavigationController和 TabbarController去管理自己的VC。他们都属于容器控制器（*一个控制器包含其他一个或多个控制器时，前者为容器控制器 (Container View Controller)，后者为子控制器 (Child View Controller）*）。

- 对于 **UINavigationController** 我们知道显示在导航控制器上的控制器，永远是栈顶控制器，其实就是压栈，先进后出的原则。退出到下一级，上一级的控制器就会被销毁。
- 而 **TabbarController** 则是会一次性初始化所有的子控制器，但是默认只会加载第一个VC，其他的只有在显示的时候才会调用loadView去加载对于的View。与UINavigationController不同的是他的子控制器加载后会存在内存中，下次直接显示，切换子控制器是不会销毁之前显示的VC的。

很明显，使用多视图控制器的优点：

​     1.低耦合，对页面中的逻辑更加分明。相应的View对应相应的VC。

​     2.当某个子View没有显示时，将不会被Load，减少了内存的使用。

​     3.当内存紧张时，可以释放当前没有显示的VC，优化内存释放机制。

<br>

如果我们自己要去实现一个多视图控制器该去怎么做呢？答案就是使用容器控制器。



#### 1. 基本使用

##### 1.1 添加子控制器

```objective-c
- (void)displayContentController:(UIViewController *)content {
   [self addChildViewController:content];
  //注意，容器控制器的 addChildViewController: 方法会调用子控制器的 willMoveToParentViewController: 方法，因此不需要写子控制器的 willMoveToParentViewController: 方法。
   content.view.frame = [self frameForContentController];
   [self.view addSubview:self.currentClientView];
   [content didMoveToParentViewController:self];
}
```



#####1.2 移除子控制器

```objective-c
- (void)hideContentController:(UIViewController *)content {
   [content willMoveToParentViewController:nil];
   [content.view removeFromSuperview];
   [content removeFromParentViewController];
  //注意，子控制器的 removeFromParentViewController 方法会调用 didMoveToParentViewController: 方法，不用写 didMoveToParentViewController: 方法。
}
```



##### 1.3 子控制器之间的切换

```objective-c
- (void)cycleFromViewController:(UIViewController *)oldVC
               toViewController:(UIViewController *)newVC {
   // Prepare the two view controllers for the change.
   [oldVC willMoveToParentViewController:nil];
   [self addChildViewController:newVC];
 
   // Get the start frame of the new view controller and the end frame
   // for the old view controller. Both rectangles are offscreen.
   newVC.view.frame = [self newViewStartFrame];
   CGRect endFrame = [self oldViewEndFrame];
 
   // Queue up the transition animation.
   [self transitionFromViewController:oldVC toViewController:newVC
        duration:0.25 options:0
        animations:^{
            // Animate the views to their final positions.
            newVC.view.frame = oldVC.view.frame;
            oldVC.view.frame = endFrame;
        }
        completion:^(BOOL finished) {
           // Remove the old view controller and send the final
           // notification to the new view controller.
           [oldVC removeFromParentViewController];
           [newVC didMoveToParentViewController:self];
        }];
}
```



#####1.4 通知子控制器的出现和消失

```objective-c
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}
```

如果返回NO，容器控制器就要在子控制器出现和消失时调用如下方法通知子控制器。

```objective-c
- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated{
    NSLog(@"beginAppearanceTransition");
}

- (void)endAppearanceTransition{
    NSLog(@"endAppearanceTransition");
}
```

**重要提示：当你的VC是在UINavigationController或者其他容器控制器中时，必须返回YES，否则程序会奔溃；**

*If the new child view controller is already the child of a container view controller, it is removed from that container before being added.  This method is only intended to be called by an implementation of a custom container view controller. If you override this method, you must call super in your implementation.*
