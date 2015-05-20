//
//  AutoDictionary.m
//  DeepIntoRuntime
//
//  Created by ronglei on 15/4/30.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "AutoDictionary.h"
#import <objc/runtime.h>

@interface AutoDictionary()

@property (nonatomic, strong) NSMutableDictionary *objStore;

@end

@implementation AutoDictionary
// 告诉编译器 不要为一下成员变量生成访问器
@dynamic string, number, date, object;

- (id)init
{
    self = [super init];
    if (self) {
        _objStore = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selString = NSStringFromSelector(sel);
    // 动态添加getter/setter方法 并将成员变量存储在objStore字典中
    if ([selString hasPrefix:@"set"]) {
        class_addMethod(self, sel, (IMP)autoDicSetter, "v@:@");
    } else {
        class_addMethod(self, sel, (IMP)autoDicGetter, "@@:");
    }
    return YES;
}

id autoDicGetter(id self, SEL _cmd)
{
    AutoDictionary *typedSelf = (AutoDictionary *)self;
    NSMutableDictionary *objStore = typedSelf.objStore;
    
    NSString *key = NSStringFromSelector(_cmd);
    
    return [objStore objectForKey:key];
}

void autoDicSetter(id self, SEL _cmd, id value)
{
    AutoDictionary *typedSelf = (AutoDictionary *)self;
    NSMutableDictionary *objStore = typedSelf.objStore;
    
    NSString *selString = NSStringFromSelector(_cmd);
    // 将字符串 setAbc: 转换为 abc
    // 此时 key = setAbc:
    NSMutableString *key = [selString mutableCopy];
    [key deleteCharactersInRange:NSMakeRange(key.length - 1, 1)];
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    NSString *lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    // 此时 key = abc
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
    
    if (value) {
        [objStore setObject:value forKey:key];
    } else {
        [objStore removeObjectForKey:key];
    }
}

@end
