//
//  XZCEasyChoiceBaseViewController.m
//  ERP-System
//
//  Created by xzc on 2019/3/11.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import "XZCEasyChoiceBaseViewController.h"

@interface XZCEasyChoiceBaseViewController ()

@end

@implementation XZCEasyChoiceBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}


//支持旋转
-(BOOL)shouldAutorotate{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
