//
//  WPPeopleConnectionViewController.m
//  WP
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleConnectionViewController.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"
#import "WPPeopleTableViewCell.h"
#import "MacroDefinition.h"


@interface WPPeopleConnectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;

@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic,strong) UIScrollView *mainScroller;

@property (nonatomic,strong) UITableView *tableView;



@end

@implementation WPPeopleConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"人脉");
        UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [right setImage:[UIImage imageNamed:@"黑色搜索"] forState:UIControlStateNormal];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:right];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kScreenW, kScreenH-30-64)];
    _tableView.rowHeight = 59.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 30, kScreenW, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineLabel];
    
    [self makeContent];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(void)makeContent
{
    NSMutableArray *listTop = [[NSMutableArray alloc] initWithArray:@[@"全部",@"老板",@"经理",@"朋友",@"同学",@"亲戚",@"家人",@"一亿",@"一万",@"一千",@"一百",@"一十"]];
    
    __weak typeof(self) unself = self;
    
    if (!self.detailsList) {
        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH, kScreenW, kScreenH-kListBarH)];
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
        self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kListBarH)];
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
        
        self.arrow = [[BYArrow alloc] initWithFrame:CGRectMake(kScreenW-kArrowW, 0, kArrowW, kListBarH)];
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
        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH, kScreenW , kScreenH-kListBarH-64)];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *cellId = @"ViewCellId";
    
    WPPeopleTableViewCell *cell = [[WPPeopleTableViewCell alloc] init];
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[WPPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

@end
