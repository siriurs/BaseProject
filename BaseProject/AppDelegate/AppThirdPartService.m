//
//  AppThirdPartService.m
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import "AppThirdPartService.h"
#import "BaiduMobStat.h"

@implementation AppThirdPartService

+ (void)registerBaiduMobStat {
    NSString *appVersion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[BaiduMobStat defaultStat] setShortAppVersion:appVersion];
    
    NSString *userId = [CommonMethods getUid];
    NSString *formatId = @"";
    // 生产环境
    if (IS_PRODUCTION) {
        formatId = [NSString stringWithFormat:@"o_%@", userId];
    } else {
        formatId = [NSString stringWithFormat:@"test_o_%@", userId];
    }
    [[BaiduMobStat defaultStat] setUserId:formatId];
    [[BaiduMobStat defaultStat] setChannelId:@"AppStore"];
    [[BaiduMobStat defaultStat] setEnableExceptionLog:YES];
    [[BaiduMobStat defaultStat] setEnableDebugOn:NO];
    [[BaiduMobStat defaultStat] setEnableGps:YES];
    
    
    [[BaiduMobStat defaultStat] startWithAppId:BAIDU_APP_KEY];
}

@end
