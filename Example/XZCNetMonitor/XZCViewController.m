//
//  XZCViewController.m
//  XZCNetMonitor
//
//  Created by 许智超 on 10/09/2020.
//  Copyright (c) 2020 许智超. All rights reserved.
//

#import "XZCViewController.h"

@interface XZCViewController ()

@end

@implementation XZCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self get];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)get {
    NSString *name = @"张三";
    NSString *pwd = @"zhang";
    NSString *strUrl = [NSString stringWithFormat:@"http://127.0.0.1/php/login.php?username=%@&password=%@", name, pwd];
    
    // 对汉字进行转义
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@", strUrl);
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
         if (connectionError) {
             NSLog(@"连接错误 %@", connectionError);
             return;
         }
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if (httpResponse.statusCode == 200 || httpResponse.statusCode == 304) {
             // 解析数据
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@", dict);
         } else {
             NSLog(@"服务器内部错误");
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
