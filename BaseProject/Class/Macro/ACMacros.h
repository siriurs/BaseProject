//
//  ACMacros.h
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#ifndef ACMacros_h
#define ACMacros_h


// 屏幕尺寸
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


// UI颜色控制
#define StatusBarStyle          UIStatusBarStyleDefault         //状态栏样式
#define COLOR_VIEW_BACKGROUND   RGBCOLOR(255, 255, 255)         //UIView背景色
#define COLOR_NAV_VIEW          RGBCOLOR(255, 255, 255)         //导航栏背景色
#define COLOR_NAV_TEXT          RGBCOLOR(29, 29, 29)            //导航栏文字颜色
#define COLOR_BASE_GREEN        RGBCOLOR(0xfa, 0x58,0x58)       //默认绿色fa5858
#define COLOR_TEXT_GRAY         RGBCOLOR(136, 136, 136)         //默认文字深灰

// 高度
#define BottomYFit              (IS_IPHONE_X ? 43 : 0)          //底部边距

/// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

// 等比例尺寸
#define SCALEW SCREEN_WIDTH/375

// 判断设备
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X ([CommonMethods iPhoneNotchScreen])

//图片缩放比例
#define IMAGESIZE   CGSizeMake(800, 800)

#pragma mark - 坐标
//** 坐标 ***********************************************************************************
// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height


#endif /* ACMacros_h */
