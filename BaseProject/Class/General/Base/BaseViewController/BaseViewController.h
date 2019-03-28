//
//  BaseViewController.h
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MJRefresh/MJRefresh.h>


NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, strong) AppDelegate* myAppDelegate;
@property (nonatomic, assign) BOOL loadingSwitch;           //加载中
@property (nonatomic, assign) BOOL isNavigationBarHidden;   //是否隐藏导航栏

#pragma mark 左边按钮定制
/**
 *  显示默认返回按钮
 *
 *  @param title 需要传入上级界面标题
 */
- (void)showBackWithTitle:(NSString *)title;

/**
 *  通过文字设置左侧导航按钮
 *
 *  @param title    标题
 *  @param selector 事件
 */
- (void)setLeftItemWithTitle:(NSString *)title selector:(SEL)selector ;
/**
 *通过文图片设置左侧导航按钮
 *  @param icon     图标
 *  @param selector 事件
 */
-(void)setLeftItemWithIcon:(UIImage *)icon selector:(SEL)selector;
/**
 *  通过文字设置左侧导航按钮
 *
 *  @param title    文字
 *  @param color    文字的颜色
 *  @param font     文字的大小
 *  @param selector 事件
 */
- (void)setleftItemWithCustomTitle:(NSString *)title TitileColor:(UIColor *)color TitleFont:(UIFont *)font selector:(SEL)selector;

#pragma mark 右边按钮定制
/**
 *  通过文字设置右侧导航按钮
 *
 *  @param title    文字
 *  @param selector 事件
 */
- (void)setRightItemWithTitle:(NSString *)title selector:(SEL)selector;

/**
 *  通过ico定制右侧按钮
 *
 *  @param icon     图标
 *  @param selector 事件
 */
- (void)setRightItemWithIcon:(UIImage *)icon selector:(SEL)selector;

/**
 *  通过文字设置右侧导航按钮
 *
 *  @param title    文字
 *  @param color    文字的颜色
 *  @param font     文字的大小
 *  @param selector 事件
 */
- (void)setRightItemWithCustomTitle:(NSString *)title TitileColor:(UIColor *)color TitleFont:(UIFont *)font selector:(SEL)selector;

#pragma mark - MJRefresh
/**
 *  刷新页面数据
 */
- (void)refreshData;

#pragma mark - NetWork
/**
 *  检查网络状态
 */
- (BOOL) isConnectionAvailable;

#pragma mark - Other
/**
 *  小红点View定制
 *
 *  @param redDotValue  红点显示的值
 *
 *  @return 红点view
 */
- (UIView *)itemRedViewWithRedDotValue:(NSString *)redDotValue;



@end

NS_ASSUME_NONNULL_END
