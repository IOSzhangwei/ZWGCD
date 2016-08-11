//
//  GCDSemaphore.h
//  ZWGCD
//
//  Created by 章为 on 16/8/11.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDSemaphore : NSObject
@property (strong, readonly, nonatomic) dispatch_semaphore_t dispatchSemaphore;

#pragma 初始化
- (instancetype)init;
- (instancetype)initWithValue:(long)value;

#pragma mark - 用法
- (BOOL)signal;
- (void)wait;
- (BOOL)wait:(int64_t)delta;

@end
