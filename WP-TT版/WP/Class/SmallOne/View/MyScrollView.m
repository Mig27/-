//
//  MyScrollView.m
//  test
//
//  Created by school51 on 14-11-20.
//  Copyright (c) 2014年 school51. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
        [self endEditing:YES];
    }
}



@end
