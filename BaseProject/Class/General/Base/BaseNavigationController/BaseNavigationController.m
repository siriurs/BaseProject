//
//  BaseNavigationController.m
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CommonMethods.h"
#import "BasicInfoModel.h"


@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView {
    [super loadView];
    
    //状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = StatusBarStyle;
    
    //导航背景颜色
    UIColor *backGroundColor;
    UIColor *titleCocle;
    
    BasicInfoModel *basicInfoModel = [BasicInfoModel mj_objectWithKeyValues:csUserDefaultsGET(BASIC_INFO)];
    if (basicInfoModel) {
        backGroundColor = [CommonMethods getColor:basicInfoModel.topbar_bgcolor];
        titleCocle = [CommonMethods getColor:basicInfoModel.topbar_tcolor];
    } else {
        backGroundColor = COLOR_NAV_VIEW;
        titleCocle = COLOR_NAV_TEXT;
    }
    self.transferNavigationBarAttributes = YES;
    self.navigationBar.barTintColor = backGroundColor;
    
    //title颜色和字体
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleCocle, NSFontAttributeName:SC_PINGFANG_FONT(18)};
    
    // 分割线
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        [_lineView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        //        [self.navigationBar addSubview:_lineView];
    }
    [_lineView setFrame:CGRectMake(0, self.navigationBar.frame.size.height, self.navigationBar.frame.size.width, 0.5)];
}

#pragma mark -  push 设置
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    for (Class classes in self.rootVcAry) {
        if ([viewController isKindOfClass:classes]) {
            if (self.navigationController.viewControllers.count > 0) {
                viewController.hidesBottomBarWhenPushed = YES;
            } else {
                viewController.hidesBottomBarWhenPushed = NO;
            }
        } else {
            viewController.hidesBottomBarWhenPushed = YES;
        }
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark -  RootVc



- (NSMutableArray *)rootVcAry {
    if (!_rootVcAry) {
        _rootVcAry = [NSMutableArray new];
    }
    return _rootVcAry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
