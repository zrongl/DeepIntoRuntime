#include "stdio.h"

#define OBJC  "UIWindow"

typedef struct objc_class *Class;
typedef struct objc_object *id;
typedef id (*IMP)(id, const char*, ...);

struct objc_method {
    const char *method_name;
    char *method_types;
    IMP method_imp;
};

struct objc_method_list {
    struct objc_method_list *obsolete;
    int method_count;
    /* variable length structure */
    struct objc_method method_list[1];
};

struct objc_class {
    Class isa;
    // ...
    struct objc_method_list **methodLists;
};

id objc_msgSend(id self, const char *sel);
id objc_getClass(const char *name);

int main(int argc, const char * argv[]) {
    // insert code here...
    Class cls = objc_msgSend(objc_getClass(OBJC), "alloc");
    printf("Hello, World!\n");
    return 0;
}

id objc_msgSend(id self, const char *sel)
{
    /*
    // 区分类方法还是对象方法
    if (sel is class method) {
        // 元类方法查找流程 ???
    }else if (sel is object method){
        // 类方法查找流程即 消息分发
    }
     */
    
    return NULL;
}

id objc_getClass(const char *name)
{
    // objc_auto.m => objc_registerClassPair
    // 用到某个类方法之前就已经在内存中创建了该类对象
    // 获取NSMapTable结构，不存在就去创建(应该不会存在该情况)，存在直接查找
    // 查找跟name匹配的mappair->key 并返回对应的mappair->value
    
    return NULL;
}