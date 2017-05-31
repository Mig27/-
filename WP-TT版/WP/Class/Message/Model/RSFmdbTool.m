//
//  RSFmdbTool.m
//  WP
//
//  Created by 沈亮亮 on 15/12/16.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "RSFmdbTool.h"
#import "RSChatMessageModel.h"

#define RSSQLITE_NAME @"modals.sqlite"
@implementation RSFmdbTool

static FMDatabase *_fmdb;

+ (void)initialize{
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:RSSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_modals(id INTEGER PRIMARY KEY, time TEXT NOT NULL, detail TEXT NOT NULL, avatar TEXT NOT NULL, name TEXT NOT NULL, type INTEGER NOT NULL, amount INTEGER NOT NULL, ID_No INTEGER NOT NULL ,login_ID INTEGER NOT NULL ,timestamp INTEGER NOT NULL);"];

}

#pragma mark - 插入
+ (BOOL)insertModel:(RSChatMessageModel *)model
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_modals(time, detail, avatar, name, type, amount, ID_No ,login_ID ,timestamp) VALUES ('%@', '%@', '%@', '%@', '%zd', '%zd', '%zd', '%zd', '%zd');", model.meaageTime, model.messageDetail, model.avatarUrl, model.avatarName, model.messageType, model.noReadCount, model.messageID ,model.loginID ,model.timestamp];
    return [_fmdb executeUpdate:insertSql];
}

#pragma mark - 查询
+ (NSArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM t_modals;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *time = [set stringForColumn:@"time"];
        NSString *detail = [set stringForColumn:@"detail"];
        NSString *avatar = [set stringForColumn:@"avatar"];
        NSString *name = [set stringForColumn:@"name"];
        NSString *type = [set stringForColumn:@"type"];
        NSString *amount = [set stringForColumn:@"amount"];
        NSString *ID_No = [set stringForColumn:@"ID_No"];
        NSString *login_ID = [set stringForColumn:@"login_ID"];
        NSString *timestamp = [set stringForColumn:@"timestamp"];
        
        RSChatMessageModel *modal = [RSChatMessageModel modelwithName:name avatar:avatar no:ID_No.integerValue type:type.integerValue detail:detail time:time noReadCount:amount.integerValue loginID:login_ID.integerValue timestamp:timestamp.integerValue];
        [arrM addObject:modal];
    }
    return arrM;
}

#pragma mark - 删除
+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM t_modals";
    }
    
    return [_fmdb executeUpdate:deleteSql];
    
}

#pragma mark - 修改
+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql == nil) {
        modifySql = @"UPDATE t_modals SET name = '我是测试用的小鸟' WHERE ID_No = '93'";
    }
    
    return [_fmdb executeUpdate:modifySql];
}


@end
