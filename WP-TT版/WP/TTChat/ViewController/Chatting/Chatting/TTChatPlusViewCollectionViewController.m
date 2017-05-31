//
//  TTChatPlusViewCollectionViewController.m
//  WP
//
//  Created by CC on 16/6/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "TTChatPlusViewCollectionViewController.h"
#import "TTChatPlusCell.h"
#import "WPChatPlusModel.h"
#import "PlusCollectionFooterView.h"
#import "AlbumViewController.h"
#import "MTTShakeAPI.h"
#import "RuntimeStatus.h"
#import "ChattingMainViewController.h"


#import "DDSendPhotoMessageAPI.h"
#import "DDMessageSendManager.h"
#import "MTTPhotosCache.h"


static NSString *kTTChatPlusCellIdentifier = @"kTTChatPlusCellIdentifier";

@interface TTChatPlusViewCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic, strong) PlusCollectionFooterView *footerView;

@property(nonatomic,strong)NSArray *itemsArray;
@property(nonatomic,strong)UIView *rightView;

@property(nonatomic,strong)UIPageControl *pageControl;


@end

@implementation TTChatPlusViewCollectionViewController

-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        WPChatPlusModel *model1 = [[WPChatPlusModel alloc] init];
        model1.icon = @"common_fstupian";
        model1.iconname = @"图片";
        WPChatPlusModel *model2 = [[WPChatPlusModel alloc] init];
        model2.icon = @"common_fspaizhao";
        model2.iconname = @"拍照";
        WPChatPlusModel *model3 = [[WPChatPlusModel alloc] init];
        model3.icon = @"common_fsduanshipin";
        model3.iconname = @"短视频";
        WPChatPlusModel *model4 = [[WPChatPlusModel alloc] init];
        model4.icon = @"common_fsdizhi";
        model4.iconname = @"位置";
        WPChatPlusModel *model5 = [[WPChatPlusModel alloc] init];
        model5.icon = @"common_fszaixiandianhua";
        model5.iconname = @"在线电话";
        WPChatPlusModel *model6 = [[WPChatPlusModel alloc] init];
        model6.icon = @"common_fszaixianshipin";
        model6.iconname = @"在线视频";
        WPChatPlusModel *model7 = [[WPChatPlusModel alloc] init];
        model7.icon = @"common_fsshocuang";
        model7.iconname = @"收藏";
        WPChatPlusModel *model8 = [[WPChatPlusModel alloc] init];
        model8.icon = @"common_fsmingpian";
        model8.iconname = @"名片";
        WPChatPlusModel *model9 = [[WPChatPlusModel alloc] init];
        model7.icon = @"common_fsshocuang";
        model7.iconname = @"我的求职";
        WPChatPlusModel *model10 = [[WPChatPlusModel alloc] init];
        model8.icon = @"common_fsmingpian";
        model8.iconname = @"我的招聘";
        _dataList = [NSMutableArray arrayWithObjects:model1,model2,model3,model4,model5,model6,model7,model8,model9,model10, nil];
    }
    return _dataList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupcollectionView];
}

#pragma mark -- 设置布局,根据布局创建collectionView
- (void)setupcollectionView{

        //流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 1.0;
        CGFloat width = (SCREEN_WIDTH - 5)/4;
        layout.itemSize = CGSizeMake(width, width);
        layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50.0f);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280) collectionViewLayout:layout];
        self.collectionView.backgroundColor = RGB(226, 226, 226);
        [self.collectionView  registerClass:[TTChatPlusCell class] forCellWithReuseIdentifier:kTTChatPlusCellIdentifier];
        self.collectionView .delegate = self;
        self.collectionView .dataSource = self;
//        self.collectionView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 216);
        self.collectionView .showsHorizontalScrollIndicator = NO;
        self.collectionView.pagingEnabled = YES;
        self.collectionView .showsVerticalScrollIndicator = NO;
        [self.collectionView registerClass:[PlusCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];              //注册尾视图
        [self.view addSubview:self.collectionView];

}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = self.collectionView.contentOffset.x / SCREEN_WIDTH;
    self.pageControl.currentPage = page;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {    //尾视图
        _footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        _footerView.backgroundColor = RGB(247, 247, 247);
        reusableView = _footerView;
    }
    return reusableView;


   
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
  
        CGFloat width = (SCREEN_WIDTH - 5)/4;
        return CGSizeMake(SCREEN_WIDTH, 280-2*width);
   
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView  numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TTChatPlusCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTTChatPlusCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.item];
    cell.backgroundColor = RGB(247, 247, 247);
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self choosePicture:nil];
            break;
        case 1:
            [self takePicture:nil];
            break;
            
        default:
            break;
    }
    
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



//-(void)setShakeHidden
//{
//    if(self.userId){
//        [_rightView setHidden:NO];
//    }else{
//        [_rightView setHidden:YES];
//    }
//}
-(void)shakePC:(id)sender
{
    if([MTTUtil ifCanShake])
    {
        NSDate *date = [NSDate date];
        [MTTUtil setLastShakeTime:date];
        MTTShakeAPI *request = [MTTShakeAPI new];
        NSMutableArray *array = [NSMutableArray new];
        [array addObject:@(self.userId)];
        [request requestWithObject:array Completion:^(id response, NSError *error) {
        }];
        [[ChattingMainViewController shareInstance] sendPrompt:@"你向对方发送了一个抖动~"];
        NSString* nick = [RuntimeStatus instance].user.nick;
        NSDictionary *dict = @{@"nick":nick};
    }else{
        [[ChattingMainViewController shareInstance] sendPrompt:@"留条活路吧...别太频繁了"];
    }
}
-(void)choosePicture:(id)sender
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self pushViewController:[AlbumViewController new] animated:YES];
    [self.navigationController pushViewController:[AlbumViewController new] animated:YES];
}
-(void)takePicture:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        if (self.imagePicker ) {
            [[ChattingMainViewController shareInstance].navigationController presentViewController:self.imagePicker animated:NO completion:nil];
        }else{
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [[ChattingMainViewController shareInstance].navigationController presentViewController:self.imagePicker animated:NO completion:nil];
        }
        
    });
}
- (void) viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker=nil;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        
        __block UIImage *theImage = nil;
        if ([picker allowsEditing]){
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            
        }
        UIImage *image = [self scaleImage:theImage toScale:0.3];
        NSData *imageData = UIImageJPEGRepresentation(image, (CGFloat)1.0);
        UIImage * m_selectImage = [UIImage imageWithData:imageData];
        __block MTTPhotoEnity *photo = [MTTPhotoEnity new];
        NSString *keyName = [[MTTPhotosCache sharedPhotoCache] getKeyName];
        photo.localPath=keyName;
        [picker dismissViewControllerAnimated:NO completion:nil];
        self.imagePicker=nil;
        [[ChattingMainViewController shareInstance] sendImageMessage:photo Image:m_selectImage];
    }
    
}
#pragma mark -
#pragma mark 等比縮放image
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize, image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
