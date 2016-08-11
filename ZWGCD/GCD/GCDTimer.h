//
//  GCDTimer.h
//  ZWGCD
//
//  Created by 章为 on 16/8/11.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDQueue.h"
#import "GCDTimer.h"
@class GCDQueue;
@interface GCDTimer : NSObject
@property (strong, readonly, nonatomic) dispatch_source_t dispatchSource;
#pragma 初始化
- (instancetype)init;
- (instancetype)initInQueue:(GCDQueue *)queue;

#pragma mark - 用法
- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval;
- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval delay:(uint64_t)delay;
- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs;
- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs;
- (void)start;
- (void)destroy;
@end
