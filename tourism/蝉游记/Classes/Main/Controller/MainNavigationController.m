//
//  MainNavigationController.m
//  蝉游记
//
//  Created by Charles on 15/7/7.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "MainNavigationController.h"
@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barTintColor=ThemeColor;
    self.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        /* 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）*/
        /**
         *  自动显示和隐藏tabbar
         */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /**
         *  设置左边的返回按钮
         */
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pressBack) nomalImage:[UIImage imageNamed:@"BackBarButton"] higeLightedImage:[UIImage imageNamed:@"BackBarButtonHighlight"]];
    }
    [super pushViewController:viewController animated:animated];
}
/**
 *  返回上一级事件
 */
-(void)pressBack{
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
