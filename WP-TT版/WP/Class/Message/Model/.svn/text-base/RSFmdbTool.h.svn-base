//
//  RSFmdbTool.h
//  WP
//
//  Created by 沈亮亮 on 15/12/16.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class RSChatMessageModel;
@interface RSFmdbTool : NSObject

/**
 *  插入数据
 *
 *  @param model 插入的数据
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertModel:(RSChatMessageModel *)model;

/**
 *  条件查询
 *
 *  @param querySql 查询条件
 *
 *  @return 查询结果
 */
+ (NSArray *)queryData:(NSString *)querySql;

/**
 *  删除数据
 *
 *  @param deleteSql 需要删除哪一条
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/**
 *  修改数据
 *
 *  @param modifySql 修改那一条
 *
 *  @return 是否修改成功
 */
+ (BOOL)modifyData:(NSString *)modifySql;

@end
