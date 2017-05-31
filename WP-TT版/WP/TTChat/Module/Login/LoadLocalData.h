//
//  LoadLocalData.h
//  WP
//
//  Created by CC on 16/11/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LoadLocalData : NSObject
+(instancetype)instance;
-(void)loadLocalData:(NSString*)password nameStr:(NSString*)name success:(void(^)())Success;
@end
