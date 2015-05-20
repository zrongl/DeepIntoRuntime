//
//  ViewController.m
//  DeepIntoRuntime
//
//  Created by ronglei on 15/4/30.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ViewController.h"
#import "MsgTransmit.h"
#import "ClassRelation.h"
#import <objc/runtime.h>
#import "helper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // MsgTransmit *mt = [[MsgTransmit alloc] init];
    // 上句可以一下句的C语言的语句代替 OC中的方法都可以写成objc_msgSend()形式
//    MsgTransmit *mt = objc_msgSend(objc_msgSend(objc_getClass("MsgTransmit"), @selector(alloc)), @selector(init));
//    
//    [mt performSelector:@selector(lowercaseString)];
//    NSLog(@"%@", [mt performSelector:@selector(uppercaseString)]);
//    
//    [self compareRuntimeAndIMPTimeConsuming];
    
    ClassRelation *cls = [[ClassRelation alloc] init];
    [cls classImage];
}

//IMP performselector
- (void)compareRuntimeAndIMPTimeConsuming
{
    MsgTransmit *mt = [[MsgTransmit alloc] init];
    long long timeA = get_micro_time();
    
    for (int i = 0; i < 10000; i ++) {
        [mt myFun];
    }
    
    long long timeB = get_micro_time();
    
#if 1
    /*
     使用methodForSelector:方法可以绕开动态绑定的寻找method的过程从而节省了时间
     methodForSelector:来源于Cocoa runtime system,并非object-c语言本身的特性
     */
    
    // 定义一个IMP（函数指针）
    void (*baseMethod)(id, SEL);
    // 通过methodForSelector方法根据SEL获取对应的函数指针
    baseMethod = (void (*)(id, SEL))[mt methodForSelector:@selector(myFun)];
    baseMethod = (void (*)(id, SEL))class_getMethodImplementation(object_getClass(mt), @selector(myFun));
    
    for (int j = 0; j < 10000; j ++) {
        // 直接的指针调用要比[mt myFun]消息传递方式省时
        baseMethod(mt, @selector(myFun));
    }
    
#else
    //However, the performSelector: method allows you to send messages that aren’t determined until runtime.
    [mt performSelector:@selector(myFun) withObject:nil];
#endif
    
    long long timeC = get_micro_time();
    NSLog(@"need time:%lld %lld(微秒)\n", (timeB - timeA), (timeC - timeB));
}

//NSMethodSignature和NSInvocation的使用 将方法对象化
- (NSString *)myMethod:(NSString *)param1 withParam2:(NSNumber *)param2
{
    NSString *result = @"objc";
    NSLog(@"par = %@",param1);
    NSLog(@"par 2 = %@",param2);
    return result;
}

- (void)invokeMyMethodDynamically
{
    SEL selector = @selector(myMethod:withParam2:);
    //获得类和方法的签名
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
    //从签名获得调用对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    //设置target
    [invocation setTarget:self];
    //设置selector
    [invocation setSelector:selector];
    NSString *returnValue = nil;
    NSString *argument1 = @"fist";
    NSNumber *argument2 = [NSNumber numberWithInt:102];
    //设置参数，第一个参数index为2
    [invocation setArgument:&argument1 atIndex:2];
    [invocation setArgument:&argument2 atIndex:3];
    //retain一遍参数
    [invocation retainArguments];
    //调用
    [invocation invoke];
    //得到返回值，此时不会再调用，只是返回值
    [invocation getReturnValue:&returnValue];
    NSLog(@"return value = %@",returnValue);
}

@end
