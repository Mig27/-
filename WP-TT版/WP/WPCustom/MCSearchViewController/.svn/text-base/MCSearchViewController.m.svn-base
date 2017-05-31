//
//  MCSearchViewController.m
//  qikeyun
//
//  Created by 马超 on 15/8/14.
//  Copyright (c) 2015年 Jerome. All rights reserved.
//

#import "MCSearchViewController.h"



@interface MCSearchViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) MCSearchBar *searchBar;
@property (nonatomic, strong) UIView *searchBackgroundView;



@property (nonatomic, strong) UILabel *emptyLabel;


@end

@implementation MCSearchViewController


- (NSMutableArray *)resultSource
{
    if (_resultSource == nil) {
        _resultSource = [NSMutableArray array];
    }
    return _resultSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    [self navBar];
   // self.navigationItem.hidesBackButton = YES;
    // [self.navigationController.navigationBar setBarTintColor:RGBCOLOR(254, 59, 21)];
    [self setupSearchView];
    [self setupCancel];
    
    [self setupEmptyDataView];
    [self setupTableView];
    [self.searchView becomeFirstResponder];
}
-(void)navBar{
    self.navigationController.navigationBar.hidden = YES;
    _barView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _barView.backgroundColor= WP_Line_Color;
    [self.view addSubview:_barView];
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    YPLog(@"LLERR");
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setCancelTitle:(NSString *)cancelTitle
{
    _cancelColor = [cancelTitle copy];
    
    [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
}
- (void)setupSearchView
{
    //搜索
    UIImageView *left = [[UIImageView alloc] init];
    left.image = [UIImage imageNamed:@"MCSearch"];
    left.contentMode = UIViewContentModeCenter;
    left.frame = CGRectMake(10, 0, 30, 30);
    
    UITextField *searchT = [[UITextField alloc] init];
    searchT.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    searchT.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchT.returnKeyType = UIReturnKeySearch;
    searchT.borderStyle = UITextBorderStyleNone;
    searchT.clipsToBounds = YES;
    searchT.layer.cornerRadius = 5;
    searchT.delegate = self;
            [searchT addTarget:self action:@selector(textFieldDidTextChange:) forControlEvents:UIControlEventEditingChanged];
    searchT.font = [UIFont systemFontOfSize:13.0];
    if (self.placeHolder.length) {
        searchT.placeholder = self.placeHolder;
    }else{
        searchT.placeholder = @"搜索";
    }
    
    searchT.leftView = left;
    searchT.leftViewMode = UITextFieldViewModeAlways;
    searchT.frame = CGRectMake(15, 27, self.view.bounds.size.width- 20 -40-15, 30);
    [_barView addSubview:searchT];
    self.searchView = searchT;
    //self.navigationItem.titleView = self.searchView;
    [self.searchView becomeFirstResponder];
}

- (void)setupCancel
{
    UIButton *cancel = [[UIButton alloc] init];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:self.cancelColor?self.cancelColor:[UIColor blueColor] forState:UIControlStateNormal];
    //cancel.backgroundColor=YP_COLOR_BLUE ;
    cancel.titleLabel.font = [UIFont systemFontOfSize:15.0];
    cancel.frame = CGRectMake(CGRectGetMaxX(self.searchView.frame)+3, self.searchView.frame.origin.y, 40, self.searchView.frame.size.height);
    [_barView addSubview:cancel];
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = cancel;
}
- (void)setupEmptyDataView
{
    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.text = @"没有符合条件的结果";
    emptyLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    emptyLabel.font = [UIFont systemFontOfSize:15.0];
    emptyLabel.frame = CGRectMake(10, 10, self.view.frame.size.width - 20, 20);
    [self.view addSubview:emptyLabel];
    self.emptyLabel = emptyLabel;
    self.emptyLabel.hidden = YES;
}
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    self.tableView  = tableView;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.resultSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellForRowAtIndexPathCompletion) {
        return _cellForRowAtIndexPathCompletion(tableView, indexPath);
    }
    else{
        return [[UITableViewCell alloc] init];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (_canEditRowAtIndexPath) {
        return _canEditRowAtIndexPath(tableView, indexPath);
    }
    else{
        return NO;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_heightForRowAtIndexPathCompletion) {
        return _heightForRowAtIndexPathCompletion(tableView, indexPath);
    }
    
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.editingStyle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didSelectRowAtIndexPathCompletion) {
        return _didSelectRowAtIndexPathCompletion(tableView, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didDeselectRowAtIndexPathCompletion) {
        _didDeselectRowAtIndexPathCompletion(tableView, indexPath);
    }
}
#pragma  mark 点击方法
//点击取消按钮
- (void)cancelAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.searchView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(searchViewController:didClickedSearchCancelButton:)]) {
        [self.delegate searchViewController:self didClickedSearchCancelButton:sender];
        
    }
//    [self dismissViewControllerAnimated:NO completion:^{
//        if ([self.delegate respondsToSelector:@selector(searchViewController:didClickedSearchCancelButton:)]) {
//            [self.delegate searchViewController:self didClickedSearchCancelButton:sender];
//        }
//    }];
}

#pragma mark 滑动后取消键盘
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.searchView resignFirstResponder];
//}
//点击搜索按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [self.searchView resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(searchViewController:didClickedSearchReturnWithKey:)]) {
            [self.delegate searchViewController:self didClickedSearchReturnWithKey:textField.text];
        }
    }else{
      [self.searchView resignFirstResponder];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.resultSource removeAllObjects];
    [self.tableView reloadData];
    return YES;
}

- (void)textFieldDidTextChange:(UITextField *)textField
{
    if (!textField.text.length) {
        [self.resultSource removeAllObjects];
        [self.tableView reloadData];
    }
}



#pragma  mark 私有方法
- (void)showEmptyLabelWithType:(BOOL)type
{
    if (type) {
        self.emptyLabel.hidden = NO;
    }else{
        self.emptyLabel.hidden = YES;
    }
}
@end
