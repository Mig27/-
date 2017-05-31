//
//  WPResumeListManager.h
//  WP
//
//  Created by CBCCBC on 16/4/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef void (^SuccessBlock)(NSArray *modelArr,int more);

@interface WPResumeListManager : NSObject
@property (nonatomic ,strong)NSArray *modelArray;
@property (nonatomic ,strong)NSString *resumeUserIds;

singleton_interface(WPResumeListManager);

- (void)requestForResumeuserList:(void(^)(NSArray *modelArray))Successblock;

- (void)requestForResumeList:(void(^)(NSArray *modelArray))Successblock;




@end
