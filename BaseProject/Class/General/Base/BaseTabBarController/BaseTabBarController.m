//
//  BaseTabBarController.m
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "UITabBar+Badge.h"
#import "BasicInfoModel.h"


@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tabbar背景颜色
    UIColor *backGroundColor;
    BasicInfoModel *basicInfoModel = [BasicInfoModel mj_objectWithKeyValues:csUserDefaultsGET(BASIC_INFO)];
    if (basicInfoModel) {
        backGroundColor = [CommonMethods getColor:basicInfoModel.topbar_bgcolor];
    } else {
        backGroundColor = COLOR_NAV_VIEW;
    }
    
    self.tabBar.barTintColor = backGroundColor;
    [UITabBar appearance].translucent = NO;
    
    [self removeTabarTopLine];
    [self setViewControllers];
}

- (void)viewWillLayoutSubviews{
    float height = self.tabBar.frame.size.height;//原49改为self.tabBar.frame.size.height(修正ios11问题)
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = height;
    tabFrame.origin.y = self.view.frame.size.height - height;
    self.tabBar.frame = tabFrame;
}

- (void)setViewControllers {
    //UITabBarController 数据源
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TabBarConfigure" ofType:@"plist"];
    NSMutableArray *dataAry = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSDictionary *base_info = csUserDefaultsGET(BASIC_INFO);
    NSString *url = [base_info objectForKey:@"news_url"];
    if (!url || !url.length) {
        [dataAry removeObjectAtIndex:2];
    }
    
    for (NSDictionary *dataDic in dataAry) {
        //每个tabar的数据
        Class classs = NSClassFromString(dataDic[@"class"]);
        NSString *title = dataDic[@"title"];
        NSString *imageName = dataDic[@"image"];
        NSString *selectedImage = dataDic[@"selectedImage"];
        NSString *badgeValue = dataDic[@"badgeValue"];
        NSString *storyBoardID = dataDic[@"storyBoardID"];
        [self addChildViewController:[self ittemChildViewController:classs storyBoardID:storyBoardID title:title imageName:imageName selectedImage:selectedImage badgeValue:badgeValue]];
    }
    //默认选中后台控制
    NSDictionary *d =csUserDefaultsGET(BASIC_INFO);
    NSString *homepage_tab_default = [NSString stringWithFormat:@"%@",[d objectForKey:@"homepage_tab_default"]];
    NSInteger index = [CommonMethods isNullOrNilWithObject:homepage_tab_default] ? 0 : [homepage_tab_default integerValue];
    index = MAX(0, index);
    index = MIN(index, dataAry.count - 1);
    self.selectedIndex = index;
}

- (BaseNavigationController *)ittemChildViewController:(Class)classs storyBoardID:(NSString *)storyBoardID title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage badgeValue:(NSString *)badgeValue {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyBoardID];
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //起点-8图标才会到顶，然后加上计算出来的y坐标
    //    float origin = 0;
    //    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(origin, 0, -origin,0);
    //    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(-2 + 8, 8-8);
    //title设置
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TEXT_GRAY,NSFontAttributeName:SC_PINGFANG_FONT(11)} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_BASE_GREEN,NSFontAttributeName:SC_PINGFANG_FONT(11)} forState:UIControlStateSelected];
    vc.tabBarItem.title = title;
    
    //小红点
    vc.tabBarItem.badgeValue = badgeValue.intValue > 0 ? badgeValue : nil;
    
    //导航
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.topItem.title = title;
    [nav.rootVcAry addObject:classs];
    return nav;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}

#pragma 设置小红点数值
//设置指定tabar 小红点的值
- (void)setBadgeValue:(NSString *)badgeValue index:(NSInteger)index {
    if (index + 1 > self.viewControllers.count || index < 0) {
        //越界或者数据异常直接返回
        return;
    }
    BaseNavigationController *base = self.viewControllers[index];
    if (base.viewControllers.count == 0) {
        return;
    }
    UIViewController *vc = base.viewControllers[0];
    vc.tabBarItem.badgeValue = badgeValue.intValue > 0 ? badgeValue : nil;
}

#pragma 设置小红点显示或者隐藏

//显示小红点 没有数值
- (void)showBadgeWithIndex:(int)index {
    [self.tabBar showBadgeOnItemIndex:index];
    
}

//隐藏小红点 没有数值
- (void)hideBadgeWithIndex:(int)index {
    [self.tabBar hideBadgeOnItemIndex:index];
}

#pragma mark - 去掉tabBar顶部线条

//去掉tabBar顶部线条
- (void)removeTabarTopLine {
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[CommonMethods getColor:@"#000000" Alpha:0.1] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
