//
//  CommonMethods.h
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonMethods : NSObject

// MD5加密
+ (NSString *)md5HexDigest:(NSString *)str;
// 判断深浅色
+ (BOOL)isDarkColor:(UIColor *)newColor;

// 16进制转color
+ (UIColor *)getColor:(NSString*)hexColor;
+ (UIColor *)colorWithRGBHex:(UInt32)hex;

// 16进制颜色控制透明度
+ (UIColor *)getColor:(NSString*)hexColor Alpha:(float)alpha;
+ (UIColor *)colorWithRGBHex:(UInt32)hex Alpha:(float)alpha;

// 获取手机可用磁盘容量
+ (NSString *)getAvailableDiskSize;

+ (BOOL)rewriteUTF8file:(NSString *)filePath fileName:(NSString *)fileName;

// 判断流海屏
+ (BOOL)iPhoneNotchScreen;

//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController;

//判断是否为空
+ (BOOL)isNullOrNilWithObject:(id)object;

//计算文本的宽度
+ (float)getStringWidth:(NSString *)text andFont:(float )font;

//计算文本的高度
+ (float)getStringHeight:(NSString *)text andFont:(float )font andWidth:(float)width;

//计算缓存
+ (NSString *)caculatorCacheSize;

//是否登录
+ (BOOL)isLogin;

/**获取用户UID**/
+ (NSString *)getUid;

//手机号验证
+ (BOOL)verifyUserPhone:(NSString *)userPhone;

/**获取当前时间戳**/
+ (NSString*)getCurrentTimestamp;

//某段时间距离现在有多少秒
+ (int)getTimeUTCFormateDate:(NSString *)newsDate;

// 生成二维码
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize logoImage:(UIImage *)logoImage;

//截屏
+ (UIImage *)screenshot;

//获得某个范围内的屏幕图像
+ (UIImage *)imageFromView:(UIView *) theView atFrame:(CGRect)r;

//view生成图片
+ (UIImage *)makeImageWithView:(UIView *)view;

/**
 字符串转base64
 str string
 return base64
 */
+ (NSString *)stringEncrypt_base64:(NSString *)str;

/**
 base64 解密成string
 base64Str 加密的字符串
 return string
 */
+ (NSString *)base4Decrypt_string:(NSString *)base64Str;

@end

NS_ASSUME_NONNULL_END
