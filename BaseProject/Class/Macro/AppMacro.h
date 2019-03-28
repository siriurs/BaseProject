//
//  AppMacro.h
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

// CSDA App Url
#define APPURL                  @"https://itunes.apple.com/cn/app/运动中国/id1151335421?mt=8&l=zh&ls=1"

// 加密密码
#define ENCRYPT_KEY             "1%7jhs#Zjasda"

// 本地存储
#define AD_INFO                 @"adinfo"       //广告
#define BASIC_INI               @"ini"          //打卡配置
#define BASIC_INFO              @"basic"        //基本信息
#define VERSION_INFO            @"version"      //app版本信息
#define USER_INFO               @"userinfo"     //用户资料

// 异常情况
#define NO_MESSAGE              @"no_message"       //无消息
#define NO_NETWORK              @"no_network"       //无网络

// 通用字符串
#define HUD_NET_ERROR           @"网络请求失败"
#define ALERT_OK                @"我知道了"

//默认列表图片 默认图片
#define AifanDefaultImage [UIImage imageNamed:@""] //正方形占位图
#define AifanPIIICIMAGE [UIImage imageNamed:@""] //长方形占位图

//公用Block
typedef void(^voidBlock)(void);
typedef void(^idBlock)(id obj);
typedef void(^intBlock)(NSInteger index);
typedef void(^stringBlock)(NSString *result);
typedef void(^stringBlock2)(NSString *result,NSString *description);
typedef void(^boolBlock)(BOOL boolen);
typedef void(^errorBlock)(NSError *error);
typedef void(^numberBlock)(NSNumber *result);
typedef void(^arrayBlock)(NSArray *results);
typedef void(^dictionaryBlock)(NSDictionary *results);


#endif /* AppMacro */
