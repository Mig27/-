//
//  CollectionManager.m
//  WP
//
//  Created by CBCCBC on 16/4/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "CollectionManager.h"
#import "WPMySecurities.h"
#import "MTTDatabaseUtil.h"
#define kCollection @"/ios/collection_new.ashx"
#define photoWidth (SCREEN_WIDTH==320)?74:((SCREEN_WIDTH==375)?79:86)
#define videoWidth (SCREEN_WIDTH==320)?140:((SCREEN_WIDTH==375)?164:172)

@implementation CollectionManager

singleton_implementation(CollectionManager);







- (void)requestToMoveCollections:(NSString *)collids toType:(NSString *)type success:(void (^)(id))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"collTo",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"collid":collids,
                                                                                  @"typeid":type,
                                                                                  @"my_user_id":kShareModel.userId}];
    
    NSString *url = [IPADDRESS stringByAppendingString:kCollection];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestToRemoveCollectionsWithCollids:(NSString *)collids success:(void (^)(id))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"delColl",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"collid":collids,
                                                                                  @"my_user_id":kShareModel.userId}];
    
    NSString *url = [IPADDRESS stringByAppendingString:kCollection];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestForCollectionTypeList
{
    NSString *url = [IPADDRESS stringByAppendingString:kCollection];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GetTypeList";
    params[@"username"] = kShareModel.username;
    params[@"password"] = kShareModel.password;
    params[@"user_id"] = kShareModel.userId;
    params[@"my_user_id"] = kShareModel.userId;
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        CollectTypeListModel *model = [CollectTypeListModel mj_objectWithKeyValues:json];
        self.typeArr = nil;
        self.typeArr = [NSArray arrayWithArray:model.list];
        if (json) {
            [self delegateAction];
        }
        if (model.list.count) {
            [[MTTDatabaseUtil instance] deleteAllCollectionList];
            [[MTTDatabaseUtil instance] upDateCollectionList:json[@"list"]];
        }
    } failure:^(NSError *error) {
        [[MTTDatabaseUtil instance] getCollectionList:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = @{@"list":array};
                CollectTypeListModel *model = [CollectTypeListModel mj_objectWithKeyValues:dic];
                self.typeArr = [NSArray arrayWithArray:model.list];
                [self delegateAction];
            }
        }];
    }];
}

- (void)delegateAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate reloadData];
//        });
    }
}

- (void)requestToAddCollectionTypeWithTypename:(NSString *)Typename success:(void (^)(id))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"AddType",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"typename":Typename,
                                                                                  @"my_user_id":kShareModel.userId}];
    
    NSString *url = [IPADDRESS stringByAppendingString:kCollection];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        success (json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestToaddCollectionWithParams:(NSDictionary *)params success:(void (^)(id))success
{
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"AddType",
//                                                                                  @"user_id":kShareModel.userId,
//                                                                                  @"username":kShareModel.username,
//                                                                                  @"password":kShareModel.password}];
//    [params setValuesForKeysWithDictionary:dictionary];
    NSString *url = [IPADDRESS stringByAppendingString:kCollection];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestToDeleteCollectionTypeWithTypes:(NSString *)types success:(void (^)(id json))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"deletetype",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"typeid":types,
                                                                                  @"my_user_id":kShareModel.userId}];
    
    NSString *url = [IPADDRESS stringByAppendingString:kCollection];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        success (json);
    } failure:^(NSError *error) {
        
    }];
}
//详细信息
- (void)requestForCollectionListWithTypeid:(NSString *)typeId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"GetColl",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"typeid":typeId,
                                                                                  @"my_user_id":kShareModel.userId}];
    self.dataArr = nil;
    NSString *url = [IPADDRESS stringByAppendingString:kCollection];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if (json) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:json[@"list"]];
            [self getHeightForCell];
            [self delegateAction];
            
            if ([json[@"list"] count]) {
                [[MTTDatabaseUtil instance] deleteCollectionDetail:typeId];
                [[MTTDatabaseUtil instance] upDateCollectionDetail:json[@"list"]];
            }
            
        }
    } failure:^(NSError *error) {
        [[MTTDatabaseUtil instance] getCollectionDetail:typeId success:^(NSArray *array) {
            if (array.count) {
                [self.dataArr removeAllObjects];
                [self.dataArr addObjectsFromArray:array];
                [self getHeightForCell];
                [self delegateAction];
            }
        }];
        
        
    }];
}

- (void)getHeightForCell
{
    [self.heights removeAllObjects];
    for (NSDictionary *dic in self.dataArr) {
        CGFloat cellHeight = kHEIGHT(50);
        NSString *classN = dic[@"classN"];
        if ([classN isEqualToString:@"0"]) {// 添加文字信息
            
            NSString * str = [NSString stringWithFormat:@"%@",dic[@"content"]];
            NSString *description1 = [WPMySecurities textFromBase64String:str];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            if (!description3.length)
            {
                description3 = str;
            }
            
            NSDictionary * dic = @{@"content":description3};
            
            cellHeight += [self getHeightForContentStringWithDic:dic];
            cellHeight += kHEIGHT(10);
            [self.heights addObject:[NSNumber numberWithDouble:cellHeight]];
        }else if ([classN isEqualToString:@"1"]){           // 添加图片信息
            if (dic[@"img_url"]) {
                cellHeight += photoWidth;
            }
            cellHeight += kHEIGHT(10);
            [self.heights addObject:[NSNumber numberWithDouble:cellHeight]];
        }else if ([classN isEqualToString:@"2"]){           //视频
            
            CGFloat viWidth;
            if (SCREEN_WIDTH == 320) {
                viWidth = 112;
            } else if (SCREEN_WIDTH == 375) {
                viWidth = 131;
            } else {
                viWidth = 145;
            }
            
//            cellHeight = viWidth+kHEIGHT(10);
            if (dic[@"img_url"]) {
                cellHeight += viWidth;
            }
            cellHeight += kHEIGHT(10);
            
            [self.heights addObject:[NSNumber numberWithDouble:cellHeight]];
        }
//        else if ([classN isEqualToString:@"4"])
//        {           // 说说
//            NSString *string = dic[@"content"];
//            NSArray * array = [string componentsSeparatedByString:@":"];
//            NSString * str = [NSString string];
//            if (array.count > 1) {
//                str = [NSString stringWithFormat:@"%@",array[1]];
//            }
//            else
//            {
//              str = [NSString stringWithFormat:@"%@",array[0]];
//            }
//            NSString *description1 = [WPMySecurities textFromBase64String:str];
//            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
//            NSDictionary * dictionary = [[NSDictionary alloc]init];
//            if ([dic[@"share"] isEqualToString:@"1"]) {
//               dictionary = @{@"content":[NSString stringWithFormat:@"职场日记/分享"]};
//            }
//            else
//            {
//              dictionary = @{@"content":[NSString stringWithFormat:@"职场日记\n%@",description3]};
//            }
//            cellHeight += [self getHeightForContentStringWithDic:dictionary];
//            
//            if (description3 > 0) {
//                cellHeight += kHEIGHT(10);
//            }
//            NSString * share = [NSString stringWithFormat:@"%@",dic[@"share"]];
//            if ([share isEqualToString:@"2"]||[share isEqualToString:@"3"]||[share isEqualToString:@"1"])
//            {
//              cellHeight += kHEIGHT(43) + kHEIGHT(10);
//            }
//            else
//            {
//                    NSArray *imagePhoto = dic[@"url"];
//                    NSInteger k = 3;
//                    if (imagePhoto.count == 4) {
//                        k = 2;
//                        cellHeight += (photoWidth+5) *2 +kHEIGHT(10);//20
//                    }else{
//                        if (imagePhoto.count == 0) {
//                        }
//                        else
//                        {
//                            cellHeight += ((imagePhoto.count-1) / 3 + 1) * (photoWidth+5)-5+kHEIGHT(12);
//                        }
//                    }
//            }
//            [self.heights addObject:[NSNumber numberWithDouble:cellHeight]];
//        }
        else if ([classN isEqualToString:@"3"]||[classN isEqualToString:@"5"]||[classN isEqualToString:@"6"]||[classN isEqualToString:@"7"]||[classN isEqualToString:@"8"]||[classN isEqualToString:@"4"]|| [classN isEqualToString:@"15"]||[classN isEqualToString:@"16"]){
            cellHeight += kHEIGHT(53);
            [self.heights addObject:[NSNumber numberWithDouble:cellHeight]];
        }
    }
}

- (CGFloat)getHeightForContentStringWithDic:(NSDictionary *)dic
{
    CGFloat height = 0 ;
    NSString *string = dic[@"content"];
    if (string.length > 0) {
        CGSize size = [string getSizeWithFont:kFONT(14) Width:SCREEN_WIDTH-kHEIGHT(20)];
        CGSize normalSize = [@"蛋疼不疼" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
        if (size.height > normalSize.height*8) {//5
            height = normalSize.height*8;
        }else{
            height = size.height;
        }
    }
    return height;
}

- (NSMutableArray *)heights
{
    if (!_heights) {
        self.heights = [NSMutableArray array];
    }
    return _heights;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
