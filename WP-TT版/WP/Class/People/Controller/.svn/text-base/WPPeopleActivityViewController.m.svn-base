//
//  WPPeopleActivityViewController.m
//  WP
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleActivityViewController.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"
#import "WPPeopleActivityTableViewCell.h"
#import "MacroDefinition.h"

@interface WPPeopleActivityViewController () <UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;

@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic,strong) UIScrollView *mainScroller;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) UISearchBar* searchBarTwo;

@property (nonatomic, strong) UISearchDisplayController *mySearchDisplayController;


@end

@implementation WPPeopleActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"附近活动");
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [right setTitle:@"创建" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreenW, kScreenH-30)];
    _tableView.rowHeight = 110.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 70, kScreenW, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineLabel];
    
    [self makeContent];
    
    
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
    
    
    WPPeopleActivityTableViewCell *cell = [[WPPeopleActivityTableViewCell alloc] init];
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[WPPeopleActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }
    
    
    return cell;
}


-(void)makeContent
{
    NSMutableArray *listTop = [[NSMutableArray alloc] initWithArray:@[@"全部",@"老板",@"经理",@"朋友",@"同学",@"亲戚",@"家人"]];
    
    
    __weak typeof(self) unself = self;
    
    if (!self.detailsList) {
        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH+40, kScreenW, kScreenH-kListBarH)];
        self.detailsList.listAll = [NSMutableArray arrayWithObjects:listTop, nil];
        self.detailsList.longPressedBlock = ^(){
            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
        };
        self.detailsList.opertionFromItemBlock = ^(animateType type, NSString *itemName, int index){
            [unself.listBar operationFromBlock:type itemName:itemName index:index];
        };
        [self.view addSubview:self.detailsList];
    }
    
    if (!self.listBar) {
        self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 40, kScreenW, kListBarH)];
        self.listBar.visibleItemList = listTop;
        self.listBar.arrowChange = ^(){
            
            
            
            if (unself.arrow.arrowBtnClick) {
                
                unself.arrow.arrowBtnClick();
            }
        };
        self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
            [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
            //添加scrollview
            
            //移动到该位置
            unself.mainScroller.contentOffset =  CGPointMake(itemIndex * unself.mainScroller.frame.size.width, 0);
        };
        [self.view addSubview:self.listBar];
    }
    
    if (!self.deleteBar) {
        self.deleteBar = [[BYDeleteBar alloc] initWithFrame:self.listBar.frame];
        [self.view addSubview:self.deleteBar];
    }
    
    
    if (!self.arrow) {
        
        self.arrow = [[BYArrow alloc] initWithFrame:CGRectMake(kScreenW-kArrowW, 40, kArrowW, kListBarH)];
        self.arrow.arrowBtnClick = ^(){
            unself.deleteBar.hidden = !unself.deleteBar.hidden;
            [UIView animateWithDuration:kAnimationTime animations:^{
                CGAffineTransform rotation = unself.arrow.imageView.transform;
                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                unself.detailsList.transform = (unself.detailsList.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenH):CGAffineTransformMakeTranslation(0, -kScreenH);
            }];
        };
        [self.view addSubview:self.arrow];
    }
    if (!self.mainScroller) {
        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH+40, kScreenW , kScreenH-kListBarH-64)];
        self.mainScroller.backgroundColor = [UIColor yellowColor];
        self.mainScroller.bounces = NO;
        self.mainScroller.pagingEnabled = YES;
        self.mainScroller.showsHorizontalScrollIndicator = NO;
        self.mainScroller.showsVerticalScrollIndicator = NO;
        self.mainScroller.delegate = self;
        self.mainScroller.contentSize = CGSizeMake(kScreenW*10,self.mainScroller.frame.size.height);
        [self.view insertSubview:self.mainScroller atIndex:0];
        
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    tableView.rowHeight = 110;
}


@end
