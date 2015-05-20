//
//  ClassRelation.m
//  DeepIntoRuntime
//
//  Created by ronglei on 15/5/12.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import "ClassRelation.h"
#import <objc/runtime.h>

@implementation ClassRelation

#if 0

Class object_getClass(id obj)
{
    if (obj) return obj->getIsa();
    else return Nil;
}

inline Class
objc_object::getIsa()
{
    ...
    
    return ISA();
}

inline Class
objc_object::ISA()
{
    ...
    
    return isa.cls;
}

+ (id)self {
    return (id)self;
}

- (id)self {
    return self;
}

+ (Class)class {
    return self;
}

- (Class)class {
    return object_getClass(self);
}

+ (Class)superclass {
    return self->superclass;
}

- (Class)superclass {
    return [self class]->superclass;
}

+ (BOOL)isMemberOfClass:(Class)cls {
    return object_getClass((id)self) == cls;
}

- (BOOL)isMemberOfClass:(Class)cls {
    return [self class] == cls;
}

+ (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
        if (tcls == cls) return YES;
    }
    return NO;
}

- (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
        if (tcls == cls) return YES;
    }
    return NO;
}

self obj_msgSend
super obj_msgSendSuper

// self是类的隐藏参数，指向当前调用方法的这个类的实例。
// 而super是一个Magic Keyword，它本质是一个编译器标示符，和self是指向的同一个消息接受者。
// 当使用self调用方法时，会从当前类的方法列表中开始找，如果没有，就从父类中再找；
// 而当使用super时，则从父类的方法列表中开始找。然后调用父类的这个方法。

#endif

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"self:%@\n[self class]:%@\n[super class]:%@\n[self superclass]:%@\n[super superclass]:%@\n", self, [self class], [super class], [self superclass], [super superclass]);
        printf("\n");
        Class self_cls = [self class];
        Class cls_self = [ClassRelation self];
        Class name_cls = objc_getClass("ClassRelation");
        fprintf(stdout, "[self class] address:%p\n[ClassRelation self] address:%p\nobjc_getClass(\"ClassRelation\") address:%p\n", self_cls, cls_self, name_cls);
        printf("\n");
        Class meta_class = objc_getMetaClass("ClassRelation");
        fprintf(stdout, "self address:%p\nobjc_getMetaClass(\"ClassRelation\") address:%p\n", self, meta_class);
    }
    return self;
}

- (void)classImage
{
    NSLog(@"获取指定类所在动态库");
    
    NSLog(@"NSObject Framework: %s", class_getImageName(NSClassFromString(@"NSObject")));
    
    NSLog(@"获取指定库或框架中所有类的类名");
    unsigned int outCount;
    const char ** classes = objc_copyClassNamesForImage(class_getImageName(NSClassFromString(@"NSObject")), &outCount);
    for (int i = 0; i < outCount; i++) {
        NSLog(@"class name: %s", classes[i]);
    }
}

@end
