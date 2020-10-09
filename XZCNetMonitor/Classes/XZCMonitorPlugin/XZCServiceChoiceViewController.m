//
//  XZCServiceChoiceViewController.m
//  ERP-System
//
//  Created by xzc on 2018/12/27.
//  Copyright © 2018年 邵镭镭. All rights reserved.
//

#import "XZCServiceChoiceViewController.h"
#import "XZCServiceChoiceModel.h"
#import <YYModel/YYModel.h>

#define XZCSericeChoiceLocalCacheAddress        @"XZCSericeChoiceLocalCacheAddress"

@interface XZCServiceChoiceViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *serviceTextField;

@property (nonatomic, strong) UITextField *payOrderServiceTextField;

@property (nonatomic, strong) UITextField *imageServiceTextField;

@property (nonatomic, strong) NSMutableArray *serviceArray;


@property (nonatomic, assign) NSInteger selectSegmentIndex;

@end

@implementation XZCServiceChoiceViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择环境";
        NSArray *titleArray = @[@"正式", @"开发", @"测试"];
    NSArray *urlArray = @[@"http://47.96.93.183/api", @"http://172.17.156.12:3001", @"http://172.17.156.23:3001"];
    NSArray *payOrderUrlArray = @[@"http://47.96.93.183/api/pay/pay/order", @"http://172.17.156.12:6501/pay/order", @"http://172.17.156.23:6501/pay/order"];
    NSArray *imageUrlArray = @[@"http://47.96.93.183/file", @"http://172.17.156.13:8888", @"http://172.17.156.13:8888"];
    
    self.serviceArray = [NSMutableArray array];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *cacheArray = [userDefaults objectForKey:XZCSericeChoiceLocalCacheAddress];
    if (cacheArray != nil) {
        NSInteger i = 0;
        for (NSDictionary *serviceDict in cacheArray) {
            XZCServiceChoiceModel *model = [XZCServiceChoiceModel yy_modelWithJSON:serviceDict];
            if (model.imageServiceUrl == nil) {
                
                model.imageServiceUrl = imageUrlArray[i];
                
            }
            i++;
            [self.serviceArray addObject:model];
        }
    }
    else{
        for (NSInteger i = 0; i < titleArray.count && i < urlArray.count; i++) {
            XZCServiceChoiceModel *model = [[XZCServiceChoiceModel alloc]init];
            model.title = titleArray[i];
            model.serviceUrl = urlArray[i];
            model.payOrderServiceUrl = payOrderUrlArray[i];
            model.imageServiceUrl = imageUrlArray[i];
            [self.serviceArray addObject:model];
        }
    }
    
    //
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, [UIApplication sharedApplication].statusBarFrame.size.height + 40, [UIScreen mainScreen].bounds.size.width - 30, 60)];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.textColor = [UIColor redColor];
    if (self.serviceCurrenBlock) {
        label.text = [NSString stringWithFormat:@"当前环境：%@\n支付环境：%@", self.serviceCurrenBlock(), self.payServiceCurrenBlock()];
    }
    else{
        label.text = @"环境出错了";
    }
    [self.view addSubview:label];
    
    UILabel *makeTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, label.frame.origin.y + 40, [UIScreen mainScreen].bounds.size.width - 30, 30)];
    makeTimeLabel.font = [UIFont systemFontOfSize:14];
    makeTimeLabel.numberOfLines = 0;
    makeTimeLabel.textColor = [UIColor redColor];
    [self.view addSubview:makeTimeLabel];
    NSDictionary *infoPlistDictionary = [[NSBundle mainBundle] infoDictionary];
    if([[infoPlistDictionary allKeys] containsObject:@"CFBundleVersion"]){
        makeTimeLabel.text=[@"创建时间：" stringByAppendingString:[infoPlistDictionary objectForKey:@"CFBundleVersion"]];
    }else{
        makeTimeLabel.text=@"创建时间：";
    }
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"正式", @"开发", @"测试"]];
    segment.frame = CGRectMake(15, makeTimeLabel.frame.origin.y + 50, [UIScreen mainScreen].bounds.size.width - 30 , 36);
    segment.tintColor = [UIColor redColor];
    NSDictionary * textAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [segment setTitleTextAttributes:textAttr forState:UIControlStateSelected];
    [segment addTarget:self action:@selector(segmentSelectSender:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    
    self.serviceTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, segment.frame.origin.y + 60, [UIScreen mainScreen].bounds.size.width - 30, 40)];
    self.serviceTextField.font = [UIFont systemFontOfSize:16];
    self.serviceTextField.delegate = self;
    self.serviceTextField.placeholder = @"请输入服务器地址";
    self.serviceTextField.layer.cornerRadius = 5;
    self.serviceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.serviceTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.serviceTextField.layer.borderWidth = 0.5;
    self.serviceTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,10,30)];
//    self.serviceTextField.leftView=searchImage;
    self.serviceTextField.leftViewMode=UITextFieldViewModeAlways; //标志一直会存在
    [self.view addSubview:self.serviceTextField];
    
    
    self.payOrderServiceTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, self.serviceTextField.frame.origin.y + 60, [UIScreen mainScreen].bounds.size.width - 30, 40)];
    self.payOrderServiceTextField.font = [UIFont systemFontOfSize:16];
    self.payOrderServiceTextField.delegate = self;
    self.payOrderServiceTextField.placeholder = @"请输入支付二维码服务器地址";
    self.payOrderServiceTextField.layer.cornerRadius = 5;
    self.payOrderServiceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.payOrderServiceTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.payOrderServiceTextField.layer.borderWidth = 0.5;
    self.payOrderServiceTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,10,30)];
    //    self.serviceTextField.leftView=searchImage;
    self.payOrderServiceTextField.leftViewMode=UITextFieldViewModeAlways; //标志一直会存在
    [self.view addSubview:self.payOrderServiceTextField];
    
    self.imageServiceTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, self.payOrderServiceTextField.frame.origin.y + 60, [UIScreen mainScreen].bounds.size.width - 30, 40)];
    self.imageServiceTextField.font = [UIFont systemFontOfSize:16];
    self.imageServiceTextField.delegate = self;
    self.imageServiceTextField.placeholder = @"请输入图片服务器地址";
    self.imageServiceTextField.layer.cornerRadius = 5;
    self.imageServiceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.imageServiceTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageServiceTextField.layer.borderWidth = 0.5;
    self.imageServiceTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,10,30)];
    //    self.serviceTextField.leftView=searchImage;
    self.imageServiceTextField.leftViewMode=UITextFieldViewModeAlways; //标志一直会存在
    [self.view addSubview:self.imageServiceTextField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame=  CGRectMake(15, self.imageServiceTextField.frame.origin.y + 80, [UIScreen mainScreen].bounds.size.width - 30, 44);
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(submitServiceUrl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
        UILabel *promtLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, button.frame.origin.y + 55, [UIScreen mainScreen].bounds.size.width - 30, 40)];
        promtLabel.font = [UIFont systemFontOfSize:12];
        promtLabel.textColor = [UIColor orangeColor];
        promtLabel.numberOfLines = 0;
        promtLabel.text = @"*警告：切换服务器后请退出登录";
        [self.view addSubview:promtLabel];
    
    //初始化_textfield
    
    segment.selectedSegmentIndex = 0;
    [self segmentSelectIndex:0];
//    if (_serviceUrlArray.count > 0) {
//        _serviceTextField.text = _serviceUrlArray[0];
//    }
//    if (_htmlServiceUrlArray.count > 0) {
//        _htmlServiceTextField.text = _htmlServiceUrlArray[0];
//    }
    // Do any additional setup after loading the view.
}


#pragma mark - 选择服务器
- (void)segmentSelectSender:(UISegmentedControl *)segment{
    [self segmentSelectIndex:segment.selectedSegmentIndex];
}

- (void)segmentSelectIndex:(NSInteger)index{
    self.selectSegmentIndex = index;
    XZCServiceChoiceModel *model = [self.serviceArray objectAtIndex:index];
    self.serviceTextField.text= model.serviceUrl;
    self.payOrderServiceTextField.text = model.payOrderServiceUrl;
    self.imageServiceTextField.text = model.imageServiceUrl;
}


#pragma mark - 确定
- (void)submitServiceUrl{
    XZCServiceChoiceModel *model = [self.serviceArray objectAtIndex:self.selectSegmentIndex];
    model.serviceUrl = self.serviceTextField.text;
    model.payOrderServiceUrl = self.payOrderServiceTextField.text;
    model.imageServiceUrl = self.imageServiceTextField.text;
    NSArray *array = [self.serviceArray yy_modelToJSONObject];
    
    NSLog(@"array = %@", array);
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:XZCSericeChoiceLocalCacheAddress];
    if (self.serviceChangedBlock) {
        self.serviceChangedBlock(self.serviceTextField.text, self.payOrderServiceTextField.text, self.imageServiceTextField.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    //    [self submitServiceUrl];
    return YES;
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
