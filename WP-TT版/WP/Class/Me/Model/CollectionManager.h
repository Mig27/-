//
//  CollectionManager.h
//  WP
//
//  Created by CBCCBC on 16/4/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectTypeModel.h"
@protocol CollectionManagerDelegate <NSObject>
@optional
- (void)reloadData;
- (void)cleanAction;
@end

@interface CollectionManager : NSObject
@property (nonatomic ,strong)id<CollectionManagerDelegate>delegate;
@property (nonatomic, strong)NSArray <CollectTypeModel *>*typeArr;
@property (nonatomic ,strong)NSMutableArray* dataArr;
@property (nonatomic ,strong)NSMutableArray *heights;


singleton_interface(CollectionManager);
// 收藏类表
- (void)requestForCollectionTypeList;
//获取 收藏类表

- (void)requestToAddCollectionTypeWithTypename:(NSString *)Typename success:(void (^)(id json))success;
// 添加 收藏类

- (void)requestToaddCollectionWithParams:(NSDictionary *)params success:(void (^)(id json))success;
// 添加 收藏

- (void)requestToDeleteCollectionTypeWithTypes:(NSString *)types success:(void (^)(id json))success;
//删除 收藏类

// 收藏列表
- (void)requestForCollectionListWithTypeid:(NSString *)typeId;
// 获取 收藏列表

- (void)requestToRemoveCollectionsWithCollids:(NSString *)collids success:(void (^)(id json))success;
// 删除 收藏

- (void)requestToMoveCollections:(NSString *)collids toType:(NSString *)type success:(void (^)(id json))success;
// 转移 收藏



@end
