//
//  XZCEasyTestTableViewController.h
//  ERP-System
//
//  Created by xzc on 2019/3/11.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZCServiceChoicePlugin.h"
#import "XZCEasyChoiceBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZCEasyTestTableViewController : XZCEasyChoiceBaseViewController


@property (nonatomic, copy) XZCServiceChangedUrlBlock serviceChangedBlock;

@property (nonatomic, copy) XZCServiceCurrenUrlBlock serviceCurrenBlock;


@property (nonatomic, copy) XZCServiceCurrenUrlBlock payServiceCurrenBlock;

@end

NS_ASSUME_NONNULL_END
