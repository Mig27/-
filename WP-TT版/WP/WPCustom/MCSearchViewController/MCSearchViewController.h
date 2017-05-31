//
//  MCSearchViewController.h
//  qikeyun
//
//  Created by 马超 on 15/8/14.
//  Copyright (c) 2015年 Jerome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSearchBar.h"


@class MCSearchViewController;
@protocol MCSearchViewControllerDelegate <NSObject>

/**
 *  点击了搜索中键盘的搜索按钮
 *
 *  @param searchViewController 当前的控制器
 *  @param key                  输入框中的内容
 */
- (void)searchViewController:(MCSearchViewController *)searchViewController didClickedSearchReturnWithKey:(NSString *)key;
@optional
/**
 *  点击了取消按钮
 *
 *  @param searchViewController 当前控制器
 *  @param button               点击的按钮
 */
- (void)searchViewController:(MCSearchViewController *)searchViewController didClickedSearchCancelButton:(UIButton *)button;
@end

@interface MCSearchViewController : UIViewController{
    UIView*_barView;

}


@property (nonatomic,retain)UIColor *cancelColor;
@property (nonatomic,copy)NSString *placeHolder;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic, strong)UITextField *searchView;
@property (strong, nonatomic) NSMutableArray *resultSource;
@property (nonatomic,copy)NSString *cancelTitle;
@property (nonatomic,assign)id <MCSearchViewControllerDelegate> delegate;
//编辑cell时显示的风格，默认为UITableViewCellEditingStyleDelete；／／会将值付给[tableView:editingStyleForRowAtIndexPath:]
@property (nonatomic) UITableViewCellEditingStyle editingStyle;

@property (copy) UITableViewCell * (^cellForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) BOOL (^canEditRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) CGFloat (^heightForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) void (^didSelectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) void (^didDeselectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);

- (void)showEmptyLabelWithType:(BOOL)type;

@end



