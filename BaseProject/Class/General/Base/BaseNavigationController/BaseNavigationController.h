//
//  BaseNavigationController.h
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import "RTRootNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavigationController : RTRootNavigationController

@property (nonatomic,strong) NSMutableArray *rootVcAry;
@property (nonatomic, strong) UIView *lineView;

@end

NS_ASSUME_NONNULL_END
