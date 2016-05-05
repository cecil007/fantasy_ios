//
//  LIQueue.m
//  yymdiabetes
//
//  Created by user on 15/8/13.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIQueue.h"
#import "LIObject.h"

@implementation LIQueue{
    NSString * markId;
    NSOperationQueue * _queue;
}

+ (void) mainQueue:(queueOperationClosure)mainQueueOperation{
    if ([NSOperationQueue currentQueue] != [NSOperationQueue mainQueue]) {
        NSBlockOperation * closure = [NSBlockOperation blockOperationWithBlock:^{
            mainQueueOperation([NSOperationQueue mainQueue]);
        }];
        [[NSOperationQueue mainQueue] addOperation:closure];
    }else{
            mainQueueOperation([NSOperationQueue mainQueue]);
    }
}

+ (void)queueId:(NSString *)queueId operation:(queueOperationClosure)operation{
    [self queueId:queueId maxConcurrent:1 operation:operation];
}

+ (void)queueId:(NSString *)queueId maxConcurrent:(int)maxConcurrent operation:(queueOperationClosure)operation {
    LIQueue * queue = [[LIQueue alloc] init];
    [queue queueOperationWithQueueId:queueId maxConcurrent:maxConcurrent operation:operation];
}

- (void) queueOperationWithQueueId:(NSString *)queueId maxConcurrent:(int)maxConcurrent operation:(queueOperationClosure)operation {
    
    markId = queueId;
    NSOperationQueue * myQueue;
    for (NSOperationQueue * queue in [LIObjectManage sharedInstance].queues){
        if (queue.name == queueId){
            myQueue = queue;
        }
    }
    
    if (myQueue == nil) {
        myQueue = [NSOperationQueue new];
        myQueue.maxConcurrentOperationCount = maxConcurrent;
        myQueue.name = queueId;
        [[LIObjectManage sharedInstance].queues addObject:myQueue];
    }
    
    NSBlockOperation * closure = [NSBlockOperation blockOperationWithBlock:^{
        operation(myQueue);
    }];
    
    [myQueue addOperation:closure];
}

@end
