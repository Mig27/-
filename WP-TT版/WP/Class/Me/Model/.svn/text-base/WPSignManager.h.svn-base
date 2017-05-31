//
//  SignManager.h
//  WP
//
//  Created by CBCCBC on 16/3/25.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WPSignManagerDelegate <NSObject>
@optional
- (void)reloadData;
@end
@interface WPSignManager : NSObject
@property (nonatomic ,assign)BOOL isResume;
@property (nonatomic ,strong)id<WPSignManagerDelegate>delegate;
@property (nonatomic ,strong)NSMutableArray *signArr;

singleton_interface(WPSignManager)

- (void)requestWithId:(NSString *)id page:(NSString *)page;

//- (void)requestWithResumeId:(NSString *)resume_id page:(NSString *)page;

@end
