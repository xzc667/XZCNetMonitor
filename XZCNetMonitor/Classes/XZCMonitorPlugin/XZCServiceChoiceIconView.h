//
//  XZCServiceChoiceIconView.h
//  ERP-System
//
//  Created by xzc on 2018/12/27.
//  Copyright © 2018年 邵镭镭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZCServiceChoiceIconView : UIView

@property (nonatomic, copy) void (^clickIconBlock)(void);

@end

NS_ASSUME_NONNULL_END
