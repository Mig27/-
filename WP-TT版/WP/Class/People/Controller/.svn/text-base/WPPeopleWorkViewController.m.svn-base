//
//  WPPeopleWorkViewController.m
//  WP
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleWorkViewController.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"
#import "WPPeopleWorkTableViewCell.h"
#import "WPPeopleDetailViewController.h"
#import "MacroDefinition.h"

@interface WPPeopleWorkViewController () <UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;

@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic,strong) UIScrollView *mainScroller;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) UISearchBar* searchBarTwo;

@property (nonatomic, strong) UISearchDisplayController *mySearchDisplayController;

@property (nonatomic,strong) UIScrollView *bottomScroller;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) UIButton *button1;

@property (nonatomic,strong) UIButton *button2;

@property (nonatomic,strong) UIButton *button3;

@property (nonatomic,strong) UIButton *button4;

@property (nonatomic,strong) UIButton *button5;

@property (nonatomic,strong) UIButton *button6;


@end

@implementation WPPeopleWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"职场群");
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [right setTitle:@"创建" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreenW, kScreenH - 174)];
    _tableView.rowHeight = 72.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 70, kScreenW, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineLabel];
    
    

    _bottomScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenH -104, kScreenW, 40)];
    _bottomScroller.contentSize = CGSizeMake(kScreenW*2, 40);
    _bottomScroller.bounces = NO;
    _bottomScroller.alwaysBounceVertical = NO;
    _bottomScroller.alwaysBounceHorizontal = YES;
    _bottomScroller.pagingEnabled = YES;
    _bottomScroller.showsHorizontalScrollIndicator = NO;
    _bottomScroller.showsVerticalScrollIndicator = NO;
    _bottomScroller.delegate = self;
    [self.view addSubview:_bottomScroller];
    
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenH - 74, kScreenW, 10)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = 2;
    [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:_pageControl];
    
    UIImageView *_backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW*2, 40)];
    _backImage.image = [UIImage imageNamed:@"切换栏3"];
    [_bottomScroller addSubview:_backImage];
    
    
    _button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW/3, 40)];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button1 setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"切换栏"] forState:UIControlStateSelected];
    [_button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [_button1 setSelected:YES];
    [_button1 setTitle:@"附近" forState:UIControlStateNormal];
    _button1.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomScroller addSubview:_button1];
    
    _button2 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/3, 0, kScreenW/3, 40)];
    [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button2 setTitle:@"关注" forState:UIControlStateNormal];
    [_button2 setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"切换栏"] forState:UIControlStateSelected];
    [_button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    [_button2 setSelected:NO];
    _button2.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomScroller addSubview:_button2];

    _button3 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/3*2, 0, kScreenW/3, 40)];
    [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button3 setTitle:@"好友" forState:UIControlStateNormal];
    [_button3 setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
    [_button3 setBackgroundImage:[UIImage imageNamed:@"切换栏"] forState:UIControlStateSelected];
    [_button3 addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
    [_button3 setSelected:NO];
    _button3.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomScroller addSubview:_button3];
    
    _button4 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW, 0, kScreenW/3, 40)];
    [_button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button4 setTitle:@"粉丝" forState:UIControlStateNormal];
    [_button4 setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
    [_button4 setBackgroundImage:[UIImage imageNamed:@"切换栏"] forState:UIControlStateSelected];
    [_button4 addTarget:self action:@selector(button4Click) forControlEvents:UIControlEventTouchUpInside];
    [_button4 setSelected:NO];
    _button4.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomScroller addSubview:_button4];

    
    _button5 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/3*4, 0, kScreenW/3, 40)];
    [_button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button5 setTitle:@"推荐" forState:UIControlStateNormal];
    [_button5 setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
    [_button5 setBackgroundImage:[UIImage imageNamed:@"切换栏"] forState:UIControlStateSelected];
    [_button5 addTarget:self action:@selector(button5Click) forControlEvents:UIControlEventTouchUpInside];
    [_button5 setSelected:NO];
    _button5.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomScroller addSubview:_button5];

    
    _button6 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/3*5, 0, kScreenW/3, 40)];
    [_button6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button6 setTitle:@"我的" forState:UIControlStateNormal];
    [_button6 setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
    [_button6 setBackgroundImage:[UIImage imageNamed:@"切换栏"] forState:UIControlStateSelected];
    [_button6 addTarget:self action:@selector(button6Click) forControlEvents:UIControlEventTouchUpInside];
    [_button6 setSelected:NO];
    _button6.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomScroller addSubview:_button6];






    
    
    [self makeContent];
    
    
    [self.view addSubview:self.searchBarTwo];
    [self setUpGesture];
    [self setsearchDisplayController];
}



- (void)scrollViewDidEndDecelerating: (UIScrollView *)scrollView
{
    NSLog(@"scrollView page = %f", scrollView.contentOffset.x/scrollView.frame.size.width);
    
    _pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
}

- (void)pageControlValueChanged:(UIPageControl *)pageControl
{
    [_bottomScroller setContentOffset:CGPointMake(pageControl.currentPage * _bottomScroller.frame.size.width, 0) animated:YES];
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
    
    
    WPPeopleWorkTableViewCell *cell = [[WPPeopleWorkTableViewCell alloc] init];
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[WPPeopleWorkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }
    
    
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=0) {
        
        WPPeopleDetailViewController *_detail = [[WPPeopleDetailViewController alloc] init];
        [self.navigationController pushViewController:_detail animated:YES];
    }
    return;
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
    
    
//    if (!self.mainScroller) {
//        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH+40, kScreenW , kScreenH-kListBarH-64)];
//        self.mainScroller.backgroundColor = [UIColor yellowColor];
//        self.mainScroller.bounces = NO;
//        self.mainScroller.pagingEnabled = YES;
//        self.mainScroller.showsHorizontalScrollIndicator = NO;
//        self.mainScroller.showsVerticalScrollIndicator = NO;
//        self.mainScroller.delegate = self;
//        self.mainScroller.contentSize = CGSizeMake(kScreenW*10,self.mainScroller.frame.size.height);
//        [self.view insertSubview:self.mainScroller atIndex:0];
//        
//    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    tableView.rowHeight = 72;
}

- (void)button1Click
{
    [_button1 setSelected:YES];
    [_button2 setSelected:NO];
    [_button3 setSelected:NO];
    [_button4 setSelected:NO];
    [_button5 setSelected:NO];
    [_button6 setSelected:NO];
    
}

- (void)button2Click
{
    [_button1 setSelected:NO];
    [_button2 setSelected:YES];
    [_button3 setSelected:NO];
    [_button4 setSelected:NO];
    [_button5 setSelected:NO];
    [_button6 setSelected:NO];

}


- (void)button3Click
{
    [_button1 setSelected:NO];
    [_button2 setSelected:NO];
    [_button3 setSelected:YES];
    [_button4 setSelected:NO];
    [_button5 setSelected:NO];
    [_button6 setSelected:NO];

}


- (void)button4Click
{
    [_button1 setSelected:NO];
    [_button2 setSelected:NO];
    [_button3 setSelected:NO];
    [_button4 setSelected:YES];
    [_button5 setSelected:NO];
    [_button6 setSelected:NO];

}

- (void)button5Click
{
    [_button1 setSelected:NO];
    [_button2 setSelected:NO];
    [_button3 setSelected:NO];
    [_button4 setSelected:NO];
    [_button5 setSelected:YES];
    [_button6 setSelected:NO];

}

- (void)button6Click
{
    [_button1 setSelected:NO];
    [_button2 setSelected:NO];
    [_button3 setSelected:NO];
    [_button4 setSelected:NO];
    [_button5 setSelected:NO];
    [_button6 setSelected:YES];

}



@end
