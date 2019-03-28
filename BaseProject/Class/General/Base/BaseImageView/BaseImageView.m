//
//  BaseImageView.m
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import "BaseImageView.h"
#import <Accelerate/Accelerate.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BaseImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        gaussianBlur = NO;
        gary = NO;
        clipping = NO;
        self.showBorder = NO;
    }
    
    return self;
}

// 设置缺省图
- (UIImage *)setDefaultPlaceHolder{
    UIImage *placeHolder = [[UIImage alloc] init];
    placeHolder = [UIImage imageNamed:@"head_bg"];
    return placeHolder;
}

// 设置缺省头像
- (UIImage *)setDefaultHeadface{
    UIImage *defaultHeadface = [[UIImage alloc] init];
    defaultHeadface = [UIImage imageNamed:@"icon_touxiang_hui"];
    return defaultHeadface;
}

// 设置正方形缺省图
- (UIImage *)setDefaultSquare{
    UIImage *placeHolder = [[UIImage alloc] init];
    placeHolder = [UIImage imageNamed:@"zhanwei_big"];
    return placeHolder;
}

// 设置4:3缺省图
- (UIImage *)setDefault4To3{
    UIImage *placeHolder = [[UIImage alloc] init];
    placeHolder = [UIImage imageNamed:@"head_bg"];
    return placeHolder;
}

// 设置3:2缺省图
- (UIImage *)setDefault3To2{
    UIImage *placeHolder = [self drawPlaceHolder:AifanPIIICIMAGE size:CGSizeMake(300, 200) backgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    return placeHolder;
}

// 设置读取失败缺省图
- (UIImage *)setDefaultError{
    UIImage *placeHolder = [[UIImage alloc] init];
    placeHolder = [UIImage imageNamed:@"haert_error"];
    return placeHolder;
}


- (void)csSetImageWithURL:(NSString *)url type:(CSImageType)type {
    NSString *str=[NSString stringWithFormat:@"%@",url];
    //    NSString *imgeUrl=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//防止有汉字
    NSURL *image_url = [NSURL URLWithString:str];
    UIImage *placeholder = [[UIImage alloc] init];
    
    if (type) {
        if (type == CSImageTypeDefault) {
            placeholder = [self setDefaultPlaceHolder];
        } else if (type == CSImageTypeHeaderface) {
            placeholder = [self setDefaultHeadface];
        } else if (type == CSImageTypeSquare) {
            placeholder = [self setDefaultSquare];
        } else if (type == CSImageType4To3) {
            placeholder = [self setDefault4To3];
        } else if (type == CSImageType3To2) {
            placeholder = [self setDefault3To2];
        } else if (type == CSImageTypeError) {
            placeholder = [self setDefaultError];
        } else if (type == CSImageTypeNULL) {
            placeholder = nil;
        } else {
            placeholder = [self setDefaultPlaceHolder];
        }
    } else {
        placeholder = [self setDefaultPlaceHolder];
    }
    
    if (url.length) {
        
        NSString *s = [url substringWithRange:NSMakeRange(0, 1)];
        
        // 纯色背景
        if ([s isEqualToString:@"#"]) {
            CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [CommonMethods getColor:url].CGColor);
            CGContextFillRect(context, rect);
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [self setImage:img];
        } else { // 图片地址
            [self sd_setImageWithURL:image_url placeholderImage:placeholder options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    UIImage *err_image = [self setDefaultError];
                    UIImageView *errImageView = [[UIImageView alloc] initWithImage:err_image];
                    [errImageView setCenter:self.center];
                    [self addSubview:errImageView];
                } else {
                    for (id tempView in [self subviews]) {
                        [tempView removeFromSuperview];
                    }
                    
                    //是否需要剪裁
                    if (self->clipping) {
                        UIImage *croppingImage = [self croppingImage:image];
                        [self setImage:croppingImage];
                        image = [self croppingImage:image];
                    }
                    
                    //是否开启高斯模糊
                    if (self->gaussianBlur) {
                        image = [BaseImageView blurryImage:image withBlurLevel:0.5];
                    }
                    
                    // 是否开启灰色图片
                    if (self->gary) {
                        image = [self grayscaleImageForImage:image];
                    }
                    
                    [self setImage:image];
                }
                
                // 添加边框
                if (self.showBorder) {
                    [self.layer setMasksToBounds:YES];
                    self.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
                    self.layer.borderWidth = 0.5f;
                }
            }];
        }
    } else {
        [self setImage:placeholder];
    }
}

- (void)csSetGaussianBlurImageWithURL:(NSString *)url type:(CSImageType)type {
    gaussianBlur = YES;
    [self csSetImageWithURL:url type:type];
}

- (void)csSetClippingImageWithURL:(NSString *)url type:(CSImageType)type {
    clipping = YES;
    [self csSetImageWithURL:url type:type];
}

- (void)csSetGaryImageWithURL:(NSString *)url type:(CSImageType)type {
    gary = YES;
    [self csSetImageWithURL:url type:type];
}

- (void)csSetImageWithURL:(NSString *)url type:(CSImageType)type isGaussianBlur:(BOOL)isGaussianBlur isClipping:(BOOL)isClipping isGary:(BOOL)isGary {
    gaussianBlur = isGaussianBlur;
    clipping = isClipping;
    gary = isGary;
    [self csSetImageWithURL:url type:type];
}


// 剪裁图片
- (UIImage *)croppingImage:(UIImage *)image {
    if (image) {
        CGRect rectMAX = CGRectZero;
        float coefficient = self.frame.size.width/self.frame.size.height;
        
        float newWidth = 0;
        float newHeight = 0;
        
        if (coefficient >= 1) {
            float scale = image.size.width/self.frame.size.width;
            newHeight = self.frame.size.height * scale * image.scale;
            rectMAX = CGRectMake(0, (image.size.height*image.scale -newHeight)/2, image.size.width*image.scale, newHeight);
        } else {
            float scale = image.size.height/self.frame.size.height;
            newWidth = self.frame.size.width * scale * image.scale;
            rectMAX = CGRectMake((image.size.width*image.scale-newWidth)/2, 0, newWidth, image.size.height*image.scale);
        }
        
        
        CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rectMAX);
        CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
        
        UIGraphicsBeginImageContext(smallBounds.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, smallBounds, subImageRef);
        UIImage* viewImage = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        
        return viewImage;
    }
    
    return nil;
}

//高斯模糊
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    //模糊度,
    if ((blur < 0.1f) || (blur > 2.0f)) {
        blur = 0.5f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    //    NSLog(@"boxSize:%i",boxSize);
    //图像处理
    CGImageRef img = image.CGImage;
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    //    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    //    vImage_Buffer outBuffer2;
    //    outBuffer2.data = pixelBuffer2;
    //    outBuffer2.width = CGImageGetWidth(img);
    //    outBuffer2.height = CGImageGetHeight(img);
    //    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    //    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    //    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGContextRef ctx =  CGBitmapContextCreate(
                                              outBuffer.data,
                                              outBuffer.width,
                                              outBuffer.height,
                                              8,
                                              outBuffer.rowBytes,
                                              colorSpace,
                                              bitmapInfo);
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    //    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

// 图片变灰
- (UIImage *)grayscaleImageForImage:(UIImage *)image {
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width * image.scale, image.size.height * image.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, (int)width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(imageRef);
    
    return resultUIImage;
}

// UIColor转UIImage
+ (UIImage*) createImageWithColor: (UIColor*) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)drawPlaceHolder:(UIImage*)image size:(CGSize)size backgroundColor:(UIColor *)backgroundColor {
    UIGraphicsBeginImageContextWithOptions(size,0, [UIScreen mainScreen].scale);
    [backgroundColor set];
    UIRectFill(CGRectMake(0,0, size.width, size.height));
    CGFloat imageX = (size.width /2) - (99 /2);
    CGFloat imageY = (size.height /2) - (30 /2);
    [image drawInRect:CGRectMake(imageX, imageY, 99, 30)];
    UIImage *resImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

-(UIImage *)cutCenterSquareImage:(UIImage *)image{
    CGSize imageSize = image.size;
    
    // 中间最大正方形尺寸
    CGRect centerRect;
    CGFloat centerRectWH;
    
    //根据图片的大小计算出图片中间矩形区域的位置与大小
    if (imageSize.width > imageSize.height) {
        centerRectWH = imageSize.height;
        float leftMargin = (imageSize.width - imageSize.height) * 0.5;
        centerRect = CGRectMake(leftMargin,0,centerRectWH,centerRectWH);
    } else {
        centerRectWH = imageSize.width;
        float topMargin = (imageSize.height - imageSize.width)*0.5;
        centerRect = CGRectMake(0,topMargin,centerRectWH,centerRectWH);
    }
    
    CGImageRef imageRef = image.CGImage;
    //在最大正方形尺寸范围内截取
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, centerRect);
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);// tmp是截取之后的image
    
    return tmp;
}

// 按尺寸缩放
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage * resultImage;
    if (image.size.width != image.size.height) {
        resultImage = [[BaseImageView new] cutCenterSquareImage:image];
    } else {
        resultImage = image;
    }
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

@end
