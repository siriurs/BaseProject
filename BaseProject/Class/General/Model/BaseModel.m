//
//  BaseModel.m
//  BaseProject
//
//  Created by bolin on 2019/3/27.
//  Copyright © 2019 BaseProject. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation BaseModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar var = vars[i];
        const char *name = ivar_getName(var);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        if (value) {
            [aCoder encodeObject:value forKey:key];
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int outCount = 0;
        Ivar *vars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar var = vars[i];
            const char *name = ivar_getName(var);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            if (value) {
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
}

@end
