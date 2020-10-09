//
//  XZCEasyTestTableViewController.m
//  ERP-System
//
//  Created by xzc on 2019/3/11.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import "XZCEasyTestTableViewController.h"
#import "XZCServiceChoiceViewController.h"
#import "XZCRequestTableViewController.h"
#import "XZCEasyTestExceptionViewContorller.h"

@interface XZCEasyTestTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UITableView *choiceTableView;

@end

@implementation XZCEasyTestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能列表";
    self.titleArray = @[@"网络日志", @"崩溃日志"];
    [self.view addSubview:self.choiceTableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZCEasyTestTableViewCell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XZCEasyTestTableViewCell"];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 0) {
//        XZCServiceChoiceViewController *testViewControlelr = [[XZCServiceChoiceViewController alloc]init];
//        testViewControlelr.serviceCurrenBlock  = self.serviceCurrenBlock;
//        testViewControlelr.serviceChangedBlock = self.serviceChangedBlock;
//        testViewControlelr.payServiceCurrenBlock = self.payServiceCurrenBlock;
//        [self.navigationController pushViewController:testViewControlelr animated:YES];
//    }
//    else
        if (indexPath.row == 0){
        XZCRequestTableViewController *vc = [[XZCRequestTableViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1){
        XZCEasyTestExceptionViewContorller *vc = [[XZCEasyTestExceptionViewContorller alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableView *)choiceTableView{
    if (nil == _choiceTableView) {
        _choiceTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _choiceTableView.delegate = self;
        _choiceTableView.dataSource = self;
        _choiceTableView.tableFooterView = [UIView new];
    }
    return _choiceTableView;
}

@end
