//
//  LIQueue.h
//  yymdiabetes
//
//  Created by user on 15/8/13.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^queueOperationClosure)(NSOperationQueue * queue);

@interface LIQueue : NSObject
///主队列
+ (void) mainQueue:(queueOperationClosure)mainQueueOperation;
///单线程串行队列
+ (void)queueId:(NSString *)queueId operation:(queueOperationClosure)operation;
///多线程串行队列
+ (void)queueId:(NSString *)queueId maxConcurrent:(int)maxConcurrent operation:(queueOperationClosure)operation;
@end
