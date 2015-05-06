//
//  helper.h
//  OCRuntime
//
//  Created by ronglei on 14-8-15.
//  Copyright (c) 2014年 LaShou. All rights reserved.
//

#ifndef OCRuntime_OCTexting_h
#define OCRuntime_OCTexting_h

#include <objc/objc.h>
#include <objc/runtime.h>

// 获取当前时间转换为微秒并返回
long long get_micro_time();

void printPropertyList(Class cls);

#endif
