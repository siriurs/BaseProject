//
//  UIView+Additions.m
//  yaowoo
//
//  Created by Bolin on 15/4/8.
//  Copyright (c) 2015年 YiyangLinkage. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

//利用UIResponder传递机制，找到viewController push到下一个页面
- (UIViewController *)viewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
