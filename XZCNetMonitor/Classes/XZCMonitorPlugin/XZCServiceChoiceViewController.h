//
//  XZCServiceChoiceViewController.h
//  ERP-System
//
//  Created by xzc on 2018/12/27.
//  Copyright © 2018年 邵镭镭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZCServiceChoicePlugin.h"
#import "XZCEasyChoiceBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZCServiceChoiceViewController : XZCEasyChoiceBaseViewController

//@property (nonatomic, copy) NSString *nowService;

@property (nonatomic, copy) XZCServiceChangedUrlBlock serviceChangedBlock;

@property (nonatomic, copy) XZCServiceCurrenUrlBlock serviceCurrenBlock;

@property (nonatomic, copy) XZCServiceCurrenUrlBlock payServiceCurrenBlock;

@end

NS_ASSUME_NONNULL_END
