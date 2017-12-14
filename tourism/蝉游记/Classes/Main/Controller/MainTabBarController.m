//
//  MainTabBarController.m
//  蝉游记
//
//  Created by Charles on 15/7/7.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "NotesViewController.h"
#import "TacticsViewController.h"
#import "ToolsViewController.h"
#import "MineViewController.h"
#import "OffLineViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NotesViewController *notes=[[NotesViewController alloc]init];
    [self addChildViewController:notes withTitle:@"游记" image:[UIImage imageNamed:@"TabBarIconFeaturedNormal"] selectedImage:[UIImage imageNamed:@"TabBarIconFeatured"]];
    TacticsViewController *tactics=[[TacticsViewController alloc]init];
    [self addChildViewController:tactics withTitle:@"攻略" image:[UIImage imageNamed:@"TabBarIconDestinationNormal"] selectedImage:[UIImage imageNamed:@"TabBarIconDestination"]];
    ToolsViewController *tools=[[ToolsViewController alloc]init];
    [self addChildViewController:tools withTitle:@"工具" image:[UIImage imageNamed:@"TabBarIconToolboxNormal"] selectedImage:[UIImage imageNamed:@"TabBarIconToolbox"]];
    MineViewController *mine=[[MineViewController alloc]init];
    [self addChildViewController:mine withTitle:@"我的" image:[UIImage imageNamed:@"TabBarIconMyNormal"] selectedImage:[UIImage imageNamed:@"TabBarIconMy"]];
    OffLineViewController *offLine=[[OffLineViewController alloc]init];
    [self addChildViewController:offLine withTitle:@"离线" image:[UIImage imageNamed:@"TabBarIconOfflineNormal"] selectedImage:[UIImage imageNamed:@"TabBarIconOffline"]];
}
/**
 *  添加子控制器到tabbar,并封装一个navgationbar
 *
 *  @param childController 子控制器对象
 *  @param title           子控制器标题
 *  @param image           tabbaritem正常图片
 *  @param selectedImage   tabbaritem选中图片
 */
-(void)addChildViewController:(UIViewController *)childController withTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    childController.tabBarItem=[[UITabBarItem alloc]initWithTitle:title image:image selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:ThemeColor} forState:UIControlStateSelected];
    /**
     给每个控制器添加一个UINavigationController
     */
    MainNavigationController *navigationController=[[MainNavigationController alloc]initWithRootViewController:childController];
    [self addChildViewController:navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
