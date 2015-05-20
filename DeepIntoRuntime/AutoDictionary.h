//
//  AutoDictionary.h
//  DeepIntoRuntime
//
//  Created by ronglei on 15/4/30.
//  Copyright (c) 2015年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

// 如果需要为

@interface AutoDictionary : NSObject

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) id object;

@end
