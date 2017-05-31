//
//  AnonymousManager.h
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnonymousModel.h"

typedef void (^reloadBlock) (AnonymousModel *model);
@protocol AnonymousManagerDelegate <NSObject>
@optional
- (void)reloadData;
- (void)backToControllerWithStatus:(BOOL)status;
@end
@interface AnonymousManager : NSObject
@property (nonatomic ,weak)id<AnonymousManagerDelegate>delegate;
@property (nonatomic ,strong)NSArray *anonyList;
@property (nonatomic ,strong)AnonymousModel *model;
@property (nonatomic ,copy)reloadBlock reload;

singleton_interface(AnonymousManager)
- (void)getAnonymityList;
- (void)getAnonymityInfo;
- (void)setAnonymousModelWithModel:(AnonymousModel *)model;


@end
