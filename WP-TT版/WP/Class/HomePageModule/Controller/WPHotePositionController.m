//
//  WPHotePositionController.m
//  WP
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 WP. All rights reserved.
//

static NSString *kcellIdentifier = @"collectionCellID";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kfooterIdentifier = @"footerIdentifier";
static NSString *kfooterNullIdentifier = @"footerNullIdentifier";

#import "WPHotePositionController.h"
#import "WPHotHeaderCell.h"
#import "WPHotFooterCell.h"
#import "WPHotNullCell.h"
#import "WPHotPositionCell.h"
#import "WPHotCompanyCell.h"
#import "WPHotPositionModel.h"
#import "WPHotCompanyModel.h"
#import "UIImageView+WebCache.h"
#import "WPHotRecruitController.h"
#import "NearInterViewController.h"
#import "WPSchoolViewController.h"
#import "WPAllSearchController.h"
#import "WPInterviewController.h"
#import "WPRecruitController.h"
#import "WPActionSheet.h"
#import "WPHotIndustryModel.h"
#import "WPNewResumeController.h"
#import "WPHotCompanyInfoController.h"
#import "MTTDatabaseUtil.h"
#import "WPFlowLayout.h"
#import "UISelectCity.h"
#import "WPCollectionBlankCell.h"
#import "WPRecruitApplyController.h"
#import "AdScrollView.h"
#import "WPDownLoadVideo.h"
@implementation WPHotStateModel

@end

@interface WPHotePositionController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,WPActionSheet,UIScrollViewDelegate,UISelectDelegate>
{
    NSInteger companyPage;
    NSInteger industryPage;
    NSInteger postionPage;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *positionArray;//专区
//@property (strong, nonatomic) NSMutableArray *areaArray;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSMutableArray *companyArray;//公司
@property (strong, nonatomic) NSMutableArray *industryArray;//职位
@property (strong, nonatomic) NSMutableArray *stateArray;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) WPActionSheet *actionSheet;
@property (strong, nonatomic) AdScrollView* scroller;
@property (strong, nonatomic) UIPageControl*page;
@property (strong, nonatomic) NSTimer * timer;
@property (nonatomic, strong) UIView *rightBlackView; /**< 点击创建的时候在TabBar上加一个半透明背景 */
@property (nonatomic, strong) NSMutableArray * urlArray;
@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UIImageView * leftImage;
@property (nonatomic, strong) UISelectCity * city;

@property (nonatomic, strong) UIImageView * leftImageView;
@property (nonatomic, strong) UIImageView * centerImageView;
@property (nonatomic, strong) UIImageView * rightImageView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) BOOL isFirst;
@property (strong, nonatomic) SPIndexPath *citySelectedNumber;
//@property (assign, nonatomic) BOOL positionState;
//@property (assign, nonatomic) BOOL companyState;

@end

@implementation WPHotePositionController
- (UISelectCity *)city
{
    if (!_city) {
        _city = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _city.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+40)];
        subView1.tag = 3345;//1000
        subView1.backgroundColor = RGBA(0, 0, 0, 0);
        [window addSubview:subView1];
        WS(ws);
        _city.touchHide =^(){
            [ws touchHide:nil];
        };
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
        [tap1 addTarget:self action:@selector(touchHide:)];
        [subView1 addGestureRecognizer:tap1];
        [window addSubview:_city];
    }
    return _city;
}
- (void)touchHide:(UITapGestureRecognizer *)tap{
    UIView *view1 = [WINDOW viewWithTag:3345];
    view1.hidden = YES;
    [self.city remove];
}


-(UIButton*)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _leftBtn.titleLabel.font = kFONT(14);
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        NSString * provinceStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
        CGSize size = [provinceStr sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
        size.width = size.width+5*2.25+5;
        _leftBtn.frame = CGRectMake(0, 0, size.width, size.height);
        [_leftBtn setTitle:provinceStr forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(clickLeftBnt:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn addSubview:self.leftImage];
    }
    return _leftBtn;
}

-(UIImageView*)leftImage
{
    if (!_leftImage) {
        NSString * provinceStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
        CGSize size = [provinceStr sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
        size.width = size.width;
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(size.width,(size.height-5)/2,5*2.25, 5)];
        _leftImage.image = [UIImage imageNamed:@"arrow_down"];
    }
    return _leftImage;
}
-(void)clickLeftBnt:(UIButton*)btn
{
    [btn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    btn.selected  = !btn.selected;
    if (btn.selected)
    {
        _leftImage.image = [UIImage imageNamed:@"arrow_up"];
        self.city.isArea = YES;
        self.city.isIndusty = NO;
        self.city.isCity = YES;
        self.city.isPosition = NO;
        
        //将定位的id保存以便于判断数组中应添加的类型
        [[NSUserDefaults standardUserDefaults] setObject:@"340100" forKey:@"LOCALID"];
        self.city.localName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
        self.city.localFatherName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPrivince"];
        self.city.localID = @"340100";
        self.city.localFatherId = @"340000";
        [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"340100"} citySelectedindex:_citySelectedNumber];
    }
    else
    {
        _leftImage.image = [UIImage imageNamed:@"arrow_down"];
        [self touchHide:nil];
    }
//        self.city.isArea = YES;
//        self.city.isIndusty = NO;
//        self.city.isCity = YES;
//        self.city.isPosition = NO;
//        
//        //将定位的id保存以便于判断数组中应添加的类型
//        [[NSUserDefaults standardUserDefaults] setObject:@"340100" forKey:@"LOCALID"];
//        self.city.localName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
//        self.city.localFatherName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPrivince"];
//        self.city.localID = @"340100";
//        self.city.localFatherId = @"340000";
//        [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"340100"} citySelectedindex:0];
}
- (void)citUiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model
{
    _citySelectedNumber.section = f_model.section;
    _citySelectedNumber.row = c_model.row;
    
    _leftImage.image = [UIImage imageNamed:@"arrow_down"];
    UIView *view1 = [WINDOW viewWithTag:3345];
    view1.hidden = YES;
    [self.city remove];
    NSString * adressStr = f_model.industryName;
    if (adressStr.length>4) {
       adressStr = [adressStr substringToIndex:4];
        adressStr = [adressStr stringByAppendingString:@"..."];
    }
     CGSize size = [adressStr sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    [self.leftBtn setTitle:adressStr forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    CGRect rect1 = self.leftBtn.frame;
    rect1.size.width = size.width+5*2.25+8;
    self.leftBtn.frame = rect1;
//    [self.leftBtn setBackgroundColor:[UIColor greenColor]];
    
    CGRect imageRect = _leftImage.frame;
    imageRect.origin.x = size.width;
    _leftImage.frame = imageRect;
    
    for (UIView *view in _searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"UITextField")]) {
                    UITextField *textField = (UITextField *)subview;
                    CGRect frame = textField.frame;
                    frame.origin.x = kHEIGHT(14)+size.width+5*2.25+kHEIGHT(10)+100;
                    frame.size.width = 30;//SCREEN_WIDTH-(kHEIGHT(14)+size.width+5*2.25+kHEIGHT(10))-15-2*kHEIGHT(10);
                    textField.frame = frame;
                    break;
                }
            }
            break;
        }
    }
    
    
    
}


-(NSMutableArray*)urlArray
{
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
 return _urlArray;
}
-(UIScrollView*)scroller
{
    if (!_scroller) {
        _scroller = [[AdScrollView alloc]initWithFrame:CGRectMake(0,-imageScrollerHeight, SCREEN_WIDTH, imageScrollerHeight)];
        _scroller.backgroundColor = [UIColor whiteColor];

        [self.collectionView addSubview:_scroller];
        _scroller.imageNameArray = self.urlArray;
        _scroller.PageControlShowStyle = UIPageControlShowStyleRight;
        _scroller.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _scroller.pageControl.currentPageIndicatorTintColor = RGB(0, 172, 255);
    }
    return _scroller;
}
-(void)requstImageUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"scrollerImage"];
        if (array.count) {
            [self.urlArray addObjectsFromArray:array];
            [self scroller];
        }
    });
    
    
    
    NSDictionary * dic = @{@"action":@"GetAdvertList"};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/advert.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.urlArray removeAllObjects];
            if (json[@"List"])
            {
                NSArray * array = json[@"List"];
                [self.urlArray addObjectsFromArray:array];
                [self scroller];
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"scrollerImage"];
                for (NSDictionary * dic in array) {
                    NSString * string = dic[@"img_url"];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        WPDownLoadVideo * downLoad = [[WPDownLoadVideo alloc]init];
                        [downLoad downLoadScrollerImage:[NSString stringWithFormat:@"%@%@",IPADDRESS,string] success:^(id response) {
                        } failed:^(NSError *error) {
                        }];
                    });
                }
            }
            else
            {
                NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"scrollerImage"];
                if (array.count) {
                    [self.urlArray addObjectsFromArray:array];
                    [self scroller];
                }
                else
                {
                    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                }
            }
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.urlArray removeAllObjects];
            NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"scrollerImage"];
            if (array.count) {
                [self.urlArray addObjectsFromArray:array];
                [self scroller];
            }
            else
            {
                self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _citySelectedNumber = [[SPIndexPath alloc]init];
    _citySelectedNumber.section = -1;
    _citySelectedNumber.row = -1;
    
    
    self.isFirst = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGB(226, 226, 226);
    //注释这个版本隐藏
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
//    [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 23, 23);
    [rightBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_fabu"] forState:UIControlStateNormal];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zhichangshuoshuo_fabu"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
    self.navigationItem.titleView = self.searchBar;
    postionPage = 1;
    companyPage = 1;
    industryPage = 1;
    
    [[MTTDatabaseUtil instance] getIndustry:^(NSArray *array) {
        if (array.count) {
            [self.industryArray addObjectsFromArray:array];
            [self.collectionView reloadData];
        }
    }];
    [[MTTDatabaseUtil instance] getCompanyInfo:^(NSArray *array) {
        if (array.count) {
            [self.companyArray addObjectsFromArray:array];
            [self.collectionView reloadData];
        }
        
    }];
//    [[MTTDatabaseUtil instance] getPositionInfo:^(NSArray *array) {
//        if (array.count) {
//            [self.positionArray addObjectsFromArray:array];
//            [self.collectionView reloadData];
//        }
//    }];
    
//    [self requestForPosition];
    [self requestForCompany];
    [self requestForIndustry];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       [self requstImageUrl];
    });
   
    
//    [self searchBar];
}

-(WPActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"面试求职",@"企业招聘"] imageNames:nil top:64];
        __weak typeof(self) unself = self;
        _actionSheet.touchToHide = ^(){
            [unself hideRightBlack];
        };
    }
    return _actionSheet;
}

-(UIView *)rightBlackView
{
    if (!_rightBlackView) {
        _rightBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _rightBlackView.backgroundColor = RGBA(0, 0, 0, 0.3);
        _rightBlackView.hidden = YES;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_rightBlackView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBlackViewHide:)];
        [_rightBlackView addGestureRecognizer:tap1];
    }
    return _rightBlackView;
}


-(void)rightBlackViewHide:(UITapGestureRecognizer *)tap
{
    [self hideRightBlack];
    [_actionSheet hideFromView:self.view];
}

-(void)showRightBlack
{
    self.rightBlackView.hidden = NO;
    self.rightBlackView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.rightBlackView.backgroundColor = RGBA(0, 0, 0, 0.5);
    }];
}

-(void)hideRightBlack
{
//    self.rightBlackView.hidden = YES;
    self.rightBlackView.backgroundColor = RGBA(0, 0, 0, 0.5);
    [UIView animateWithDuration:0.3 animations:^{
        self.rightBlackView.backgroundColor = [UIColor clearColor];
    }];
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
}
-(void)delay
{
    self.rightBlackView.hidden = YES;
}

- (void)rightBarButtonItemClick:(UIButton *)sender{
    if(self.actionSheet.frame.origin.y < 0&&sender.selected){
        sender.selected = !sender.selected;
    }
    sender.selected = !sender.selected;
    if(sender.selected){
        [self.actionSheet showInView:self.view];
        [self showRightBlack];
    }else{
        [self.actionSheet hideFromView:self.view];
        [self hideRightBlack];
    }
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        WPRecruitApplyController *interview = [[WPRecruitApplyController alloc]init];
        interview.title = @"创建求职简历";
        interview.isBuildNew = YES;
        interview.isBuild = YES;
        interview.isRecuilist = 0;
        [self.navigationController pushViewController:interview animated:YES];
    }
    if (buttonIndex == 2) {
        WPRecruitController *recuilist = [[WPRecruitController alloc]init];
        recuilist.title = @"创建企业招聘";
        recuilist.isRecuilist = 1;
        recuilist.model = nil;
        recuilist.isBuild = YES;
        [self.navigationController pushViewController:recuilist animated:YES];
    }
}

//- (NSMutableArray *)areaArray{
//    if (!_areaArray) {
//        _areaArray = [[NSMutableArray alloc]initWithObjects:@"五险一金",@"周末双休",@"附近工作",@"包吃包住",@"加班补助",@"应届生专区", nil];
//    }
//    return _areaArray;
//}

-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]initWithObjects:@"wuxianyijin_blue",@"zhoumoshuangxiu_blue",@"fujindegongzuo_blue",@"baochibaozhu_blue",@"jiabanbuzhu_blue",@"yingjieshengzhuanqu_blue", nil];
    }
    return _imageArray;
}

- (NSMutableArray *)positionArray{
    if (!_positionArray) {
        _positionArray = [[NSMutableArray alloc]init];
  
        NSArray * array = @[@"为我推荐",@"五险一金",@"周末双休",@"附近工作",@"包吃住专区",@"应届生专区"];
        for (NSString * string in array) {
            WPHotPositionListModel *model = [[WPHotPositionListModel alloc]init];
            model.positionName = string;
            [_positionArray addObject:model];
        }
    }
    return _positionArray;
}

- (NSMutableArray *)industryArray
{
    if (!_industryArray) {
        self.industryArray = [NSMutableArray array];
    }
    return _industryArray;
}

- (NSMutableArray *)companyArray{
    if (!_companyArray) {
        _companyArray = [[NSMutableArray alloc]init];
    }
    return _companyArray;
}

- (NSMutableArray *)stateArray{
    if (!_stateArray) {
        WPHotStateModel *model = [[WPHotStateModel alloc]init];
        model.allData = NO;
        
        WPHotStateModel *model1 = [[WPHotStateModel alloc]init];
        model1.allData = NO;
        
        WPHotStateModel *model2 = [[WPHotStateModel alloc]init];
        model2.allData = NO;
        
        _stateArray = [[NSMutableArray alloc]initWithObjects:model,model1,model2, nil];
    }
    return _stateArray;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
//        WS(ws);
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
//        _searchBar.barTintColor = [UIColor redColor];
        _searchBar.placeholder = @"关键词、职位、公司等";
        _searchBar.delegate = self;
//        _searchBar.backgroundColor = [UIColor whiteColor];
//        _searchBar.layer.borderWidth = 0.5;
//        _searchBar.layer.borderColor = RGB(226, 226, 226).CGColor;
//        _searchBar.frame = CGRectMake(0, 0, 100, 40);
//        [self.view addSubview:_searchBar];
//        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(ws.view).offset(64);
//            make.left.right.equalTo(ws.view);
//            make.height.equalTo(@(40));
//        }];
        
        for (UIView *view in _searchBar.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                for (UIView *subview in view.subviews) {
                    if ([subview isKindOfClass:NSClassFromString(@"UITextField")]) {
                        UITextField *textField = (UITextField *)subview;
                        CGRect frame = textField.frame;
                        frame.size.height = 38;
                        textField.frame = frame;
                        textField.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
                        textField.layer.borderColor = RGB(226, 226, 226).CGColor;
                        textField.layer.borderWidth= 0.5;
                        textField.layer.cornerRadius = 4;
                        textField.backgroundColor = RGB(247, 247, 247);
                        break;
                    }
                }
                break;
            }
        }
    }
    return _searchBar;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    WPAllSearchController *search = [[WPAllSearchController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:search];
    [self presentViewController:navc animated:NO completion:nil];
    
    return NO;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.sectionInset = UIEdgeInsetsZero;
//        flowLayout.minimumLineSpacing = 0.0;
//        flowLayout.minimumInteritemSpacing = 0.5;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [_collectionView setCollectionViewLayout:flowLayout];
        
        WS(ws);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGB(235, 235, 235);
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.view).offset(64);//64+imageScrollerHeight
            make.left.and.right.equalTo(ws.view);
            make.height.equalTo(@(SCREEN_HEIGHT-64-49));//SCREEN_HEIGHT-64-49-imageScrollerHeight
        }];
        _collectionView.contentInset = UIEdgeInsetsMake(imageScrollerHeight, 0, 0, 0);
        [_collectionView registerClass:[WPHotPositionCell class] forCellWithReuseIdentifier:@"WPHotPositionCellId"];
        [_collectionView registerClass:[WPHotCompanyCell class] forCellWithReuseIdentifier:@"WPHotCompanyCellId"];
        [_collectionView registerClass:[WPCollectionBlankCell class] forCellWithReuseIdentifier:@"WPCollectionBlankCellId"];
        
        //注册headerView Nib的view需要继承UICollectionReusableView
        [_collectionView registerClass:[WPHotHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
        //注册footerView Nib的view需要继承UICollectionReusableView
        [_collectionView registerClass:[WPHotFooterCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];
        [_collectionView registerClass:[WPHotNullCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterNullIdentifier];
    }
    return _collectionView;
}

//请求专区的数据
//- (void)requestForPosition{
//    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
//    NSString *page = [NSString stringWithFormat:@"%ld",postionPage];
//    NSDictionary *params = @{@"action":@"getHotIndustry",@"page":page};
//    [MBProgressHUD showMessage:@"" toView:self.view];
//    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
//        if (postionPage == 1) {
//          [[MTTDatabaseUtil instance] removePosition];
//            [self.positionArray removeAllObjects];
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        WPHotPositionModel *model = [WPHotPositionModel mj_objectWithKeyValues:json];
//        [self.positionArray addObjectsFromArray:model.list];
//        [self.collectionView reloadData];
//        if (postionPage == 1) {
//            [[MTTDatabaseUtil instance] upDatePosition:self.positionArray];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"%@",error.localizedDescription);
//    }];
//}
//请求公司的数据
- (void)requestForCompany{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
    NSString *page = [NSString stringWithFormat:@"%ld",companyPage];
    NSDictionary *params = @{@"action":@"getHotCompany",@"page":page};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        if (companyPage == 1) {
            [[MTTDatabaseUtil instance] removeCompany];
            [self.companyArray removeAllObjects];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        WPHotCompanyModel *model = [WPHotCompanyModel mj_objectWithKeyValues:json];
        if (model.list.count) {
            [self.companyArray addObjectsFromArray:model.list];
            [self.collectionView reloadData];
            if (companyPage == 1) {
                [[MTTDatabaseUtil instance] updateCompany:self.companyArray];
            }
        }
        else//没有数据
        {
            WPHotStateModel *model = self.stateArray[2];
            model.allData = YES;
            [self.collectionView reloadData];
        }
        
        
//        if (self.companyArray.count == [json[@"count"] integerValue]) {
//            WPHotStateModel *model = self.stateArray[2];
//            model.allData = YES;
//            [self.collectionView reloadData];
//        }
        
        
        
//        [self.companyArray addObjectsFromArray:model.list];
//        [self.collectionView reloadData];
//        if (companyPage == 1) {
//            [[MTTDatabaseUtil instance] updateCompany:self.companyArray];
//        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}
//请求职位的数据
- (void)requestForIndustry{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
    NSString *page = [NSString stringWithFormat:@"%ld",industryPage];
    NSDictionary *params = @{@"action":@"getHotPostion",@"page":page};//getHotIndustry
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        if (industryPage == 1) {
         [[MTTDatabaseUtil instance] removeIndustry];
            [self.industryArray removeAllObjects];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        WPHotIndustryModel *model = [WPHotIndustryModel mj_objectWithKeyValues:json];
        [self.industryArray addObjectsFromArray:model.list];
        [self.collectionView reloadData];
        if (industryPage == 1) {
            [[MTTDatabaseUtil instance] upDataIndustry:self.industryArray];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 1) {
        return self.industryArray.count;
    }
    else if (section == 0) {
        return self.positionArray.count;
    }
    else {
        if (self.companyArray.count%4) {
            return self.companyArray.count+(4-self.companyArray.count%4);
        }
        else
        {
            return self.companyArray.count;
        }
        return self.companyArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0||indexPath.section == 1) {
        static NSString *cellId = @"WPHotPositionCellId";
        WPHotPositionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        if (!cell) {
            cell = [[WPHotPositionCell alloc]initWithFrame:CGRectZero];
        }
        if (indexPath.section == 0) {
            WPHotPositionListModel *model = self.positionArray[indexPath.row];
            NSString * string = model.positionName;
            if (string.length>6) {
                string = [string substringToIndex:5];
                string = [NSString stringWithFormat:@"%@...",string];
            }
            cell.titleLabel.text = string;//model.positionName
        }
        if (indexPath.section == 1) {
            WPHotIndustryListModel *model = self.industryArray[indexPath.row];
            NSString * string = model.industryName;
            if (string.length>6) {
                string = [string substringToIndex:5];
                string = [NSString stringWithFormat:@"%@...",string];
            }
            cell.titleLabel.text = string;//model.industryName
        }
        return cell;
    }else{
        static NSString *cellId = @"WPHotCompanyCellId";
        WPHotCompanyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        if (!cell) {
            cell = [[WPHotCompanyCell alloc]initWithFrame:CGRectZero];
        }
        if (indexPath.row > self.companyArray.count-1) {
            static NSString *cellId1 = @"WPCollectionBlankCellId";
            WPCollectionBlankCell * cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:cellId1 forIndexPath:indexPath];
            if (!cell1) {
                cell1 = [[WPCollectionBlankCell alloc]initWithFrame:CGRectZero];
            }
            return cell1;
        }
        WPHotCompanyListModel *model = self.companyArray[indexPath.row];
        NSString * company = model.company_name;
        if (company.length>4) {
            company = [company substringToIndex:3];
            company = [NSString stringWithFormat:@"%@...",company];
        }
        cell.titleLabel.text = company;//model.company_name
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.logo]];
        [cell.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        
        if (indexPath.row >= self.companyArray.count-4) {
            NSString * string = @"哈哈";
            CGSize zise = [string sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
            CGFloat height = 20*3+2*kHEIGHT(45)+2*zise.height+6*2;
            cell.backView.height = (height/2)+10;
        }
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = kfooterIdentifier;
    }else{
        reuseIdentifier = kheaderIdentifier;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
        UILabel *label = (UILabel *)[view viewWithTag:1];
        label.backgroundColor = RGB(235, 235, 235);
        label.text = indexPath.section==0?@"热门专区":(indexPath.section == 1?@"热门职位":@"热门公司");
        label.font = kFONT(13);
        return view;
    }
    else{
        if (indexPath.section == 2 || indexPath.section == 1) {
            WPHotFooterCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            if (!cell) {
                 cell = [[WPHotFooterCell alloc]initWithFrame:CGRectZero];
            }
            WS(ws);
            cell.indexPath = indexPath;
            WPHotStateModel *model = self.stateArray[indexPath.section];
            [cell.titleButton setTitle:(model.allData?@"收起":@"查看更多") forState:UIControlStateNormal];
            cell.checkAllData = ^(NSIndexPath *indexPath,BOOL selected){
                [ws checkAll:indexPath Selected:YES];
            };
//            if (indexPath.section == 1) {
//                cell.isFoot = NO;
//            }
//            else
//            {
//                cell.isFoot = YES;
//            }
            return cell;
        }
        else
        {
            WPHotNullCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kfooterNullIdentifier forIndexPath:indexPath];
            return cell;
        }
//        WPHotFooterCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//        if (!cell) {
//            cell = [[WPHotFooterCell alloc]initWithFrame:CGRectZero];
//        }
//        WS(ws);
//        cell.indexPath = indexPath;
//        WPHotStateModel *model = self.stateArray[indexPath.section];
//        [cell.titleButton setTitle:(model.allData?@"收起":@"查看全部") forState:UIControlStateNormal];
//        cell.checkAllData = ^(NSIndexPath *indexPath,BOOL selected){
//            [ws checkAll:indexPath Selected:YES];
//        };
//        return  cell;
    }
}

- (void)checkAll:(NSIndexPath *)indexPath Selected:(BOOL)selected{

    if (indexPath.section == 0) { // 刷新专区
//        if (postionPage == 1) {
//            postionPage = 0;
//            [self.positionArray removeAllObjects];
//        }
//        postionPage++;
//        [self requestForPosition];
    }else if (indexPath.section == 2) {  // 刷新公司
        
         WPHotStateModel *model = self.stateArray[2];
        if (model.allData) {
            model.allData = NO;
            companyPage = 0;
            [self.companyArray removeAllObjects];
        }
        companyPage++;
        [self requestForCompany];
//        if (companyPage == 1) {
//            companyPage = 0;
//            [self.companyArray removeAllObjects];
//        }
//        companyPage++;
//        [self requestForCompany];
    }else{
        if (industryPage == 2) {  // 刷新职位
            industryPage = 0;
            [self.industryArray removeAllObjects];
        }
        WPHotStateModel *model = self.stateArray[1];
        industryPage++;
        if (industryPage == 2) {
            model.allData = YES;
        }
        else
        {
             model.allData = NO;
        }
        [self requestForIndustry];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    WPNewResumeController *search = [[WPNewResumeController alloc]init];
    search.isFromInduetry = YES;
    search.type = WPMainPositionTypeRecruit;
    if (indexPath.section == 0) {       //热门专区
        WPHotPositionListModel *model = self.positionArray[indexPath.row];
        search.title = model.positionName;
        search.titleString = model.positionName;
        search.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:search animated:YES];
    }
    else  if (indexPath.section == 1) { //热门职位
        WPHotIndustryListModel *model = self.industryArray[indexPath.row];
        search.titleString = model.industryName;
        search.positionHangID = model.industryID;
        search.hangFatherID = model.fatherID;
        search.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:search animated:YES];
    }
    else if (indexPath.section == 2) {  //热门公司
        WPHotCompanyInfoController *near = [[WPHotCompanyInfoController alloc]init];
        if (indexPath.row > self.companyArray.count-1) {
            return;
        }
        WPHotCompanyListModel *model = self.companyArray[indexPath.row];
        near.hidesBottomBarWhenPushed = YES;
        near.model = model;
        [self.navigationController pushViewController:near animated:YES];
    }
}

//cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = @"哈哈";
    CGSize zise = [string sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat height = 20*3+2*kHEIGHT(45)+2*zise.height+6*2;
    CGSize size;
    if (indexPath.section == 2)
    {
        CGFloat width = (SCREEN_WIDTH-0.00000001*3)/4;
        size = CGSizeMake(width, height/2-10);
        CGFloat num;
        if (self.companyArray.count%4)
        {
           num = self.companyArray.count+(4-self.companyArray.count%4);
        }
        else
        {
            num = self.companyArray.count;
        }
        if (indexPath.row >= num-4) {
            size = CGSizeMake(width, height/2+10);
        }
        else
        {
            size = CGSizeMake(width, height/2-10);
        }
    }
    else
    {
        CGFloat width = (SCREEN_WIDTH-0.5*2)/3;
         size = CGSizeMake(width, kHEIGHT(38));
    }
//    CGSize size = {SCREEN_WIDTH/2-0.25,kHEIGHT(43)};
    return size;
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={SCREEN_WIDTH,kHEIGHT(24)};
    return size;
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 2 || section == 1) {
     CGSize size  = {SCREEN_WIDTH,kHEIGHT(38)};
//        if (section == 1) {
//            size = CGSizeMake(SCREEN_WIDTH,kHEIGHT(38)+8);
//        }
        
     return size;
    }
    else
    {
      CGSize  size={SCREEN_WIDTH,0};
        return size;
    }
//     CGSize size  = {SCREEN_WIDTH,kHEIGHT(36)+10};
}
//////每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 2)
    {
        return 0.00000001;
    }
    else
    {
     return 0.5;
    }
//     return 0.5;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
        return 0.00000001;
    }
    else
    {
        return 0.5;
    }
//    return 0.5;
}
////选择了某个cell
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor greenColor]];
//}
////取消选择了某个cell
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor redColor]];
//}

@end
