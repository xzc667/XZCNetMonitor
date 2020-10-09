//
//  XZCEasyTestExceptionManager.h
//  ERP-System
//
//  Created by xzc on 2019/3/13.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XZCEasyTestExceptionModel;

@interface XZCEasyTestExceptionManager : NSObject

+ (void)startException;

+ (instancetype)shareManager;

- (void)queryAll:(void(^)(NSMutableArray *dataArray))dataBlock;

- (void)deleteAll:(void (^)(void))dataBlock;

@end

@interface XZCEasyTestExceptionModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, copy) NSString *detail;

@end

NS_ASSUME_NONNULL_END
