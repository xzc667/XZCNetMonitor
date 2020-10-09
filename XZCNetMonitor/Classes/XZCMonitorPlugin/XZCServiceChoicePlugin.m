//
//  XZCServiceChoicePlugin.m
//  ERP-System
//
//  Created by xzc on 2018/12/27.
//  Copyright © 2018年 邵镭镭. All rights reserved.
//

#import "XZCServiceChoicePlugin.h"
#import "XZCServiceChoiceIconView.h"
#import "XZCServiceChoiceViewController.h"
#import "XZCURLProtocol.h"
#import "XZCEasyTestTableViewController.h"
#import "XZCEasyTestExceptionManager.h"

@interface XZCServiceChoicePlugin ()

@property (nonatomic, strong) XZCServiceChoiceIconView *serviceChoiceIconView;

@property (nonatomic, copy) XZCServiceChangedUrlBlock serviceChangedBlock;

@property (nonatomic, copy) XZCServiceCurrenUrlBlock serviceCurrenBlock;


@property (nonatomic, copy) XZCServiceCurrenUrlBlock payServiceCurrenBlock;

@property (nonatomic, copy) NSString *currenServiceUrl;

@end

@implementation XZCServiceChoicePlugin

+ (XZCServiceChoicePlugin *)shareInstance{
    static XZCServiceChoicePlugin *choicePlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        choicePlugin = [[XZCServiceChoicePlugin alloc]init];
    });
    return choicePlugin;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"rootViewController"]) {
        
        [self bringChoiceViewToFront];
    }
}

- (void)startServiceChoiceCurrenServiceUrl:(XZCServiceCurrenUrlBlock)serviceCurrenBlock currenPayServiceUrl:(XZCServiceCurrenUrlBlock)payServiceCurenBlock choiceServiceBlock:(XZCServiceChangedUrlBlock)serviceChangedBlock{
    self.serviceChangedBlock = serviceChangedBlock;
    self.serviceCurrenBlock = serviceCurrenBlock;
    self.payServiceCurrenBlock = payServiceCurenBlock;
    [XZCURLProtocol startMonitor];
    [XZCEasyTestExceptionManager startException];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak typeof(self)weakSelf = self;
    self.serviceChoiceIconView.clickIconBlock = ^{
        [weakSelf clickModifyService];
    };
    [window addSubview:self.serviceChoiceIconView];
    
    [window addObserver:self forKeyPath:@"rootViewController" options:NSKeyValueObservingOptionNew context:nil];
    
    [window bringSubviewToFront:self.serviceChoiceIconView];
    

}

- (void)clickModifyService{
    //    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[self getCurrentVC]];
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *viewcontroller = [UIViewController new];
    if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBar = (UITabBarController *)window.rootViewController;
        if ([tabBar.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav1 = tabBar.selectedViewController;
            viewcontroller = nav1.visibleViewController;
        }
        else{
            viewcontroller = tabBar.selectedViewController;
        }
    }
    else if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav1 = (UINavigationController *)window.rootViewController;
        viewcontroller = nav1.visibleViewController;
    }
    else{
        viewcontroller = window.rootViewController;
    }
    //    UITabBarController *tabBar = (UITabBarController *)window.rootViewController;
    //    UINavigationController *nav1 = tabBar.selectedViewController;
    //    UIViewController *viewcontroller = nav1.visibleViewController;
    if ([viewcontroller isKindOfClass:[XZCEasyChoiceBaseViewController class]]) {
        return;
    }
    //    NSLog(@"ddd%@", nav1.visibleViewController.title);
    XZCEasyTestTableViewController *testViewControlelr = [[XZCEasyTestTableViewController alloc]init];
    testViewControlelr.serviceCurrenBlock  = self.serviceCurrenBlock;
    testViewControlelr.serviceChangedBlock = self.serviceChangedBlock;
    testViewControlelr.payServiceCurrenBlock = self.payServiceCurrenBlock;
    if (viewcontroller.navigationController == nil) {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:testViewControlelr];
        [viewcontroller presentViewController:nav animated:YES completion:nil];
    }
    else{
        [viewcontroller.navigationController pushViewController:testViewControlelr animated:YES];
    }
}


- (XZCServiceChoiceIconView *)serviceChoiceIconView{
    if (nil == _serviceChoiceIconView) {
        _serviceChoiceIconView = [[XZCServiceChoiceIconView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 70, 60, 60)];
        _serviceChoiceIconView.layer.cornerRadius = 10;
        _serviceChoiceIconView.layer.masksToBounds = YES;
        
    }
    return _serviceChoiceIconView;
}

- (void)bringChoiceViewToFront{
    UIWindow *window2 = [UIApplication sharedApplication].keyWindow;
    
    [window2 bringSubviewToFront:self.serviceChoiceIconView];
}


@end
