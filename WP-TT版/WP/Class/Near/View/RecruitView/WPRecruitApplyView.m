//
//  WPRecuilistApplyView.m
//  WP
//
//  Created by CBCCBC on 15/11/6.
//  Copyright © 2015年 WP. All rights reserved.
//


#import "WPRecruitApplyView.h"
#import "BaseModel.h"
#import "SPItemView.h"
#import "SPTextView.h"
#import "SPSelectView.h"
#import "SPSelectMoreView.h"
#import "SPPhotoAsset.h"
#import "SPPhotoBrowser.h"
#import "MJPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Masonry.h"
#import "UIButton+WebCache.h"
#import "SPButton.h"
#import "WPCompanyListModel.h"
#import "WPChooseView.h"
#import "WPPerInfoView.h"
#import "WPMoreInfoView.h"
//#import "CouldnotbenNil.h"

#import "CommonTipView.h"

#define sItemTag 20

#define VideoTag 65
#define PhotoTag 50

#define WorksViewHeight 170

#define isApply(x) (x?@"1":@"0")



@interface WPRecruitApplyView () <SPPhotoBrowserDelegate,SPSelectViewDelegate,SPSelectMoreViewDelegate>

@property (strong, nonatomic) UIScrollView *baseView;   // 容器，滚动视图

@property (strong, nonatomic) WPChooseView *chooseView;

@property (strong, nonatomic) UIView *photoBaseView;    // 照片、视频 选择
@property (strong, nonatomic) UIScrollView *photoView;
@property (strong, nonatomic) UIButton *addPhotosBtn;   // 添加按钮

@property (strong, nonatomic) SPTextView *worksView;
@property (strong, nonatomic) SPSelectView *selectView;
@property (strong, nonatomic) SPSelectMoreView *selectMoreView;

//@property (strong, nonatomic) SPDateView *dateView;
@property (assign, nonatomic) NSInteger cateTag;

@property (copy, nonatomic) NSArray *listApplyArr;

@property (nonatomic ,strong)WPPerInfoView *perInfoView;
@property (nonatomic ,strong)WPMoreInfoView *moreInfoView;

@property (nonatomic ,strong)SPButton *button;
@property (nonatomic ,strong)CommonTipView *redView;
@end

@implementation WPRecruitApplyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.backgroundColor = RGB(235, 235, 235);
     
    }
    return self;
}

- (BOOL)couldnotCommit
{
    BOOL commit = NO;
    
    if (!(self.photosArray.count !=0 || self.videosArray.count != 0)) {
        
        commit = YES;
        
        [self.photoView addSubview:self.redView];
    }
    WS(ws);
    if ([self.perInfoView couldnotCommitFrameBlock:^(CGRect frame) {
        if (!commit) {
            if (frame.origin.y > kHEIGHT(43)*5) {
                [ws setOffset];
            }
        }
        
    }]) {
        commit = YES;
    }
    
    return commit;
}

- (void)setOffset
{
//    CGFloat y = frame.origin.y+self.perInfoView.origin.y+self.baseView.origin.y - SCREEN_HEIGHT+64+49;
    CGFloat height = self.baseView.contentSize.height;
//    self.baseView.contentOffset = CGPointMake(0, height-SCREEN_HEIGHT);
    [self.baseView setContentOffset:CGPointMake(0, height-SCREEN_HEIGHT+64) animated:YES];
}

#pragma mark - 添加选择界面
- (void)setAddChooseView:(BOOL)addChooseView
{
    _addChooseView = addChooseView;
    
    [self baseView];
    
    // 选择照片、视频
    [self.baseView addSubview:self.photoBaseView];
    
    // 用户个人信息
    [self.baseView addSubview:self.perInfoView];
}


-(NSMutableArray *)photosArray
{
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc]init];
    }
    return _photosArray;
}

-(NSMutableArray *)videosArray
{
    if (!_videosArray) {
        _videosArray = [[NSMutableArray alloc]init];
    }
    return _videosArray;
}

#pragma mark - baseView
- (UIScrollView *)baseView{
    if (!_baseView) {
        self.baseView = [UIScrollView new];     // 滚动视图
        [self addSubview:_baseView];
        
        WS(ws);
        [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws);
        }];
        
        if (self.addChooseView)     // 选择求职者；根据条件是否显示
        {
            [self.baseView addSubview:self.chooseView];
        }
        
    }
    return _baseView;
}

#pragma mark 选择框
-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    return _selectView;
}

-(SPSelectMoreView *)selectMoreView
{
    if (!_selectMoreView) {
        _selectMoreView = [[SPSelectMoreView alloc]initWithTop:64];
        _selectMoreView.delegate = self;
    }
    return _selectMoreView;
}

#pragma mark 选择日期
-(SPDateView *)dateView
{
    if (!_dateView) {
        __weak typeof(self) weakSelf = self;
        _dateView = [[SPDateView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-30, SCREEN_WIDTH, 216+30)];
        _dateView.getDateBlock = ^(NSString *dateStr){
            SPItemView *view = (SPItemView *)[weakSelf.baseView viewWithTag:WPRecruitApplyViewActionTypeBirthday];
            [view resetTitle:dateStr];
            weakSelf.listModel.birthday = dateStr;
        };
    }
    return _dateView;
}

#pragma mark 选择求职者；根据条件是否显示
- (WPChooseView *)chooseView
{
    if (!_chooseView)
    {
        self.chooseView = [[WPChooseView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, ItemViewHeight)];
        
        [self.chooseView.button addTarget:self action:@selector(chooseCompanyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseView;
}


- (void)setChooseViewName:(NSString *)name
{
    self.chooseView.label.text = name;
}

- (void)chooseCompanyClick{
    [self.dateView hide];
    
    if (self.pushSubController)     // 响应按钮，进入下一个VC
    {
        self.pushSubController();
    }
}

#pragma mark 选择照片、视频
-(UIView *)photoBaseView
{
    if (!_photoBaseView) {
        
        CGFloat height = 0;
        
        if (_addChooseView) {
            height = self.chooseView.bottom;
        }
        
        _photoBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, height + 8, SCREEN_WIDTH, PhotoViewHeight)];
        _photoView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-28, _photoBaseView.height)];
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoView.showsHorizontalScrollIndicator = NO;
        [_photoBaseView addSubview:_photoView];
        _addPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotosBtn.frame = CGRectMake(10, 10, PhotoHeight, PhotoHeight);
        
        [_addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"commom_gr_tianjiazhaopian"] forState:UIControlStateNormal];
        
        [_addPhotosBtn addTarget:self action:@selector(addPhotos:) forControlEvents:UIControlEventTouchUpInside];
        
        [_photoView addSubview:_addPhotosBtn];
        
        /** 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-28, _photoView.top, 28, PhotoViewHeight) ImageName:@"jinru" Target:self Action:@selector(photosViewClick:)];
        
        scrollBtn.backgroundColor = [UIColor whiteColor];
        
        [_photoBaseView addSubview:scrollBtn];
        
    }
    return _photoBaseView;
}

- (CommonTipView *)redView
{
    if (!_redView) {
        self.redView = [[CommonTipView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.redView.title = @"不能为空,至少上传一张";
        CGFloat x = SCREEN_WIDTH-8-16-8-(self.redView.size.width/2);
        self.redView.center = CGPointMake(x, self.photoView.size.height/2);
    }
    return _redView;
}

- (void)removeRedView
{
    [_addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
    [self.redView removeFromSuperview];
}

#pragma mark 选择照片、
- (void)addPhotos:(UIButton *)sender{
    [self.dateView hide];
    if (self.addPhotoBlock) {
        self.addPhotoBlock();
    }
}

- (void)photosViewClick:(UIButton *)sender{
    [self.dateView hide];
    if (self.checkALlBlock) {
        self.checkALlBlock();
    }
}

- (void)checkVideos:(NSInteger)videoTag{
    [self.dateView hide];
    if (self.checkVideoBlock) {
        self.checkVideoBlock(videoTag);
    }
}


#pragma mark 更新，选择图片
- (void)updatePhotoView{
    
    for (UIView *view in self.photoView.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.photosArray.count + self.videosArray.count == 0)
    {
        [_addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"commom_gr_tianjiazhaopian"] forState:UIControlStateNormal];
    }
    else
    {
        [_addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < self.photosArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+6)+10, 10, PhotoHeight, PhotoHeight);
        button.tag = PhotoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //        SPPhotoAsset *asset = ;
        //        [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
        if ([self.photosArray[i] isKindOfClass:[SPPhotoAsset class]]) {
            [button setImage:[self.photosArray[i] thumbImage] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArray[i] thumb_path]]];
            [button sd_setImageWithURL:url forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoView addSubview:button];
    }
    
    CGFloat width = self.photosArray.count*(PhotoHeight+6)+10;
    
    for (int i = 0; i < self.videosArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+6)+width, 10, PhotoHeight, PhotoHeight);
        button.tag = VideoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.videosArray[i] isKindOfClass:[NSString class]]) {
            [button setImage:[UIImage getImage:self.videosArray[i]] forState:UIControlStateNormal];
        }else if([self.videosArray[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = self.videosArray[i];
            [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.videosArray[i] thumb_path]]];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
        [self.photoView addSubview:button];
        
        UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(PhotoHeight/2-10, PhotoHeight/2-10, 20, 20)];
        subImageV.image = [UIImage imageNamed:@"video_play"];
        [button addSubview:subImageV];
    }
    
    if (self.photosArray.count == 12&&self.videosArray.count == 4) {
        self.photoView.contentSize = CGSizeMake(16*(PhotoHeight+6)+10, PhotoViewHeight);
    }else{
        NSInteger count = self.photosArray.count+self.videosArray.count;
        self.photoView.contentSize = CGSizeMake(count*(PhotoHeight+6)+PhotoHeight+10, PhotoViewHeight);
        _addPhotosBtn.frame = CGRectMake(count*(PhotoHeight+6)+10, 10, PhotoHeight, PhotoHeight);
        [self.photoView addSubview:_addPhotosBtn];
    }
}

#pragma mark - 个人信息
- (WPPerInfoView *)perInfoView
{
    if (!_perInfoView)
    {
        CGFloat top = self.photoBaseView.frame.origin.y + self.photoBaseView.size.height;
        
        self.perInfoView = [[WPPerInfoView alloc]initWithTop:top];
        
        WS(ws);
        
        for (SPItemView *view in self.perInfoView.viewArr) {
            view.SPItemBlock = ^(NSInteger tag){
                [ws buttonItem:tag];                // 添加对应的按钮事件
            };
            
            view.hideFromFont = ^(NSInteger tag, NSString *title){
                switch (tag-sItemTag) {
                    case WPRecruitApplyViewActionTypeName:
                        ws.listModel.name = title;
                        break;
//                    case WPRecruitApplyViewActionTypePhone:
//                        ws.model.Tel = title;
//                        break;
                }
            };
        }
        
        // 更多条件、收起
       // [self.baseView addSubview:self.button];
//      self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, self.button.bottom+kListEdge);
        
        self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, self.perInfoView.bottom+kListEdge);
    }
    return _perInfoView;
}



#pragma mark - 收起、 更多条件

- (SPButton *)button
{
    if (!_button) {
        self.button = [[SPButton alloc]initWithFrame:CGRectMake(0, self.perInfoView.bottom+kListEdge, SCREEN_WIDTH, ItemViewHeight) title:@"更多条件(可填可不填)" ImageName:@"tianjiafeiyong" Target:self Action:@selector(addMoreConditions:)];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.button.height, SCREEN_WIDTH, 8)];
        view.backgroundColor = RGB(235, 235, 235);
        [self.button addSubview:view];
    }
    return _button;
}


- (void)addMoreConditions:(SPButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.baseView addSubview:self.moreInfoView];
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.baseView bringSubviewToFront:sender];
            [sender setSelectedTitle:@"收起" imageName:@"shouqi"];
            
            sender.top = self.moreInfoView.leftCorner+8;
            self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, sender.bottom+kListEdge);
            CGFloat height = sender.origin.y-SCREEN_HEIGHT+2*(sender.size.height+kListEdge)+8;
            self.baseView.contentOffset = CGPointMake(0, height);
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [sender setSelectedTitle:@"更多条件(可填可不填)" imageName:@"tianjiafeiyong"];
            sender.top = self.perInfoView.leftCorner+8;
            self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, sender.bottom+kListEdge);
            CGFloat height = sender.origin.y-SCREEN_HEIGHT+2*(sender.size.height+kListEdge)+8;
            self.baseView.contentOffset = CGPointMake(0, height);
            
        } completion:^(BOOL finished) {
            [self.moreInfoView removeFromSuperview];
        }];
    }
    NSLog(@"%f",self.button.bottom);
}


#pragma mark 更多条件、收起
- (WPMoreInfoView *)moreInfoView
{
    if (!_moreInfoView) {
        CGFloat top = self.perInfoView.leftCorner + 8;
        self.moreInfoView = [[WPMoreInfoView alloc]initWithTop:top];
        
    }
    return _moreInfoView;
}



//- (WPRecruitApplyModel *)model{
//    if (!_model) {
//        _model = [[WPRecruitApplyModel alloc]init];
//    }
//    return _model;
//}

/*
- (void)setListModel:(WPRecruitApplyChooseDetailModel *)listModel{
    _listModel = listModel;

    if ([_listApplyArr[0] integerValue]) {
        [self.photosArray removeAllObjects];
        [self.photosArray addObjectsFromArray:_listModel.photoList];
        [self.videosArray removeAllObjects];
        [self.videosArray addObjectsFromArray:_listModel.videoList];
        [self updatePhotoView];
    }
    
    NSArray *title = @[listModel.name,listModel.sex,listModel.birthday,listModel.education,listModel.homeTown,listModel.workTime,listModel.address,listModel.tel,listModel.hopePosition,listModel.HopeSalary,listModel.hopeWelfare,listModel.HopeAddress,listModel.lightspot,listModel.educationList,listModel.workList];
    NSArray *content = @[@"name",@"sex",@"birthday",@"education",@"hometown",@"hometown",@"workTime",@"address",@"Tel",@"Position",@"hopeSalary",@"hopeWelfare",@"hopeAddress",@"lightspot",@"educationList",@"workList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    int j = 0;
    for (int i = WPRecruitApplyViewActionTypeName; i <= WPRecruitApplyViewActionTypeArea; i++) {
        SPItemView *view = (SPItemView *)[self viewWithTag:i];
        [view resetTitle:title[i-WPRecruitApplyViewActionTypeName]];
        
        [dic setObject:title[j] forKey:content[j]];
        j ++;
    }
    [self.model setValuesForKeysWithDictionary:dic];
    
    if (listModel.educationList.count) {
        SPItemView *view = (SPItemView *)[self viewWithTag:WPRecruitApplyViewActionTypeEducationList];
        [view resetTitle:@"教育经历已填写"];
    }
    
    if (listModel.workList.count) {
        SPItemView *view = (SPItemView *)[self viewWithTag:WPRecruitApplyViewActionTypeWorkList];
        [view resetTitle:@"工作经历已填写"];
    }
    
    self.model.resume_id = _listModel.resumeId;
}
*/


- (void)setListModel:(WPResumeUserInfoModel *)listModel{
    _listModel = listModel;
    
    if ([_listApplyArr[0] integerValue]) {
        [self.photosArray removeAllObjects];
        [self.photosArray addObjectsFromArray:_listModel.photoList];
        
        [self.videosArray removeAllObjects];
        [self.videosArray addObjectsFromArray:_listModel.videoList];
        
        [self updatePhotoView];
    }
    
    NSArray *title = @[listModel.name,listModel.sex,listModel.birthday,listModel.education,listModel.workTime,
                       listModel.nowSalary,listModel.marriage,listModel.homeTown,listModel.address,
                       listModel.Hope_Position,listModel.Hope_salary,listModel.Hope_address,listModel.Hope_welfare,listModel.lightspot,listModel.educationList,listModel.workList];
    
//    NSArray *content = @[@"name",@"sex",@"birthday",@"education",@"hometown",@"hometown",@"workTime",@"address",@"Tel",@"Position",@"hopeSalary",@"hopeWelfare",@"hopeAddress",@"lightspot",@"educationList",@"workList"];
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    int j = 0;
    for (int i = WPRecruitApplyViewActionTypeName; i <= WPRecruitApplyViewActionTypeArea; i++) {
        SPItemView *view = (SPItemView *)[self viewWithTag:i];
        [view resetTitle:title[i-WPRecruitApplyViewActionTypeName]];
        
//        [dic setObject:title[j] forKey:content[j]];
        j ++;
    }
//    [self.model setValuesForKeysWithDictionary:dic];
    
    if (listModel.educationList.count) {
        SPItemView *view = (SPItemView *)[self viewWithTag:WPRecruitApplyViewActionTypeEducationList];
        [view resetTitle:@"教育经历已填写"];
    }
    
    if (listModel.workList.count) {
        SPItemView *view = (SPItemView *)[self viewWithTag:WPRecruitApplyViewActionTypeWorkList];
        [view resetTitle:@"工作经历已填写"];
    }
    
//    self.model.resume_id = _listModel.resumeId;
}


-(void)checkImageClick:(UIButton *)sender
{
    if (sender.tag>=PhotoTag &&sender.tag <VideoTag) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.photosArray.count; i++) {/**< 头像或背景图 */
            MJPhoto *photo = [[MJPhoto alloc]init];
            if ([self.photosArray[i] isKindOfClass:[Pohotolist class]]) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArray[i] original_path]]];
                photo.url = url;
            }else{
                photo.image = [self.photosArray[i] originImage];
            }
            photo.srcImageView = [(UIButton *)[self.baseView viewWithTag:50+i] imageView];
            [arr addObject:photo];
        }
        SPPhotoBrowser *brower = [[SPPhotoBrowser alloc] init];
        brower.delegate = self;
        brower.currentPhotoIndex = sender.tag-PhotoTag;
        brower.photos = arr;
        [brower show];
    }else{
        NSLog(@"视频");
        [self checkVideos:sender.tag-VideoTag];
    }
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index{
    [self.photosArray removeObjectAtIndex:index];
    [self updatePhotoView];
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index{
    id photo = self.photosArray[index];
    [self.photosArray removeObjectAtIndex:index];
    [self.photosArray insertObject:photo atIndex:0];
    [self updatePhotoView];
}


#pragma mark - buttonItem
-(void)buttonItem:(NSInteger)tag
{
    _cateTag = tag;
    [self.dateView hide];
    [self endEditing:YES];

    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (tag) {
        case WPRecruitApplyViewActionTypeSex:
            NSLog(@"性别");
            [self.selectView setLocalData:[SPLocalApplyArray sexArray]];
            break;
        case WPRecruitApplyViewActionTypeBirthday:
            NSLog(@"出生年月");
            [self.dateView showInView:WINDOW];
            break;
        case WPRecruitApplyViewActionTypeEducation:
            NSLog(@"学历");
            [self.selectView setLocalData:[SPLocalApplyArray educationArray]];
            break;
        case WPRecruitApplyViewActionTypeWorkTime:
            NSLog(@"工作年限");
            [self.selectView setLocalData:[SPLocalApplyArray workTimeArray]];
            break;
        case WPRecruitApplyViewActionTypeNowSalary:     //  目前薪资
            [self.selectView setLocalData:[SPLocalApplyArray salaryArray]];
            break;
        case WPRecruitApplyViewActionTypeMarriage:     //  婚姻状况
            [self.selectView setLocalData:[SPLocalApplyArray marriageArray]];
            break;
        case WPRecruitApplyViewActionTypeHometown:      // 户籍
            NSLog(@"现居住地");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        
        case WPRecruitApplyViewActionTypeNowAddress:
            NSLog(@"现居住地");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
            
            
        case WPRecruitApplyViewActionTypePosition:
            NSLog(@"期望职位");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = NO;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
            break;
        case WPRecruitApplyViewActionTypeSalary:
            NSLog(@"期望薪资");
            [self.selectView setLocalData:[SPLocalApplyArray salaryArray]];
            break;
        case WPRecruitApplyViewActionTypeArea:
            NSLog(@"期望地区");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case WPRecruitApplyViewActionTypeWelfare:
            NSLog(@"期望福利");
            [self.selectMoreView setLocalData:[SPLocalApplyArray welfareArray] SelectArr:nil];
            break;
            
        case WPRecruitApplyViewActionTypeLightPoint:
            NSLog(@"个人亮点");
            if (self.RecruitApplyViewBlock) {
                self.RecruitApplyViewBlock(WPRecruitApplyViewTypeLightspot);
            }
            break;
        case WPRecruitApplyViewActionTypeEducationList:
            NSLog(@"教育经历");
            if (self.RecruitApplyViewBlock) {
                self.RecruitApplyViewBlock(WPRecruitApplyViewTypeEducationList);
            }
            break;
        case WPRecruitApplyViewActionTypeWorkList:
            NSLog(@"工作经历");
            if (self.RecruitApplyViewBlock) {
                self.RecruitApplyViewBlock(WPRecruitApplyViewTypeWorkList);
            }
            break;
        
        default:
            break;
    }
}

#pragma mark 选择条件回调代理函数 ~ 刷新选择内容
-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
    [view resetTitle:model.industryName];
    switch (_cateTag) {
        case WPRecruitApplyViewActionTypeSex:
            self.listModel.sex = model.industryName;
            break;
        case WPRecruitApplyViewActionTypeEducation:
            self.listModel.education = model.industryName;
            break;
        case WPRecruitApplyViewActionTypeHometown:
            NSLog(@"没有这个字段");
            self.listModel.education = model.industryName;
            break;
        case WPRecruitApplyViewActionTypeWorkTime:
            self.listModel.workTime = model.industryName;
            break;
        case WPRecruitApplyViewActionTypeNowAddress:
            self.listModel.address = model.industryName;
            self.listModel.addressId = model.industryID;
            break;
        case WPRecruitApplyViewActionTypePosition:
            self.listModel.Hope_Position = model.industryName;
            self.listModel.hopePositionNo = model.industryID;
            break;
        case WPRecruitApplyViewActionTypeSalary:
            self.listModel.Hope_salary = model.industryName;
            break;
        case WPRecruitApplyViewActionTypeArea:
            self.listModel.Hope_address = model.industryName;
            self.listModel.hopeAddressID = model.industryID;
            break;
    }
}

/*
-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
    [view resetTitle:model.industryName];
    switch (_cateTag) {
        case WPRecruitApplyViewActionTypeSex:
            self.model.sex = model.industryName;
            break;
        case WPRecruitApplyViewActionTypeEducation:
            self.model.education = model.industryName;
            break;
        case WPRecruitApplyViewActionTypeHometown:
            NSLog(@"没有这个字段");
            self.model.education = model.industryName;
            break;
        case WPRecruitApplyViewActionTypeWorkTime:
            self.model.WorkTime = model.industryName;
            break;
        case WPRecruitApplyViewActionTypeNowAddress:
            self.model.address = model.industryName;
            self.model.Address_id = model.industryID;
            break;
        case WPRecruitApplyViewActionTypePosition:
            self.model.Position = model.industryName;
            self.model.PositionNo = model.industryID;
            break;
        case WPRecruitApplyViewActionTypeSalary:
            self.model.hopeSalary = model.industryName;
            break;
        case WPRecruitApplyViewActionTypeArea:
            self.model.hopeAddress = model.industryName;
            self.model.hopeAddressId = model.industryID;
            break;
    }
}*/


- (void)SPSelectMoreViewDelegate:(SPSelectMoreView *)selectMoreView arr:(NSArray *)arr
{
    if (selectMoreView == _selectMoreView) {
        SPItemView *view = (SPItemView *)[self viewWithTag:_cateTag];
        if (arr.count == 0) {
            [view resetTitle:@"请选择福利"];
            [view.button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
            self.listModel.Hope_welfare = nil;
        }else{
            NSString *str = [[NSString alloc]init];
            for (NSString *subStr in arr) {
                str = [NSString stringWithFormat:@"%@%@/",str,subStr];
            }
            [view resetTitle:@"已设置"];
            self.listModel.Hope_welfare = str;
        }
    }
}

- (NSArray *)titleArray{
    NSArray *titleArr = @[@"姓       名:",
                          @"性       别:",
                          @"出生年月:",
                          @"学       历:",
                          @"户       籍:",
                          @"工作年限:",
                          @"现居住地:",
                          @"手       机:",
                          @"期望职位:",
                          @"期望薪资:",
                          @"期望福利:",
                          @"期望地区:",
                          @"个人亮点:",
                          @"教育经历:",
                          @"工作经历:",
                          ];
    return titleArr;
}

- (NSArray *)placeholderArray{
    NSArray *placeholderArr = @[@"请输入姓名",
                                @"请选择性别",
                                @"请选择出生年月",
                                @"请选择学历",
                                @"请选择户籍",
                                @"请选择工作年限",
                                @"请选择现居住地",
                                @"请输入手机号码",
                                @"请选择期望职位",
                                @"请选择期望薪资",
                                @"请选择期望福利",
                                @"请选择期望地区",
                                @"请输入个人亮点",
                                @"请输入教育经历",
                                @"请输入工作经历"
                                ];
    return placeholderArr;
}

- (NSArray *)typeArray{
    NSArray *typeArr = @[kCellTypeText,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeText,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton
                         ];
    return typeArr;
}

+(NSArray *)getApplyConditionIndexesInArray:(NSArray *)applyArray{
    NSArray *allApply = @[@"照片",@"姓名",@"性别",@"证件",@"出生年月",@"手机",@"微信",@"QQ",@"邮箱",@"期望职位",@"期望薪资",@"期望福利",@"期望地区",@"目前薪资",@"学历",@"工作年限",@"婚姻状况",@"现居住地",@"工作经历"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < allApply.count; i++) {
        BOOL isExist = NO;
        for (NSString *str in applyArray) {
            if ([allApply[i] isEqualToString:str]) {
                isExist = YES;
                break;
            }
        }
        [arr addObject:isApply(isExist)];
    }
    return arr;
}



@end
