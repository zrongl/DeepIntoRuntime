//
//  MsgTransmit.m
//  DeepIntoRuntime
//
//  Created by ronglei on 15/4/30.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "MsgTransmit.h"
#import <objc/runtime.h>

@implementation MsgTransmit

- (void)myFun
{
    
}

// oc对象的每个方法中都有两个隐藏参数 self 和 _cmd
void resolveMethod(id self, SEL _cmd)
{
    NSLog(@"success method %s add in %@!\n", sel_getName(_cmd), self);
}

// 从本类开始一直查到到根类(NSObject)都没有找到方法就会进入给方法
// 即动态方法决议(Dynamic Method Resolution) 你可以添加方法并跳转至该方法执行 否则进入消息转发
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    // 接收lowercaseString消息是 添加resolveMethod方法 并执行该添加的方法
    if (sel == @selector(lowercaseString)) {
        class_addMethod([self class], sel, (IMP)resolveMethod, nil);
        return YES;
    }
    
    return NO;
}

// 消息转发 最后的挣扎 还是找不到selector 崩溃
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    // 做selector判断
    if (aSelector == @selector(uppercaseString)) {
        // 如果接收到的是uppercaseString消息 则返回字符串对象(@"not find")去执行@selector(uppercaseString)
        return @"not find";
    }else {
        return nil;
    }
}

//- (void)forwardInvocation:(NSInvocation *)invocation
//{
//    SEL invSEL = invocation.selector;
//    if ([self respondsToSelector:invSEL]){
//        [invocation invokeWithTarget:self];
//    } else {
//        [self doesNotRecognizeSelector:invSEL];
//    }
//}

@end
