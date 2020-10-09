//
//  XZCEasyTestExceptionManager.m
//  ERP-System
//
//  Created by xzc on 2019/3/13.
//  Copyright © 2019年 邵镭镭. All rights reserved.
//

#import "XZCEasyTestExceptionManager.h"
#import <FMDB/FMDB.h>

#define kExceptionUserDefault [NSUserDefaults standardUserDefaults]
#define kExceptionCache     @"kExceptionLocationCache"
@interface XZCEasyTestExceptionManager()

@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;


@end

@implementation XZCEasyTestExceptionManager

+ (void)startException{
//    [self uploadException];
    [XZCEasyTestExceptionManager shareManager];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}


//todo : 从后台激活，冷却超过15分钟就重新刷新首页
void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    [[XZCEasyTestExceptionManager shareManager] saveDataBaseWithName:name reason:reason detail:[callStack componentsJoinedByString:@"\n"]];
//    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
//    NSLog(@"content= %@", content);
//    [XZCEasyTestExceptionManager saveException:[NSDictionary dictionaryWithObjectsAndKeys:content, @"content", nil]];
}

+ (instancetype)shareManager{
    static XZCEasyTestExceptionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XZCEasyTestExceptionManager alloc]init];
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
        NSString * create=@"create table if not exists t_exceptionData(id integer Primary Key Autoincrement,name TEXT,reason TEXT,detail TEXT)";
        BOOL c1= [db executeUpdate:create];
        if(c1){
            NSLog(@"创建表成功");
        }
        
    }];
}

- (void)saveDataBaseWithName:(NSString *)name reason:(NSString *)reason detail:(NSString *)detail{
    NSError *error = nil;
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString * insertSql=@"insert into t_exceptionData(name,reason,detail) values(?,?,?)";
        
        //插入语句1
        bool inflag=[db executeUpdate:insertSql,name,reason,detail];
        if(inflag){
            NSLog(@"插入成功");
        }
        
    }];
}

// 查询所有数据
- (void)queryAll:(void(^)(NSMutableArray *dataArray))dataBlock{
    
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select * from t_exceptionData order by id desc";
        
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:nil];
        NSMutableArray *array = [NSMutableArray array];
        while (resultSet.next) {
            XZCEasyTestExceptionModel *model = [[XZCEasyTestExceptionModel alloc]init];
            model.name = [resultSet stringForColumn:@"name"];
            model.reason = [resultSet stringForColumn:@"reason"];
            model.detail = [resultSet stringForColumn:@"detail"];
            [array addObject:model];
        }
        dataBlock(array);
    }];
}

- (void)deleteAll:(void (^)(void))dataBlock{
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"delete from t_exceptionData";
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
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    return jsonString;
    
}




+ (void)saveException:(NSDictionary *)dict{
    [kExceptionUserDefault setObject:dict forKey:kExceptionCache];
}

+ (void)uploadException{
    NSDictionary *uploadDict = [self getExceptionDict];
    if (uploadDict != nil) {
        //        NSLog(@"lastException = %@", uploadDict);
        
        //        NSLog(@"=============");
        //        NSLog(@"content = %@", uploadDict[@"content"]);
        //post
        //上传完成delete
        // post  {...delete...}
    }
}

+ (void)deleteException{
    [kExceptionUserDefault removeObjectForKey:kExceptionCache];
}

+ (NSDictionary *)getExceptionDict{
    NSDictionary *dict = [kExceptionUserDefault objectForKey:kExceptionCache];
    return dict;
}

@end

@implementation XZCEasyTestExceptionModel



@end
