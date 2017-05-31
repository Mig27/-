//
//  PreviewViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/9/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "PreviewViewController.h"
#import "PreViewCell.h"
#import "DemandViewController.h"
#import "FDActionSheet.h"
#import "MLSelectPhotoAssets.h"
#import "WPHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "NewDemandViewController.h"

@interface PreviewViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,FDActionSheetDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) NSMutableArray *photoData;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.photoData = [NSMutableArray array];
//    NSLog(@"%@",self.previewData);
    [self initNav];
    [self creattableView];
    [self createBottom];
}

- (void)initNav
{
    self.title = @"预览";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnClick)];
}

- (void)rightBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBtnClick{
    
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"是否保存为草稿？"
                                                  delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"保存", @"不保存", nil];
    [sheet setTitleColor:[UIColor lightGrayColor] fontSize:12];
    [sheet setButtonTitleColor:[UIColor redColor] bgColor:nil fontSize:0 atIndex:1];
    [sheet show];
}

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[DemandViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)createBottom
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 104 - 3, SCREEN_WIDTH, 43)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 104 - 3 , SCREEN_WIDTH, 0.5)];
    view.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:view];
    
    UIButton *deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deletBtn.frame = CGRectMake(0, 0, 34, 43);
    [deletBtn setImage:[UIImage imageNamed:@"delet_info"] forState:UIControlStateNormal];
    [deletBtn addTarget:self action:@selector(deletBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:deletBtn];
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(34, 0, SCREEN_WIDTH - 34*2, 43);
    [publishBtn setImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
    [publishBtn setTitle:@"  发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:RGBColor(153, 153, 153) forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:publishBtn];
}

- (void)deletBtnClick{
    NSLog(@"删除");
}

- (void)publishBtnClick{
    NSLog(@"发布");

    [MBProgressHUD showMessage:@"" toView:self.view];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    //封装图片
    for (int i = 0; i<self.assets.count; i++) {
        MLSelectPhotoAssets *asset = self.assets[i];
        if ([asset isKindOfClass:[UIImage class]]) {
            
            //            UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.frame];
            //            image.image = (UIImage *)asset;
            //            [self.view addSubview:image];
            UIImage *image = [self fixOrientation:(UIImage *)asset];
            WPFormData *formData = [[WPFormData alloc]init];
            formData.data = UIImageJPEGRepresentation(image, 0.5);
            formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
            formData.filename = [NSString stringWithFormat:@"filedata_%d.jpg",i+1];
            formData.mimeType = @"application/octet-stream";
            [_photoData addObject:formData];
        } else {
            NSArray * arr = [asset.asset valueForProperty:ALAssetPropertyRepresentations] ;
            if ([arr[0] rangeOfString:@".bmp"].location !=NSNotFound) {
                NSLog(@"BMP");
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                WPFormData *formData = [[WPFormData alloc]init];
                //                formData.data = [NSData dataWithContentsOfURL:nsALAssetPropertyAssetURL];
                formData.data = UIImageJPEGRepresentation(img, 0.5);
                formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
                formData.filename = [NSString stringWithFormat:@"filedata_%d.jpg",i+1];
                formData.mimeType = @"application/octet-stream";
                [_photoData addObject:formData];
            } else if ([arr[0] rangeOfString:@".gif"].location !=NSNotFound) {
                NSLog(@"GIF");
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                WPFormData *formData = [[WPFormData alloc]init];
                //                formData.data = [NSData dataWithContentsOfURL:nsALAssetPropertyAssetURL];
                formData.data = UIImageJPEGRepresentation(img, 0.5);
                formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
                formData.filename = [NSString stringWithFormat:@"filedata_%d.gif",i+1];
                formData.mimeType = @"application/octet-stream";
                [_photoData addObject:formData];
            } else {
                NSLog(@"NOMAL");
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                
                //                UIImage *img;
                //                CGFloat width = asset.asset.defaultRepresentation.dimensions.width;
                //                if (width <= 480) {
                //                    img = [UIImage imageWithCIImage:asset.asset.defaultRepresentation.fullResolutionImage];
                //                } else {
                //                    img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                //                }
                //
                //                UIImage *newImage;
                //                if (img.size.height/img.size.width >= 3) {
                //                    if (img.size.width > 480) {
                //                        NSInteger proportion;
                //                        NSInteger width = (NSInteger)img.size.width;
                //                        if (width%480 == 0) {
                //                            proportion = width/480;
                //                        } else {
                //                            proportion = width/480 + 1;
                //                        }
                //                        newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(480, img.size.height/proportion)];
                //                    } else {
                //                        newImage = img;
                //                    }
                //                } else {
                //                    if (img.size.width > 1000 && img.size.height > 1000) {
                //                        newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(1000, 1000)];
                //                    } else if (img.size.width <= 1000 && img.size.height > 1000) {
                //                        newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(img.size.width, 1000)];
                //                    } else if (img.size.width > 1000 && img.size.height <= 1000) {
                //                        newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(1000, img.size.height)];
                //                    } else {
                //                        newImage = img;
                //                    }
                //                }
                WPFormData *formData = [[WPFormData alloc]init];
                formData.data = UIImageJPEGRepresentation(img, 0.5);
                formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
                formData.filename = [NSString stringWithFormat:@"filedata_%d.jpg",i+1];
                formData.mimeType = @"application/octet-stream";
                [_photoData addObject:formData];
            }
        }
    }
    

//    
//    for (int i = 0; i<self.assets.count; i++) {
//        MLSelectPhotoAssets *asset = self.assets[i];
//        if ([asset isKindOfClass:[UIImage class]]) {
//            UIImage *image = [self fixOrientation:(UIImage *)asset];
//            WPFormData *formData = [[WPFormData alloc]init];
//            formData.data = UIImageJPEGRepresentation(image, 0.5);
//            formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
//            formData.filename = [NSString stringWithFormat:@"filedata_%d.jpg",i+1];
//            formData.mimeType = @"application/octet-stream";
//            [_photoData addObject:formData];
//        } else {
//            UIImage *img;
//            CGFloat width = asset.asset.defaultRepresentation.dimensions.width;
//            if (width <= 480) {
//                img = [UIImage imageWithCIImage:asset.asset.defaultRepresentation.fullResolutionImage];
//            } else {
//                img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
//            }
//            
//            UIImage *newImage;
//            if (img.size.height/img.size.width >= 3) {
//                if (img.size.width > 480) {
//                    NSInteger proportion;
//                    NSInteger width = (NSInteger)img.size.width;
//                    if (width%480 == 0) {
//                        proportion = width/480;
//                    } else {
//                        proportion = width/480 + 1;
//                    }
//                    newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(480, img.size.height/proportion)];
//                } else {
//                    newImage = img;
//                }
//            } else {
//                if (img.size.width > 1000 && img.size.height > 1000) {
//                    newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(1000, 1000)];
//                } else if (img.size.width <= 1000 && img.size.height > 1000) {
//                    newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(img.size.width, 1000)];
//                } else if (img.size.width > 1000 && img.size.height <= 1000) {
//                    newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(1000, img.size.height)];
//                } else {
//                    newImage = img;
//                }
//            }
//            WPFormData *formData = [[WPFormData alloc]init];
//            formData.data = UIImageJPEGRepresentation(newImage, 0.5);
//            formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
//            formData.filename = [NSString stringWithFormat:@"filedata_%d.jpg",i+1];
//            formData.mimeType = @"application/octet-stream";
//            [_photoData addObject:formData];
//        }
//    }
    
    
    NSLog(@"*****%@",self.params);
    NSLog(@"#####%@",url);
    if (self.assets.count == 0) {
        [WPHttpTool postWithURL:url params:_params success:^(id json) {
            NSLog(@"%@",json);
            NSLog(@"%@",json[@"info"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([json[@"status"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
                NSString *title = self.previewData[0][@"content"];
                if ([title isEqualToString:@"搭顺风车"]) {
                    title = @"顺风车";
                }
                NSLog(@"*****%@",title);
                NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:title,@"title", nil];
                NSNotification *notification = [NSNotification notificationWithName:@"fefresh" object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[NewDemandViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            } else {
                [MBProgressHUD alertView:@"发布失败" Message:json[@"info"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"error: %@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD alertView:@"发布失败" Message:error.localizedDescription];
        }];
    } else {
        [WPHttpTool postWithURL:url params:_params formDataArray:_photoData success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",json);
            NSLog(@"%@",json[@"info"]);
            if ([json[@"status"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
                NSString *title = self.previewData[0][@"content"];
                if ([title isEqualToString:@"搭顺风车"]) {
                    title = @"顺风车";
                }
                NSLog(@"*****%@",title);
                NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:title,@"title", nil];
//                NSNotification *notification = [NSNotification notificationWithName:@"fefresh" object:dic];
                NSNotification *notification = [NSNotification notificationWithName:@"fefresh" object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[NewDemandViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"%@",NSStringFromCGRect(_tableView.frame));
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


- (void)creattableView{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    PreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[PreViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    [cell cofignCellWith:self.previewData andPic:self.assets andAddres:self.current_position];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       _cellHeight = 50;
        for (int i = 0; i< self.previewData.count; i ++) {
            NSDictionary *dic = self.previewData[i];
            NSString *title = dic[@"title"];
            NSString *content = dic[@"content"];
            CGSize normalSize = [title sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
            CGSize size = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 - normalSize.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            if (i == 0) {
                _cellHeight = _cellHeight + 10 + size.height;
            } else {
                _cellHeight = _cellHeight + 8 + size.height;
            }
        }
        
        if (self.assets.count != 0) {
            _cellHeight = _cellHeight + 8 + 76;
        }
        
        CGSize positionSize = [_current_position sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
        if (_current_position.length != 0) {
            _cellHeight = _cellHeight + 10 + positionSize.height;
        }
        NSLog(@"%f",_cellHeight + 10);
        return _cellHeight + 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else if (buttonIndex == 1) {
            NSLog(@"保存");
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
