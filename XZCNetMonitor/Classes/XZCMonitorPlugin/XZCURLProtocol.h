//
//  XZCURLProtocol.h
//  ERP-System
//
//  Created by xzc on 2019/3/5.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface XZCURLProtocol : NSURLProtocol<NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLRequest *myRequest;

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSOperationQueue *sessionDelegateQueue;

+ (void)startMonitor;


@end




NS_ASSUME_NONNULL_END
