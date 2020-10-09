//
//  XZCEasyTestRuquestDetailViewController.m
//  ERP-System
//
//  Created by xzc on 2019/3/12.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import "XZCEasyTestRuquestDetailViewController.h"

@interface XZCEasyTestRuquestDetailViewController ()

@property (nonatomic, strong) UIScrollView *detailScrollView;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UITextView *detailTextView;

@end

@implementation XZCEasyTestRuquestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self setupUI];
    [self initPageData];
    // Do any additional setup after loading the view.
}

- (void)initPageData{
    self.detailTextView.text = [NSString stringWithFormat:@"url = %@\n\nmothod = %@\n\nhead = %@\n\nbody = %@\n\nresponse = %@\n",self.model.url, self.model.mothod, self.model.head, self.model.body, self.model.response];
//    self.detailLabel.text = self.model.response;
}

- (void)setupUI{
    [self.view addSubview:self.detailTextView];
//    [self.view addSubview:self.detailScrollView];
//    [self.detailScrollView addSubview:self.detailLabel];
//    [self.detailScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsZero);
//        make.centerX.mas_equalTo(self.view);
////        make.height.mas_greaterThanOrEqualTo(self.view.mas_height);
//    }];
//    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsMake(10, 15, 10, 15));
//        make.width.mas_equalTo(kScreenWidth - 30);
//
//    }];
    
}

- (UITextView *)detailTextView{
    if (nil == _detailTextView) {
        _detailTextView = [[UITextView alloc]initWithFrame:self.view.frame];
        _detailTextView.textColor = [UIColor darkGrayColor];;
    }
    return _detailTextView;
}

- (UILabel *)detailLabel{
    if (nil == _detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.numberOfLines = 0;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _detailLabel;
}

- (UIScrollView *)detailScrollView{
    if (nil == _detailScrollView) {
        _detailScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    }
    return _detailScrollView;
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
