//
//  SAYPhotoManagerViewController.m
//  CampusJobV2
//
//  Created by school51 on 15/4/1.
//  Copyright (c) 2015年 noworrry. All rights reserved.
//

#import "SAYPhotoManagerViewController.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import <BlocksKit+UIKit.h>
#import "WPHttpTool.h"
#import "WPActionSheet.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "MLSelectPhotoAssets.h"
#import "MLPhotoBrowserViewController.h"
#import "UIButton+WebCache.h"
#import "SPPhotoAsset.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "DBTakeVideoVC.h"
#import "CTAssetsPickerController.h"
#import "HJCActionSheet.h"

#import "WPCompanyListModel.h"
#import "SPPhotoBrowser.h"
#import "WPResumeUserInfoModel.h"

#import "VideoBrowser.h"
@interface SAYPhotoManagerViewController ()<UIActionSheetDelegate,WPActionSheet,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MLPhotoBrowserViewControllerDelegate,MLPhotoBrowserViewControllerDataSource,callBackVideo,takeVideoBack,UIAlertViewDelegate,HJCActionSheetDelegate,SPPhotoBrowserDelegate>//callBackVideo,takeVideoBack,

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIScrollView *videoScroll;
@property (strong, nonatomic) UIButton *addButton;

@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerVC;
@property (strong, nonatomic) UILabel *label1;
@end

@implementation SAYPhotoManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相册编辑";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
//    
    if (self.isEdit) {
//        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        saveBtn.frame = CGRectMake(0, 0, 30, 20);
//        saveBtn.backgroundColor = [UIColor redColor];
//        [saveBtn setTitle:@"完成" forState:UIControlStateNormal];
//        [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [saveBtn addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
        
//        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onSave)];
//        self.navigationItem.rightBarButtonItem = saveItem;
        
//        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 164, SCREEN_WIDTH - 20, 100)];
//        tip.numberOfLines = 0;
//        NSString *text = [NSString stringWithFormat:@"%@\n%@\n%@",@"小提示:",@"1.长按图片,当图片晃动时可拖动图片位置,",@"2.第一张图片为对外显示封面!"];
//        tip.text = text;
//        tip.font = [UIFont systemFontOfSize:15];
//        tip.textColor = [UIColor lightGrayColor];
//        [self.view addSubview:tip];
    }
//    self.data = [NSMutableArray array];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 64+10, SCREEN_WIDTH, 20)];
    label.text = @"";//照片
    label.textColor = RGB(153, 153, 153);
    label.font = GetFont(15);
    [self.view addSubview:label];
    
    self.photoScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 4+64, SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
//    _photoScroll.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.photoScroll];
    
//    _photoScroll.contentSize = CGSizeMake(SCREEN_WIDTH, 300);
    
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, self.photoScroll.bottom, SCREEN_WIDTH, 20)];
    _label1.text = @"视频";
    _label1.font = GetFont(15);
    _label1.textColor = RGB(153,153,153);
//    [self.view addSubview:_label1];
    
    self.videoScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _label1.bottom, SCREEN_WIDTH, SCREEN_WIDTH/4)];
//    _videoScroll.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.videoScroll];
    
//    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelbtn.frame = CGRectMake(0, 0, 30, 20);
//    cancelbtn.backgroundColor = [UIColor redColor];
//    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cancelbtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    //    back.tag = pushType;
    //    backTag = pushType;
    [back addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
//    self.navigationItem.leftBarButtonItem = item;
    
    CGFloat width = (SCREEN_WIDTH - 5*5)/4;
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5+width-16+3+64, width, 16)];
    _titleLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    _titleLabel.text = @"头像";
    _titleLabel.font = [UIFont systemFontOfSize:10];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    
    [self startLoadData];
}

-(void)cancelClick
{
    if (self.delegate) {
        [self.delegate UpdateImageDelegate:_newPhotolist VideoArr:_newVideolist];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 点击完成
//- (void)onSave
//{
//    if (self.delegate) {
//        [self.delegate UpdateImageDelegate:_newPhotolist VideoArr:_newVideolist];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}

#pragma mark - 加载数据
- (void)startLoadData
{
    if (self.arr.count > 0) {
        _newPhotolist = [[NSMutableArray alloc]initWithArray:self.arr];
    }else{
        _newPhotolist = [[NSMutableArray alloc]init];
    }
    [self updatephotoScroll];
    
    if (self.videoArr) {
        self.label1.hidden = NO;
        if (self.videoArr.count > 0) {
            _newVideolist = [[NSMutableArray alloc]initWithArray:self.videoArr];
        }else{
            _newVideolist = [[NSMutableArray alloc]init];
        }
        [self updateVideoScroll];
    }else{
        self.label1.hidden = YES;
    }
}

#pragma mark 从相册或相机中添加图片的按钮
- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_addButton setImage:[UIImage imageNamed:@"tianjiazhaop"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];
        [self.photoScroll addSubview:_addButton];
        
        CGFloat width = (SCREEN_WIDTH - 5*5)/4;
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        imageV.image = [UIImage imageNamed:@"tianjia64"];//tianjia64//tupian
        [_addButton addSubview:imageV];
    }
    return _addButton;
}

#pragma mark 更新图片视图
- (void)updatephotoScroll
{
    for (UIView *view in self.photoScroll.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = (SCREEN_WIDTH - 5*5)/4;
    for (int i=0; i< _newPhotolist.count; i++)
    {
        CGFloat y = i/4*(width + 5) + 5;
        CGFloat x = i%4*(width + 5) + 5;
        
        UIButton *dragBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dragBtn.frame = CGRectMake(x, y, width, width);
        
//        [dragBtn setBackgroundImage:_newPhotolist[i] forState:UIControlStateNormal];
//        [dragBtn setBackgroundImage:_newPhotolist[i] forState:UIControlStateHighlighted];
        
        if ([_newPhotolist[i] isKindOfClass:[SPPhotoAsset class]])
        {
            [dragBtn setImage:[_newPhotolist[i] originImage] forState:UIControlStateNormal];
        }
        else
        {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newPhotolist[i] thumb_path]]];
            [dragBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
        
        dragBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        dragBtn.tag = 100 + i;
        
        [dragBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoScroll addSubview:dragBtn];
        
        // 长按，拖动手势
        if (self.isEdit) {
            UILongPressGestureRecognizer * panTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
            panTap.minimumPressDuration = 0.2;
            [dragBtn addGestureRecognizer:panTap];
#pragma mark 添加删除按钮
            UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(width-20, 0, 20,20)];
            [deleteBtn setImage:[UIImage imageNamed:@"UMS_delete_image_button_normal"] forState:UIControlStateNormal];
            deleteBtn.tag = 200+i;
            [deleteBtn addTarget:self action:@selector(deleteVideoClick:) forControlEvents:UIControlEventTouchUpInside];
            [dragBtn addSubview:deleteBtn];
        }
    }
    
    if (self.isEdit) {
        if (_newPhotolist.count < 12) {
            
            CGFloat x = _newPhotolist.count%4*(width + 5) + 5;
            CGFloat y = _newPhotolist.count/4*(width + 5) + 5;
//            self.addButton.hidden = NO;
            self.addButton.frame = CGRectMake(x, y, width, width);
            
            [self.photoScroll addSubview:self.addButton];
//            NSLog(@"111%@",NSStringFromCGRect(self.addButton.frame));
        }
    }

    _titleLabel.hidden = !_newPhotolist.count;
    [self.photoScroll bringSubviewToFront:_titleLabel];
    
    if (_newPhotolist.count == 0) {
        _photoScroll.height = (_newPhotolist.count/4+1)*(width+5);
        _label1.top = _photoScroll.bottom;
    }else{
        if (_newPhotolist.count==12) {
            _photoScroll.height = _newPhotolist.count/4*(width+5);
        }else{
            _photoScroll.height = (_newPhotolist.count/4+1)*(width+5);
        }
        _label1.top = _photoScroll.bottom+10;
    }
    _videoScroll.top = _label1.bottom;
}
#pragma mark 更新视频视图
- (void)updateVideoScroll
{
    for (UIView *view in self.videoScroll.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = (SCREEN_WIDTH - 5*5)/4;
    NSLog(@"%@",_newVideolist);
    for (int i=0; i< _newVideolist.count; i++) {
        CGFloat y = i/4*(width + 5) + 5;
        CGFloat x = i%4*(width + 5) + 5;
        UIButton *dragBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dragBtn.frame = CGRectMake(x, y, width, width);
        dragBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        dragBtn.tag = 300 + i;
        [dragBtn addTarget:self action:@selector(VonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoScroll addSubview:dragBtn];
        
        if ([_newVideolist[i] isKindOfClass:[NSString class]]) {
            [dragBtn setImage:[UIImage getImage:_newVideolist[i]] forState:UIControlStateNormal];
        }else if([_newVideolist[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = _newVideolist[i];
            [dragBtn setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newVideolist[i] thumb_path]]];
            [dragBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
        UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(dragBtn.width/2-10,dragBtn.width/2-10, 20, 20)];
        subImageV.image = [UIImage imageNamed:@"video_play"];
        [dragBtn addSubview:subImageV];
        
        if (self.isEdit) {
            UILongPressGestureRecognizer * panTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(VhandlePanGesture:)];
            [dragBtn addGestureRecognizer:panTap];
#pragma mark 添加删除的按钮
            UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(width-20, 0, 20,20)];
            [deleteBtn setImage:[UIImage imageNamed:@"UMS_delete_image_button_normal"] forState:UIControlStateNormal];
            deleteBtn.tag = 400+i;
            [deleteBtn addTarget:self action:@selector(VdeleteVideoClick:) forControlEvents:UIControlEventTouchUpInside];
            [dragBtn addSubview:deleteBtn];
        }
    }
    
#pragma mark 添加视频按钮
    if (self.isEdit) {
        if (_newVideolist.count < 4) {
            
            CGFloat x = _newVideolist.count%4*(width + 5) + 5;
            CGFloat y = _newVideolist.count/4*(width + 5) + 5;
            
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(x, y, width, width);
            [addBtn addTarget:self action:@selector(addVideoClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:addBtn.bounds];
            imageV.image = [UIImage imageNamed:@"shipin"];
            [addBtn addSubview:imageV];
            
//            [_videoScroll addSubview:addBtn];
        }
    }
}

- (void)addVideoClick:(UIButton *)sender
{
    DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
    tackVedio.delegate = self;
    tackVedio.takeVideoDelegate = self;
    [self.navigationController pushViewController:tackVedio animated:YES];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)onTap
{
//    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
//    [actionSheet showInView:self.view];
    
    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册",@"拍照", nil];
    
    [sheet show];
}

//- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 2) {
//        [self fromCamera];
//    }
//    if (buttonIndex == 1) {
//        [self fromAlbums];
//    }
//}

//- (void)alertshow
//{
//    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册",@"相机",@"视频", nil];
//    
//    [sheet show];
//    
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self fromAlbums];
    }
    else if(buttonIndex == 2)
    {
        [self fromCamera];
    }
}





- (void)fromCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//        [@"您的设备不支持拍照" alertInViewController:self];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    //picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    picker.bk_didCancelBlock = ^(UIImagePickerController *picker){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    picker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        SPPhotoAsset *asset = [[SPPhotoAsset alloc]init];
        asset.image = image;
        [_newPhotolist addObject:asset];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        for (UIView *btn in self.photoScroll.subviews) {
            [btn removeFromSuperview];
        }
        [self updatephotoScroll];
    };
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)fromAlbums {

    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 12 - _newPhotolist.count;
    //        [pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for (MLSelectPhotoAssets *asset in assets) {
            SPPhotoAsset *spAsset = [[SPPhotoAsset alloc]init];
            spAsset.asset = asset.asset;
            [photos addObject:spAsset];
        }
        [_newPhotolist addObjectsFromArray:photos];
        [self updatephotoScroll];
    };
}


#pragma mark 点击查看图片
- (void)onBtnClick:(UIButton *)sender
{
//    _deleteIndex = sender.tag - 100;
//    UIActionSheet *sheet1 = [[UIActionSheet alloc] initWithTitle:nil
//                                                        delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除图片" otherButtonTitles:@"设置为头像", nil];
//    sheet1.tag = 10;
//    [sheet1 showInView:self.view];
//    
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    for (int i = 0; i < _newPhotolist.count; i++) {
//        MJPhoto *photo = [[MJPhoto alloc]init];
//        photo.image = _newPhotolist[i];
//        photo.srcImageView = [(UIButton *)[_photoScroll viewWithTag:100+i] imageView];
//        [arr addObject:photo];
//    }
//
//    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
//    brower.currentPhotoIndex = sender.tag-100;
//    brower.photos = arr;
//    [brower show];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < _newPhotolist.count; i++) {/**< 头像或背景图 */
        MJPhoto *photo = [[MJPhoto alloc]init];
        if ([_newPhotolist[i] isKindOfClass:[PhotoVideo class]]|| [_newPhotolist[i] isKindOfClass:[Pohotolist class]]) {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newPhotolist[i] original_path]]];
            photo.url = url;
        }else{
//            if ([_newPhotolist[i] isKindOfClass:[Pohotolist class]]) {
//                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newPhotolist[i] original_path]]];
//                photo.url = url;
//            }
//            else
//            {
              photo.image = [_newPhotolist[i] originImage];
//            }
            
        }
        photo.srcImageView = [(UIButton *)[self.view viewWithTag:100+i] imageView];
        [arr addObject:photo];
    }
    SPPhotoBrowser *brower = [[SPPhotoBrowser alloc] init];
    brower.delegate = self;
    brower.currentPhotoIndex = sender.tag-100;
    brower.photos = arr;
    [self.navigationController pushViewController:brower animated:YES];
    
    
    
    
    
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-100 inSection:0];
//    // 图片游览器
//    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
//    // 缩放动画
//    photoBrowser.status = UIViewAnimationAnimationStatusFade;
//    // 可以删除
//    photoBrowser.editing = YES;
//    // 数据源/delegate
//    photoBrowser.delegate = self;
//    photoBrowser.dataSource = self;
//    // 当前选中的值
//    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
//    // 展示控制器
//    [photoBrowser showPickerVc:self];
}
#pragma mark SPPhotoBrowser-delegate
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser photosArr:(NSArray *)photosArray
{

}
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index
{
    id object = _newPhotolist[index];
    [_newPhotolist removeObjectAtIndex:index];
    [_newPhotolist insertObject:object atIndex:0];
//    _newPhotolist = self.arr;
    [self updatephotoScroll];
}
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index
{
    if (_newPhotolist.count == 1)
    {
        //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请至少保留一张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        //        [alert show];
    }
    else
    {
        [_newPhotolist removeObjectAtIndex:index];
    }
//    _newPhotolist = self.arr;
    [self updatephotoScroll];
}



#pragma <MLPhotoBrowerDelegate>
#pragma mark - <MLPhotoBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return _newPhotolist.count;
}

#pragma mark - 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
- (MLPhotoBrowserPhoto *) photoBrowser:(MLPhotoBrowserViewController *)browser photoAtIndexPath:(NSIndexPath *)indexPath{
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
    if ([_newPhotolist[indexPath.row] isKindOfClass:[SPPhotoAsset class]]) {
        photo.photoObj = [[_newPhotolist objectAtIndex:indexPath.row] originImage];
    }else{
        photo.photoObj = [IPADDRESS stringByAppendingString:[_newPhotolist[indexPath.row] original_path]];
    }
    // 缩略图
    UIButton *btn = (UIButton *)[self.photoScroll viewWithTag:indexPath.row+100];
    photo.toView = btn.imageView;
//    photo.thumbImage = btn.imageView.image;
    return photo;
}

#pragma mark - <MLPhotoBrowserViewControllerDelegate>
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser coverPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *photo = _newPhotolist[indexPath.row];
    [_newPhotolist removeObjectAtIndex:indexPath.row];
    [_newPhotolist insertObject:photo atIndex:0];
    [self updatephotoScroll];
}

#pragma mark - <MLPhotoBrowserViewControllerDelegate>
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
//    if (_newPhotolist.count == 1)
//    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请至少保留一张图片" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    else
//    {
//        [_newPhotolist removeObjectAtIndex:indexPath.row];
//        [self updatephotoScroll];
//    }
    [_newPhotolist removeObjectAtIndex:indexPath.row];
    [self updatephotoScroll];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (actionSheet.tag == 10) {
//        if (buttonIndex == 0) {
//            NSLog(@"删除图片");
//            [self deletePhoto];
//        } else if (buttonIndex == 1) {
//            NSLog(@"设置为头像");
//            [self setupToIcon];
//        }
//    }
//}
//
//- (void)setupToIcon
//{
//    UIImage *image = [_newPhotolist objectAtIndex:_deleteIndex];
//    [_newPhotolist removeObjectAtIndex:_deleteIndex];
//    [_newPhotolist insertObject:image atIndex:0];
//    for (UIView *btn in _photoScroll.subviews) {
//        [btn removeFromSuperview];
//    }
//    [self updatephotoScroll];
//}
#pragma mark 删除图片
-(void)deleteVideoClick:(UIButton *)sender
{
    _deleteIndex = sender.tag - 200;
    if (_newPhotolist.count == 1)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请至少保留一张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
     [self deletePhoto];
    }
    
}

- (void)deletePhoto
{
    UIButton *btnSecleted = (UIButton *)[self.photoScroll viewWithTag:_deleteIndex + 100];
    _dragToPoint = btnSecleted.center;
    
    [btnSecleted removeFromSuperview];
    
    __block NSMutableArray * bnewAlbumlist = _newPhotolist;
    __block UIScrollView * bphotoScrol = self.photoScroll;
    //把删除按钮的下一个按钮移动到记录的删除按钮的位置，并把下一按钮的位置记为新的_toFrame，并把view的tag值-1,依次处理
    [UIView animateWithDuration:0.3 animations:^
     {
         for (int i = (int)_deleteIndex + 1; i < bnewAlbumlist.count; i ++)
         {
             UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
             _dragFromPoint = dragBu.center;
             dragBu.center = _dragToPoint;
             _dragToPoint = _dragFromPoint;
             dragBu.tag --;
         }
         
     } completion:^(BOOL finished) {
         //移动完成之后,才能从_newAlbumlist列表中移除要删除按钮的数据
         [bnewAlbumlist removeObjectAtIndex:_deleteIndex];
         NSLog(@">>>>>>>>>>>>>%@",_newPhotolist);
         for (UIView *btn in self.photoScroll.subviews) {
             [btn removeFromSuperview];
         }
         [self updatephotoScroll];
     }];
}

- (void)handlePanGesture:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self dragTileBegan:recognizer];
            [self startShake:recognizer.view];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self dragTileMoved:recognizer];
            break;//开始时忘记加break，一直执行结束方法
        }
        case UIGestureRecognizerStateEnded:
        {
            [self dragTileEnded:recognizer];
            [self stopShake:recognizer.view];
            break;
        }
        default:
            break;
    }
}

- (void)dragTileBegan:(UIGestureRecognizer *)recognizer
{
    //把要移动的视图放在顶层
    [self.photoScroll bringSubviewToFront:recognizer.view];
    
    _dragFromPoint = recognizer.view.center;
}

#pragma mark - 拖动晃动
- (void)startShake:(UIView* )imageV
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, -0.06, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, 0.06, 0, 0, 1)];
    [imageV.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake:(UIView* )imageV
{
    [imageV.layer removeAnimationForKey:@"shakeAnimation"];
}

- (void)dragTileMoved:(UIGestureRecognizer *)recognizer
{
    CGPoint locationPoint = [recognizer locationInView:self.photoScroll];
    recognizer.view.center = locationPoint;
    [self pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIImageView *)recognizer.view];
}

- (void)pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIView *)tileView
{
    for (UIButton *item in self.photoScroll.subviews)
    {
        //移动到另一个按钮的区域，判断需要移动按钮的位置
        if (CGRectContainsPoint(item.frame, tileView.center) && item != tileView )
        {
            
            //开始的位置
            NSInteger fromIndex = tileView.tag - 100;
            //需要移动到的位置
            NSInteger toIndex = (item.tag - 100)>0?(item.tag - 100):0;
            NSLog(@"从位置%d移动到位置%d",(int)fromIndex, (int)toIndex);
            [self dragMoveFromIndex:fromIndex ToIndex:toIndex withView:tileView];
        }
    }
    [self.photoScroll bringSubviewToFront:_titleLabel];
}

- (void)dragMoveFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex withView:(UIView *)tileView
{
    //局部变量是不能在闭包中发生改变的，所以需要把_dragFromPoint，_dragToPoint定义成全局变量
    __block NSMutableArray * bnewAlbumlist = _newPhotolist;
    __block UIScrollView * bphotoScrol = self.photoScroll;
    NSDictionary * moveDict = [bnewAlbumlist objectAtIndex:fromIndex];
    [bnewAlbumlist removeObjectAtIndex:fromIndex];
    [bnewAlbumlist insertObject:moveDict atIndex:toIndex];
    //向前移动
    if (fromIndex > toIndex)
    {
        //把移动相册的上一个相册移动到记录的移动相册的位置，并把上一相册的位置记为新的_dragFromPoint，并把view的tag值+1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            
            for (int i = (int)fromIndex - 1; i >= toIndex; i--)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
                _dragToPoint = dragBu.center;
                dragBu.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragBu.tag ++;
            }
            tileView.tag = 100 + toIndex;
        }];
    }
    //向后移动
    else
    {
        //把移动相册的下一个相册移动到记录的移动相册的位置，并把下一相册的位置记为新的_dragFromPoint，并把view的tag值-1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = (int)fromIndex + 1; i <= toIndex; i++)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
                _dragToPoint = dragBu.center;
                dragBu.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragBu.tag --;
            }
            tileView.tag = 100 + toIndex;
        }];
    }
}
- (void)dragTileEnded:(UIGestureRecognizer *)recognizer
{
    //    [UIView animateWithDuration:0.2f animations:^{
    //        recognizer.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
    //        recognizer.view.alpha = 1.f;
    //    }];
    
    [UIView animateWithDuration:0.2f animations:^{
        if (_isDragTileContainedInOtherTile)
            recognizer.view.center = _dragToPoint;
        else
            recognizer.view.center = _dragFromPoint;
    }];
    _isDragTileContainedInOtherTile = NO;
//    NSLog(@"*******%@",_newPhotolist);
}

#pragma mark - Video 查看视频
- (void)VonBtnClick:(UIButton *)sender
{

    NSLog(@"查看视频");
    VideoBrowser *video = [[VideoBrowser alloc] init];
    video.isCreat = YES;
    //    NSLog(@"查看视频");
    if ([_newVideolist[sender.tag-300] isKindOfClass:[NSString class]]) {
        video.isNetOrNot = NO;
        video.videoUrl = _newVideolist[sender.tag-300];
        //        NSURL *url = [NSURL fileURLWithPath:_newVideolist[sender.tag-300]];
        //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    } else if([_newVideolist[sender.tag-300] isKindOfClass:[ALAsset class]]){
        ALAsset *asset = _newVideolist[sender.tag-300];
        video.isNetOrNot = NO;
        video.videoUrl = [NSString stringWithFormat:@"%@",asset.defaultRepresentation.url];
        //        ALAsset *asset = _newVideolist[sender.tag-300];
        //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    }else{
        video.isNetOrNot = YES;
        video.videoUrl =[IPADDRESS stringByAppendingString:[_newVideolist[sender.tag-300] original_path]];
        //        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newVideolist[sender.tag-300] original_path]]];
        //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    }
    [video showPickerVc:self];
//    if ([_newVideolist[sender.tag-300] isKindOfClass:[NSString class]]) {
//        NSURL *url = [NSURL fileURLWithPath:_newVideolist[sender.tag-300]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    } else if([_newVideolist[sender.tag-300] isKindOfClass:[ALAsset class]]){
//        ALAsset *asset = _newVideolist[sender.tag-300];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
//    }else{
//        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newVideolist[sender.tag-300] original_path]]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    }
//    //指定媒体类型为文件
//    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile|MPMovieSourceTypeStreaming;
//    
//    //通知中心
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPlaybackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
//    [self presentViewController:_moviePlayerVC animated:YES completion:^{}];
}

- (void)onPlaybackFinished
{
    NSLog(@"onPlaybackFinished");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}
#pragma mark 删除视频
-(void)VdeleteVideoClick:(UIButton *)sender
{
    _deleteIndex = sender.tag - 400;
    [self VdeletePhoto];
}
- (void)VdeletePhoto
{
    UIButton *btnSecleted = (UIButton *)[_videoScroll viewWithTag:_vdeleteIndex + 300];
    _vdragToPoint = btnSecleted.center;
    
    [btnSecleted removeFromSuperview];
    
    __block NSMutableArray * bnewAlbumlist = _newVideolist;
    __block UIScrollView * bphotoScrol = _videoScroll;
    //把删除按钮的下一个按钮移动到记录的删除按钮的位置，并把下一按钮的位置记为新的_toFrame，并把view的tag值-1,依次处理
    [UIView animateWithDuration:0.3 animations:^
     {
         for (int i = (int)_vdeleteIndex + 1; i < bnewAlbumlist.count; i ++)
         {
             UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 300];
             _vdragFromPoint = dragBu.center;
             dragBu.center = _vdragToPoint;
             _vdragToPoint = _vdragFromPoint;
             dragBu.tag --;
         }
         
     } completion:^(BOOL finished) {
         //移动完成之后,才能从_newAlbumlist列表中移除要删除按钮的数据
         [bnewAlbumlist removeObjectAtIndex:_vdeleteIndex];
         for (UIView *btn in _videoScroll.subviews) {
             [btn removeFromSuperview];
         }
         [self updateVideoScroll];
     }];
}

#pragma mark 长按，拖动手势
- (void)VhandlePanGesture:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self VdragTileBegan:recognizer];
            [self VstartShake:recognizer.view];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self VdragTileMoved:recognizer];
            break;//开始时忘记加break，一直执行结束方法
        }
        case UIGestureRecognizerStateEnded:
        {
            [self VdragTileEnded:recognizer];
            [self VstopShake:recognizer.view];
            break;
        }
        default:
            break;
    }
}

- (void)VdragTileBegan:(UIGestureRecognizer *)recognizer
{
    //把要移动的视图放在顶层
    [_videoScroll bringSubviewToFront:recognizer.view];
    
    _vdragFromPoint = recognizer.view.center;
}

#pragma mark - 拖动晃动
- (void)VstartShake:(UIView* )imageV
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, -0.06, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, 0.06, 0, 0, 1)];
    [imageV.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)VstopShake:(UIView* )imageV
{
    [imageV.layer removeAnimationForKey:@"shakeAnimation"];
}

- (void)VdragTileMoved:(UIGestureRecognizer *)recognizer
{
    CGPoint locationPoint = [recognizer locationInView:_videoScroll];
    recognizer.view.center = locationPoint;
    [self VpushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIImageView *)recognizer.view];
}

- (void)VpushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIView *)tileView
{
    for (UIButton *item in _videoScroll.subviews)
    {
        //移动到另一个按钮的区域，判断需要移动按钮的位置
        if (CGRectContainsPoint(item.frame, tileView.center) && item != tileView )
        {
            
            //开始的位置
            NSInteger fromIndex = tileView.tag - 300;
            //需要移动到的位置
            NSInteger toIndex = (item.tag - 300)>0?(item.tag - 300):0;
            NSLog(@"从位置%d移动到位置%d",(int)fromIndex, (int)toIndex);
            [self VdragMoveFromIndex:fromIndex ToIndex:toIndex withView:tileView];
        }
    }
//    [_videoScroll bringSubviewToFront:_titleLabel];
}

- (void)VdragMoveFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex withView:(UIView *)tileView
{
    //局部变量是不能在闭包中发生改变的，所以需要把_dragFromPoint，_dragToPoint定义成全局变量
    __block NSMutableArray * bnewAlbumlist = _newVideolist;
    __block UIScrollView * bphotoScrol = _videoScroll;
    NSDictionary * moveDict = [bnewAlbumlist objectAtIndex:fromIndex];
    [bnewAlbumlist removeObjectAtIndex:fromIndex];
    [bnewAlbumlist insertObject:moveDict atIndex:toIndex];
    //向前移动
    if (fromIndex > toIndex)
    {
        //把移动相册的上一个相册移动到记录的移动相册的位置，并把上一相册的位置记为新的_dragFromPoint，并把view的tag值+1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            
            for (int i = (int)fromIndex - 1; i >= toIndex; i--)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 300];
                _vdragToPoint = dragBu.center;
                dragBu.center = _vdragFromPoint;
                _vdragFromPoint = _vdragToPoint;
                dragBu.tag ++;
            }
            tileView.tag = 300 + toIndex;
        }];
    }
    //向后移动
    else
    {
        //把移动相册的下一个相册移动到记录的移动相册的位置，并把下一相册的位置记为新的_dragFromPoint，并把view的tag值-1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = (int)fromIndex + 1; i <= toIndex; i++)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 300];
                _vdragToPoint = dragBu.center;
                dragBu.center = _vdragFromPoint;
                _vdragFromPoint = _vdragToPoint;
                dragBu.tag --;
            }
            tileView.tag = 300 + toIndex;
        }];
    }
}
- (void)VdragTileEnded:(UIGestureRecognizer *)recognizer
{
    //    [UIView animateWithDuration:0.2f animations:^{
    //        recognizer.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
    //        recognizer.view.alpha = 1.f;
    //    }];
    
    [UIView animateWithDuration:0.2f animations:^{
        if (_visDragTileContainedInOtherTile)
            recognizer.view.center = _vdragToPoint;
        else
            recognizer.view.center = _vdragFromPoint;
    }];
    _visDragTileContainedInOtherTile = NO;
    NSLog(@"*******%@",_newVideolist);
}

// 从录制界面选择Video返回
-(void)sendBackVideoWith:(NSArray *)array
{
    [_newVideolist addObjectsFromArray:array];
    [self updateVideoScroll];
}
// 录制返回
-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    NSLog(@"===========%@",filePaht);
    [_newVideolist addObject:filePaht];
    [self updateVideoScroll];
}

// 直接选择Video返回
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [_newVideolist addObjectsFromArray:assets];
    [self updateVideoScroll];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
