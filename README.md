# CtrlCustomManagement

我们大多数情况都会使用NavigationController和 TabbarController去管理自己的VC。他们都属于容器控制器（*一个控制器包含其他一个或多个控制器时，前者为容器控制器 (Container View Controller)，后者为子控制器 (Child View Controller）*）。

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
