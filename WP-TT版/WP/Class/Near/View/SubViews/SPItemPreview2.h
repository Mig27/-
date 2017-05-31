//
//  SPItemPreview2.h
//  WP
//
//  Created by CBCCBC on 15/10/26.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPItemPreview2 : UIView

@property (copy, nonatomic) void (^addHeight)(CGFloat addHeight);
@property (copy, nonatomic) void (^subHeight)(CGFloat subHeight);

-(id)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content;
+(CGFloat)itemHeightFromContent:(NSString *)content;

@end
