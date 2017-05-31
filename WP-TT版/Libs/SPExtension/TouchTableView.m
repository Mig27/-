//
//  TouchTableView.m
//  BoYue
//
//  Created by Leejay on 15/1/22.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "TouchTableView.h"

@implementation TouchTableView


-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        if ([self respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)])
        {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ( !self.dragging )
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if ( !self.dragging )
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(!self.dragging)
    {
        [[self nextResponder] touchesCancelled:touches withEvent:event];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if(!self.dragging)
    {
        [[self nextResponder] touchesMoved:touches withEvent:event];
    }
}

@end
