//
//  XZCServiceChoicePlugin.h
//  ERP-System
//
//  Created by xzc on 2018/12/27.
//  Copyright © 2018年 邵镭镭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XZCServiceChangedUrlBlock)(NSString *serviceUrl, NSString *payServiceUrl, NSString *imageServiceUrl);

typedef NSString *(^XZCServiceCurrenUrlBlock)(void);

@interface XZCServiceChoicePlugin : NSObject

//@property (nonatomic, stro

+ (XZCServiceChoicePlugin *)shareInstance;

- (void)startServiceChoiceCurrenServiceUrl:(XZCServiceCurrenUrlBlock)serviceCurrenBlock currenPayServiceUrl:(XZCServiceCurrenUrlBlock)payServiceCurenBlock choiceServiceBlock:(XZCServiceChangedUrlBlock)serviceChangedBlock;

@end

NS_ASSUME_NONNULL_END
