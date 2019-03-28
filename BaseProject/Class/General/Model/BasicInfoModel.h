//
//  BasicInfoModel.h
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasicInfoModel : BaseModel

// 各种地址
@property (nonatomic, strong) NSString *about_url;          //关于我们
@property (nonatomic, strong) NSString *feedback_url;       //意见反馈
@property (nonatomic, strong) NSString *help_url;           //帮助
@property (nonatomic, strong) NSString *privacy_url;        //隐私协议
@property (nonatomic, strong) NSString *reviewed_url;       //
@property (nonatomic, strong) NSString *tos_url;            //使用条款
@property (nonatomic, strong) NSString *cart_url;           //购物车
@property (nonatomic, strong) NSString *points_url;         //我的积分

// 各种提示
@property (nonatomic, strong) NSString *tip;                //贴士
@property (nonatomic, strong) NSString *logout_tips;        //退出时提示
@property (nonatomic, strong) NSDictionary *langs;          //无数据,无网络时提示信息
@property (nonatomic, strong) NSDictionary *icons;          //无数据,无网络时显示图片

// 各种缺省
@property (nonatomic, strong) NSString *nologin_headface;   //未登录的头像
@property (nonatomic, strong) NSString *nologin_title;      //未登录的名字
@property (nonatomic, strong) NSString *topbar_bgcolor;     //顶部默认背景色
@property (nonatomic, strong) NSString *topbar_tcolor;      //顶部默认文字颜色

@property (nonatomic, strong) NSArray *bridge_domains;      //url白名单

@end

NS_ASSUME_NONNULL_END
