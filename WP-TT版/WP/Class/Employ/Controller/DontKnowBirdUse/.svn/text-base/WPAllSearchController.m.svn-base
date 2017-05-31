//
//  WPAllLookViewController.m
//  WP
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPAllSearchController.h"

@interface WPAllSearchController () <UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation WPAllSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage creatUIImageWithColor:RGB(235, 235, 235)] forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    self.navigationController.navigationBar.translucent = NO;
    
    [self searchBar];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSearchAction)];
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        [self.navigationItem setTitleView:_searchBar];
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}

- (void)cancelSearchAction{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar resignFirstResponder];
}

@end
