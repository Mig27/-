//
//  IndustryModel.h
//  WP
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IndustryModel : NSObject<NSCoding>

@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *fatherID;
@property (copy, nonatomic) NSString *fathername;
@property (copy, nonatomic) NSString *industryID;
@property (copy, nonatomic) NSString *industryName;
@property (copy, nonatomic) NSString *layer;
@property (copy, nonatomic) NSString *sid;
@property (copy, nonatomic) NSString *is_alone;     // 0为直辖市
@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) NSInteger row;
@property (copy, nonatomic) NSString *fullname;
@property (assign, nonatomic) BOOL isSelected;
@end
