//
//  XZCEasyTestExceptionDetailViewController.m
//  ERP-System
//
//  Created by xzc on 2019/3/13.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import "XZCEasyTestExceptionDetailViewController.h"
#import <Masonry/Masonry.h>

@interface XZCEasyTestExceptionDetailViewController ()



@property (nonatomic, strong) UIScrollView *detailScrollView;

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation XZCEasyTestExceptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self setupUI];
    [self initPageData];
    // Do any additional setup after loading the view.
}

- (void)initPageData{
    self.detailLabel.text = [NSString stringWithFormat:@"name = %@\nreason = %@\ndetail = %@\n",self.model.name, self.model.reason, self.model.detail];
}

- (void)setupUI{
    
    [self.view addSubview:self.detailScrollView];
    [self.detailScrollView addSubview:self.detailLabel];
    [self.detailScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
        make.centerX.mas_equalTo(self.view);
        //        make.height.mas_greaterThanOrEqualTo(self.view.mas_height);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(10, 15, 10, 15));
        make.width.mas_lessThanOrEqualTo([UIScreen mainScreen].bounds.size.width - 30);
    }];
    
}

- (UILabel *)detailLabel{
    if (nil == _detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIScrollView *)detailScrollView{
    if (nil == _detailScrollView) {
        _detailScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    }
    return _detailScrollView;
}
@end
