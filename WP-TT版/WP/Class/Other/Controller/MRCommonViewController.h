//
//  MRCommonViewController.h
//  闵瑞微博
//
//  Created by Asuna on 15/4/21.
//  Copyright (c) 2015年 Asuna. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MRCommonGroup,MRCommonCheckGroup;
@interface MRCommonViewController : UITableViewController
- (MRCommonGroup *)addGroup;
- (MRCommonCheckGroup *)addCheckGroup;
- (id)groupInSection:(int)section;
@end
