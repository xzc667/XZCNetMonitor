//
//  XZCEasyTestRequestManager.h
//  ERP-System
//
//  Created by xzc on 2019/3/12.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XZCEasyTestRequestModel;

@interface XZCEasyTestRequestManager : NSObject

+ (instancetype)shareManager;

- (void)saveDataBaseWithUrl:(NSString *)url mothod:(NSString *)mothod head:(NSDictionary *)headDict body:(NSData *)body response:(NSString *)response;

- (void)queryAll:(void(^)(NSMutableArray *dataArray))dataBlock;

- (void)deleteAll:(void(^)(void))dataBlock;

@end



@interface XZCEasyTestRequestModel : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *mothod;

@property (nonatomic, copy) NSString *head;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *response;

@end

NS_ASSUME_NONNULL_END
