//
//  LIDownload.m
//  yymdiabetes
//
//  Created by user on 15/8/11.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIDownload.h"
#import "LINetwork.h"
#import "LINetworkManager.h"
@interface LIDownloadCache : NSObject
- (void)saveData:(NSData *)newImage storageFileKeyWithURLString:(NSString *)urlString;
- (NSData *) dataWithURLString:(NSString *)urlString;
- (NSData *)data:(NSData *)newImage storageFileKeyWithURLString:(NSString *)urlString;
@property (atomic,strong) NSCache * imageDataCache;
+ (LIDownloadCache *) sharedInstance;
@end
static LIDownloadCache * ___DownloadCache = nil;
@implementation LIDownloadCache
+ (LIDownloadCache *) sharedInstance{
    @synchronized(self){
        if (___DownloadCache == nil) {
            ___DownloadCache = [[self alloc] init];
            ___DownloadCache.imageDataCache = [[NSCache alloc] init];
        }
    }
    return  ___DownloadCache;
}
- (NSData *) dataWithURLString:(NSString *)urlString
{
    NSData * data = [self.imageDataCache objectForKey:urlString];
    if (data) {
        return data;
    }else{
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString * CachesDirectory = [paths objectAtIndex:0];
        NSString * fullPathToFile = [CachesDirectory stringByAppendingPathComponent:@"LIImage_Share_Caches/"];
        
        NSString * fullPathToFileString = [fullPathToFile stringByAppendingPathComponent:[urlString stringByReplacingOccurrencesOfString: @"/" withString: @"_"]];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:fullPathToFileString isDirectory:&isDir];
        if ((isDir == YES && existed == YES) || existed == NO){
            return nil;
        }else{
            NSData * imageTempData = [NSData dataWithContentsOfFile:fullPathToFileString];
            [self.imageDataCache setObject:imageTempData forKey:urlString];
            return imageTempData;
        }
    }
    return nil;
}

- (NSData *)data:(NSData *)newImage storageFileKeyWithURLString:(NSString *)urlString
{
    
    if (newImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self saveData:newImage storageFileKeyWithURLString:urlString];
        });
    }
    if (newImage) {
        return newImage;
    }else
        return nil;
}

- (void)saveData:(NSData *)newImage storageFileKeyWithURLString:(NSString *)urlString
{
    // long-running task
    //路径判断与生成
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * CachesDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [CachesDirectory stringByAppendingPathComponent:@"LIImage_Share_Caches/"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:fullPathToFile isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:fullPathToFile withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSData * imageTempData;
    imageTempData = newImage;
    //数据存储
    if (self.imageDataCache) {
        [self.imageDataCache setObject:imageTempData forKey:urlString];
    }
    NSString *imageCachePath = [urlString stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
    NSString * saveFilePath = [fullPathToFile stringByAppendingPathComponent:imageCachePath];
    BOOL isSussce = [imageTempData writeToFile:saveFilePath atomically:NO];
    NSLog(@"文件缓存%d",isSussce);
    /*
     dispatch_async(dispatch_get_main_queue(), ^{
     // update UI
     });
     */
}
@end

@interface LIDownload ()<NSURLSessionDownloadDelegate,NSURLConnectionDataDelegate>
@end

@implementation LIDownload{
    float _downloadProgress;
    long long _downloadSize;
    NSURLSessionDownloadTask * _downloadTask;
    NSURLConnection * _URLConnection;
    LIResponseBlock _closure;
    NSMutableData * _downloadData;
    NSURLSession * _session;
    DownloadProgressBlock _progress;
    DownloadCurrentDataBlock _currentData;
    NSString * _downloadUrlString;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloadProgress = 0;
        _downloadSize = 0;
        _downloadData = [[NSMutableData alloc] init];
    }
    return self;
}
//TODO: - 初始化
- (void)DownloadMainQueue:(void(^)())block{
    if ([NSOperationQueue currentQueue] == [NSOperationQueue mainQueue]) {
        if (block) {
            block();
        }
    }else{
        [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
            if (block) {
                block();
            }
        }]];
    }
}
- (NSString *)fullURLWithString:(NSString *)string {
    if ([[string lowercaseString] hasPrefix:@"http://"] || [[string lowercaseString] hasPrefix:@"https://"]) {
        return string;
    }else{
        NSString * baseUrl = @"";
        if ([[LINetworkManager sharedInstance].downloadBaseURLString hasSuffix:@"/"]) {
            baseUrl = LINetworkManager.sharedInstance.downloadBaseURLString;
        }else{
            baseUrl = [NSString stringWithFormat:@"%@/",[LINetworkManager sharedInstance].downloadBaseURLString];
        }
        
        if ([string hasPrefix:@"/"]){
            return [NSString stringWithFormat:@"%@%@",baseUrl,[string substringFromIndex:1]];
        }else{
            return [NSString stringWithFormat:@"%@%@",baseUrl,string];
        }
        
    }
}
- (void)requestWithURLString:(NSString *)URLString loading:(DownloadProgressBlock)progress downloaded:(DownloadCurrentDataBlock)data response:(LIResponseBlock)closure {
    NSData * mData = [[LIDownloadCache sharedInstance] dataWithURLString:URLString];
    if (mData==nil) {
        _downloadUrl = URLString;
        if ([LINetwork networkState]!=NetworkStateWifi) {
            BOOL isDelete = NO;
            for (NSString * url in [LINetworkManager sharedInstance].wifiDownLoadUrls) {
                if ([url isEqual:_downloadUrl]) {
                    isDelete = YES;
                }
            }
            if (isDelete==YES) {
                if (closure) {
                    closure(nil,nil,nil);
                }
                [[LINetworkManager sharedInstance].netWorks removeObject:self];
                return;
            }
        }
    }else{
        if (closure) {
            closure(nil,mData,nil);
        }
        [[LINetworkManager sharedInstance].netWorks removeObject:self];
        return;
    }
    _downloadUrlString = URLString;
    _closure = closure;
    _progress = progress;
    _currentData = data;
#ifdef __IPHONE_7_0
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    _downloadTask = [_session downloadTaskWithURL:[NSURL URLWithString:[self fullURLWithString:URLString]]];
    [_downloadTask resume];
#else
    _URLConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self fullURLWithString:URLString]]] delegate:self startImmediately:NO];
    [_URLConnection setDelegateQueue:[NSOperationQueue mainQueue]];
    [_URLConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_URLConnection start];
#endif
}


- (void) cancelNetwork{
    if (_downloadTask != nil) {
        [_downloadTask cancel];
    }
    if (_URLConnection != nil) {
        [_URLConnection cancel];
    }
}

#pragma mark - URLSessionSelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    [_downloadData appendData:[NSData dataWithContentsOfURL:location]];
    if (_closure != nil) {
        //       __weak LIDownload * weakSelf  = self;
        [self DownloadMainQueue:^{
            [[LIDownloadCache sharedInstance] data:_downloadData storageFileKeyWithURLString:_downloadUrlString];
            _closure(nil,_downloadData,nil);
        }];
    }
    _closure = nil;
    _progress = nil;
    _currentData = nil;
    [[LINetworkManager sharedInstance].netWorks removeObject:self];
    [_session invalidateAndCancel];
    _session = nil;
    _downloadTask = nil;
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    _downloadProgress = totalBytesWritten*1.0 / totalBytesExpectedToWrite;
    if (_progress != nil ){
        [self DownloadMainQueue:^{
            _progress( totalBytesExpectedToWrite,totalBytesWritten);
        }];
    }
}

#pragma mark - NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_downloadData appendData:data];
    if (_downloadSize > 0) {
       [self DownloadMainQueue:^{
           _downloadProgress =  _downloadData.length*1.0/_downloadSize;
            if (_progress != nil) {
                _progress(_downloadSize,_downloadData.length);
            }
            if (_currentData  != nil) {
                _currentData(_downloadData);
            }
       }];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self DownloadMainQueue:^{
        if  (_closure != nil) {
            [[LIDownloadCache sharedInstance] data:_downloadData storageFileKeyWithURLString:_downloadUrlString];
            _closure(nil,_downloadData,nil);
        }
    }];
    _closure = nil;
    _progress = nil;
    _currentData = nil;
    [[LINetworkManager sharedInstance].netWorks removeObject:self];
    _URLConnection = nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //allHeaderFields
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse != nil ) {
        NSDictionary * httpResponseHeaderFields = httpResponse.allHeaderFields;
        _downloadSize = [httpResponseHeaderFields[@"Content-Length"]  longLongValue];
    }//获取文件文件的大小
}

@end

