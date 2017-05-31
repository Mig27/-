//
//  WPInterviewApplyView.m
//  WP
//
//  Created by CBCCBC on 15/11/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewApplyView.h"
#import "SPItemView.h"
#import "SPTextView.h"
#import "SPSelectView.h"
#import "SPSelectMoreView.h"
#import "SPDateView.h"
#import "SPPhotoAsset.h"
#import "SPPhotoBrowser.h"
#import "MJPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Masonry.h"
#import "UIButton+WebCache.h"
#import "SPButton.h"
#import "CommonTipView.h"
#import "WPCompanyListModel.h"

#define sItemTag 20
#define VideoTag 65
#define PhotoTag 50
#define BackTag 233

#define WorksViewHeight 170

#define isApply(x) (x?@"1":@"0")


@interface WPInterviewApplyView () <SPPhotoBrowserDelegate,SPSelectViewDelegate,SPSelectMoreViewDelegate,UISelectDelegate,UIAlertViewDelegate,SPItemViewTelePhoneShowOrHiddenDelegate>



//@property (strong, nonatomic) UIView *photoBaseView;
@property (strong, nonatomic) UIScrollView *photoView;
@property (strong, nonatomic) UIButton *addPhotosBtn;
@property (strong, nonatomic) SPTextView *companyView;
@property (strong, nonatomic) SPTextView *worksView;
@property (strong, nonatomic) SPSelectView *selectView;
@property (strong, nonatomic) SPSelectMoreView *selectMoreView;
@property (strong, nonatomic) SPDateView *dateView;
@property (assign, nonatomic) NSInteger cateTag;
@property (nonatomic ,strong) CommonTipView *tipView;
@property (copy, nonatomic) NSArray *listApplyArr;

@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *backTitle;

@property (nonatomic ,strong) NSMutableArray *itemsArray;




@end

@implementation WPInterviewApplyView

- (BOOL)isAnyItemIsNil
{
    BOOL commit = NO;
    if (self.photosArray.count==0 && self.videosArray.count==0) {
        [self.photoBaseView addSubview:self.tipView];
        commit = YES;
//        if (self.isPhoto) {
            self.isPhoto(YES);
//        }
    }
    for (SPItemView *view in self.itemsArray) {
        if ([view textFieldIsnotNil]) {
            commit = YES;
            if (view.tag < WPInterviewApplyViewActionTypeCompanyBrief) {
              self.isCompany(YES);
            }
            else
            {
              self.isZhaoPin(YES);
            }
        }
        
    }
    return commit;
}

- (CommonTipView *)tipView
{
    if (!_tipView) {
        
        self.tipView = [[CommonTipView alloc] init];
        
        self.tipView.title = @"请至少选择一张照片";
        CGFloat x = SCREEN_WIDTH-8-16-8-(self.tipView.size.width/2);
        self.tipView.center = CGPointMake(x, self.photoView.frame.size.height/2);
    }
    
    return _tipView;
}

- (NSMutableArray *)itemsArray
{
    if (!_itemsArray) {
        self.itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
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

- (UIScrollView *)baseView{
    if (!_baseView) {
      
        _baseView = [UIScrollView new];
        [self addSubview:_baseView];
        WS(ws);
        [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws);
        }];
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
    else
    {
        _selectView.line.height = 0.5;
    }
    return _selectView;
}

-(SPSelectMoreView *)selectMoreView
{
    if (!_selectMoreView) {
        _selectMoreView = [[SPSelectMoreView alloc]initWithTop:64];
        _selectMoreView.delegate = self;
    }
    else
    {
        _selectMoreView.line.height = 0.5;
    }
    return _selectMoreView;
}

#pragma mark 选择日期
//-(SPDateView *)dateView
//{
////    if (!_dateView) {
////        __weak typeof(self) weakSelf = self;
////        _dateView = [[SPDateView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-30, SCREEN_WIDTH, 216+30)];
////        _dateView.getDateBlock = ^(NSString *dateStr){
////            SPItemView *view = (SPItemView *)[weakSelf.baseView viewWithTag:sItemTag+4];
////            [view resetTitle:dateStr];
//////            weakSelf.model.age = dateStr;
////        };
////    }
////    return _dateView;
//}

- (UIView *)chooseView{
    if (!_chooseView) {
        _chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, kListEdge, SCREEN_WIDTH, ItemViewHeight)];
        _chooseView.backgroundColor = [UIColor whiteColor];
        
        
       
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, ItemViewHeight);//120-26
        button.titleLabel.font = kFONT(12);
        button.tag = 200;
        NSString *str = @"";
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [button setBackgroundColor:[UIColor greenColor]];
        [button addTarget:self action:@selector(chooseCompanyClick:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(clickDown) forControlEvents:UIControlEventTouchDown];
        [_chooseView addSubview:button];
        
        
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(kHEIGHT(12), 0, 190, ItemViewHeight);
        [leftBtn setTitle:@"调取已有企业招聘信息" forState:UIControlStateNormal];//选择企业招聘信息
        [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = kFONT(15);
        [leftBtn addTarget:self action:@selector(chooseCompanyClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn addTarget:self action:@selector(clickDown) forControlEvents:UIControlEventTouchDown];
        [button addSubview:leftBtn];
        
      
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(12)-15-83, 0, 80, ItemViewHeight)];
        self.title.textAlignment = NSTextAlignmentRight;
        self.title.textColor = [UIColor grayColor];
        self.title.userInteractionEnabled = YES;
        self.title.font = kFONT(11);
        [_chooseView addSubview:self.title];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTitle)];
        [self.title addGestureRecognizer:tap];
        
//        UIButton *label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), 0, 160, ItemViewHeight)];
//        label.text = @"选择企业招聘信息";
////        label.backgroundColor = [UIColor redColor];
//        label.userInteractionEnabled = YES;
//        label.font = kFONT(15);
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseCompanyClick:)];
//        [label addGestureRecognizer:tap];
//        [button addSubview:label];
        

        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"collect"]];//jinru
//        imageV.backgroundColor = [UIColor blackColor];
        imageV.userInteractionEnabled = YES;
        imageV.frame = CGRectMake(_chooseView.width-kHEIGHT(12)-15, _chooseView.height/2-7.5, 15,15);
        [button addSubview:imageV];
        
        [self.baseView addSubview:_chooseView];
    }
    return _chooseView;
}
-(void)clickTitle
{
    UIButton * button = (UIButton*)[self viewWithTag:200];
    [button setBackgroundColor:RGB(226, 226, 226)];
    if (self.pushSubController) {
        self.pushSubController();
    }
}
- (void)chooseCompanyClick:(id)sender{
    
    UIButton * button = (UIButton*)[self viewWithTag:200];
    [button setBackgroundColor:RGB(226, 226, 226)];
    if (self.pushSubController) {
        self.pushSubController();
    }
    if (![sender isKindOfClass:[UIButton class]]) {
        [self clickDown];
    }
}
-(void)clickDown
{
    UIButton * button = (UIButton*)[self viewWithTag:200];
    [button setBackgroundColor:RGB(226, 226, 226)];
}

-(UIView *)photoBaseView
{
    if (!_photoBaseView) {
        
        _photoBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.chooseView.bottom+kListEdge, SCREEN_WIDTH, 0)];
        
        _photoView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, GetHeight(0), SCREEN_WIDTH-28, PhotoViewHeight)];
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoView.showsHorizontalScrollIndicator = NO;
        [_photoBaseView addSubview:_photoView];
        
        _addPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotosBtn.frame = CGRectMake(kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        [_addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];//tianjia64
        [_addPhotosBtn addTarget:self action:@selector(addPhotos:) forControlEvents:UIControlEventTouchUpInside];
        [_photoView addSubview:_addPhotosBtn];
        
        /**< 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-28, _photoView.top, 28, PhotoViewHeight) ImageName:@"jinru" Target:self Action:@selector(photosViewClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        [_photoBaseView addSubview:scrollBtn];
        
        WS(ws);
        
//        NSArray *titleArr = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"企业区域:",@"详细地点:",@"联  系 人:",@"企业官网:",@"企业描述:"];
//        NSArray *placeholderArr = @[@"请填写企业名称",@"请选择行业",@"请选择企业性质",@"请选择企业规模",@"请选择企业区域",@"请输入详细地点",@"请输入联系人",@"请输入企业官网",@"请输入企业描述"];
        
        
        NSArray *titleArr = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"联  系 人:",@"企业官网:",@"企业描述:"];
        NSArray *placeholderArr = @[@"请填写企业名称",@"请选择行业",@"请选择企业性质",@"请选择企业规模",@"请输入联系人",@"请输入企业官网",@"请输入企业描述"];
        
        
        NSArray *typeArr = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeText,kCellTypeButton];
        
        UIView *lastview = nil;
        
        for (int i = 0; i < titleArr.count; i++) {
            
            CGFloat top = lastview?lastview.bottom:_photoView.bottom+kListEdge;
            
            SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
            view.padding = 6;
            [view setTitle:titleArr[i] placeholder:placeholderArr[i] style:typeArr[i]];
            [_photoBaseView addSubview:view];
            if (i <= 3) {
               view.tag = i + WPInterviewApplyViewActionTypeCompanyName;
            }
            else
            {
              view.tag = i + WPInterviewApplyViewActionTypeCompanyName+2;
            }
            //企业官网去掉大写
            if (i == 5) {
                view.textField.keyboardType = UIKeyboardTypeASCIICapable;
                view.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;//去掉大写
            }
            
            view.SPItemBlock = ^(NSInteger tag){
                
                if (self.isChoised) {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有企业招聘信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                    [alert show];
                    return;
                }
                [ws buttonItem:tag];
            };
            __weak typeof(view) weakView = view;
            view.showToFont = ^(){
               
                if (self.isChoised) {
                     [weakView.textField resignFirstResponder];
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有企业招聘信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                    [alert show];
                    return;
                }
            };
            view.hideFromFont = ^(NSInteger tag, NSString *title){
//                if (self.isChoised) {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有企业招聘信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//                    [alert show];
//                    return;
//                }
                
                switch (tag) {
                    case WPInterviewApplyViewActionTypeCompanyName:
                        ws.model.companyName = title;
                        break;
                    case WPInterviewApplyViewActionTypePersonName:
                        ws.model.personName = title;
                        break;
                    case WPInterviewApplyViewActionTypeDetailAddress://企业详细地址
                        ws.model.companyDetailAddress = title;
                        break;
                    case WPInterviewApplyViewActionTypePhone:   //手机号码
                        ws.model.companyPhone = title;
                        break;
                    case WPInterviewApplyViewActionTypePersonWebSite:
                        ws.model.companyWesite = title;
                        break;
                }
            };
            [self.itemsArray addObject:view];
            
            (view.tag == WPInterviewApplyViewActionTypePersonWebSite)?(view.textField.keyboardType = UIKeyboardTypeASCIICapable):(view.textField.keyboardType = UIKeyboardTypeDefault);
            lastview = view;
        }
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _photoView.bottom-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [_photoBaseView addSubview:line];
        
        _photoBaseView.height = lastview.bottom;
        
        [self.baseView addSubview:_photoBaseView];
    }
    return _photoBaseView;
}

- (void)addBackClick{
    if (self.addBackBlock) {
        self.addBackBlock();
    }
}

- (void)updateBackView:(UIImage *)image{
    [_backBtn setImage:image forState:UIControlStateNormal];
}

- (void)startLayoutSubViews:(WPInterviewApplyChooseModel *)model{
    
    self.backgroundColor = RGB(235, 235, 235);
    
    if ([model.apply_Condition hasPrefix:@"/"]) {
        model.apply_Condition = [model.apply_Condition substringFromIndex:1];
    }
    if ([model.apply_Condition hasSuffix:@"/"]) {
        model.apply_Condition = [model.apply_Condition substringToIndex:model.apply_Condition.length-1];
    }
    NSArray *allApply = @[@"企业信息",@"招聘职位",@"招聘行业",@"工资待遇",@"企业福利",@"工作经验",@"学历要求",@"性别要求",@"年龄要求",@"招聘人数",@"工作地点",@"联系人",@"联系方式",@"手机号码:",@"任职要求"];
    NSArray *arr = [WPInterviewApplyView getApplyConditionIndexesInArray:allApply];
    _listApplyArr = [[NSArray alloc]initWithArray:arr];
    NSArray *titleArr = [self titleArray];
    NSArray *placeholderArr = [self placeholderArray];
    NSArray *typeArr = [self typeArray];
    
    WS(ws);
    [self baseView];
    (model.jobList.count?(self.chooseView):([self.chooseView removeFromSuperview]));
    self.chooseView.bottom = (model.jobList.count?self.chooseView.bottom:0);//-10－>0
    ([arr[0] integerValue]?(self.photoBaseView):[self.photoBaseView removeFromSuperview]);
    CGFloat top = self.photoBaseView.bottom + 8;
    UIView *lastView = nil;
    for (int i = 0; i < titleArr.count; i++) {
//        NSInteger count = (i<11?[arr[i] integerValue]:[arr[i-1] integerValue]);
        SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, top+i*ItemViewHeight, SCREEN_WIDTH, ItemViewHeight)];
        view.padding = 6;
        [view setTitle:titleArr[i] placeholder:placeholderArr[i] style:typeArr[i]];
        [self.baseView addSubview:view];
        view.tag = i + WPInterviewApplyViewActionTypeRecruitPosition;
        view.textField.keyboardType = UIKeyboardTypeDefault;
        if ([titleArr[i] isEqualToString:@"手机号码:"]) {
            view.textField.keyboardType = UIKeyboardTypeNumberPad;
            view.delegate = self;
        }
        
        
        view.SPItemBlock = ^(NSInteger tag){
            if (self.isChoised) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有企业招聘信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [alert show];
                return;
            }
            [ws buttonItem:tag];
        };
        [self.itemsArray addObject:view];
        if (view.tag == WPInterviewApplyViewActionTypeCompanyQQ) {
            view.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        __weak typeof(view) weakView = view;
        view.showToFont = ^(){
            if (self.isChoised) {
                [weakView.textField resignFirstResponder];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有企业招聘信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [alert show];
                return;
            }
        };
        view.hideFromFont = ^(NSInteger tag, NSString *title){
//            if (self.isChoised) {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有企业招聘信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//                [alert show];
//                return;
//            }
            
            
            
            switch (tag) {
                case WPInterviewApplyViewActionTypeCompanyQQ:
                    ws.model.recruitNumber = title;
                    break;
                case WPInterviewApplyViewActionTypeCompanyWebsite:
                    ws.model.workAddressDetail = title;
                    break;
                default:
                    break;
            }
        };
        lastView = view;
    }
    
//    SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, lastView.bottom+kListEdge, SCREEN_WIDTH, ItemViewHeight) title:@"更多条件(可填可不填)" ImageName:@"tianjiafeiyong" Target:self Action:@selector(addMoreConditions:)];
//    [self.baseView addSubview:button];
    
    self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, lastView.bottom+kListEdge);
}

//- (void)addMoreConditions:(SPButton *)sender{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        NSArray *title = @[@"企业电话:",@"企业Q Q:",@"企业微信:",@"企业官网:",@"企业邮箱:"];
//        NSArray *placeholder = @[@"请输入企业电话",@"请输入企业QQ",@"请输入企业微信",@"请输入企业官网",@"请输入企业邮箱"];
//        NSArray *type = @[kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeText];
//        UIView *lastView = nil;
//        for (int i = 0; i < 5; i++) {
//            CGFloat top = lastView?lastView.bottom:sender.top;
//            SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
//            [view setTitle:title[i] placeholder:placeholder[i] style:type[i]];
//            view.tag = WPInterviewApplyViewActionTypeCompanyPhone+i;
//            [self.baseView addSubview:view];
//            lastView = view;
//        }
//        [sender setSelectedTitle:@"收起" imageName:@"shouqi"];
//        sender.top = lastView.bottom;
//        self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, sender.bottom+kListEdge);
//    }else{
//        
//        for (int i = 0; i < 5; i++) {
//            SPItemView *view = (SPItemView *)[self viewWithTag:i+WPInterviewApplyViewActionTypeCompanyPhone];
//            [view removeFromSuperview];
//        }
//        [sender setSelectedTitle:@"更多条件(可填可不填)" imageName:@"tianjiafeiyong"];
//        sender.top = sender.top - ItemViewHeight*5;
//        self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, sender.bottom+kListEdge);
//    }
//}
#pragma mark  更新图片
- (void)updatePhotoView{
    
    for (UIView *view in self.photoView.subviews) {
        [view removeFromSuperview];
    }
    
    [self.addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
    [self.tipView removeFromSuperview];
    
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
        //        if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
        //            [button setImage:[UIImage getImage:self.videosArr[i]] forState:UIControlStateNormal];
        //        }else{
        //            ALAsset *asset = self.videosArr[i];
        //            [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
        //        }
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

- (WPInterviewApplyModel *)model{
    if (!_model) {
        _model = [[WPInterviewApplyModel alloc]init];
    }
    return _model;
}

- (void)setListModel:(WPInterviewApplyChooseDetailModel *)listModel{
    _listModel = listModel;
    
//    UIButton *button = (UIButton *)[self viewWithTag:BackTag];
//    [IPADDRESS stringByAppendingString:_listModel.QR_code]
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,_listModel.QR_code]];
    [_backBtn sd_setImageWithURL:url forState:UIControlStateNormal];
    
    _imageview.hidden = YES;
    _backTitle.hidden = YES;
    
    [self.photosArray removeAllObjects];
    [self.photosArray addObjectsFromArray:_listModel.photoList];
    [self.videosArray removeAllObjects];
    [self.videosArray addObjectsFromArray:_listModel.videoList];
    [self updatePhotoView];
    
    NSArray *title = @[listModel.enterprise_name.length?listModel.enterprise_name:@"",
                       listModel.dataIndustry.length?listModel.dataIndustry:@"",
                       listModel.enterprise_properties.length?listModel.enterprise_properties:@"",
                       listModel.enterprise_scale.length?listModel.enterprise_scale:@"",
                       listModel.enterprise_address.length?listModel.enterprise_address:@"",
                       listModel.enterprise_ads.length?listModel.enterprise_ads:@"",
                       listModel.enterprise_personName.length?listModel.enterprise_personName:@"",
                       listModel.enterprise_website.length?listModel.enterprise_website:@"",
                       listModel.enterprise_brief.length?listModel.enterprise_brief:@"",
                       listModel.jobPositon.length?listModel.jobPositon:@"",
                       listModel.salary.length?listModel.salary:@"",
                       listModel.epRange.length?listModel.epRange:@"",
                       listModel.workTime.length?listModel.workTime:@"",
                       listModel.education.length?listModel.education:@"",
                       listModel.sex.length?listModel.sex:@"",
                       listModel.age.length?listModel.age:@"",
                       listModel.invitenumbe.length?listModel.invitenumbe:@"",
                       listModel.workAddress.length?listModel.workAddress:@"",
                       listModel.workAdS.length?listModel.workAdS:@"",
                       listModel.enterprise_phone.length?listModel.enterprise_phone:@"",   
                       listModel.Require.length?listModel.Require:@""];
    
    
    NSArray *modelContent = @[self.model.companyName.length?self.model.companyName:@"",
                              self.model.companyIndusty.length?self.model.companyIndusty:@"",
                              self.model.companyProperties.length?self.model.companyProperties:@"",
                              self.model.companyScale.length?self.model.companyScale:@"",
                              self.model.companyAddress.length?self.model.companyAddress:@"",
                              self.model.companyDetailAddress.length?self.model.companyDetailAddress:@"",
                              self.model.personName.length?self.model.personName:@"",
                              self.model.companyWesite.length?self.model.companyWesite:@"",
                              self.model.companyBrief.length?self.model.companyBrief:@"",
                              self.model.recruitPosition.length?self.model.recruitPosition:@"",
                              self.model.recruitSalary.length?self.model.recruitSalary:@"",
                              self.model.companyWelfare.length?self.model.companyWelfare:@"",
                              self.model.workTime.length?self.model.workTime:@"",
                              self.model.education.length?self.model.education:@"",
                              self.model.sex.length?self.model.sex:@"",
                              self.model.age.length?self.model.age:@"",
                              self.model.recruitNumber.length?self.model.recruitNumber:@"",
                              self.model.workAddress.length?self.model.workAddress:@"",
                              self.model.workAddressDetail.length?self.model.workAddressDetail:@"",
                              self.model.companyPhone.length?self.model.companyPhone:@"",
                              self.model.require.length?self.model.require:@""];
    
    for (int i = WPInterviewApplyViewActionTypeCompanyName; i <= WPInterviewApplyViewActionTypeCompanyEmail; i++) {
        SPItemView *view = [self viewWithTag:i];
        if (i == 7) {
            continue;
        }
        [view resetTitle:title[i-WPInterviewApplyViewActionTypeCompanyName]];
        NSString *str = modelContent[i - WPInterviewApplyViewActionTypeCompanyName];
        str = title[i-WPInterviewApplyViewActionTypeCompanyName];
    }
    if (listModel.enterprise_brief.length) {
        SPItemView *view = [self viewWithTag:WPInterviewApplyViewActionTypeCompanyBrief];
        [view resetTitle:@"企业描述已填写"];
    }
    self.model.companyIndustyId = listModel.dataIndustry_id;
    self.model.companyAddressId = listModel.enterprise_addressID;
    self.model.recruitPositionId = listModel.jobPositonID;
    self.model.workAddressId = listModel.workAddressID;
    
    self.model.job_id = _listModel.job_id;
}

#pragma mark 点击查看图片
-(void)checkImageClick:(UIButton *)sender
{
    
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有企业招聘信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        return;
    }
    
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
        self.clickImage(arr,sender.tag,PhotoTag);
        
//        SPPhotoBrowser *brower = [[SPPhotoBrowser alloc] init];
//        brower.delegate = self;
//        brower.currentPhotoIndex = sender.tag-PhotoTag;
//        brower.photos = arr;
//        [brower show];
    }else{
        NSLog(@"视频");
        [self checkVideos:sender.tag-VideoTag];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.isChoised = NO;
        self.changeResume = YES;
    }
}
#pragma mark  点击查看单个图片的代理
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

- (void)addPhotos:(UIButton *)sender{
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有企业招聘信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        return;
    }
    
    
    
    if (self.addPhotoBlock) {
        self.addPhotoBlock();
    }
}

- (void)photosViewClick:(UIButton *)sender{
    
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有企业招聘信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        return;
    }
    
    if (self.checkALlBlock) {
        self.checkALlBlock();
    }
}

- (void)checkVideos:(NSInteger)videoTag{
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有企业招聘信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        return;
    }
    if (self.checkVideoBlock) {
        self.checkVideoBlock(videoTag);
    }
}

-(void)buttonItem:(NSInteger)tag
{
    _cateTag = tag;
    [self.dateView hide];
    [self endEditing:YES];
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (tag) {
        case WPInterviewApplyViewActionTypeCompanyIndustry:
//            NSLog(@"行业");
            self.selectView.isIndustry = YES;
            self.selectView.isArea = NO;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}];
        case WPInterviewApplyViewActionTypePropreties:
//            NSLog(@"企业性质");
            [self.selectView setLocalData:[SPLocalApplyArray natureArray]];
            break;
        case WPInterviewApplyViewActionTypeScale:
//            NSLog(@"企业规模");
            [self.selectView setLocalData:[SPLocalApplyArray scaleArray]];
            break;
        case WPInterviewApplyViewActionTypeAddress:
//            NSLog(@"企业地址");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case WPInterviewApplyViewActionTypeCompanyBrief://企业简介
            if (self.InterviewApplyBlock) {
                self.InterviewApplyBlock(WPInterviewTypeCompanyBrief);
            }
            break;
        case WPInterviewApplyViewActionTypeRecruitPosition:
//            NSLog(@"招聘职位");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = NO;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
            break;
        case WPInterviewApplyViewActionTypeSalary:
//            NSLog(@"薪资待遇");、
        {
            NSMutableArray * muarray = [[NSMutableArray alloc]init];
            NSArray * array = [SPLocalApplyArray salaryArray];
            [muarray addObjectsFromArray:array];
            [muarray removeFirstObject];
            [self.selectView setLocalData:muarray];
        }
//            [self.selectView setLocalData:[SPLocalApplyArray salaryArray]];
            break;
        case WPInterviewApplyViewActionTypeWelfare:
//            NSLog(@"公司福利");
            [self.selectMoreView setLocalData:[SPLocalApplyArray welfareArray] SelectArr:nil];
            break;
        case WPInterviewApplyViewActionTypeWorkAddress:
//            NSLog(@"工作年限");
            [self.selectView setLocalData:[SPLocalApplyArray workTimeArray]];
            break;
        case WPInterviewApplyViewActionTypeWorkAds:
//            NSLog(@"学历要求");、
            [self.selectView setLocalData:[SPLocalApplyArray educationArray]];
            break;
        case WPInterviewApplyViewActionTypeRequire:
//            NSLog(@"性别要求");
            [self.selectView setLocalData:[SPLocalApplyArray sexWithNoLimitArray]];
            break;
        case WPInterviewApplyViewActionTypeCompanyPhone:
//            NSLog(@"年龄要求");
            [self.selectView setLocalData:[SPLocalApplyArray ageArray]];
            break;
        case WPInterviewApplyViewActionTypeCompanyWeChat:
//            NSLog(@"工作区域");
//            self.selectView.isIndustry = NO;
//            self.selectView.isArea = YES;
//            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
        {
            UIView *view1 = [WINDOW viewWithTag:1001];
            view1.hidden = NO;
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
            SPIndexPath * indexPath = [[SPIndexPath alloc]init];
            indexPath.row = -1;
            indexPath.section = -1;
            [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":self.city.localID} citySelectedindex:indexPath];
        }
            break;
        case WPInterviewApplyViewActionTypeCompanyEmail:
//            NSLog(@"任职要求");
            if (self.InterviewApplyBlock) {
                self.InterviewApplyBlock(WPInterviewTypeRequire);
            }
            break;
        default:
            break;
    }
}
#pragma mark 选择工作区域
- (UISelectCity *)city
{
    if (!_city) {
        
        _city = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _city.delegate = self;
        
        UIView * view =[WINDOW viewWithTag:1001];
        [view removeFromSuperview];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        subView1.tag = 1001;
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
    else
    {
        _city.lineLabel.height = 0.5;
    }
    return _city;
}
- (void)touchHide:(UITapGestureRecognizer *)tap{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    [self.city remove];
}
- (void)citUiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model
{
    [self.city remove];
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    
    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
    [view resetTitle:f_model.fullname];
    
    self.model.workAddress = f_model.fullname;
    self.model.workAddressId = f_model.industryID;
}
#pragma mark 选择条件回调代理函数 ~ 刷新选择内容
-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    
    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
    [view resetTitle:model.industryName];
    switch (_cateTag) {
        case WPInterviewApplyViewActionTypeCompanyIndustry:
            self.model.companyIndusty = model.industryName;
            self.model.companyIndustyId = model.industryID;
            break;
        case WPInterviewApplyViewActionTypePropreties:
            self.model.companyProperties = model.industryName;
            break;
        case WPInterviewApplyViewActionTypeScale:
            self.model.companyScale = model.industryName;
            break;
        case WPInterviewApplyViewActionTypeAddress:
            self.model.companyAddress = model.industryName;
            self.model.companyAddressId = model.industryID;
            break;
        case WPInterviewApplyViewActionTypeRecruitPosition:
            self.model.recruitPosition = model.industryName;
            self.model.recruitPositionId = model.industryID;
            break;
        case WPInterviewApplyViewActionTypeSalary:
            self.model.recruitSalary = model.industryName;
            break;
        case WPInterviewApplyViewActionTypeWelfare:
            self.model.companyWelfare = model.industryName;
            break;
        case WPInterviewApplyViewActionTypeWorkAddress:
            self.model.workTime = model.industryName;
            break;
        case WPInterviewApplyViewActionTypeWorkAds:
            self.model.education = model.industryName;
            break;
        case WPInterviewApplyViewActionTypeRequire:
            self.model.sex = model.industryName;
            break;
        case WPInterviewApplyViewActionTypeCompanyPhone:
            self.model.age = model.industryName;
            break;
        case WPInterviewApplyViewActionTypeCompanyWeChat:
            self.model.workAddress = model.industryName;
            self.model.workAddressId = model.industryID;
            break;
        case WPInterviewApplyViewActionTypeCompanyEmail:
            self.model.age = model.industryName;
            break;
        default:
            break;
    }
}

- (void)SPSelectMoreViewDelegate:(SPSelectMoreView *)selectMoreView arr:(NSArray *)arr
{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    if (selectMoreView == _selectMoreView) {
        SPItemView *view = (SPItemView *)[self viewWithTag:_cateTag];
        if (arr.count == 0) {
            [view resetTitle:@"请选择福利"];
            [view.button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
            self.model.companyWelfare = nil;
        }else{
            NSString *str = [[NSString alloc]init];
            for (NSString *subStr in arr) {
                str = [NSString stringWithFormat:@"%@%@/",str,subStr];
            }
            [view resetTitle:[str substringToIndex:str.length-1]];
            self.model.companyWelfare = str;
        }
    }
}

- (NSArray *)titleArray{
    NSArray *titleArr = @[@"招聘职位:",
                          @"工资待遇:",
                          @"企业福利:",
                          @"工作经验:",
                          @"学历要求:",
                          @"性别要求:",
                          @"年龄要求:",
                          @"招聘人数:",
                          @"工作区域:",
                          @"详细地点:",
                          @"手机号码:",
                          @"任职要求:"];
//    NSArray *titleArr = @[@"企业信息:",
//                          @"招聘职位:",
//                          @"工资待遇:",
//                          @"企业福利:",
//                          @"工作区域:",
//                          @"详细地点:",
//                          @"任职要求:"];
    return titleArr;
}

- (NSArray *)placeholderArray{
    NSArray *placeholderArr = @[@"请选择职位",
                                @"请选择工资待遇",
                                @"请选择企业福利",
                                @"请选择工作经验",
                                @"请选择学历",
                                @"请选择性别",
                                @"请选择年龄",
                                @"请输入招聘人数",
                                @"请选择工作区域",
                                @"请输入详细地点",
                                @"请输入手机号码",
                                @"请填写任职要求"];
//    NSArray *placeholderArr = @[@"企业信息",
//                                @"请选择职位",
//                                @"请选择工资待遇",
//                                @"请选择企业福利",
//                                @"请选择工作区域",
//                                @"请输入详细地点",
//                                @"请输入任职要求"];
    return placeholderArr;
}

- (NSArray *)typeArray{
    NSArray *typeArr = @[kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeButton,
                         kCellTypeText,
                         kCellTypeButton,
                         kCellTypeText,
                         kCellTypeTextWithSwitch,
                         kCellTypeButton];
    return typeArr;
}

+(NSArray *)getApplyConditionIndexesInArray:(NSArray *)applyArray{
    NSArray *allApply = @[@"企业信息",@"招聘职位",@"招聘行业",@"工资待遇",@"企业福利",@"工作经验",@"学历要求",@"性别要求",@"年龄要求",@"招聘人数",@"工作地点",@"联系人",@"联系方式",@"任职要求"];
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

#pragma mark 手机号码显示和隐藏代理方法
- (void)SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:(BOOL)showed{
    if (self.telephoneNumShowOrHiddenBlock) {
        self.telephoneNumShowOrHiddenBlock(showed);
    }
}

@end
