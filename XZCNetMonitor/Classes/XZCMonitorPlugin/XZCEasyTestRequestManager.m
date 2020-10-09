//
//  XZCEasyTestRequestManager.m
//  ERP-System
//
//  Created by xzc on 2019/3/12.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import "XZCEasyTestRequestManager.h"
#import <FMDB/FMDB.h>

@interface XZCEasyTestRequestManager ()

@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;

//@property (nonatomic, strong)

@end

@implementation XZCEasyTestRequestManager

+ (instancetype)shareManager{
    static XZCEasyTestRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XZCEasyTestRequestManager alloc]init];
    });
    return manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createDataBaseIfNotExist];
    }
    return self;
}

- (void)createDataBaseIfNotExist{
    
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path=[path stringByAppendingPathComponent:@"requestData.sqlite"];
    
    self.dataBaseQueue=[FMDatabaseQueue databaseQueueWithPath:path];
   
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString * create=@"create table if not exists t_requestData(id integer Primary Key Autoincrement,url TEXT,mothod TEXT,head TEXT,body TEXT,response TEXT)";
        BOOL c1= [db executeUpdate:create];
//        if(c1){
//            NSLog(@"创建表成功");
//        }
        
    }];
}

- (void)saveDataBaseWithUrl:(NSString *)url mothod:(NSString *)mothod head:(NSDictionary *)headDict body:(NSData *)body response:(NSString *)response{
    NSError *error = nil;
    NSString *bodyString = body?[NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:&error]:@"body is none";
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString * insertSql=@"insert into t_requestData(url,mothod,head,body,response) values(?,?,?,?,?)";
        
        //插入语句1
        bool inflag=[db executeUpdate:insertSql,url,mothod,[self convertToJsonData:headDict],bodyString,response];
//        if(inflag){
//            NSLog(@"插入成功");
//        }
        
    }];
}

// 查询所有数据
- (void)queryAll:(void(^)(NSMutableArray *dataArray))dataBlock{
    
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select * from t_requestData order by id desc";
        
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:nil];
        NSMutableArray *array = [NSMutableArray array];
        while (resultSet.next) {
            XZCEasyTestRequestModel *model = [[XZCEasyTestRequestModel alloc]init];
            model.url = [resultSet stringForColumn:@"url"];
            model.mothod = [resultSet stringForColumn:@"mothod"];
            model.head = [resultSet stringForColumn:@"head"];
            model.body = [resultSet stringForColumn:@"body"];
            model.response = [resultSet stringForColumn:@"response"];
            [array addObject:model];
        }
        dataBlock(array);
    }];
}

- (void)deleteAll:(void (^)(void))dataBlock{
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"delete from t_requestData";
        BOOL c1= [db executeUpdate:sql];
        if(c1){
            NSLog(@"删除成功");
        }
        dataBlock();
    }];
}


-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = nil;
    if (dict != nil) {
        jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    }
    else{
        NSLog(@"==================easyRequest dict is nil==============");
    }
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    return jsonString;
    
}

@end



@implementation XZCEasyTestRequestModel



@end
