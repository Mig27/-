//
//  WPPeopleInviteViewController.m
//  WP
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleInviteViewController.h"
#import "WPPeopleInviteTableViewCell.h"
#import "MacroDefinition.h"


@interface WPPeopleInviteViewController () <UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *button1;

@property (nonatomic,strong) UIButton *button2;

@property (nonatomic, strong) UISearchBar* searchBarTwo;

@property (nonatomic, strong) UISearchDisplayController *mySearchDisplayController;

@property (nonatomic,strong) UIScrollView *bottomScroller;

@property (nonatomic,strong) UIButton *button3;

@property (nonatomic,strong) UIButton *button4;

@property (nonatomic,strong) UIButton *button5;





@end

@implementation WPPeopleInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"邀请好友");
    _button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, kScreenW/2, 36)];
    [_button1 setBackgroundColor:[UIColor whiteColor]];
    [_button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1];
    UIImageView *_button1Image = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW*0.086, 7.5, 21, 21)];
    _button1Image.image = [UIImage imageNamed:@"图层5"];
    [_button1 addSubview:_button1Image];
    UILabel *_button1Label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW*0.178, 0, kScreenW/2 - kScreenW*0.178, 36)];
    _button1Label.text = @"邀请微信好友";
    _button1Label.textAlignment = NSTextAlignmentLeft;
    _button1Label.font = [UIFont systemFontOfSize:15.0];
    [_button1 addSubview:_button1Label];
    
    _button2 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/2, 40, kScreenW/2, 36)];
    [_button2 setBackgroundColor:[UIColor whiteColor]];
    [_button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2];
    UIImageView *_button2Image = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW*0.086, 7.5, 21, 21)];
    _button2Image.image = [UIImage imageNamed:@"添加QQ好友"];
    [_button2 addSubview:_button2Image];
    UILabel *_button2Label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW*0.178, 0, kScreenW/2 - kScreenW*0.178, 36)];
    _button2Label.text = @"邀请QQ好友";
    _button2Label.textAlignment = NSTextAlignmentLeft;
    _button2Label.font = [UIFont systemFontOfSize:15.0];
    [_button2 addSubview:_button2Label];
    
    UILabel *_line1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2, 40, 1, 36)];
    _line1.backgroundColor = RGBColor(235, 235, 235);
    [self.view addSubview:_line1];
    UILabel *_line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, kScreenW, 1)];
    _line2.backgroundColor = RGBColor(235, 235, 235);
    [self.view addSubview:_line2];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 76, kScreenW, kScreenH - 174)];
    _tableView.rowHeight = 58.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _bottomScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenH -104, kScreenW, 40)];
    _bottomScroller.contentSize = CGSizeMake(kScreenW, 40);
    _bottomScroller.bounces = NO;
    _bottomScroller.alwaysBounceVertical = NO;
    _bottomScroller.alwaysBounceHorizontal = YES;
    _bottomScroller.pagingEnabled = YES;
    _bottomScroller.showsHorizontalScrollIndicator = NO;
    _bottomScroller.showsVerticalScrollIndicator = NO;
    _bottomScroller.delegate = self;
    [self.view addSubview:_bottomScroller];
    
    UIImageView *_backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    _backImage.image = [UIImage imageNamed:@"切换栏2"];
    [_bottomScroller addSubview:_backImage];


    
    _button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW/3, 40)];
    [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button3 setTitle:@"通讯录" forState:UIControlStateNormal];
    [_button3 setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
    [_button3 setBackgroundImage:[UIImage imageNamed:@"切换栏"] forState:UIControlStateSelected];
    [_button3 addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
    [_button3 setSelected:YES];
    _button3.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomScroller addSubview:_button3];
    
    _button4 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/3, 0, kScreenW/3, 40)];
    [_button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button4 setTitle:@"新的好友" forState:UIControlStateNormal];
    [_button4 setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
    [_button4 setBackgroundImage:[UIImage imageNamed:@"切换栏"] forState:UIControlStateSelected];
    [_button4 addTarget:self action:@selector(button4Click) forControlEvents:UIControlEventTouchUpInside];
    [_button4 setSelected:NO];
    _button4.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomScroller addSubview:_button4];
    
    
    _button5 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/3*2, 0, kScreenW/3, 40)];
    [_button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button5 setTitle:@"新的粉丝" forState:UIControlStateNormal];
    [_button5 setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
    [_button5 setBackgroundImage:[UIImage imageNamed:@"切换栏"] forState:UIControlStateSelected];
    [_button5 addTarget:self action:@selector(button5Click) forControlEvents:UIControlEventTouchUpInside];
    [_button5 setSelected:NO];
    _button5.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomScroller addSubview:_button5];

    
    [self.view addSubview:self.searchBarTwo];
    
    [self setUpGesture];
    [self setsearchDisplayController];

}

-(void)setsearchDisplayController
{
    _mySearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBarTwo contentsController:self];
    
    _mySearchDisplayController.delegate = self;
    _mySearchDisplayController.searchResultsDataSource = self;
    _mySearchDisplayController.searchResultsDelegate = self;
}

-(UISearchBar *)searchBarTwo
{
    if (_searchBarTwo == nil) {
        self.searchBarTwo = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -4, SCREEN_WIDTH, SEARCHBARHEIGHT/2+12)];
        self.searchBarTwo.delegate =self;
        self.searchBarTwo.placeholder = @"搜索";
        self.searchBarTwo.tintColor = [UIColor lightGrayColor];
        self.searchBarTwo.autocorrectionType = UITextAutocorrectionTypeNo;
        self.searchBarTwo.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.searchBarTwo.keyboardType = UIKeyboardTypeDefault;
        self.searchBarTwo.backgroundColor = WPColor(235, 235, 235);
        for (UIView *view in self.searchBarTwo.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
    
    return _searchBarTwo;
}

- (void)setUpGesture
{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    //  [textField resignFirstResponder];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchBarTwo.showsCancelButton = YES;
    
    NSArray *subViews;
    
    if (iOS7) {
        subViews = [(_searchBarTwo.subviews[0]) subviews];
    }
    else {
        subViews = _searchBarTwo.subviews;
    }
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    
    
    self.navigationController.navigationBarHidden = YES;
    CGFloat xPos = searchBar.frame.origin.x;
    CGFloat yPos = searchBar.frame.origin.y;
    CGFloat width = searchBar.frame.size.width;
    CGFloat height = searchBar.frame.size.height;
    searchBar.frame = CGRectMake(xPos, yPos+20, width, height);
    
    CGFloat xPos1 = self.tableView.frame.origin.x;
    CGFloat yPos1 = self.tableView.frame.origin.y;
    CGFloat width1 = self.tableView.frame.size.width;
    CGFloat height1 = self.tableView.frame.size.height;
    self.tableView.frame = CGRectMake(xPos1, yPos1, width1, height1);
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    
    
    self.navigationController.navigationBarHidden = NO;
    CGFloat xPos = searchBar.frame.origin.x;
    CGFloat yPos = searchBar.frame.origin.y;
    CGFloat width = searchBar.frame.size.width;
    CGFloat height = searchBar.frame.size.height;
    searchBar.frame = CGRectMake(xPos, yPos-20, width, height);
    
    CGFloat xPos1 = self.tableView.frame.origin.x;
    CGFloat yPos1 = self.tableView.frame.origin.y;
    CGFloat width1 = self.tableView.frame.size.width;
    CGFloat height1 = self.tableView.frame.size.height;
    self.tableView.frame = CGRectMake(xPos1, yPos1, width1, height1);
    return YES;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString  *cellId = @"ViewCellId";
    
    
    WPPeopleInviteTableViewCell *cell = [[WPPeopleInviteTableViewCell alloc] init];
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[WPPeopleInviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    
    
    
    
    return cell;
}

- (void)button1Click
{
    
}

- (void)button2Click
{
    
}

- (void)button3Click
{

    [_button3 setSelected:YES];
    [_button4 setSelected:NO];
    [_button5 setSelected:NO];

    
}


- (void)button4Click
{

    [_button3 setSelected:NO];
    [_button4 setSelected:YES];
    [_button5 setSelected:NO];

    
}

- (void)button5Click
{

    [_button3 setSelected:NO];
    [_button4 setSelected:NO];
    [_button5 setSelected:YES];

    
}


- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    tableView.rowHeight = 58;
}



@end
