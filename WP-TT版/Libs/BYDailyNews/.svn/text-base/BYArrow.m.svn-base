//
//  SelectionButton.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYArrow.h"
#import "BYArrowInfo.h"


@implementation BYArrow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"Arrow.png"] forState:0];
        [self setImage:[UIImage imageNamed:@"Arrow.png"] forState:1<<0];
//        self.backgroundColor = RGBColor(238.0, 238.0, 238.0);
        self.backgroundColor = [UIColor whiteColor];
        [self addTarget:self
                 action:@selector(ArrowClick)
       forControlEvents:1 << 6];

    }
    return self;
}

-(void)ArrowClick{
    if (self.arrowBtnClick) {
//        BYArrowInfo *p = [BYArrowInfo defaultInfo];
//
//        if (p.one%2 == 1) {
//            self.backgroundColor = RGBColor(238.0, 238.0, 238.0);
//        }
//        if (p.one%2 == 0) {
//            self.backgroundColor = [UIColor whiteColor];
//        }
//        p.one++;
        self.arrowBtnClick();
    }
    
    
    

}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageSize = 18;
    return CGRectMake((contentRect.size.width-imageSize)/2, (30-imageSize)/2, imageSize, imageSize);
}

@end
