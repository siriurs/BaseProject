//
//  BaseImageView.h
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseImageView;
typedef NS_ENUM(NSInteger, CSImageType) {
    CSImageTypeDefault  =   0,
    CSImageTypeHeaderface,
    CSImageTypeSquare,
    CSImageType4To3,
    CSImageType3To2,
    CSImageTypeError,
    CSImageTypeNULL,
};


@interface BaseImageView : UIImageView {
    BOOL gaussianBlur;    // 高斯模糊
    BOOL clipping;        // 居中裁切正方
    BOOL gary;            // 黑白
}

@property (nonatomic, assign) BOOL showBorder;    // 边框

- (void)csSetImageWithURL:(NSString *)url type:(CSImageType)type;
- (void)csSetGaussianBlurImageWithURL:(NSString *)url type:(CSImageType)type;
- (void)csSetClippingImageWithURL:(NSString *)url type:(CSImageType)type;
- (void)csSetGaryImageWithURL:(NSString *)url type:(CSImageType)type;
- (void)csSetImageWithURL:(NSString *)url type:(CSImageType)type isGaussianBlur:(BOOL)isGaussianBlur isClipping:(BOOL)isClipping isGary:(BOOL)isGary;

// UIColor转UIImage
+ (UIImage*) createImageWithColor: (UIColor*) color;

// 按尺寸缩放
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
