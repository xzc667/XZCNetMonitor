//
//  XZCURLProtocol.m
//  ERP-System
//
//  Created by xzc on 2019/3/5.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import "XZCURLProtocol.h"
#import "XZCURLSessionConfiguration.h"
#import "XZCEasyTestRequestManager.h"


static NSString* const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface XZCURLProtocol ()

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSURLResponse *response;

@property (nonatomic, strong) NSMutableData *receiveData;


@end

@implementation XZCURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    //避免死循环
    if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    if ([request.URL.scheme isEqualToString:@"http"]
        || [request.URL.scheme isEqualToString:@"https"]) {
        return YES;
    }
    return NO;
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    //标记一下，避免死循环

//
    [NSURLProtocol setProperty:@YES
                        forKey:URLProtocolHandledKey
                     inRequest:mutableReqeust];
    return [self cyl_getPostRequestIncludeBody:mutableReqeust];

//    return [mutableReqeust copy];
}
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

+ (NSURLRequest *)cyl_getPostRequestIncludeBody:(NSURLRequest *)request {
    return [[self cyl_getMutablePostRequestIncludeBody:request] copy];
}

+ (NSMutableURLRequest *)cyl_getMutablePostRequestIncludeBody:(NSURLRequest *)request {
    NSMutableURLRequest * req = [request mutableCopy];
    if ([request.HTTPMethod isEqualToString:@"POST"]||[request.HTTPMethod isEqualToString:@"PUT"]) {
        if (!request.HTTPBody) {
            NSInteger maxLength = 1024;
            uint8_t d[maxLength];
            NSInputStream *stream = request.HTTPBodyStream;
            NSMutableData *data = [[NSMutableData alloc] init];
            [stream open];
            BOOL endOfStreamReached = NO;
            //不能用 [stream hasBytesAvailable]) 判断，处理图片文件的时候这里的[stream hasBytesAvailable]会始终返回YES，导致在while里面死循环。
            while (!endOfStreamReached) {
                NSInteger bytesRead = [stream read:d maxLength:maxLength];
                if (bytesRead == 0) { //文件读取到最后
                    endOfStreamReached = YES;
                } else if (bytesRead == -1) { //文件读取错误
                    endOfStreamReached = YES;
                } else if (stream.streamError == nil) {
                    [data appendBytes:(void *)d length:bytesRead];
                }
            }
            req.HTTPBody = [data copy];
            [stream close];
        }

    }
    return req;
}

// 重新父类的开始加载方法
- (void)startLoading {
//    NSLog(@"***XZC 监听接口：%@", self.request.URL.absoluteString);
    
    
    NSURLSessionConfiguration *configuration =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.sessionDelegateQueue = [[NSOperationQueue alloc] init];
    self.sessionDelegateQueue.maxConcurrentOperationCount = 1;
    self.sessionDelegateQueue.name = @"com.hujiang.wedjat.session.queue";
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:configuration
                                  delegate:self
                             delegateQueue:self.sessionDelegateQueue];
    
    
    self.dataTask = [session dataTaskWithRequest:self.request];
    NSError *error = nil;

    [self.dataTask resume];
}
//结束加载
- (void)stopLoading {
    [self.dataTask cancel];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        [self.client URLProtocolDidFinishLoading:self];
        id dataDict = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONReadingAllowFragments error:&error];
        //    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (dataDict) {
            [[XZCEasyTestRequestManager shareManager] saveDataBaseWithUrl:task.originalRequest.URL.absoluteString mothod:task.originalRequest.HTTPMethod head:task.originalRequest.allHTTPHeaderFields body:task.originalRequest.HTTPBody response:[self convertToJsonData:dataDict]];
        }
        else{
            NSString *dataStr = [[NSString alloc] initWithData:self.receiveData encoding:NSUTF8StringEncoding];
            [[XZCEasyTestRequestManager shareManager] saveDataBaseWithUrl:task.originalRequest.URL.absoluteString mothod:task.originalRequest.HTTPMethod head:task.originalRequest.allHTTPHeaderFields body:task.originalRequest.HTTPBody response:dataStr];
            
        }
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
        
    } else {
        [self.client URLProtocol:self didFailWithError:error];
        [[XZCEasyTestRequestManager shareManager] saveDataBaseWithUrl:task.originalRequest.URL.absoluteString mothod:task.originalRequest.HTTPMethod head:task.originalRequest.allHTTPHeaderFields body:task.originalRequest.HTTPBody response:error.localizedDescription];
    }
    self.dataTask = nil;
}

#pragma mark - NSURLSessionDataDelegate

// 当服务端返回信息时，这个回调函数会被ULS调用，在这里实现http返回信息的截
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    // 返回给URL Loading System接收到的数据，这个很重要，不然光截取不返回，就瞎了。
    [self.client URLProtocol:self didLoadData:data];
    [self.receiveData appendData:data];
//    NSURL *ddurl = dataTask.originalRequest.URL;
    NSError *error = nil;
    // 打印返回数据
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
    self.response = response;
    self.receiveData = [NSMutableData data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    if (response != nil){
        self.response = response;
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
}

/// 开始监听
+ (void)startMonitor {
    [XZCEasyTestRequestManager shareManager];
    XZCURLSessionConfiguration *sessionConfiguration = [XZCURLSessionConfiguration defaultConfiguration];
    [NSURLProtocol registerClass:[XZCURLProtocol class]];
    if (![sessionConfiguration isSwizzle]) {
        [sessionConfiguration load];
    }
}

/// 停止监听
+ (void)stopMonitor {
    XZCURLSessionConfiguration *sessionConfiguration = [XZCURLSessionConfiguration defaultConfiguration];
    [NSURLProtocol unregisterClass:[XZCURLProtocol class]];
    if ([sessionConfiguration isSwizzle]) {
        [sessionConfiguration unload];
    }
}


-(NSString *)convertToJsonData:(id)dict

{
    
    NSError *error;
    
    NSData *jsonData = nil;
    if (dict != nil && ([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSArray class]])) {
        jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    return jsonString;
    
}

@end
