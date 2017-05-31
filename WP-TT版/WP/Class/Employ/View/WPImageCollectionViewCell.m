//
//  WPImageCollectionViewCell.m
//  WP
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPImageCollectionViewCell.h"
#import "WPHttpTool.h"

@implementation WPImageCollectionViewCell
{
    //子视图
    UIImageView * _imageView;
    UILabel* _label;
    NSMutableArray* dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,30,30)];
        _label=[[UILabel alloc] initWithFrame:CGRectMake(40, 5, (SCREEN_WIDTH-30)/2, 33)];
        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"action"] = @"getIndustry";
        dic[@"fatherid"] = @"0";
        NSLog(@"<<<<<>>>>>%@,%@",urlStr,dic);
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            NSLog(@"*****%@",json);
            dataSource=json[@"list"];
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];

        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
}

@end
