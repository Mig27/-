//
//  TouchView.m
//  BoYue
//
//  Created by Spyer on 15/1/8.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "TouchScrollView.h"

@implementation TouchScrollView

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
