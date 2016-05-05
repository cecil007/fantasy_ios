//
//  LIDownload.h
//  yymdiabetes
//
//  Created by user on 15/8/11.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LINetwork.h"
#import "LIRequest.h"

@interface LIDownload : NSObject
@property (nonatomic,strong) NSString * isCanceCache;
@property (nonatomic,strong,readonly) NSString * downloadUrl;
- (void) cancelNetwork;
- (void)requestWithURLString:(NSString *)URLString loading:(DownloadProgressBlock)progress downloaded:(DownloadCurrentDataBlock)data response:(LIResponseBlock)closure;
@end
