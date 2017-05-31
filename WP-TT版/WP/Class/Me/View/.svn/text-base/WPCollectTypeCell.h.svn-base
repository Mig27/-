//
//  WPCollectTypeCell.h
//  WP
//
//  Created by CBCCBC on 16/4/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectTypeModel.h"

//typedef void(^touchsBegan)();

typedef void (^checkboxBlock)();

@protocol WPCollectTypeCellDelegate <NSObject>

@optional
- (void)editTypeId:(NSString *)typeId andeditValue:(NSString *)value;
@end

@interface WPCollectTypeCell : UITableViewCell
//@property (nonatomic ,copy)touchsBegan touch;
@property (nonatomic ,assign)BOOL needSelect;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)CollectTypeModel *model;
@property (nonatomic , strong)UITextField *titleLabel;
@property (nonatomic,weak)id <WPCollectTypeCellDelegate> delegate;

@property (nonatomic ,copy)checkboxBlock checkboxBlock;

@end
