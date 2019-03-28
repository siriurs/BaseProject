//
//  CommonMethods.m
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import "CommonMethods.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/param.h>
#include <sys/mount.h>
#import <SDImageCache.h>


@implementation CommonMethods


// MD5加密
+ (NSString *)md5HexDigest:(NSString *)str {
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}

// 判断色值深浅
+ (BOOL)isDarkColor:(UIColor *)newColor{
    if ([[self class] alphaForColor: newColor] < 10e-5) {
        return YES;
    }
    const CGFloat *componentColors = CGColorGetComponents(newColor.CGColor);
    CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
    if (colorBrightness < 0.5){
        return YES;
    }
    else{
        return NO;
    }
}

//获取颜色透明度
+ (CGFloat)alphaForColor:(UIColor*)color {
    CGFloat r, g, b, a, w, h, s, l;
    BOOL compatible = [color getWhite:&w alpha:&a];
    if (compatible) {
        return a;
    } else {
        compatible = [color getRed:&r green:&g blue:&b alpha:&a];
        if (compatible) {
            return a;
        } else {
            [color getHue:&h saturation:&s brightness:&l alpha:&a];
            return a;
        }
    }
}

// 16进制颜色
+ (UIColor *)getColor:(NSString*)hexColor {
    if([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    
    NSScanner*scanner = [NSScanner scannerWithString:hexColor];
    unsigned hexNum;
    if(![scanner scanHexInt:&hexNum]) {
        return nil;
    }
    return [[self class] colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex{
    int r = (hex >>16) &0xFF;
    int g = (hex >>8) &0xFF;
    int b = (hex) &0xFF;
    return[UIColor colorWithRed:r /255.0f
                          green:g /255.0f
                           blue:b /255.0f
                          alpha:1.0f];
}

// 16进制颜色控制透明度
+ (UIColor *)getColor:(NSString*)hexColor Alpha:(float)alpha {
    if([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    
    NSScanner*scanner = [NSScanner scannerWithString:hexColor];
    unsigned hexNum;
    if(![scanner scanHexInt:&hexNum]) {
        return nil;
    }
    return [[self class] colorWithRGBHex:hexNum Alpha:alpha];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex Alpha:(float)alpha{
    int r = (hex >>16) &0xFF;
    int g = (hex >>8) &0xFF;
    int b = (hex) &0xFF;
    return[UIColor colorWithRed:r /255.0f
                          green:g /255.0f
                           blue:b /255.0f
                          alpha:alpha];
}

// 获取手机可用磁盘容量
+ (NSString *)getAvailableDiskSize {
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    NSString *str = [NSString stringWithFormat:@"%0.2lld",freeSpace/1024/1024];//MB
    
    return str;
}

+ (BOOL)rewriteUTF8file:(NSString *)filePath fileName:(NSString *)fileName{
    
    NSData *fileData = [NSData dataWithContentsOfFile:[filePath stringByAppendingPathComponent:fileName]];
    
    char *buff = malloc(sizeof(char) * 3);
    [fileData getBytes:buff length:3];
    
    char bom16[3] = {0xef,0xbb,0xbf};//"\xef\xbb\xbf";
    char *p = bom16;
    char *q = buff;
    
    short cnt = 0;
    for (short i=0; i<3; i++) {
        if (*p++ == *q++) {
            cnt++;
        }
    }
    free(buff);
    
    // Match BOM fmt
    NSData *newData;
    
    if (cnt == 3) {
        //        XLLog(@"Matched \\Number!");
        newData = [fileData subdataWithRange:NSMakeRange(3, fileData.length-3)];
        NSError *rewriteErr;
        BOOL res = [newData writeToFile:[filePath stringByAppendingPathComponent:fileName] options:NSDataWritingAtomic error:&rewriteErr];
        if (res) {
            return YES;
        }else{
            //            XLLog(@"rewrite file Err:%@",rewriteErr);
            return NO;
        }
    }else{
        //        XLLog(@">>>Not Match BOM");
        return YES;
    }
}

// 判断流海屏
+ (BOOL)iPhoneNotchScreen {
    if (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_11_0) {
        return false;
    } else {
        CGFloat iPhoneNotchDirectionSafeAreaInsets = 0;
        if (@available(iOS 11.0, *)) {
            UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
            switch ([UIApplication sharedApplication].statusBarOrientation) {
                case UIInterfaceOrientationPortrait:{
                    iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top;
                }
                    break;
                case UIInterfaceOrientationLandscapeLeft:{
                    iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.left;
                }
                    break;
                case UIInterfaceOrientationLandscapeRight:{
                    iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.right;
                }
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:{
                    iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.bottom;
                }
                    break;
                default:
                    iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top;
                    break;
            }
        } else {
            // Fallback on earlier versions
        }
        return iPhoneNotchDirectionSafeAreaInsets > 20;
    }
}

//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

//判断是否为空
+ (BOOL)isNullOrNilWithObject:(id)object; {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]||[object isEqualToString:@"(null)"]) {
            return YES;
        } else {
            return NO;
        }
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

//计算文本的宽度
+ (float)getStringWidth:(NSString *)text andFont:(float)font{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width+1;
}

//计算文本的高度
+ (float)getStringHeight:(NSString *)text andFont:(float)font andWidth:(float)width{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height+1;
}

#pragma mark计算缓存
+ (NSString *)caculatorCacheSize{
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    
    NSString *cacheStr;
    //    缓存内存大小
    if (size<1024) {
        cacheStr=[NSString stringWithFormat:@"%lu B",(unsigned long)size];
    } else if (size>=1024 && size <1024 *1024) {
        cacheStr=[NSString stringWithFormat:@"%0.2f KB" ,size/1024.0];
    } else {
        cacheStr=[NSString stringWithFormat:@"%.2f MB" ,size *1.0 /( 1024*1024)];
    }
    return cacheStr;
}

//是否登录
+  (BOOL)isLogin{
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:csUserDefaultsGET(USER_INFO)];
    if ([infoDic allKeys].count == 0) {//未登录
        return NO;
    } else {
        if (![[infoDic allKeys] containsObject: @"uid"]) {
            return NO;
        } else {
            return YES;
        }
    }
}

/**获取用户UID**/
+ (NSString *)getUid {
    NSDictionary *infoDic = [[NSDictionary alloc] initWithDictionary:csUserDefaultsGET(USER_INFO)];
    NSString *uidStr = @"";
    if ([infoDic allKeys].count!=0 && ![CommonMethods isNullOrNilWithObject:[infoDic objectForKey:@"uid"]]) {
        uidStr = [infoDic objectForKey:@"uid"];
    }
    return uidStr;
}

//手机号验证
+ (BOOL)verifyUserPhone:(NSString *)userPhone {
    NSString *phone = @"^[0-9]{11}$";
    
    NSPredicate *prePhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    BOOL result = [prePhone evaluateWithObject:userPhone];
    if (result) {
        return YES;
    }
    return NO;
}

/**获取当前时间戳**/
+ (NSString*)getCurrentTimestamp {
    NSDate* date= [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval interval=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", interval * 1000];//转为字符型
    return timeString;
}

//某段时间距离现在有多少秒
+ (int)getTimeUTCFormateDate:(NSString *)newsDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];

    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted]; //间隔的秒数
    int seconds = ((int)time)%(3600*24)%3600%60;
    return seconds;
}

// 生成二维码
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize logoImage:(UIImage *)logoImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [[self alloc] createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:waterImagesize logoImage:logoImage];
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize logoImage:(UIImage *)logoImage{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //logo图
    UIImage *waterimage;
    if (![CommonMethods isNullOrNilWithObject:logoImage]) {
        waterimage = logoImage;
    }
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

//截屏
+ (UIImage *)screenshot {
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 获得某个范围内的屏幕图像
+ (UIImage *)imageFromView:(UIView *) theView atFrame:(CGRect)r {
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}

// view生成图片
+ (UIImage *)makeImageWithView:(UIView *)view {
    CGSize s = view.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// 字符串转base64
+ (NSString *)stringEncrypt_base64:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

// base64 解密成string
+ (NSString *)base4Decrypt_string:(NSString *)base64Str {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
