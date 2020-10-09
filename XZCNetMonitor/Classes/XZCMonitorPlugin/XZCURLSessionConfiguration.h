//
//  XZCURLSessionConfiguration.h
//  ERP-System
//
//  Created by xzc on 2019/3/5.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZCURLSessionConfiguration : NSURLSessionConfiguration

@property (nonatomic, assign) BOOL isSwizzle;

+ (XZCURLSessionConfiguration *)defaultConfiguration;

- (void)load;

- (void)unload;

@end

NS_ASSUME_NONNULL_END
