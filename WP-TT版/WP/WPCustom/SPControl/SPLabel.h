//
//  SPLabel.h
//  WP
//
//  Created by CBCCBC on 15/10/28.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,VerticalAlignment){
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
};

@interface SPLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
