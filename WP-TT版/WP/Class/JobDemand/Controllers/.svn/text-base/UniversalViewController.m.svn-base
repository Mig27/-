//
//  UniversalViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/9/1.
//  Copyright (c) 2015年 WP. All rights reserved.
//  通用界面（请吃饭，看电影，唱歌，户外，自定义）

#import "UniversalViewController.h"
#import "MyScrollView.h"
#import "ZCControl.h"

#import "UIPlaceHolderTextView.h"
#import "WriteCollectionViewCell.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "MBProgressHUD+MJ.h"

#import "LocationViewController.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "LocationViewController.h"
#import "PreviewViewController.h"
#import "DemandViewController.h"
#import "TYGSelectMenu.h"
#import "RecruitmentViewController.h"
#import "ApplyViewController.h"
#import "FreerideViewController.h"
#import "MakeFriendViewController.h"
#import "WPActionSheet.h"
#import "NewDemandViewController.h"

#define NORMALHEIGHT 43
#define FRAME_X 10
#define WIDTH  (SCREEN_WIDTH - 50)/4

@interface UniversalViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,sendBackLocation,WPActionSheet>

@property (nonatomic, strong)MyScrollView *scroll;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) TYGSelectMenu *menuLevel4;
@property (nonatomic, strong)UIButton *button1;
@property (nonatomic, strong)UIButton *button2;
@property (nonatomic, strong)UIButton *button3;
@property (nonatomic, strong)UIButton *button4;
@property (nonatomic, strong)UIButton *button5;
@property (nonatomic, strong)UIButton *button6;
@property (nonatomic,assign) int MAXCOUNT;
@property (nonatomic,strong) NSMutableArray *assets;
@property (nonatomic,assign) NSInteger delectPage;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIView *rootView;

@property (nonatomic,strong) UIView *viewTwo;
@property (nonatomic,strong) UIView *backView2;
@property (nonatomic,strong) NSMutableArray *photos;

@property (nonatomic,strong) UITextField *customeText;   //自定义时的标题
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *placeLabel;
@property (nonatomic,strong) UITextField *numberText;
@property (nonatomic,strong) UIView *filmView;
@property (nonatomic,strong) UITextField *filmText;
@property (nonatomic,strong) UIPlaceHolderTextView *text;
@property (nonatomic,strong) UILabel *locationLabel;
@property (nonatomic,assign) CGFloat preToMoveY; //编辑时移动的Y
@property (nonatomic,strong) UIView *timeView;
@property (nonatomic,assign) NSInteger addres_tag;
@property (nonatomic,strong) NSMutableArray *photoData; //照片的二进制数据
@property (nonatomic,strong) UIView *numberView;

@end

@implementation UniversalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _MAXCOUNT = 3;
    self.delectPage = -1;
    self.addres_tag = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.photos = [NSMutableArray array];
    self.buttons = [NSMutableArray array];
    self.photoData = [NSMutableArray array];
    [self createUI];
    [self createNave];
    [self loadMune];
}

- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

- (void)createNave
{
    if (self.type == PublishTypeEat) {
        self.title = @"请吃饭";
    } else if (self.type == PublishTypeFilm) {
        self.title = @"看电影";
    } else if (self.type == PublishTypeSing) {
        self.title = @"唱歌";
    } else if (self.type == PublishTypeOutdoor) {
        self.title = @"户外";
    } else if (self.type == PublishTypeCustom) {
        self.title = @"自定义";
    }
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = anotherButton;//    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(publish)];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: anotherButton2,anotherButton,nil]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnClick)];
}

- (void)loadMune
{
    NSArray *style = @[@"急招聘",@"急求职",@"交友",@"请吃饭",@"看电影",@"唱歌",@"户外",@"顺风车"];
    self.menuLevel4 = [[TYGSelectMenu alloc] init];
    for (NSString *title in style) {
        TYGSelectMenuEntity *menu4 = [[TYGSelectMenuEntity alloc] init];
        menu4.title = title;
        [_menuLevel4 addChildSelectMenu:menu4 forParent:nil];}
    
}

- (void)publish
{
    NSLog(@"发布");
    if (self.type == PublishTypeCustom) {
        if (self.customeText.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写自定义的主题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    if ([self.timeLabel.text isEqualToString:@"请选择时间"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.placeLabel.text isEqualToString:@"请选择地点"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择地点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.numberText.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写人数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.type == PublishTypeFilm) {
        if (self.filmText.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写电影名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    params[@"action"] = @"AddWonderful";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    if (self.type == PublishTypeEat) {
        params[@"domand_type"] = @"4";
        params[@"title"] = @"请吃饭";
    } else if (self.type == PublishTypeFilm) {
        params[@"domand_type"] = @"5";
        params[@"title"] = @"看电影";
    } else if (self.type == PublishTypeSing) {
        params[@"domand_type"] = @"6";
        params[@"title"] = @"唱歌";
    } else if (self.type == PublishTypeOutdoor){
        params[@"domand_type"] = @"7";
        params[@"title"] = @"户外";
    } else if (self.type == PublishTypeCustom) {
        params[@"domand_type"] = @"9";
        params[@"title"] = self.customeText.text;
    }
    params[@"remark"] = self.text.text;
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    params[@"address"] = @"中绿广场";
    if (self.selectBtn.isSelected) {
        params[@"is_anonymously"] = @"1";
    } else {
        params[@"is_anonymously"] = @"0";
    }
    
    if (self.button1.isSelected) {
        params[@"sex"] = @"2";
    }
    if (self.button2.isSelected) {
        params[@"sex"] = @"1";
    }
    if (self.button3.isSelected) {
        params[@"sex"] = @"0";
    }
    params[@"request_time"] = self.timeLabel.text;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *area = [user objectForKey:@"area"];
    params[@"begin_place"] = area;
    params[@"begin_place_address"] = self.placeLabel.text;
    params[@"meet_longitude"] = [user objectForKey:@"longitude"];
    params[@"meet_latitude"] = [user objectForKey:@"latitude"];
    params[@"person_count"] = self.numberText.text;
    if (self.button4.isSelected) {
        params[@"fees"] = @"1";
    } else if (self.button5.isSelected) {
        params[@"fees"] = @"2";
    } else if (self.button6.isSelected) {
        params[@"fees"] = @"3";
    }
    if (self.type == PublishTypeFilm) {
        params[@"film"] = self.filmText.text;
    }
    
    //封装图片
    for (int i = 0; i<self.assets.count; i++) {
        MLSelectPhotoAssets *asset = self.assets[i];
        if ([asset isKindOfClass:[UIImage class]]) {
            UIImage *image = [self fixOrientation:(UIImage *)asset];
            WPFormData *formData = [[WPFormData alloc]init];
            formData.data = UIImageJPEGRepresentation(image, 0.5);
            formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
            formData.filename = [NSString stringWithFormat:@"filedata_%d.jpg",i+1];
            formData.mimeType = @"application/octet-stream";
            [_photoData addObject:formData];
        } else {
            UIImage *img;
            CGFloat width = asset.asset.defaultRepresentation.dimensions.width;
            if (width <= 480) {
                img = [UIImage imageWithCIImage:asset.asset.defaultRepresentation.fullResolutionImage];
            } else {
                img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
            }
            
            UIImage *newImage;
            if (img.size.height/img.size.width >= 3) {
                if (img.size.width > 480) {
                    NSInteger proportion;
                    NSInteger width = (NSInteger)img.size.width;
                    if (width%480 == 0) {
                        proportion = width/480;
                    } else {
                        proportion = width/480 + 1;
                    }
                    newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(480, img.size.height/proportion)];
                } else {
                    newImage = img;
                }
            } else {
                if (img.size.width > 1000 && img.size.height > 1000) {
                    newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(1000, 1000)];
                } else if (img.size.width <= 1000 && img.size.height > 1000) {
                    newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(img.size.width, 1000)];
                } else if (img.size.width > 1000 && img.size.height <= 1000) {
                    newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(1000, img.size.height)];
                } else {
                    newImage = img;
                }
            }
            WPFormData *formData = [[WPFormData alloc]init];
            formData.data = UIImageJPEGRepresentation(newImage, 0.5);
            formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
            formData.filename = [NSString stringWithFormat:@"filedata_%d.jpg",i+1];
            formData.mimeType = @"application/octet-stream";
            [_photoData addObject:formData];
        }
    }
    
    
    NSLog(@"*****%@",params);
    NSLog(@"#####%@",url);
    if (self.assets.count == 0) {
        [WPHttpTool postWithURL:url params:params success:^(id json) {
            NSLog(@"%@",json);
            NSLog(@"%@",json[@"info"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([json[@"status"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD alertView:@"发布失败" Message:json[@"info"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"error: %@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD alertView:@"发布失败" Message:error.localizedDescription];
        }];
    } else {
        [WPHttpTool postWithURL:url params:params formDataArray:_photoData success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",json);
            NSLog(@"%@",json[@"info"]);
            if ([json[@"status"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD alertView:@"发布失败" Message:json[@"info"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"error: %@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD alertView:@"发布失败" Message:error.localizedDescription];
        }];
    }
    
}

//将自动旋转的图片调成正确的位置
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//控制图片大小
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

- (void)leftBtnClick
{
    [self.view endEditing:YES];
    [_menuLevel4 disMiss];
    [self dateDissmiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否退出本次编辑？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    alert.tag = 10;
    [alert show];
}

#pragma mark 右按钮点击事件
- (void)rightBtnClick
{
    [self.view endEditing:YES];
    [_menuLevel4 disMiss];
    [self dateDissmiss];
    NSLog(@"发布");
    if (self.type == PublishTypeCustom) {
        if (self.customeText.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写自定义的主题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    if ([self.timeLabel.text isEqualToString:@"请选择时间"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.placeLabel.text isEqualToString:@"请选择地点"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择地点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.numberText.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写人数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.type == PublishTypeFilm) {
        if (self.filmText.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写电影名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }

    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    params[@"action"] = @"AddWonderful";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    if (self.type == PublishTypeEat) {
        params[@"domand_type"] = @"4";
        params[@"title"] = @"请吃饭";
    } else if (self.type == PublishTypeFilm) {
        params[@"domand_type"] = @"5";
        params[@"title"] = @"看电影";
    } else if (self.type == PublishTypeSing) {
        params[@"domand_type"] = @"6";
        params[@"title"] = @"唱歌";
    } else if (self.type == PublishTypeOutdoor){
        params[@"domand_type"] = @"7";
        params[@"title"] = @"户外";
    } else if (self.type == PublishTypeCustom) {
        params[@"domand_type"] = @"9";
        params[@"title"] = self.customeText.text;
    }
    params[@"remark"] = self.text.text;
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    params[@"address"] = @"中绿广场";
    if (self.selectBtn.isSelected) {
        params[@"is_anonymously"] = @"1";
    } else {
        params[@"is_anonymously"] = @"0";
    }
    
    if (self.button1.isSelected) {
        params[@"sex"] = @"2";
    }
    if (self.button2.isSelected) {
        params[@"sex"] = @"1";
    }
    if (self.button3.isSelected) {
        params[@"sex"] = @"0";
    }
    params[@"request_time"] = self.timeLabel.text;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *area = [user objectForKey:@"area"];
    params[@"begin_place"] = area;
    params[@"begin_place_address"] = self.placeLabel.text;
    params[@"meet_longitude"] = [user objectForKey:@"longitude"];
    params[@"meet_latitude"] = [user objectForKey:@"latitude"];
    params[@"person_count"] = self.numberText.text;
    if (self.button4.isSelected) {
        params[@"fees"] = @"1";
    } else if (self.button5.isSelected) {
        params[@"fees"] = @"2";
    } else if (self.button6.isSelected) {
        params[@"fees"] = @"3";
    }
    if (self.type == PublishTypeFilm) {
        params[@"film"] = self.filmText.text;
    }
    
    
    NSMutableArray *data = [NSMutableArray array];
    if (self.type == PublishTypeCustom) {
        NSDictionary *dic1 = @{@"title"  : @"主       题:",
                               @"content": self.customeText.text};
        
        [data addObject:dic1];
    } else if (self.type == PublishTypeEat) {
        NSDictionary *dic1 = @{@"title"  : @"主       题:",
                               @"content": @"请吃饭"};
        
        [data addObject:dic1];
    } else if (self.type == PublishTypeFilm) {
        NSDictionary *dic1 = @{@"title"  : @"主       题:",
                               @"content": @"看电影"};
        
        [data addObject:dic1];
    } else if (self.type == PublishTypeOutdoor) {
        NSDictionary *dic1 = @{@"title"  : @"主       题:",
                               @"content": @"户外"};
        
        [data addObject:dic1];
    } else if (self.type == PublishTypeSing) {
        NSDictionary *dic1 = @{@"title"  : @"主       题:",
                               @"content": @"唱歌"};
        
        [data addObject:dic1];
    }
    
    if (self.button1.isSelected) {
        NSDictionary *dic2 = @{@"title"  : @"要       求:",
                               @"content": @"女"};
        
        [data addObject:dic2];
    } else if (self.button2.isSelected) {
        NSDictionary *dic2 = @{@"title"  : @"要       求:",
                               @"content": @"男"};
        
        [data addObject:dic2];
    } else if (self.button3.isSelected) {
        NSDictionary *dic2 = @{@"title"  : @"要       求:",
                               @"content": @"不限"};
        
        [data addObject:dic2];
    }
    
    NSDictionary *dic3 = @{@"title"  : @"时       间:",
                           @"content": self.timeLabel.text};
    
    [data addObject:dic3];
    
    NSDictionary *dic4 = @{@"title"  : @"地       点:",
                           @"content": self.placeLabel.text};
    
    [data addObject:dic4];

    NSDictionary *dic5 = @{@"title"  : @"人       数:",
                           @"content": self.numberText.text};
    
    [data addObject:dic5];

    if (self.type == PublishTypeFilm) {
        NSDictionary *dic6 = @{@"title"  : @"电       影:",
                               @"content": self.filmText.text};
        
        [data addObject:dic6];
    }
    
    if (self.button4.isSelected) {
        NSDictionary *dic7 = @{@"title"  : @"费       用:",
                               @"content": @"我请客"};
        
        [data addObject:dic7];
    } else if (self.button5.isSelected) {
        NSDictionary *dic7 = @{@"title"  : @"费       用:",
                               @"content": @"请客我"};
        
        [data addObject:dic7];
    } else if (self.button6.isSelected) {
        NSDictionary *dic7 = @{@"title"  : @"费       用:",
                               @"content": @"A A制"};
        
        [data addObject:dic7];
    }
    
    if (self.text.text.length != 0) {
        NSDictionary *dic12 = @{@"title"  : @"备       注:",
                                @"content": self.text.text};
        [data addObject:dic12];
    }
    
    PreviewViewController *preview = [[PreviewViewController alloc] init];
    preview.previewData = data;
    preview.assets = self.assets;
    if ([self.locationLabel.text isEqualToString:@"所在位置"] || [self.locationLabel.text isEqualToString:@"默认不显示"]) {
        preview.current_position = @"";
    } else {
        preview.current_position = self.locationLabel.text;
    }
    preview.params = params;
    [self.navigationController pushViewController:preview animated:YES];
    
    
}

- (void)createUI
{
    self.rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view addSubview:self.rootView];
    MyScrollView *scrollView = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scroll = scrollView;
    if (self.type == PublishTypeFilm) {
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 106 + WIDTH + 15 + 43*8 + 40 + 6 + 88);
    } else if (self.type == PublishTypeCustom){
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 106 + WIDTH + 15 + 43*8 + 40 + 6 - 44 + 88 + 44);
    } else {
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 106 + WIDTH + 15 + 43*8 + 40 + 6 - 44 + 88);
    }
    scrollView.delegate = self;
    scrollView.backgroundColor = RGBColor(235, 235, 235);
    [self.view addSubview:scrollView];
    
    //主题
    UIView *themeView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 43)];
    themeView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:themeView];
    
    CGSize normalSize = [@"工资待遇:" sizeWithFont:[UIFont systemFontOfSize:15]];
    CGFloat y = (43 - normalSize.height)/2;
    CGFloat height = normalSize.height;
    CGFloat width = normalSize.width;
    UILabel *titleLabel = [ZCControl createLabelWithFrame:CGRectMake(10, y, width, height) Font:15 Text:@"主       题:"];
    //    titleLabel.backgroundColor = [UIColor redColor];
    [themeView addSubview:titleLabel];
    
    
    if (self.type == PublishTypeCustom) {
        UIView *styleView = [[UIView alloc] initWithFrame:CGRectMake(0, themeView.bottom + 1, SCREEN_HEIGHT, 43)];
        styleView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:styleView];
        
        UILabel *styleLabel = [ZCControl createLabelWithFrame:CGRectMake(FRAME_X, y, width, height) Font:15 Text:@"类       型:"];
        [styleView addSubview:styleLabel];
        UITextField *companyText = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.right + RightF, 6.5, SCREEN_WIDTH - 44 - width, 30)];
        self.customeText = companyText;
        companyText.placeholder = @"请输入类型";
        [companyText becomeFirstResponder];
        [companyText setValue:RGBColor(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
        [companyText setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        companyText.font = [UIFont systemFontOfSize:15];
        [styleView addSubview:companyText];
        
        UILabel *titleLabel2 = [ZCControl createLabelWithFrame:CGRectMake(titleLabel.right + RightF, y, SCREEN_WIDTH - 100,height) Font:15 Text:@""];
        titleLabel2.text = @"自定义";
        [themeView addSubview:titleLabel2];
        
//        UIImageView *themeImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 12, 12, 20)];
//        //    image.backgroundColor = [UIColor redColor];
//        themeImg.image = [UIImage imageNamed:@"箭头"];
//        [styleView addSubview:themeImg];
//        
//        UIControl *themeControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NORMALHEIGHT)];
//        themeControl.tag = 20;
//        [themeControl addTarget:self action:@selector(clickToSelectWith:) forControlEvents:UIControlEventTouchUpInside];
//        [styleView addSubview:themeControl];

    } else {
        UILabel *titleLabel2 = [ZCControl createLabelWithFrame:CGRectMake(titleLabel.right + RightF, y, SCREEN_WIDTH - 100,height) Font:15 Text:@""];
        if (self.type == PublishTypeEat) {
            titleLabel2.text = @"请吃饭";
        } else if (self.type == PublishTypeFilm) {
            titleLabel2.text = @"看电影";
        } else if (self.type == PublishTypeSing) {
            titleLabel2.text = @"唱歌";
        } else if (self.type == PublishTypeOutdoor) {
            titleLabel2.text = @"户外";
        } else if (self.type == PublishTypeCustom) {
            titleLabel2.text = @"自定义";
        }
//        titleLabel2.textColor = RGBColor(170, 170, 170);
        [themeView addSubview:titleLabel2];
    }
    
    UIImageView *themeImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 12, 12, 20)];
    //    image.backgroundColor = [UIColor redColor];
    themeImg.image = [UIImage imageNamed:@"箭头"];
    [themeView addSubview:themeImg];
    
    UIControl *themeControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NORMALHEIGHT)];
    themeControl.tag = 20;
    [themeControl addTarget:self action:@selector(clickToSelectWith:) forControlEvents:UIControlEventTouchUpInside];
    [themeView addSubview:themeControl];
    
    //要求
    UIView *require = [[UIView alloc] init];
    if (self.type == PublishTypeCustom) {
        require.frame = CGRectMake(0, themeView.bottom + 10 + 44, SCREEN_WIDTH, 43);
    } else {
        require.frame = CGRectMake(0, themeView.bottom + 10, SCREEN_WIDTH, 43);
    }
    require.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:require];
    
    UILabel *requireLabel = [ZCControl createLabelWithFrame:CGRectMake(FRAME_X, y, width, height) Font:15 Text:@"要       求:"];
    [require addSubview:requireLabel];
    
    CGSize size1 = [@"我" sizeWithFont:[UIFont systemFontOfSize:15]];
    UIButton *girl = [UIButton buttonWithType:UIButtonTypeCustom];
    //    girl.backgroundColor = [UIColor redColor];
    girl.titleLabel.font = [UIFont systemFontOfSize:15];
    girl.frame = CGRectMake(requireLabel.right + RightF, 0, size1.width + 26, 43);
    girl.titleLabel.textAlignment = NSTextAlignmentLeft;
    [girl setTitleEdgeInsets:UIEdgeInsetsMake(y,  - 24, y, girl.bounds.size.width - 24)];
    [girl setImageEdgeInsets:UIEdgeInsetsMake(11.5, girl.frame.size.width - 20, 11.5, -14)];
    [girl setTitle:@"女" forState:UIControlStateNormal];
    girl.selected = YES;
    [girl setTitleColor:RGBColor(170, 170, 170) forState:UIControlStateNormal];
    [girl setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [girl setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    [girl setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateSelected];
    girl.tag = 1;
    [girl addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button1 = girl;
    [require addSubview:girl];
    UIButton *boy = [UIButton buttonWithType:UIButtonTypeCustom];
    //    girl.backgroundColor = [UIColor redColor];
    boy.titleLabel.font = [UIFont systemFontOfSize:15];
    boy.frame = CGRectMake(girl.right + 24, 0, size1.width + 26, 43);
    boy.titleLabel.textAlignment = NSTextAlignmentLeft;
    [boy setTitleEdgeInsets:UIEdgeInsetsMake(y,  - 24, y, girl.bounds.size.width - 24)];
    [boy setImageEdgeInsets:UIEdgeInsetsMake(11.5, girl.frame.size.width - 20, 11.5, -14)];
    [boy setTitle:@"男" forState:UIControlStateNormal];
    [boy setTitleColor:RGBColor(170, 170, 170) forState:UIControlStateNormal];
    [boy setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [boy setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    [boy setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateSelected];
    boy.tag = 2;
    [boy addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button2 = boy;
    [require addSubview:boy];
    
    UIButton *unlimited = [UIButton buttonWithType:UIButtonTypeCustom];
    //        unlimited.backgroundColor = [UIColor redColor];
    unlimited.titleLabel.font = [UIFont systemFontOfSize:15];
    unlimited.frame = CGRectMake(boy.right + 24, 0, 2*size1.width + 26, 43);
    unlimited.titleLabel.textAlignment = NSTextAlignmentLeft;
    [unlimited setTitleEdgeInsets:UIEdgeInsetsMake(y,  - 26, y, girl.bounds.size.width - 24)];
    [unlimited setImageEdgeInsets:UIEdgeInsetsMake(11.5, girl.frame.size.width - 20, 11.5, -40)];
    [unlimited setTitle:@"不限" forState:UIControlStateNormal];
    [unlimited setTitleColor:RGBColor(170, 170, 170) forState:UIControlStateNormal];
    [unlimited setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [unlimited setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    [unlimited setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateSelected];
    unlimited.tag = 3;
    [unlimited addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button3 = unlimited;
    [require addSubview:unlimited];

    
    //时间
    UIView *industry = [[UIView alloc] initWithFrame:CGRectMake(0, require.bottom + 1, SCREEN_WIDTH, 43)];
    industry.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:industry];
    self.timeView = industry;
    
    UILabel *industryLabel1 = [ZCControl createLabelWithFrame:CGRectMake(FRAME_X, y, width, height) Font:15 Text:@"时       间:"];
    [industry addSubview:industryLabel1];
    
    UILabel *industryLabel2 = [ZCControl createLabelWithFrame:CGRectMake(industryLabel1.right + RightF, y, SCREEN_WIDTH - 54 - width, height) Font:15 Text:@"请选择时间"];
    industryLabel2.textColor = RGBColor(170, 170, 170);
    [industry addSubview:industryLabel2];
    self.timeLabel = industryLabel2;
    
    UIImageView *industryImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 12, 12, 20)];
    //    image.backgroundColor = [UIColor redColor];
    industryImg.image = [UIImage imageNamed:@"箭头"];
    [industry addSubview:industryImg];
    
    UIControl *timeControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NORMALHEIGHT)];
    timeControl.tag = 1;
    [timeControl addTarget:self action:@selector(clickToSelectWith:) forControlEvents:UIControlEventTouchUpInside];
    [industry addSubview:timeControl];

    
    //地点
    UIView *position = [[UIView alloc] initWithFrame:CGRectMake(0, industry.bottom + 1, SCREEN_WIDTH, 43)];
    position.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:position];
    
    UILabel *positionLable1 = [ZCControl createLabelWithFrame:CGRectMake(FRAME_X, y, width, height) Font:15 Text:@"地       点:"];
    [position addSubview:positionLable1];
    
    UILabel *positionLabel2 = [ZCControl createLabelWithFrame:CGRectMake(industryLabel1.right + RightF, y, SCREEN_WIDTH - 54 - width, height) Font:15 Text:@"请选择地点"];
    positionLabel2.textColor = RGBColor(170, 170, 170);
    self.placeLabel = positionLabel2;
    [position addSubview:positionLabel2];
    
    UIImageView *positionImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 12, 12, 20)];
    //    image.backgroundColor = [UIColor redColor];
    positionImg.image = [UIImage imageNamed:@"箭头"];
    [position addSubview:positionImg];
    
    UIControl *positionControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NORMALHEIGHT)];
    positionControl.tag = 2;
    [positionControl addTarget:self action:@selector(clickToSelectWith:) forControlEvents:UIControlEventTouchUpInside];
    [position addSubview:positionControl];

    
    //人数
    UIView *salary = [[UIView alloc] initWithFrame:CGRectMake(0, position.bottom + 1, SCREEN_WIDTH, 43)];
    salary.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:salary];
    self.numberView = salary;
    
    UILabel *salaryLabel1 = [ZCControl createLabelWithFrame:CGRectMake(FRAME_X, y, width, height) Font:15 Text:@"人       数:"];
    [salary addSubview:salaryLabel1];
    
    UITextField *numberText = [[UITextField alloc] initWithFrame:CGRectMake(salaryLabel1.right + RightF, 6.5, SCREEN_WIDTH - 44 - width, 30)];
    self.numberText = numberText;
    numberText.placeholder = @"请填写人数";
    numberText.keyboardType = UIKeyboardTypeNumberPad;
    numberText.tag = 1;
    numberText.delegate = self;
    [numberText setValue:RGBColor(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
    [numberText setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    numberText.font = [UIFont systemFontOfSize:15];
    [salary addSubview:numberText];
    
//    UILabel *salaryLabel2 = [ZCControl createLabelWithFrame:CGRectMake(industryLabel1.right + 24, y, SCREEN_WIDTH - 54 - width, height) Font:15 Text:@"请选择人数"];
//    salaryLabel2.textColor = RGBColor(170, 170, 170);
//    [salary addSubview:salaryLabel2];
//    
//    UIImageView *salaryImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 12, 12, 20)];
//    //    image.backgroundColor = [UIColor redColor];
//    salaryImg.image = [UIImage imageNamed:@"箭头"];
//    [salary addSubview:salaryImg];
    
    //电影
    UIView *experience = [[UIView alloc] initWithFrame:CGRectMake(0, salary.bottom + 1, SCREEN_WIDTH, 43)];
    experience.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:experience];
    self.filmView = experience;
    UILabel *experienceLabel1 = [ZCControl createLabelWithFrame:CGRectMake(FRAME_X, y, width, height) Font:15 Text:@"电       影:"];
    [experience addSubview:experienceLabel1];
    
//    UILabel *experienceLabel2 = [ZCControl createLabelWithFrame:CGRectMake(industryLabel1.right + 24, y, SCREEN_WIDTH - 54 - width, height) Font:15 Text:@"请选择电影"];
//    experienceLabel2.textColor = RGBColor(170, 170, 170);
//    [experience addSubview:experienceLabel2];
//    
//    UIImageView *experienceImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 12, 12, 20)];
//    //    image.backgroundColor = [UIColor redColor];
//    experienceImg.image = [UIImage imageNamed:@"箭头"];
//    [experience addSubview:experienceImg];
    
    UITextField *fileText = [[UITextField alloc] initWithFrame:CGRectMake(experienceLabel1.right + RightF, 6.5, SCREEN_WIDTH - 44 - width, 30)];
    self.filmText = fileText;
    fileText.tag = 5;
    fileText.delegate = self;
    fileText.placeholder = @"请填写电影名称";
    [fileText setValue:RGBColor(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
    [fileText setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    fileText.font = [UIFont systemFontOfSize:15];
    [experience addSubview:fileText];

    
//    UIControl *experienceControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NORMALHEIGHT)];
//    experienceControl.tag = 3;
//    [experienceControl addTarget:self action:@selector(clickToSelectWith:) forControlEvents:UIControlEventTouchUpInside];
//    [experience addSubview:experienceControl];

    
    //费用
    UIView *cost = [[UIView alloc] init];
    if (self.type == PublishTypeFilm) {
        cost.frame = CGRectMake(0, salary.bottom + 1 + 44, SCREEN_WIDTH, 43);
    } else {
        cost.frame = CGRectMake(0, salary.bottom + 1, SCREEN_WIDTH, 43);
    }
    cost.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:cost];
    
    UILabel *costLabel = [ZCControl createLabelWithFrame:CGRectMake(FRAME_X, y, width, height) Font:15 Text:@"费       用:"];
    [cost addSubview:costLabel];
    
    CGSize size2 = [@"我请客" sizeWithFont:[UIFont systemFontOfSize:15]];
    UIButton *my = [UIButton buttonWithType:UIButtonTypeCustom];
//    my.backgroundColor = [UIColor redColor];
    my.titleLabel.font = [UIFont systemFontOfSize:15];
    my.frame = CGRectMake(requireLabel.right + 8, 0, size2.width + 20, 43);
    my.titleLabel.textAlignment = NSTextAlignmentLeft;
    [my setTitleEdgeInsets:UIEdgeInsetsMake(y,  - 24, y, girl.bounds.size.width - 24)];
    [my setImageEdgeInsets:UIEdgeInsetsMake(11.5, girl.frame.size.width, 11.5, -16)];
    [my setTitle:@"我请客" forState:UIControlStateNormal];
    my.selected = YES;
    [my setTitleColor:RGBColor(170, 170, 170) forState:UIControlStateNormal];
    [my setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [my setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    [my setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateSelected];
    my.tag = 4;
    [my addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button4 = my;
    [cost addSubview:my];
    UIButton *you = [UIButton buttonWithType:UIButtonTypeCustom];
//    you.backgroundColor = [UIColor orangeColor];
    you.titleLabel.font = [UIFont systemFontOfSize:15];
    you.frame = CGRectMake(my.right + 12, 0, size2.width + 20, 43);
    you.titleLabel.textAlignment = NSTextAlignmentLeft;
    [you setTitleEdgeInsets:UIEdgeInsetsMake(y,  - 24, y, girl.bounds.size.width - 24)];
    [you setImageEdgeInsets:UIEdgeInsetsMake(11.5, girl.frame.size.width, 11.5, -16)];
    [you setTitle:@"求请客" forState:UIControlStateNormal];
    [you setTitleColor:RGBColor(170, 170, 170) forState:UIControlStateNormal];
    [you setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [you setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    [you setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateSelected];
    you.tag = 5;
    [you addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button5 = you;
    [cost addSubview:you];
    
    UIButton *we = [UIButton buttonWithType:UIButtonTypeCustom];
//    we.backgroundColor = [UIColor yellowColor];
    we.titleLabel.font = [UIFont systemFontOfSize:15];
    we.frame = CGRectMake(you.right + 12, 0, size2.width + 20, 43);
    we.titleLabel.textAlignment = NSTextAlignmentLeft;
    [we setTitleEdgeInsets:UIEdgeInsetsMake(y,  - 24, y, girl.bounds.size.width - 24)];
    [we setImageEdgeInsets:UIEdgeInsetsMake(11.5, girl.frame.size.width, 11.5, -16)];
    [we setTitle:@"A A制" forState:UIControlStateNormal];
    [we setTitleColor:RGBColor(170, 170, 170) forState:UIControlStateNormal];
    [we setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [we setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    [we setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateSelected];
    we.tag = 6;
    [we addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button6 = we;
    [cost addSubview:we];
    
    UIView *remark = [[UIView alloc] initWithFrame:CGRectMake(0, cost.bottom + 1, SCREEN_WIDTH, 106 + WIDTH + 15)];
    remark.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:remark];
    
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    fl.scrollDirection = UICollectionViewScrollDirectionVertical;
    fl.minimumInteritemSpacing = 10;
    fl.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 106 + 5, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20) collectionViewLayout:fl];
    _collectionView.shouldGroupAccessibilityChildren = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator=YES;
    _collectionView.showsVerticalScrollIndicator=YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"WriteCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"WriteCollectionViewCellId"];
    _collectionView.backgroundColor = [UIColor clearColor];
    [remark addSubview:_collectionView];
    
    UIPlaceHolderTextView *text = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, cost.bottom + 1, SCREEN_WIDTH - 10, 103 - 10)];
    text.delegate = self;
    self.text = text;
    text.placeholder = @"备       注:  说些什么...";
    text.font = [UIFont systemFontOfSize:15];
    
    [scrollView addSubview:text];
    
    UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, remark.bottom + 10, SCREEN_WIDTH, 43)];
    lastView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:lastView];
    
    UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 12, 14, 17)];
    icon1.image = [UIImage imageNamed:@"地址"];
    UILabel *adress = [[UILabel alloc] initWithFrame:CGRectMake(icon1.right + 8, 12, SCREEN_WIDTH - 50, 20)];
    adress.text = @"所在位置";
    self.locationLabel = adress;
    adress.font = [UIFont systemFontOfSize:15];
    [lastView addSubview:adress];
    [lastView addSubview:icon1];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 12, 12, 20)];
    //    image.backgroundColor = [UIColor redColor];
    image.image = [UIImage imageNamed:@"箭头"];
    [lastView addSubview:image];
    
    UIControl *adressControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NORMALHEIGHT)];
    adressControl.tag = 4;
    [adressControl addTarget:self action:@selector(clickToSelectWith:) forControlEvents:UIControlEventTouchUpInside];
    [lastView addSubview:adressControl];

    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, lastView.bottom + 1, SCREEN_WIDTH, 43)];
    view2.backgroundColor = [UIColor whiteColor];
    UIImageView *icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(14.5, 14, 14, 14)];
    icon2.image = [UIImage imageNamed:@"匿名"];
    [view2 addSubview:icon2];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(icon2.right + 8, 11.5, 100, 20)];
    label2.text = @"匿名发布";
    label2.font = [UIFont systemFontOfSize:15];
    [view2 addSubview:label2];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(SCREEN_WIDTH - 34, 11.5, 21, 21);
    [_selectBtn setImage:[UIImage imageNamed:@"是否匿名"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"是匿名"] forState:UIControlStateSelected];
    _selectBtn.selected = NO;
    [view2 addSubview:_selectBtn];
    [self.selectBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick)];
    [view2 addGestureRecognizer:tap];
    [scrollView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.bottom + 1, SCREEN_WIDTH, 43)];
    view3.backgroundColor = [UIColor whiteColor];
    
    UIImageView *icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13.5, 14, 14)];
    icon3.image = [UIImage imageNamed:@"分享"];
    [view3 addSubview:icon3];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(icon3.right + 8, 11.5, 100, 20)];
    label3.text = @"分享到";
    label3.font = [UIFont systemFontOfSize:15];
    [view3 addSubview:label3];
    
    NSArray *unSelectImg = @[@"weixin",@"friend",@"qq",@"qzone",@"sina"];
    NSArray *selectImg = @[@"weixin_select",@"friend_select",@"qq_select",@"qzone_select",@"sina_select"];
    
    CGFloat x1 = SCREEN_WIDTH - 144;
    CGFloat y1 = 11.5;
    CGFloat width1 = 22;
    
    for (int i = 0; i < unSelectImg.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x1 + i%5*(width1 + 6), y1 + i/5*(width1 + 6), width1, width1);
        [btn setImage:[UIImage imageNamed:unSelectImg[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImg[i]] forState:UIControlStateSelected];
        btn.tag = i + 1;
        btn.selected = NO;
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:btn];
        [view3 addSubview:btn];
    }
    
    [scrollView addSubview:view3];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    //设置style
    [topView setBarStyle:UIBarStyleDefault];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem * button1 = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    UIBarButtonItem * button2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [_text setInputAccessoryView:topView];
    [_numberText setInputAccessoryView:topView];
    [_filmText setInputAccessoryView:topView];
}

- (void)resignKeyboard
{
    [self.view endEditing:YES];
}

- (void)buttonClick{
    if (self.selectBtn.isSelected == YES) {
        self.selectBtn.selected = NO;
    } else {
        self.selectBtn.selected = YES;
    }
}

- (void)shareBtnClick:(UIButton *)sender
{
    UIButton *button = self.buttons[sender.tag - 1];
    if (button.isSelected == YES) {
        button.selected = NO;
    } else {
        button.selected = YES;
    }
}

- (void)clickToSelectWith:(UIControl *)control
{
    [self.view endEditing:YES];
    [self dateDissmiss];
    if (control.tag == 1) {
        NSLog(@"时间");
        [self createDatePicker];
    } else if (control.tag == 2) {
        NSLog(@"地点");
        LocationViewController *location = [[LocationViewController alloc] init];
        location.delegate = self;
        self.addres_tag = 1;
        [self.navigationController pushViewController:location animated:YES];
    } else if (control.tag == 3) {
        NSLog(@"电影");
    } else if (control.tag == 4) {
        NSLog(@"所在位置");
        LocationViewController *location = [[LocationViewController alloc] init];
        location.delegate = self;
        self.addres_tag = 2;
        [self.navigationController pushViewController:location animated:YES];
    } else if (control.tag == 20) {
        [self selectNewStyle];
    }
}

- (void)selectNewStyle{
    [_menuLevel4 showFromView:self.rootView];
    [_menuLevel4 selectAtMenu:^(NSMutableArray *selectedMenuArray) {
        
        NSMutableString *title = [NSMutableString string];
        for (TYGSelectMenuEntity *tempMenu in selectedMenuArray) {
            [title appendString:[NSString stringWithFormat:@"%ld",(long)tempMenu.id]];
            NSLog(@"***%@",tempMenu.title);
            //                self.time.textColor = [UIColor blackColor];
            //                self.time.text = tempMenu.title;
            if ([self.title isEqualToString:tempMenu.title]) {
                return ;
            } else if ([tempMenu.title isEqualToString:@"急招聘"]) {
                RecruitmentViewController *recruit = [[RecruitmentViewController alloc] init];
                [self.navigationController pushViewController:recruit animated:YES];
            }else if ([tempMenu.title isEqualToString:@"急求职"]) {
                ApplyViewController *apply = [[ApplyViewController alloc] init];
                [self.navigationController pushViewController:apply animated:YES];
            } else if ([tempMenu.title isEqualToString:@"交友"]){
                MakeFriendViewController *make = [[MakeFriendViewController alloc] init];
                [self.navigationController pushViewController:make animated:YES];
            } else if ([tempMenu.title isEqualToString:@"请吃饭"]) {
                UniversalViewController *universal = [[UniversalViewController alloc] init];
                universal.type = PublishTypeEat;
                [self.navigationController pushViewController:universal animated:YES];
            } else if ([tempMenu.title isEqualToString:@"看电影"]) {
                UniversalViewController *universal = [[UniversalViewController alloc] init];
                universal.type = PublishTypeFilm;
                [self.navigationController pushViewController:universal animated:YES];
            } else if ([tempMenu.title isEqualToString:@"唱歌"]) {
                UniversalViewController *universal = [[UniversalViewController alloc] init];
                universal.type = PublishTypeSing;
                [self.navigationController pushViewController:universal animated:YES];
            } else if ([tempMenu.title isEqualToString:@"户外"]) {
                UniversalViewController *universal = [[UniversalViewController alloc] init];
                universal.type = PublishTypeOutdoor;
                [self.navigationController pushViewController:universal animated:YES];
            } else if ([tempMenu.title isEqualToString:@"自定义"]) {
                UniversalViewController *universal = [[UniversalViewController alloc] init];
                universal.type = PublishTypeCustom;
                [self.navigationController pushViewController:universal animated:YES];
            } else if ([tempMenu.title isEqualToString:@"顺风车"]) {
                FreerideViewController *free = [[FreerideViewController alloc] init];
                [self.navigationController pushViewController:free animated:YES];
            }
            
        }
    }];
}

- (void)sendBackLocationWith:(NSString *)location
{
    if (self.addres_tag == 1) {
        self.placeLabel.text = location;
        self.placeLabel.textColor = [UIColor blackColor];
    } else {
        self.locationLabel.text = location;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 5) {
        CGRect textFrame =  self.filmView.frame;
        float textY = textFrame.origin.y+textFrame.size.height;
        float bottomY = self.view.frame.size.height- (textY - _scroll.contentOffset.y);
        if (bottomY>=240 + 30) {
            return;
        }
        float moveY = 240 + 30-bottomY + _scroll.contentOffset.y;
        [_scroll scrollRectToVisible:CGRectMake(0, moveY, SCREEN_WIDTH, _scroll.frame.size.height) animated:YES];
    } else if (textField.tag == 1) {
        CGRect textFrame =  self.numberView.frame;
        float textY = textFrame.origin.y+textFrame.size.height;
        float bottomY = self.view.frame.size.height- (textY - _scroll.contentOffset.y);
        if (bottomY>=220 + 30) {
            return;
        }
        float moveY = 220 + 30-bottomY + _scroll.contentOffset.y;
        [_scroll scrollRectToVisible:CGRectMake(0, moveY, SCREEN_WIDTH, _scroll.frame.size.height) animated:YES];
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView

{
    [self dateDissmiss];
    //    [super textViewDidBeginEditing:textView];
    CGRect textFrame =  textView.frame;
    float textY = textFrame.origin.y+textFrame.size.height;
    float bottomY = self.view.frame.size.height- (textY - _scroll.contentOffset.y);
    NSLog(@"%f",bottomY);
    if(bottomY>=300)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度,汉字键盘高度是252，这个根据输入的情况来定
    {
        return;
    }
    float moveY = 300-bottomY;
    _preToMoveY = moveY;
    
    //view的上移
    CGRect frame = self.view.frame;
    
    NSTimeInterval animationDuration = 0.50f;
    frame.origin.y -= moveY;//view的Y轴上移
    frame.size.height += moveY; //View的高度增加
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //    if(prewTag == -1) //当编辑的View不是需要移动的View
    //    {
    //        return;
    //    }
    float moveY ;
    NSTimeInterval animationDuration = 0.50f;
    CGRect frame = self.view.frame;
    //    if(prewTag == textView.tag) //当结束编辑的View的TAG是上次的就移动
    //    {   //还原界面
    moveY =  _preToMoveY;
    frame.origin.y +=moveY;
    frame.size. height -=moveY;
    self.view.frame = frame;
    //    }
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textView resignFirstResponder];
    
}

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        //设置最大值
        //_datePicker.maximumDate = [NSDate date];
        //设置最小值
        NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
        [fomatter setDateFormat:@"yyyy-MM-dd"];
        //设置日期格式
        //    [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        //    if (date == 3 || date == 4) {
        //        [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        //        _datePicker.minuteInterval = 15;
        //    }
        //    NSDate *date1 = [NSDate date];
        //    _datePicker.minimumDate = [fomatter dateFromString:@"1960-01-01"];
        _datePicker.minimumDate = [NSDate date];
        [self.view addSubview:_datePicker];
        [_datePicker addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - 创建选择日期的datePicker
- (void)createDatePicker
{
    //设置动画
    [self datePicker];
    [UIView animateWithDuration:0.3 animations:^{
        _datePicker.frame = CGRectMake(0, SCREEN_HEIGHT - 216 - 64, SCREEN_WIDTH, 216);
    }];
    CGRect textFrame =  self.timeView.frame;
    NSLog(@"%@",NSStringFromCGRect(textFrame));
    float textY = textFrame.origin.y+textFrame.size.height;
    NSLog(@"%f",_scroll.contentOffset.y);
    float bottomY = self.view.frame.size.height- (textY - _scroll.contentOffset.y);
    NSLog(@"%f",bottomY);
    if (bottomY>=220) {
        return;
    }
    float moveY = 220-bottomY + _scroll.contentOffset.y;
    [_scroll scrollRectToVisible:CGRectMake(0, moveY, SCREEN_WIDTH, _scroll.frame.size.height) animated:YES];
    
}

- (void)dateClick
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateAndTime = [fomatter stringFromDate:_datePicker.date];
    NSLog(@"%@",dateAndTime);
    self.timeLabel.text = dateAndTime;
    self.timeLabel.textColor = [UIColor blackColor];
    //    NSString *subStr = [dateAndTime substringToIndex:10];
}

- (void)dateDissmiss
{
    [UIView animateWithDuration:0.3 animations:^{
        _datePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self dateDissmiss];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WriteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WriteCollectionViewCellId" forIndexPath:indexPath];
    
    if (self.assets.count>0 && self.assets.count<self.MAXCOUNT) {
        if (indexPath.row == self.assets.count) {
            cell.imageV.image = [UIImage imageNamed:@"write_bounds"];
            cell.deleteBtn.hidden = YES;
        } else {
            MLSelectPhotoAssets *asset = self.assets[indexPath.row];
            cell.imageV.image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
            cell.deleteBtn.hidden = NO;
            cell.deleteBtn.tag = indexPath.row + 1;
            [cell.deleteBtn addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if (self.assets.count == 0) {
        cell.imageV.image = [UIImage imageNamed:@"write_bounds"];
        cell.deleteBtn.hidden = YES;
    } else if (self.assets.count == self.MAXCOUNT) {
        MLSelectPhotoAssets *asset = self.assets[indexPath.row];
        cell.imageV.image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
        cell.deleteBtn.hidden = NO;
        cell.deleteBtn.tag = indexPath.row + 1;
        [cell.deleteBtn addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}

- (void)deletePicture:(UIButton *)sender
{
    self.delectPage = sender.tag - 1;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要删除该张图片吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 5;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 5) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else if (buttonIndex == 1) {
            NSLog(@"删除");
            [self.assets removeObjectAtIndex:self.delectPage];
            [self.collectionView reloadData];
        }
    } else if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else if (buttonIndex == 1) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[NewDemandViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }
        
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.assets.count < self.MAXCOUNT) {
        return self.assets.count + 1;
    } else {
        return self.assets.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 50)/4, (SCREEN_WIDTH - 50)/4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    [self.text resignFirstResponder];
    if (self.assets.count < 9) { //相册里面没有9张图片
        if (indexPath.row == self.assets.count) {
            [self onTap];
        } else {
            MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
            browserVc.currentPage = indexPath.row;
            browserVc.photos = self.assets;
            [self.navigationController pushViewController:browserVc animated:YES];
        }
    } else {                    //相册已选满，不能再选了
        MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
        browserVc.currentPage = indexPath.row;
        browserVc.photos = self.assets;
        [self.navigationController pushViewController:browserVc animated:YES];
    }
}


- (void)onTap{
    NSLog(@"添加图片");
    [self selectPicture];
}

- (void)selectPicture{
    [self.view endEditing:YES];
    [self dateDissmiss];
//    self.viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 - 44)];
//    self.viewTwo.backgroundColor = RGBColor(235, 235, 235);
//    NSArray *titles = @[@"从相册选择",@"拍拍"];
//    for (int i = 0; i<titles.count; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 44*i, SCREEN_WIDTH, 43);
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        button.backgroundColor = [UIColor whiteColor];
//        [button setTitle:titles[i] forState:UIControlStateNormal];
//        button.tag = i + 1;
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.viewTwo addSubview:button];
//    }
//    
//    UIButton *buttonSix = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonSix.frame = CGRectMake(0, 44*2 + 6, self.view.bounds.size.width, 43);
//    [buttonSix setImage:[UIImage imageNamed:@"menu_cancel"] forState:UIControlStateNormal];
//    //    [buttonSix setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [buttonSix setBackgroundColor:[UIColor whiteColor]];
//    buttonSix.tag = 4;
//    [buttonSix setImageEdgeInsets:UIEdgeInsetsMake(5, (SCREEN_WIDTH - 33)/2, 5, (SCREEN_WIDTH - 33)/2)];
//    [buttonSix addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.viewTwo addSubview:buttonSix];
//    
//    self.backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.backView2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    [self.backView2 addSubview:self.viewTwo];
//    self.backView2.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
//    [self.backView2 addGestureRecognizer:tap];
//    
//    [self.view addSubview:self.backView2];
    WPActionSheet *action =[[WPActionSheet alloc] initWithDelegate:self otherButtonTitle:@[@"相册",@"拍照"] imageNames:nil top:0];
    [action showInView:self.view];
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self selectPhoto];
    } else {
        [self takePhoto];
    }
}

- (void)selectPhoto{
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = self.MAXCOUNT - self.assets.count;
    //        [pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [weakSelf.assets addObjectsFromArray:assets];
        for (MLSelectPhotoAssets *asset in assets) {
            UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
            [_photos addObject:image];
        }
        [self.collectionView reloadData];
    };
}

- (void)takePhoto
{
    UIImagePickerController*picker=[[UIImagePickerController alloc]init];
    //判读相机是否可以启动
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)photoBtnClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        NSLog(@"相册");
        [self cancelView];
        // 创建控制器
        MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
        // 默认显示相册里面的内容SavePhotos
        pickerVc.status = PickerViewShowStatusCameraRoll;
        pickerVc.minCount = self.MAXCOUNT - self.assets.count;
        //        [pickerVc show];
        [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
        __weak typeof(self) weakSelf = self;
        pickerVc.callBack = ^(NSArray *assets){
            [weakSelf.assets addObjectsFromArray:assets];
            for (MLSelectPhotoAssets *asset in assets) {
                UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                [_photos addObject:image];
            }
            [self.collectionView reloadData];
        };
        
    } else if (sender.tag == 2) {
        NSLog(@"拍拍");
        UIImagePickerController*picker=[[UIImagePickerController alloc]init];
        //判读相机是否可以启动
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:nil];
        
        [self cancelView];
    } else if (sender.tag == 3) {
        NSLog(@"视频");
        [self cancelView];
    } else {
        [self cancelView];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_assets addObject:image];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    
}

- (void)cancelView{
    [self.viewTwo removeFromSuperview];
    [self.backView2 removeFromSuperview];
}


- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
    } else if (sender.tag == 2) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
    } else if (sender.tag == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
    } else if (sender.tag == 4) {
        self.button4.selected = YES;
        self.button5.selected = NO;
        self.button6.selected = NO;
    } else if (sender.tag == 5) {
        self.button4.selected = NO;
        self.button5.selected = YES;
        self.button6.selected = NO;
    } else {
        self.button4.selected = NO;
        self.button5.selected = NO;
        self.button6.selected = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
