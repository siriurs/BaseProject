//
//  ToolView.h
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#ifndef ToolView_h
#define ToolView_h


#pragma mark - 系统信息
//** 系统信息 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define csFileManager    [NSFileManager defaultManager]
#define csWindow         [[UIApplication sharedApplication] keyWindow]

#define csUserDefaultsGET(key)          [[NSUserDefaults standardUserDefaults] objectForKey:key]            // 取
#define csUserDefaultsSET(object,key)   [[NSUserDefaults standardUserDefaults] setObject:object forKey:key] // 写
#define csUserDefaultsSynchronize       [[NSUserDefaults standardUserDefaults] synchronize]                 // 存
#define csUserDefaultsRemove(key)       [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]      // 删

// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

// 判断设备
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//设备的UDID号
#define UDID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

//系统版本号
#define Version7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define Version8  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define Version9  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define Version10  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define Version11  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
#define Version12  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0)

//获取APP的版本号
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)           [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 中文字体
#define SC_PINGFANG_FONT(FONTSIZE)          [UIFont fontWithName:@"PingFangSC-Regular" size:(FONTSIZE)]
#define SC_PINGFANG_SEMIBLOD(FONTSIZE)      [UIFont fontWithName:@"PingFangSC-Semibold" size:(FONTSIZE)]  //中粗

// 英文和数字
#define SC_Motion_FONT(FONTSIZE)       [UIFont fontWithName:@"DINCond-Bold" size:(FONTSIZE)]
#define SC_NUMBER_FONT(FONTSIZE)       [UIFont fontWithName:@"DIN-LightAlternate" size:(FONTSIZE)]

#pragma mark - 常量
//** 常量 ***********************************************************************************

/** 时间间隔 */
#define kHUDDuration            (1.f)
/** 一天的秒数 */
#define SecondsOfDay            (24.f * 60.f * 60.f)
/** 秒数 */
#define Seconds(Days)           (24.f * 60.f * 60.f * (Days))
/** 一天的毫秒数 */
#define MillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)
/** 毫秒数 */
#define Milliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))

// 判断字段时候为空的情况
#define IF_NULL_TO_STRING(x) ([(x) isEqual:[NSNull null]]||(x)==nil)? @"":TEXT_STRING(x)
// 转换为字符串
#define TEXT_STRING(x) [NSString stringWithFormat:@"%@",x]

// block self
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#endif /* ToolView_h */
