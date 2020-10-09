//
//  XZCEasyTestExceptionViewContorller.m
//  ERP-System
//
//  Created by xzc on 2019/3/13.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import "XZCEasyTestExceptionViewContorller.h"
#import "XZCEasyTestExceptionManager.h"
#import "XZCEasyTestExceptionDetailViewController.h"

@interface XZCEasyTestExceptionViewContorller ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *requestTableView;

@property (nonatomic, strong) NSMutableArray *requestArray;

@end

@implementation XZCEasyTestExceptionViewContorller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"崩溃列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAllList)];
    self.requestArray = [NSMutableArray array];
    
    [self.view addSubview:self.requestTableView];
    [self checkAllList];
    // Do any additional setup after loading the view.
}

- (void)checkAllList{
    [[XZCEasyTestExceptionManager shareManager] queryAll:^(NSMutableArray * _Nonnull dataArray) {
        self.requestArray = [NSMutableArray arrayWithArray:dataArray];
        [self.requestTableView reloadData];
    }];
}


- (void)deleteAllList{
    [[XZCEasyTestExceptionManager shareManager]deleteAll:^{
        [self.requestArray removeAllObjects];
        [self.requestTableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"XZCRequestTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    XZCEasyTestExceptionModel *model = [self.requestArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.requestArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XZCEasyTestExceptionDetailViewController *vc = [[XZCEasyTestExceptionDetailViewController alloc]init];
    XZCEasyTestExceptionModel *model = [self.requestArray objectAtIndex:indexPath.row];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - init

- (UITableView *)requestTableView{
    if (nil == _requestTableView) {
        _requestTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _requestTableView.delegate = self;
        _requestTableView.dataSource = self;
        _requestTableView.tableFooterView = [UIView new];

    }
    return _requestTableView;
}


@end
