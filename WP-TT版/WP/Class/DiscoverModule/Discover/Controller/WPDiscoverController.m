//
//  WPDiscoverController.m
//  WP
//
//  Created by Asuna on 15/5/20.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPDiscoverController.h"
#import "HMNewsCell.h"
#import "HMNews.h"
#import "WPDiscoverButton.h"
#import "WPSmallOneController.h"
#import "WPJobsController.h"
#import "WPJobViewController.h"
#import "WPPeopleViewController.h"
#import "QuestionsViewController.h"
#import "DemandViewController.h"

#import "NewJobViewController.h"
#import "DiscoverCell.h"
#import "NewDemandViewController.h"
#import "NearActivityViewController.h"
#import "OtherActivityController.h"
#import "SecondJobViewController.h"
#import "ThirdJobViewController.h"

#import "ThirdJobViewController_New.h"
#import "WPDynamicGroupViewController.h"
#import "WPTipModel.h"

#import "WPNearbyPeopleController.h"
#import "WPNeiborController.h"

#import "LinkManViewController.h"



#define HMCellIdentifier @"news"
#define HMMaxSections 500

#define MRRIGHT 155
#define MRBOTTOM 50

#define MRLEFTMARGIN 10
#define MRTOPMARGIN 15

#define CYNavigationBarHeight 88
#define CYStatusBarHeight 40

@interface WPDiscoverController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UICollectionView* collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout* flowLayout;
@property (nonatomic, strong) UIPageControl* pageContol;
@property (nonatomic, strong) NSArray* newses;
@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, strong) UIScrollView* bottomView;
@property (nonatomic, weak) NSArray* buttonArray;
@property (nonatomic,assign) CGFloat photoWallHeight;
@property (nonatomic,assign) CGFloat cellBtnHeight;
@property (nonatomic,strong) NSArray *iconAndTitle;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation WPDiscoverController

//-(void)clickLeft
//{
//    LinkManViewController *linkMane = [[LinkManViewController alloc] init];
//    [self.navigationController pushViewController:linkMane animated:YES];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"点击" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeft)];
    
    
    
    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"发现";
//   原来的九宫格的布局
//    self.photoWallHeight = 0.5625*SCREEN_WIDTH;
//    self.cellBtnHeight = 0.215625*SCREEN_WIDTH;
//    [self.navigationController.navigationBar setTranslucent:NO];
//    self.view.backgroundColor = WPColor(229, 230, 231);
//    [self setUpCollectionView];
    
   // [self.view addSubview:self.bottomView];
//    [self.view addSubview:self.bottomView];
//    [self.bottomView addSubview:self.pageContol];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStylePlain  target:self  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageTip) name:@"GlobalMessageTip" object:nil];
//    WPTipModel *model = [WPTipModel sharedManager];
//    [self addTimer];
    _iconAndTitle = @[
                      @[@{@"image" : @"faxian_zhichangshuoshuo",//fenxiang_zhichangshuoshuo@2x
                          @"title" : @"话题",//工作圈
                          @"count" : @"",
                          @"avatar": @""
                          }],
                      //                      @[@{@"image" : @"dynamic_tabbar2",
                      //                          @"title" : @"奇葩需求"
                      //                          }],
                      @[@{@"image" : @"dynamic_tabbar3",
                          @"title" : @"附近人脉",
                          @"count" : @"",
                          @"avatar": @""
                          },
                        @{@"image" : @"dynamic_tabbar4",
                          @"title" : @"职场群组",
                          @"count" : @"",
                          @"avatar": @""
                                                    }],
//                        @[@{@"image" : @"dynamic_tabbar5",
//                                                    @"title" : @"附近的活动",
//                                                    @"count" : @"",
//                                                    @"avatar": @""
//                          }]
                      ];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = RGB(235, 235, 235);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [self.view addSubview:_tableView];
}

- (void)messageTip
{
    WPTipModel *model = [WPTipModel sharedManager];
    _iconAndTitle = @[
                      @[@{@"image" : @"faxian_zhichangshuoshuo",
                          @"title" : @"话题",
                          @"count" : model.speak,
                          @"avatar": model.con_avatar,
                          @"publishAvatar":model.avatar.length?model.avatar:model.M_avatar
                          }],
                      //                      @[@{@"image" : @"dynamic_tabbar2",
                      //                          @"title" : @"奇葩需求"
                      //                          }],
                      @[@{@"image" : @"dynamic_tabbar3",
                          @"title" : @"附近人脉",
                          @"count" : @"",
                          @"avatar": @""
                          },
                        @{@"image" : @"dynamic_tabbar4",
                          @"title" : @"职场群组",
                          @"count" : @"",
                          @"avatar": @""
                          //                          }],
                          //                      @[@{@"image" : @"dynamic_tabbar5",
                          //                          @"title" : @"附近的活动"
                          }]
                      ];
//    [self setToolbarBadge:[model.speak integerValue]];
    [_tableView reloadData];
}


-(void)setToolbarBadge:(NSInteger)count
{
    
    if (count !=0) {
        if (count > 99)
        {
            [self.navigationController.tabBarItem setBadgeValue:@"99+"];
        }
        else
        {
            [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",count]];
        }
    }else
    {
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [self.navigationController.tabBarItem setBadgeValue:nil];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GlobalMessageTip" object:nil];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _iconAndTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_iconAndTitle[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DiscoverCell";
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"DiscoverCell" owner:self options:nil][0];
        cell = [[DiscoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *info = _iconAndTitle[indexPath.section][indexPath.row];
    cell.dic = info;
//    cell.icon.image = [UIImage imageNamed:info[@"image"]];
//    cell.title.text = info[@"title"];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(43);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //            WPJobViewController *job = [[WPJobViewController alloc] init];
        //            job.reqJobType = JobTypeDynamic;
        //            job.title = @"职场动态";
//        NewJobViewController *job = [[NewJobViewController alloc] init];
//        //            job.reqJobType = JobTypeDynamic;
//        job.title = @"职场动态";
//        [self.navigationController pushViewController:job animated:YES];
        
//        SecondJobViewController *job = [[SecondJobViewController alloc] init];
//        job.title = @"工作圈";
//        [self.navigationController pushViewController:job animated:YES];
//        ThirdJobViewController *thirdJob = [[ThirdJobViewController alloc] init];
//        thirdJob.title = @"工作圈";
//        [self.navigationController pushViewController:thirdJob animated:YES];

        ThirdJobViewController_New *thirdJob = [[ThirdJobViewController_New alloc] init];
//        thirdJob.messageArray = self.iconAndTitle;
//        thirdJob.title = @"职场说说";
//        WPTipModel *model = [WPTipModel sharedManager];//进入时是否需要刷新
        [self.navigationController pushViewController:thirdJob animated:YES];
    }
//    else if (indexPath.section == 1) {
//        NSLog(@"奇葩需求");
////        DemandViewController *demand = [[DemandViewController alloc] init];
////        [self.navigationController pushViewController:demand animated:YES];
//        
//        NewDemandViewController *demand = [[NewDemandViewController alloc] init];
//        demand.title = @"奇葩需求";
//        [self.navigationController pushViewController:demand animated:YES];
//        
//    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //附近人脉
            WPNearbyPeopleController *nearby = [[WPNearbyPeopleController alloc] init];
            [self.navigationController pushViewController:nearby animated:YES];
        } else if (indexPath.row == 1) {
            //职场群组
            WPDynamicGroupViewController *group = [[WPDynamicGroupViewController alloc] init];
            [self.navigationController pushViewController:group animated:YES];
        }
    }
//    else if (indexPath.section == 2) {
//            NSLog(@"附近的活动");
//            OtherActivityController *activity = [[OtherActivityController alloc] init];
//            activity.title = @"附近的活动";
//            [self.navigationController pushViewController:activity animated:YES];
//
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self performSelector:@selector(unselectCell:) withObject:nil afterDelay:0.5];
}

-(void)unselectCell:(id)sender{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

//- (UIView*)bottomView
//{
//    if (_bottomView == nil) {
//        //_bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height - 198)];
//        _bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 49)];
//        _bottomView.contentSize = CGSizeMake(SCREEN_WIDTH, self.photoWallHeight + self.cellBtnHeight*4);
//        _bottomView.showsVerticalScrollIndicator = NO;
//        _bottomView.showsHorizontalScrollIndicator = NO;
////        _bottomView.backgroundColor = WPColor(233, 233, 233);
//        _bottomView.backgroundColor = [UIColor whiteColor];
//        NSArray* arrayTitle = @[ @"职场动态", @"奇葩需求", @"附近的人", @"附近的群",@"附近的活动", @"职场正能量", @"职场吐槽",@"管理智慧", @"创业心得", @"情感心语" ];
//        CGSize nomalSize = [@"我是" sizeWithFont:[UIFont systemFontOfSize:12]];
//        CGFloat width = SCREEN_WIDTH/3;
//        CGFloat height = (SCREEN_HEIGHT - 64 - 49 - self.photoWallHeight)/4;
//        CGFloat x = (width - 27)/2;
//        CGFloat y = (self.cellBtnHeight - nomalSize.height - 6 - 27)/2;
//        
//        for (int i = 0; i < arrayTitle.count; i++) {
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.layer.borderColor = RGBColor(226, 226, 226).CGColor;
//            //            button.layer.borderColor = [UIColor redColor].CGColor;
//            button.layer.borderWidth = 0.25;
//            button.frame = CGRectMake((i%3)*width, self.photoWallHeight + (i/3)*self.cellBtnHeight, width, self.cellBtnHeight);
//            [button setBackgroundImage:[UIImage imageNamed:@"videoPlaceImage"] forState:UIControlStateHighlighted];
//            button.backgroundColor = [UIColor clearColor];
//            button.tag = i+1;
//            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//            [_bottomView addSubview:button];
////            [self createButtonxPos:(i % 2 == 0 ? 0 : SCREEN_WIDTH/2)yPos:(i / 2 * MRBOTTOM + 180)title:arrayTitle[i] imageName:[NSString stringWithFormat:@"discover_cell_%d-1", i + 1] tag:i];
////            [self createButtonxPos:(i%3)*(SCREEN_WIDTH/3) yPos:180 + (i/3)*69 title:arrayTitle[i] imageName:[NSString stringWithFormat:@"discover_cell_%d", i + 1] tag:i];
//            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(x + (i%3)*width, self.photoWallHeight + y + (i/3)*self.cellBtnHeight, 27, 27)];
//            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"discover_cell_%d",i+1]];
//            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((i%3)*width, image.bottom + 6, width, nomalSize.height)];
//            title.text = arrayTitle[i];
//            title.textAlignment = NSTextAlignmentCenter;
//            title.font = [UIFont systemFontOfSize:12];
//            [_bottomView addSubview:image];
//            [_bottomView addSubview:title];
//            
//        }
//        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(width, self.photoWallHeight + self.cellBtnHeight*3, 2*width, 0.5)];
//        line.backgroundColor = RGBColor(226, 226, 226);
//        [_bottomView addSubview:line];
//        
//        if (SCREEN_WIDTH == 320) {
//            UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.photoWallHeight + self.cellBtnHeight*4, width, 0.5)];
//            line1.backgroundColor = RGBColor(226, 226, 226);
//            [_bottomView addSubview:line1];
//        }
//        
//        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(width, self.photoWallHeight + self.cellBtnHeight*3, 0.5, self.cellBtnHeight)];
//        line2.backgroundColor = RGBColor(226, 226, 226);
//        [_bottomView addSubview:line2];
//    }
//    
//    
//    return _bottomView;
//}
//
//- (void)setUpCollectionView
//{
//    NSLog(@"%f",self.photoWallHeight);
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, self.photoWallHeight) collectionViewLayout:self.flowLayout];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    self.collectionView.showsHorizontalScrollIndicator = NO;
//    self.collectionView.showsVerticalScrollIndicator = NO;
//    self.collectionView.backgroundColor = [UIColor whiteColor];
//    
//    self.collectionView.scrollEnabled = YES;
//    self.collectionView.pagingEnabled = YES;
//    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.collectionView registerNib:[UINib nibWithNibName:@"HMNewsCell" bundle:nil] forCellWithReuseIdentifier:HMCellIdentifier];
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:HMMaxSections / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//    
//    [self.bottomView addSubview:self.collectionView];
//}
//
//- (void)createButtonxPos:(CGFloat)xPos yPos:(CGFloat)yPos title:(NSString*)title imageName:(NSString*)image tag:(NSInteger)tagIndex
//{
////    WPDiscoverButton* buttonOne = [[WPDiscoverButton alloc] init];
////    [buttonOne setFrame:CGRectMake(xPos,yPos, SCREEN_WIDTH/3, 69)];
////    [buttonOne setTitle:title forState:UIControlStateNormal];
////    [buttonOne setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
////    buttonOne.titleLabel.font=[UIFont systemFontOfSize:14];
////    buttonOne.layer.borderColor = [UIColor lightGrayColor].CGColor;
////    buttonOne.layer.borderWidth = 0.5;
////    
////    [buttonOne setTag:tagIndex];
////    [buttonOne addTarget:self action:@selector(buttonClickDiscovery:) forControlEvents:UIControlEventTouchDown];
////    [_bottomView addSubview:buttonOne];
//}
//
//- (void)buttonClick:(UIButton *)sender
//{
//    NSLog(@"点击");
//    switch (sender.tag) {
//        case 1:
//        {
////            WPJobViewController *job = [[WPJobViewController alloc] init];
////            job.reqJobType = JobTypeDynamic;
////            job.title = @"职场动态";
//            NewJobViewController *job = [[NewJobViewController alloc] init];
////            job.reqJobType = JobTypeDynamic;
//            job.title = @"职场动态";
//            [self.navigationController pushViewController:job animated:YES];
//        }
//            break;
//        case 2:
//        {
//            NSLog(@"奇葩需求");
//            DemandViewController *demand = [[DemandViewController alloc] init];
//            [self.navigationController pushViewController:demand animated:YES];
//        }
//            break;
//        case 3:
//        {
//            NSLog(@"附近的人");
//        }
//            break;
//        case 4:
//        {
//            NSLog(@"附近的群");
//        }
//            break;
//        case 5:
//        {
//            NSLog(@"附近的活动");
//        }
//            break;
//        case 6:
//        {
//            NSLog(@"职场正能量");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypePositiveEnergy;
//            vc.title = @"职场正能量";
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case 7:
//        {
//            NSLog(@"职场吐槽");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypeSpit;
//            vc.title = @"职场吐槽";
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case 8:
//        {
//            NSLog(@"管理智慧");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypeManage;
//            vc.title = @"管理智慧";
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case 9:
//        {
//            NSLog(@"创业心得");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypePoineering;
//            vc.title = @"创业心得";
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case 10:
//        {
//            NSLog(@"情感心语");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypeEmotion;
//            vc.title = @"情感心语";
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//
//        default:
//            break;
//    }
//}
//
//- (void)buttonClickDiscovery:(UIButton*)sender
//{
//    switch (sender.tag)
//    {
//        case 0:
//            {
//               
////                WPJobsController* smallone = [[WPJobsController alloc]init];
////                [self.navigationController pushViewController:smallone animated:YES];
//                WPJobViewController *job = [[WPJobViewController alloc] init];
//                job.reqJobType = JobTypeDynamic;
//                job.title = @"职场动态";
//                [self.navigationController pushViewController:job animated:YES];
//                break;
//
//                break;
//            }
//            
//        case 1:
//            {
//                WPPeopleViewController* people = [[WPPeopleViewController alloc]init];
//                [self.navigationController pushViewController:people animated:YES];
//                break;
//            }
//         case 2:
//        {
//            NSLog(@"职场问答");
//            QuestionsViewController *question = [[QuestionsViewController alloc] init];
//            [self.navigationController pushViewController:question animated:YES];
//            break;
//        }
//         case 3:
//        {
//            NSLog(@"奇葩需求");
//            DemandViewController *demand = [[DemandViewController alloc] init];
//            [self.navigationController pushViewController:demand animated:YES];
//            break;
//        }
//        case 4:
//        {
//            NSLog(@"职场正能量");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypePositiveEnergy;
//            vc.title = @"职场正能量";
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 5:
//        {
//            NSLog(@"职场吐槽");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypeSpit;
//            vc.title = @"职场吐槽";
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 6:
//        {
//            NSLog(@"职场心理学");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypePsychology;
//            vc.title = @"职场心理学";
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 7:
//        {
//            NSLog(@"管理智慧");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypeManage;
//            vc.title = @"管理智慧";
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 8:
//        {
//            NSLog(@"创业心得");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypePoineering;
//            vc.title = @"创业心得";
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 9:
//        {
//            NSLog(@"情感心语");
//            WPJobViewController *vc = [[WPJobViewController alloc] init];
//            vc.reqJobType = JobTypeEmotion;
//            vc.title = @"情感心语";
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        default:
//        break;
//    }
//}
//- (NSArray*)buttonArray
//{
//    if (_buttonArray == nil) {
//        _buttonArray = [NSArray array];
//    }
//    return _buttonArray;
//}
//
//- (UICollectionViewFlowLayout*)flowLayout
//{
//    if (_flowLayout == nil) {
//        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//        
//        CGSize screenSize = [UIScreen mainScreen].bounds.size;
//        [flowLayout setItemSize:CGSizeMake(SCREEN_WIDTH, self.photoWallHeight)];
//
//        [flowLayout setHeaderReferenceSize:CGSizeMake(0, 0)];
//        [flowLayout setFooterReferenceSize:CGSizeMake(0, 0)];
//        [flowLayout setMinimumLineSpacing:0];
//        [flowLayout setMinimumInteritemSpacing:0];
//        [flowLayout setSectionInset:UIEdgeInsetsZero];
//        _flowLayout = flowLayout;
//    }
//    return _flowLayout;
//}
//
////需要根据图片数量进行修改
//- (NSArray*)newses
//{
//
//    if (_newses == nil) {
//        NSMutableArray* array = [NSMutableArray array];
//        for (int i = 0; i < 3; ++i) {
//            HMNews* news = [[HMNews alloc] init];
//            news.icon = [NSString stringWithFormat:@"discover_%d.jpg", i + 1];
//            [array addObject:news];
//        }
//        _newses = array;
//    }
//
//    return _newses;
//}
//
//- (UIPageControl*)pageContol
//{
//    if (_pageContol == nil) {
//        _pageContol = [[UIPageControl alloc] init];
//        _pageContol.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 30, self.photoWallHeight - 20, 50, 20);
//        _pageContol.tintColor = [UIColor blueColor];
//        _pageContol.currentPageIndicatorTintColor = [UIColor whiteColor];
//        _pageContol.pageIndicatorTintColor = WPColor(153, 153, 153);
//        self.pageContol.numberOfPages = 3;
//    }
//    return _pageContol;
//}
//
//
//
//- (void)addTimer
//{
//    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    self.timer = timer;
//}
//
//
//- (void)removeTimer
//{
//    [self.timer invalidate];
//    self.timer = nil;
//}
//
//- (NSIndexPath*)resetIndexPath
//{
//
//    NSIndexPath* currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
//    NSIndexPath* currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:HMMaxSections / 2];
//    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//    return currentIndexPathReset;
//}
//
//
//- (void)nextPage
//{
//    NSIndexPath* currentIndexPathReset = [self resetIndexPath];
//
//
//    NSInteger nextItem = currentIndexPathReset.item + 1;
//    NSInteger nextSection = currentIndexPathReset.section;
//    if (nextItem == self.newses.count) {
//        nextItem = 0;
//        nextSection++;
//    }
//    NSIndexPath* nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
//
//    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//}
//
//#pragma mark - UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.newses.count;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
//{
//    return HMMaxSections;
//}
//
//- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
//{
//    HMNewsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:HMCellIdentifier forIndexPath:indexPath];
//
//    cell.news = self.newses[indexPath.item];
//
//    return cell;
//}
//
//#pragma mark - UICollectionViewDelegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
//{
//    [self removeTimer];
//}
//
//
//- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self addTimer];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView*)scrollView
//{
//    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.newses.count;
//    self.pageContol.currentPage = page;
//}

@end
