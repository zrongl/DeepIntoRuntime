//
//  NSArray+MethodSwizzling.m
//  DeepIntoRuntime
//
//  Created by ronglei on 15/4/30.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "NSArray+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation NSArray (MethodSwizzling)

+ (void)load
{
    Method objectAtIndex = class_getInstanceMethod(self, @selector(objectAtIndex:));
    Method logObjectAtIndex = class_getInstanceMethod(self, @selector(logObjectAtIndex:));
    method_exchangeImplementations(objectAtIndex, logObjectAtIndex);
}

- (void)logObjectAtIndex:(NSInteger)index
{
    NSLog(@"get object at %ld", (unsigned long)index);
    [self logObjectAtIndex:index];
}

@end
