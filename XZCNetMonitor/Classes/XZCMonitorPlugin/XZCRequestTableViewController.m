//
//  XZCRequestTableViewController.m
//  ERP-System
//
//  Created by xzc on 2019/3/11.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import "XZCRequestTableViewController.h"
#import "XZCEasyTestRequestManager.h"
#import "XZCEasyTestRuquestDetailViewController.h"

#import <FMDB/FMDB.h>

@interface XZCRequestTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *requestTableView;

@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;

@property (nonatomic, strong) NSMutableArray *requestArray;

@end

@implementation XZCRequestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请求列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAllList)];
    self.requestArray = [NSMutableArray array];
    
    [self.view addSubview:self.requestTableView];
    [self checkAllList];
    // Do any additional setup after loading the view.
}

- (void)checkAllList{
    [[XZCEasyTestRequestManager shareManager] queryAll:^(NSMutableArray * _Nonnull dataArray) {
        self.requestArray = [NSMutableArray arrayWithArray:dataArray];
        [self.requestTableView reloadData];
    }];
}


- (void)deleteAllList{
    [[XZCEasyTestRequestManager shareManager]deleteAll:^{
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
    XZCEasyTestRequestModel *model = [self.requestArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.url;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.requestArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XZCEasyTestRuquestDetailViewController *vc = [[XZCEasyTestRuquestDetailViewController alloc]init];
    XZCEasyTestRequestModel *model = [self.requestArray objectAtIndex:indexPath.row];
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
