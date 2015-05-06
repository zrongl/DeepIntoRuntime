//
//  helper.c
//  OCRuntime
//
//  Created by ronglei on 14-8-15.
//  Copyright (c) 2014年 LaShou. All rights reserved.
//

#include <stdio.h>
#include <sys/time.h>
#include <sys/_types/_timeval.h>
#include "helper.h"

long long get_micro_time()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    
    // 此处不进行long long的强制转换会造成long类型的溢出
    return ((long long)tv.tv_sec * 1000000 + tv.tv_usec);
}

void printPropertyList(Class cls)
{
    unsigned int outCount, i;
    Ivar *vars = class_copyIvarList(cls, &outCount);
    printf("%s Ivars---------------------------:\n", class_getName(cls));
    for (i = 0; i < outCount; i ++) {
        Ivar var = vars[i];
        fprintf(stdout, "name:%s typeEncoding:%s offset:%i\n", ivar_getName(var),
                ivar_getTypeEncoding(var), ivar_getOffset(var));
    }
    
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    printf("%s propertys---------------------------:\n", class_getName(cls));
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        fprintf(stdout, "name:%s attr:%s\n", property_getName(property),
                property_getAttributes(property));
    }
    
    Method *methods = class_copyMethodList(cls, &outCount);
    printf("%s methods---------------------------:\n", class_getName(cls));
    for (i = 0; i < outCount; i ++) {
        Method method = methods[i];
        fprintf(stdout, "name:%s typeEncoding:%s\n", sel_getName(method_getName(method)),
                method_getTypeEncoding(method));
    }
    
    Protocol **protocols = class_copyProtocolList(cls, &outCount);
    printf("%s protocols---------------------------:\n", class_getName(cls));
    for (i = 0; i < outCount; i ++) {
        Protocol *protocol = protocols[i];
        fprintf(stdout, "name:%s", protocol_getName(protocol));
    }
    
}