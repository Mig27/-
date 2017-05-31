//
//  DetailsViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/1/7.
//  Copyright © 2016年 WP. All rights reserved.
//  他人的详细资料

#import "DetailsViewController.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "WPIVManager.h"
#import "WPIVModel.h"
#import "WPPersonalAlbumController.h"
#import "WPInfoController.h"
#import "WPInfoManager.h"
#import "WPPersonalDetailInfoCell.h"
#import "SAYPhotoManagerViewController.h"
#import "SPPhotoBrowser.h"
#define PhotoTag 50
@interface DetailsViewController ()<UIWebViewDelegate,UpdateInfoDelegate,WPInfoManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic ,strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray * heightArray;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSMutableArray * contentArray;
@property (nonatomic, strong) UITableView*infoTableview;
@property (nonatomic, strong) UIView*photoBaseView;
@property (nonatomic, strong) UIScrollView * photoView;

@end

@implementation DetailsViewController

- (UIScrollView *)photoView{
    if (!_photoView) {
        _photoView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,8, SCREEN_WIDTH-28, PhotoViewHeight)];
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoView.showsHorizontalScrollIndicator = NO;
    }
    return _photoView;
}

- (UIView *)photoBaseView
{
    if (!_photoBaseView) {
        _photoBaseView = [[UIView alloc]init];
        
        CGFloat height = 8;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ItemViewHeight+8)];
        view.backgroundColor = RGB(235, 235, 235);
    
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PhotoViewHeight)];
        view2.backgroundColor = RGB(235, 235, 235);//RGB(235, 235, 235)
        [view2 addSubview:self.photoView];
        
        [_photoBaseView addSubview:view];
        [_photoBaseView addSubview:view2];
        _photoBaseView.frame = CGRectMake(0, 8, SCREEN_WIDTH, height+view2.height);
        
        
        /** 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-28, view2.top+8, 28, PhotoViewHeight) ImageName:@"jinru" Target:self Action:@selector(photosViewClick:)];
        
        scrollBtn.backgroundColor = [UIColor whiteColor];
        
        [_photoBaseView addSubview:scrollBtn];
        
        _photoBaseView.hidden = YES;
    }
    return _photoBaseView;
}
-(void)photosViewClick:(UIButton *)sender
{
    
    WPPersonalAlbumController *album = [[WPPersonalAlbumController alloc] init];
    album.friend_id = self.userID;
    [self.navigationController pushViewController:album animated:YES];
//    WPInfoManager *manager = [WPInfoManager sharedManager];
//    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
//    vc.arr =  manager.model.ImgPhoto;//将图片数组和视频数组赋值
////    vc.videoArr = self.vedioArray;
////    vc.isEdit = YES;
////    vc.delegate = self;
//    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
//    [self presentViewController:navc animated:YES completion:nil];
}
-(UITableView*)infoTableview
{
    if (!_infoTableview) {
        _infoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _infoTableview.delegate = self;
        _infoTableview.dataSource = self;
        _infoTableview.tableHeaderView = self.photoBaseView;
        _infoTableview.backgroundColor = RGB(235, 235, 235);
        _infoTableview.showsHorizontalScrollIndicator = NO;
        _infoTableview.showsVerticalScrollIndicator = NO;
    }
    return _infoTableview;
}
-(NSMutableArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
//        NSArray * array = @[@[@"名   称",@"快聘号",@"性   别",@"年    龄",@"个性签名"],@[@"所在企业",@"职   位",@"工作地点",@"生活地点"],@[@"学   历",@"毕业学校",@"爱好兴趣",@"擅   长",@"家   乡"]];
//        [_titleArray addObjectsFromArray:array];
    }
    return _titleArray;
}
-(NSMutableArray*)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}
-(NSMutableArray*)heightArray
{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}
- (NSMutableArray *)array
{
    if (!_array) {
        self.array = [NSMutableArray array];
    }
    return _array;
}

- (NSInteger)getCurrentIndexPathWithUrl:(NSString *)urlStr
{
    int i = 0;
    for (Pohotolist *model in [WPIVManager sharedManager].model.ImgPhoto) {
        if ([model.original_path isEqualToString:urlStr]) {
            return i;
        }
        i++;
    }
    return 0;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/user_info.aspx?user_id=%@",IPADDRESS,self.userID];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    WPIVManager *manager = [WPIVManager sharedManager];
    manager.fk_id = self.userID;
    manager.fk_type = @"5";
    [manager requsetForImageAndVideo];
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    
    if (self.isMySelf)
    {
        
        [self.view addSubview:self.infoTableview];
        WPInfoManager *manager = [WPInfoManager sharedManager];
        manager.delegate = self;
        [manager requestForWPInFo];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 70, 30);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(15);
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = item;
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        UIWebView *webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        webView.dataDetectorTypes=UIDataDetectorTypeAll;
        webView.backgroundColor= RGBColor(226, 226, 226);
        self.webView = webView;
        webView.delegate=self;
        NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/user_info.aspx?user_id=%@",IPADDRESS,self.userID];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self.view addSubview:webView];
        
        for (UIView * view in webView.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                UIScrollView * scroller = (UIScrollView*)view;
                scroller.bounces = NO;
            }
        }
    }
//    UIWebView *webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    webView.dataDetectorTypes=UIDataDetectorTypeAll;
//    webView.backgroundColor= RGBColor(226, 226, 226);
//    self.webView = webView;
//    webView.delegate=self;
//    NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/user_info.aspx?user_id=%@",IPADDRESS,self.userID];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//    [self.view addSubview:webView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackWithCount:) name:@"refreshWebView" object:nil];
    
//    for (UIView * view in webView.subviews) {
//        if ([view isKindOfClass:[UIScrollView class]]) {
//            UIScrollView * scroller = (UIScrollView*)view;
//            scroller.bounces = NO;
//        }
//    }
//    
//    if (self.isMySelf) {
//        
//        WPInfoManager *manager = [WPInfoManager sharedManager];
//        manager.delegate = self;
//        [manager requestForWPInFo];
//        
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, 70, 30);
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitle:@"编辑" forState:UIControlStateNormal];
//        button.titleLabel.font = kFONT(15);
//        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.rightBarButtonItem = item;
//        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    }
}

#pragma mark 请求个人数据的代理
- (void)reloadData
{
    
    [self.titleArray removeAllObjects];
    [self.contentArray removeAllObjects];
    [self.heightArray removeAllObjects];
    _photoBaseView.hidden = NO;
    
   WPInfoManager *manager = [WPInfoManager sharedManager];
    NSMutableArray * heightArr = [NSMutableArray array];
    NSMutableArray * content = [NSMutableArray new];
    NSArray * array = @[manager.model.nickName,manager.model.wpId,manager.model.sex,manager.model.birthday,manager.model.signature,manager.model.company,manager.model.position,manager.model.workAddress,manager.model.address,manager.model.education,manager.model.school,manager.model.hobby,manager.model.specialty,manager.model.hometown];
    for (NSString * string  in array)
    {
        if (string.length && ![string isEqualToString:@"(null)"])
        {
            CGSize size = [string getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-kHEIGHT(80)-kHEIGHT(10)];
            [heightArr addObject:[NSString stringWithFormat:@"%f",size.height]];
            [content addObject:string];
        }
        else
        {
            [heightArr addObject:@"0"];
            [content addObject:@""];
        }
    }
    
    NSArray * allArray = @[@"姓        名:",@"快聘号:",@"性        别:",@"年        龄:",@"个性签名:",@"所在企业:",@"职        位:",@"工作地点:",@"生活地点:",@"学        历:",@"毕业学校:",@"爱好兴趣:",@"擅        长:",@"家        乡:"];
    //添加应有的高度和title
    NSMutableArray * allArr = [NSMutableArray array];
    NSMutableArray * allArr1 = [NSMutableArray array];
    NSMutableArray * allArr2 = [NSMutableArray array];
    
    NSMutableArray * muarr = [NSMutableArray array];
    NSMutableArray * muarr1 = [NSMutableArray array];
    NSMutableArray * muarr2 = [NSMutableArray array];
    
    for (int i = 0 ; i < heightArr.count; i++) {
        if (i <= 4) {
            NSString * string = heightArr[i];
            if (string.intValue) {
                [muarr addObject:string];
                [allArr addObject:allArray[i]];
            }
        }
        else if (i <=8)
        {
            NSString * string = heightArr[i];
            if (string.intValue) {
                [muarr1 addObject:string];
                [allArr1 addObject:allArray[i]];
            }
        }
        else
        {
            NSString * string = heightArr[i];
            if (string.intValue) {
                [muarr2 addObject:string];
                [allArr2 addObject:allArray[i]];
            }
        }
    }
    muarr.count?[self.heightArray addObject:[NSArray arrayWithArray:muarr]]:0;
    muarr1.count?[self.heightArray addObject:[NSArray arrayWithArray:muarr1]]:0;
    muarr2.count?[self.heightArray addObject:[NSArray arrayWithArray:muarr2]]:0;
    
    
    allArr.count?[self.titleArray addObject:[NSArray arrayWithArray:allArr]]:0;
    allArr1.count?[self.titleArray addObject:[NSArray arrayWithArray:allArr1]]:0;
    allArr2.count?[self.titleArray addObject:[NSArray arrayWithArray:allArr2]]:0;

    //添加内容
    NSMutableArray * muar = [NSMutableArray array];
    NSMutableArray * muar1 = [NSMutableArray array];
    NSMutableArray * muar2 =[NSMutableArray array];
    for (int i = 0 ; i < content.count; i++) {
        if (i <= 4) {
            NSString * string = content[i];
            if (string.length) {
                [muar addObject:string];
            }
        }
        else if (i <=8)
        {
            NSString * string = content[i];
            if (string.length) {
                [muar1 addObject:string];
            }
        }
        else
        {
            NSString * string = content[i];
            if (string.length) {
                [muar2 addObject:string];
            }
        }
    }
    muar.count?[self.contentArray addObject:[NSArray arrayWithArray:muar]]:0;
    muar1.count?[self.contentArray addObject:[NSArray arrayWithArray:muar1]]:0;
    muar2.count?[self.contentArray addObject:[NSArray arrayWithArray:muar2]]:0;
    
    [self.infoTableview reloadData];
    [self updateImage];
}
-(void)updateImage
{
    WPInfoManager *manager = [WPInfoManager sharedManager];
    for (int i = 0; i < manager.model.ImgPhoto.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        button.tag = PhotoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[manager.model.ImgPhoto[i] thumb_path]]];
        [button sd_setImageWithURL:url forState:UIControlStateNormal];
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoView addSubview:button];
    }
    NSInteger count = manager.model.ImgPhoto.count;
    self.photoView.contentSize = CGSizeMake(count*(PhotoHeight+kHEIGHT(6))+PhotoHeight+kHEIGHT(12), PhotoViewHeight);
    
    if (!manager.model.ImgPhoto.count) {
        self.photoBaseView = nil;
    }
    
    
}
-(void)checkImageClick:(UIButton*)btn
{
    //NSLog(@"当前按钮的tag值是多少 == %ld",(long)btn.tag );
    WPInfoManager *manager = [WPInfoManager sharedManager];
    [self showPhotoBrowserWithPhotoArray:manager.model.ImgPhoto url:[manager.model.ImgPhoto[btn.tag-50] original_path] withSender:btn];
}
#pragma mark 点击编辑
-(void)clickBtn:(UIButton*)btn
{
    WPInfoController *info = [[WPInfoController alloc]init];
    info.title = @"个人资料";
    info.delegate = self;
    [self.navigationController pushViewController:info animated:YES];

}

#pragma mark 个人资料更新代理
-(void)UpdateInfoDelegate
{
    WPInfoManager *manager = [WPInfoManager sharedManager];
    manager.delegate = self;
    [manager requestForWPInFo];
//    [self.webView reload];
    if (self.upDataInfo) {
        self.upDataInfo();
    }
    //更新图片
    [[WPIVManager sharedManager] requsetForImageAndVideo];
}

-(void)callBackWithCount:(NSNotification *)notice{
    self.userID  = notice.userInfo[@"UserId"];
    NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/user_info.aspx?user_id=%@",IPADDRESS,self.userID];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

-(void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *str = request.URL.relativeString;
    NSArray *array = [str componentsSeparatedByString:@"="];
    NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/photo_users.aspx?phpto_url",IPADDRESS];
    NSString *url2 = [NSString stringWithFormat:@"%@/webMobile/November/photo_users.aspx?user_id",IPADDRESS];
    NSString *url3 = [NSString stringWithFormat:@"%@/webMobile/November/PhotoAndVideo.aspx?fk_id",IPADDRESS];
    if ([array[0] isEqualToString:url]) {
        NSString *urlstr1 = array[1];
        NSArray *arr2 = [urlstr1 componentsSeparatedByString:@"&"];   // 点击的当前图片
        NSArray *images = [WPIVManager sharedManager].model.ImgPhoto;  //全部图片
        [self showPhotoBrowserWithPhotoArray:images url:arr2[0] withSender:nil];
        return NO;
    }else if ([array[0] isEqualToString:url2]){
        return NO;
    }else if([array[0] isEqualToString:url3]){
        WPPersonalAlbumController *album = [[WPPersonalAlbumController alloc] init];
        album.friend_id = self.userID;
        [self.navigationController pushViewController:album animated:YES];
    }
    return YES;
}

//点击查看图片,/个人的是原生/其他人是web
- (void)showPhotoBrowserWithPhotoArray:(NSArray *)array url:(NSString *)urlStr withSender:(id)sender
{
    NSInteger count = array.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    [self removeAllImageViews];
    for (int i = 0; i<array.count; i++) {
        Pohotolist *list = array[i];
        NSString *url = [IPADDRESS stringByAppendingString:list.original_path];
        
        MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:url];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        
        if (self.isMySelf) { //个人主页
            imageView.frame = ((UIButton *)sender).frame;
            imageView.center = CGPointMake(((UIButton *)sender).center.x, ((UIButton *)sender).center.y + 72);
        }else{  //网页
            imageView.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
            imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        }

        [self.view addSubview:imageView];
        photo.toView = imageView;
        [self.array addObject:imageView];
        [self.view sendSubviewToBack:imageView];
        [photos addObject:photo];
    }
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.isDetail = YES;
    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
//    photoBrowser.isNewZoom = YES;
    photoBrowser.photos = photos;
    photoBrowser.isNeedShow = YES;
       photoBrowser.currentStr = [IPADDRESS stringByAppendingString:urlStr];
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:[self getCurrentIndexPathWithUrl:urlStr] inSection:0];
     photoBrowser.reloadIndex = [NSIndexPath indexPathForItem:[self getCurrentIndexPathWithUrl:urlStr] inSection:0];;
    // 展示控制器
    [photoBrowser showPickerVc:self];
    
    
    
//    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
//    photoBrowser.isDetail = self.isDetail;
//    //缩放动画
//    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
//    photoBrowser.photos = photos;
//    photoBrowser.isNeedShow = YES;
//    photoBrowser.currentStr = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][tap.view.tag - 1][@"small_address"]];
//    photoBrowser.reloadIndex = self.index;
//    //当前选中的值
//    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:tap.view.tag - 1 inSection:0];
//    //展示控制器
//    [photoBrowser showPickerVc:[self viewController]];
    
    
    
    
}
- (void)removeAllImageViews
{
    for (UIImageView *imageView in self.array) {
        [imageView removeFromSuperview];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.heightArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.heightArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString * string = @"哈哈";
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGFloat distance = (kHEIGHT(43)-size.height)/2;
    CGFloat heigh;
    if ([self.heightArray[indexPath.section][indexPath.row] floatValue]+2*distance<=kHEIGHT(43)) {
        heigh = kHEIGHT(43);
    }
    else
    {
        heigh = [self.heightArray[indexPath.section][indexPath.row] floatValue]+2*distance;
    }
    return heigh;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * refursedID = @"WPPersonalDetailInfoCellID";
    WPPersonalDetailInfoCell*cell = [self.infoTableview dequeueReusableCellWithIdentifier:refursedID];
    if (!cell) {
        cell = [[WPPersonalDetailInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:refursedID];
    }
    cell.titleLLabel.text = self.titleArray[indexPath.section][indexPath.row];
//    cell.contentLabel.text = self.contentArray[indexPath.section][indexPath.row];
    cell.content = self.contentArray[indexPath.section][indexPath.row];
    cell.selectionStyle = NO;
    return cell;
}
@end
