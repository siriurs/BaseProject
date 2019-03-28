//
//  BaseWebView.m
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import "BaseWebView.h"

@implementation BaseWebView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    } else if (action == @selector(select:)) {
        return YES;
    } else if (action == @selector(selectAll:)) {
        return YES;
    }
    
    return NO;
}

@end
