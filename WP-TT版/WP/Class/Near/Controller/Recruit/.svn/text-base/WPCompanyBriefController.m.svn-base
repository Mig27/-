//
//  WPCompanyBriefController.m
//  WP
//
//  Created by CBCCBC on 15/12/16.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPCompanyBriefController.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "ActivityTextEditingController.h"
#import "WPActionSheet.h"
#import "NearAddCell.h"
#import "NearShowCell.h"
#import "UIImageView+WebCache.h"
#import "WPRecruitCompanyBriefPreview.h"

@interface WPCompanyBriefController () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WPActionSheet>

@property (nonatomic, strong) TouchTableView *tableView;
@property (nonatomic,assign) NSInteger deletIndex;            //需要删除

@property (nonatomic, strong) NSMutableArray *cellHeightArray;


@end

@implementation WPCompanyBriefController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公司简介";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 22);
    [button normalTitle:@"完成" Color:RGB(0, 0, 0) Font:kFONT(14)];
    [button selectedTitle:@"编辑" Color:RGB(0, 0, 0)];
    [button addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self tableView];
    if (self.objects.count) {
        [self showPreview];
        [self showBottomview];
        button.selected = YES;
        
        [self.tableView reloadData];
    }
}

- (NSMutableArray *)objects{
    if (!_objects) {
        _objects = [[NSMutableArray alloc]init];
    }
    return _objects;
}

- (NSMutableArray *)cellHeightArray{
    if (!_cellHeightArray) {
        _cellHeightArray = [[NSMutableArray alloc]init];
    }
    return _cellHeightArray;
}

- (void)showPreview{
    WPRecruitCompanyBriefPreview *preview = [[WPRecruitCompanyBriefPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    
    preview.array = self.objects;
    [preview initSubViews];
    [self.view addSubview:preview];
}

- (void)removePreview{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[WPRecruitCompanyBriefPreview class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)showBottomview{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    view.tag = 1111;
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame  =CGRectMake(SCREEN_WIDTH-50, 0, 40, 49);
    [button normalTitle:@"确认" Color:RGB(0, 0, 0) Font:kFONT(14)];
    [button addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [view addSubview:line];
    
    [self.view addSubview:view];
}

- (void)removeBottomView{
    for (UIView *view in self.view.subviews) {
        if (view.tag == 1111) {
            [view removeFromSuperview];
        }
    }
}

- (TouchTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TouchTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
        }];
    }
    return _tableView;
}

- (void)completeAction{
    if (self.delegate) {
        [self.delegate getCompanyBrief:self.objects];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightButtonAction:(UIButton *)sender{
    [self.tableView endEditing:YES];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self showPreview];
        [self showBottomview];
    }else{
        [self removePreview];
        [self removeBottomView];
    }
}

- (void)constantLightspotActions:(UIButton *)sender{
    sender.selected = !sender.selected;
}

#pragma mark - tableve delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count*2 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        
        NearAddCell *cell = [NearAddCell cellWithTableView:tableView];
        cell.titleLabel.text = @"企业描述:";
        if (self.objects.count == 0) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        } else {
            cell.contentView.backgroundColor = RGB(235, 235, 235);
        }
        
        __weak typeof(self) weakSelf = self;
        __block NSInteger index = indexPath.row/2;
        cell.selectType = ^(NSInteger type){
            //        NSLog(@"****%ld",(long)type);
            if (type == 0) {
                NSLog(@"文字");
                ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
                editing.verifyClickBlock = ^(NSAttributedString *attributedString){
                    //                    NSLog(@"****%@",attributedString);
                    [weakSelf.objects insertObject:attributedString atIndex:index];
                    //                    NSLog(@"####%@",weakSelf.objects);
                    [weakSelf.tableView reloadData];
                    [weakSelf updateHeight];
                };
                [self.navigationController pushViewController:editing animated:YES];
            } else {
                NSLog(@"图片");
                MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
                // 默认显示相册里面的内容SavePhotos
                pickerVc.status = PickerViewShowStatusCameraRoll;
                pickerVc.minCount = 30;
                //        [pickerVc show];
                pickerVc.callBack = ^(NSArray *assets){
                    //                    for (NSInteger i = assets.count; i > 0; i--) {
                    //                       [weakSelf.objects ins]
                    //                    }
                    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, assets.count)];
                    [weakSelf.objects insertObjects:assets atIndexes:indexSet];
                    //                    [weakSelf.objects addObjectsFromArray:assets];
                    [weakSelf.tableView reloadData];
                    [weakSelf updateHeight];
                };
                [self presentViewController:pickerVc animated:YES completion:NULL];
                
            }
        };
        if (indexPath.row == 0) {
            cell.titleLabel.hidden = NO;
        } else {
            cell.titleLabel.hidden = YES;
        }
        return cell;
    } else {
        NearShowCell *cell = [NearShowCell cellWithTableView:tableView];
        NSInteger index = (indexPath.row - 1)/2;
        //if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]]) {
            //cell.asset = self.objects[index];
        //} else {
            //cell.attributedString = self.objects[index];
        //}
        if ([self.objects[index] isKindOfClass:[NSAttributedString class]]) {
            cell.attributedString = self.objects[index];
        }else{
            cell.asset = self.objects[index];
        }
        cell.deleteClickBlock = ^(){
            NSLog(@"删除");
            self.deletIndex = index;
            [[[UIAlertView alloc] initWithTitle:nil message:@"确定删除此段?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        };
        cell.upClickBlock = ^(){
            NSLog(@"上移");
            if (index == 0) {
                [MBProgressHUD alertView:nil Message:@"不能再上移了!"];
                return ;
            }
            [self moveFrom:index To:index - 1];
        };
        cell.downClickBlock = ^(){
            NSLog(@"下移");
            if (index == self.objects.count - 1) {
                [MBProgressHUD alertView:nil Message:@"不能再下移了!"];
                return ;
            }
            [self moveFrom:index To:index + 1];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) { //加号
        NearAddCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.addBtn.hidden = NO;
        cell.segment.hidden = YES;
    } else {
        __weak typeof(self) weakSelf = self;
        __block NSInteger index = (indexPath.row - 1)/2;
        if ([self.objects[index] isKindOfClass:[NSAttributedString class]]) {
            ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
            editing.attributedString = self.objects[index];
            editing.attributedString = [[NSAttributedString alloc] initWithAttributedString:self.objects[index]];
            //            NSLog(@"****%@",self.objects[index]);
            editing.verifyClickBlock = ^(NSAttributedString *attributedString){
            [weakSelf.objects replaceObjectAtIndex:index withObject:attributedString];
            [weakSelf.tableView reloadData];
            [weakSelf updateHeight];
            };
            [self.navigationController pushViewController:editing animated:YES];
        }else{
            MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
            // 默认显示相册里面的内容SavePhotos
            pickerVc.status = PickerViewShowStatusCameraRoll;
            pickerVc.minCount = 1;
            //        [pickerVc show];
            pickerVc.callBack = ^(NSArray *assets){
            //                    for (NSInteger i = assets.count; i > 0; i--) {
            //                       [weakSelf.objects ins]
            //                    }
            //                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, assets.count)];
            //                [weakSelf.objects insertObjects:assets atIndexes:indexSet];
            [weakSelf.objects replaceObjectAtIndex:index withObject:assets[0]];
            //                    [weakSelf.objects addObjectsFromArray:assets];
            [weakSelf.tableView reloadData];
            [weakSelf updateHeight];
            };
            [self presentViewController:pickerVc animated:YES completion:NULL];
        }
        //if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]]) {
            //MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
            //// 默认显示相册里面的内容SavePhotos
            //pickerVc.status = PickerViewShowStatusCameraRoll;
            //pickerVc.minCount = 1;
            ////        [pickerVc show];
            //pickerVc.callBack = ^(NSArray *assets){
                ////                    for (NSInteger i = assets.count; i > 0; i--) {
                ////                       [weakSelf.objects ins]
                ////                    }
                ////                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, assets.count)];
                ////                [weakSelf.objects insertObjects:assets atIndexes:indexSet];
                //[weakSelf.objects replaceObjectAtIndex:index withObject:assets[0]];
                ////                    [weakSelf.objects addObjectsFromArray:assets];
                //[weakSelf.tableView reloadData];
                //[weakSelf updateHeight];
            //};
            //[self presentViewController:pickerVc animated:YES completion:NULL];
            
        //} else {
            //ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
            //editing.attributedString = self.objects[index];
            //editing.attributedString = [[NSAttributedString alloc] initWithAttributedString:self.objects[index]];
            ////            NSLog(@"****%@",self.objects[index]);
            //editing.verifyClickBlock = ^(NSAttributedString *attributedString){
                //[weakSelf.objects replaceObjectAtIndex:index withObject:attributedString];
                //[weakSelf.tableView reloadData];
                //[weakSelf updateHeight];
            //};
            //[self.navigationController pushViewController:editing animated:YES];
        //}
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        return kHEIGHT(43);
    } else {
        NSInteger index = (indexPath.row - 1)/2;
        [self getcellHeightArrayWithContent];
        NSString *str = self.cellHeightArray[index];
        
        
        return [str floatValue];
        //if ([self.objects[index] isKindOfClass:[NSAttributedString class]]) {
            ////            return 102;
            //TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            //[label setAttributedText:self.objects[index]];
            //label.linesSpacing = 4;
            //label.characterSpacing = -1;
            //[label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            //CGFloat height;
            //CGFloat textHeight = label.frame.size.height;
            //if (textHeight > 80) {
            //height = textHeight + 22;
            //} else {
            //height = 102;
            //}
            //return height;
        //}else{
            
            //if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]]) {
                //MLSelectPhotoAssets *asset = self.objects[index];
                //ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
                //CGFloat height;
                //CGSize dimension = [representation dimensions];
                //height = ((SCREEN_WIDTH - 20)/dimension.width)*dimension.height;
                //return height;
            //}else{
                //UIImageView *imageV = [UIImageView new];
                //CGFloat height = 0;
                //__block typeof(height) weakHeight = height;
                //WS(ws);
                //NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.objects[index]]];
                //[imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   //weakHeight = ((SCREEN_WIDTH - 20)/image.size.width)*image.size.height;
                    ////[ws.tableView reloadData];
                //}];
                
                //return height;
            //}
        //}
        
        //if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]]) {
            //MLSelectPhotoAssets *asset = self.objects[index];
            //ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            //CGFloat height;
            //CGSize dimension = [representation dimensions];
            //height = ((SCREEN_WIDTH - 20)/dimension.width)*dimension.height;
            //return height;
        //} else {
            ////            return 102;
            //TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            //[label setAttributedText:self.objects[index]];
            //label.linesSpacing = 4;
            //label.characterSpacing = -1;
            //[label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            //CGFloat height;
            //CGFloat textHeight = label.frame.size.height;
            //if (textHeight > 80) {
                //height = textHeight + 22;
            //} else {
                //height = 102;
            //}
            //return height;
        //}
    }
}

- (void)getcellHeightArrayWithContent{
    //NSInteger index = (indexPath.row - 1)/2;
    
    for (int i = 0; i < self.objects.count; i++) {
        [self.cellHeightArray addObject:@"0"];
    }
    
    for (int i = 0; i < self.objects.count; i++) {
        if ([self.objects[i] isKindOfClass:[NSAttributedString class]]) {
            //            return 102;
            TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            [label setAttributedText:self.objects[i]];
            label.linesSpacing = 4;
            label.characterSpacing = -1;
            [label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            CGFloat height;
            CGFloat textHeight = label.frame.size.height;
            if (textHeight > 80) {
                height = textHeight + 22;
            } else {
                height = 102;
            }
            NSString *str = [NSString stringWithFormat:@"%f",height];
            [self.cellHeightArray replaceObjectAtIndex:i withObject:str];
            
        }else{
            
            if ([self.objects[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                MLSelectPhotoAssets *asset = self.objects[i];
                ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
                CGFloat height;
                CGSize dimension = [representation dimensions];
                height = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
                NSString *str = [NSString stringWithFormat:@"%f",height];
                [self.cellHeightArray replaceObjectAtIndex:i withObject:str];
            }else{
                UIImageView *imageV = [UIImageView new];
                //CGFloat height = 0;
                //__block typeof(height) weakHeight = height;
                WS(ws);
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.objects[i]]];
                [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    CGFloat weakHeight = ((SCREEN_WIDTH - 20)/image.size.width)*image.size.height;
                    NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                    [ws.cellHeightArray replaceObjectAtIndex:i withObject:str];
                    
                }];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self.objects removeObjectAtIndex:self.deletIndex];
            [self.tableView reloadData];
            [self updateHeight];
            break;
            
        default:
            break;
    }
}

#pragma mark - 更新高度
- (void)updateHeight{
    CGFloat height = 0;
    for (int i = 0; i<self.objects.count; i++) {
        if ([self.objects[i] isKindOfClass:[NSAttributedString class]]) {
            TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            [label setAttributedText:self.objects[i]];
            label.linesSpacing = 4;
            label.characterSpacing = 2;
            [label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            CGFloat textHeight = label.frame.size.height;
            if (textHeight > 80) {
            height += textHeight + 22;
            } else {
            height += 102;
            }
        }else{
            if ([self.objects[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                MLSelectPhotoAssets *asset = self.objects[i];
                ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
                CGFloat height;
                CGSize dimension = [representation dimensions];
                height = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
            }else{
                UIImageView *imageV = [UIImageView new];
                CGFloat cellHeight = 0;
                __block typeof(cellHeight) weakHeight = cellHeight;
                //WS(ws);
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.objects[i]]];
                [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    weakHeight = ((SCREEN_WIDTH - 20)/image.size.width)*image.size.height;
                    //[ws.tableView reloadData];
                }];
                height = height+cellHeight;
            }
            //MLSelectPhotoAssets *asset = self.objects[i];
            //ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            //CGFloat cellHeight;
            //CGSize dimension = [representation dimensions];
            //cellHeight = ((SCREEN_WIDTH - 20)/dimension.width)*dimension.height;
            //height = height + cellHeight;
        }
        //if ([self.objects[i] isKindOfClass:[MLSelectPhotoAssets class]]){
            //MLSelectPhotoAssets *asset = self.objects[i];
            //ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            //CGFloat cellHeight;
            //CGSize dimension = [representation dimensions];
            //cellHeight = ((SCREEN_WIDTH - 20)/dimension.width)*dimension.height;
            //height = height + cellHeight;
        //} else {
            //TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            //[label setAttributedText:self.objects[i]];
            //label.linesSpacing = 4;
            //label.characterSpacing = 2;
            //[label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            //CGFloat textHeight = label.frame.size.height;
            //if (textHeight > 80) {
                //height += textHeight + 22;
            //} else {
                //height += 102;
            //}
        //}
    }
    
    
    height = height + (self.objects.count + 1)*35;
    
    if (self.objects.count == 0) {
        //        height = 80;
        //        self.detailView.frame = CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*11 + 10*4, SCREEN_WIDTH, height);
        //        self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, kHEIGHT(108) + 24*2 + 12*kHEIGHT(43) + 7*0.5 + 6*10 + 4 + height);
        //        self.tableView.frame = self.detailView.bounds;
        //        self.shareView.top = self.detailView.bottom + 10;
    } else {
        //        self.detailView.frame = CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*11 + 10*4 - 10, SCREEN_WIDTH, height);
        //        self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, kHEIGHT(108) + 24*2 + 12*kHEIGHT(43) + 7*0.5 + 6*10 + 4 + height - 20);
        //        self.tableView.frame = self.detailView.bounds;
        //        self.shareView.top = self.detailView.bottom;
        
    }
    
}

- (void)moveFrom:(NSInteger)orgin To:(NSInteger)destination
{
    [self.objects exchangeObjectAtIndex:orgin withObjectAtIndex:destination];
    [self.tableView reloadData];
}

#pragma mark 选择展示图
- (void)selectShowImage
{
    WPActionSheet *action =[[WPActionSheet alloc] initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:0];
    //    action.tag = 2;
    [action showInView:self.view];
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    switch (buttonIndex) {
        case 2:
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            break;
        case 1:
            
            NSLog(@"");
            //            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"模拟器暂不支持相机功能" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            //            [alert show];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
            break;
            //        default:
            //            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    //    [btnTitle removeFromSuperview];
    //    [_iconBtn setImage:image forState:UIControlStateNormal];
    //    selectPhotoButton.layer.cornerRadius=10;
    //    _headImage = image;
    //    NSMutableArray *icon = [NSMutableArray array];
    //    [icon addObject:image];
    //    self.activityPreModel.iconImage = icon;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
