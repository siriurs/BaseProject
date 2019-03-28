//
//  BaseViewController.m
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import "BaseViewController.h"
#import "UIBarButtonItem+SXCreate.h"
#import <Reachability/Reachability.h>


@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:StatusBarStyle animated:NO];
    
    if (self.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置背景色
    self.view.backgroundColor = COLOR_VIEW_BACKGROUND;
    
    // 生成实例
    self.myAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)setIsNavigationBarHidden:(BOOL)isNavigationBarHidden{
    _isNavigationBarHidden = isNavigationBarHidden;
    
    [self.navigationController setNavigationBarHidden:isNavigationBarHidden animated:NO];
}

#pragma mark - Navigation
- (void)showBackWithTitle:(NSString *)title {
    NSString *imageName = @"back_white";
    if (StatusBarStyle == UIStatusBarStyleDefault) {
        imageName = @"back_gray";
    }
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(goBack:) image:[UIImage imageNamed:imageName]];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setLeftItemWithTitle:(NSString *)title selector:(SEL)selector {
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:selector title:title];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)setLeftItemWithIcon:(UIImage *)icon selector:(SEL)selector{
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:selector image:icon];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setleftItemWithCustomTitle:(NSString *)titile TitileColor:(UIColor *)color TitleFont:(UIFont *)font selector:(SEL)selector{
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:selector title:titile font:font titleColor:color highlightedColor:color titleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)setRightItemWithTitle:(NSString *)title selector:(SEL)selector {
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:selector title:title];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setRightItemWithIcon:(UIImage *)icon selector:(SEL)selector {
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:selector image:icon];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)setRightItemWithCustomTitle:(NSString *)titile TitileColor:(UIColor *)color TitleFont:(UIFont *)font selector:(SEL)selector{
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:selector title:titile font:font titleColor:color highlightedColor:color titleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    self.navigationItem.rightBarButtonItem = item;
    
}

#pragma mark - 小红点
- (UIView *)itemRedViewWithRedDotValue:(NSString *)redDotValue {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor redColor];
    label.text = redDotValue;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    float leight = 20;
    float height = 20;
    if (redDotValue.intValue > 9) {
        leight = 30;
        height = 20;
    }
    label.layer.cornerRadius = height/2;
    label.layer.masksToBounds = YES;
    label.frame = CGRectMake(0, 0, leight, height);
    
    view.frame = CGRectMake(0, 0, leight, height);
    [view addSubview:label];
    return view;
}

#pragma mark - MJRefresh
- (void)refreshData {
    
}

#pragma mark - Action
- (BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}

- (void)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
