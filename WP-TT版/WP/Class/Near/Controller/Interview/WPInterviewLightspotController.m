//
//  WPInterviewLightspotController.m
//  WP
//
//  Created by CBCCBC on 15/12/14.
//  Copyright © 2015年 WP. All rights reserved.
//

#define ButtonWidth ((SCREEN_WIDTH-5*ButtonEdge)/4)
#define ButtonHeight kHEIGHT(36)
#define ButtonEdge kHEIGHT(10)

#import "WPInterviewLightspotController.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "ActivityTextEditingController.h"
#import "WPActionSheet.h"
#import "NearAddCell.h"
#import "NearShowCell.h"
#import "UIImageView+WebCache.h"
#import "WPInterviewLightspotPreview.h"
#import "WPMySecurities.h"

typedef NS_ENUM(NSInteger,WPInterviewLightspotActionType) {
    WPInterviewLightspotActionTypeOne = 20,
    WPInterviewLightspotActionTypeTwo,
    WPInterviewLightspotActionTypeThree,
    WPInterviewLightspotActionTypeAFour,
    WPInterviewLightspotActionTypeFive,
    WPInterviewLightspotActionTypeSix,
    WPInterviewLightspotActionTypeSeven,
    WPInterviewLightspotActionTypeEight,
    WPInterviewLightspotActionTypeNine,
    WPInterviewLightspotActionTypeTen,
    WPInterviewLightspotActionTypeEleven,
    WPInterviewLightspotActionTypeTwelve
    
};

@interface WPInterviewLightspotController () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WPActionSheet,UIAlertViewDelegate>
{
    BOOL isEdit;
}
@property (nonatomic, strong) TouchTableView *tableView;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic,assign) NSInteger deletIndex;            // 需要删除

@property (nonatomic, strong) NSMutableArray *cellHeightArray;

@property (nonatomic, strong) WPActionSheet *actionSheet;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) NSMutableArray * heightArray;

@end

@implementation WPInterviewLightspotController
-(NSMutableArray*)heightArray
{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人亮点";
    
    self.view.backgroundColor = [UIColor whiteColor];

    //[self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"完成"];
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 50, 22);
    [_rightButton normalTitle:@"完成" Color:RGB(127, 127, 127) Font:kFONT(14)];
    [_rightButton selectedTitle:@"编辑" Color:RGB(0, 0, 0)];
    _rightButton.tag = 200;
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.tableView.tableHeaderView = self.tableHeadView;
    if (self.lightStr.length > 0 || (self.buttonString && ![self.buttonString isEqualToString:@""])) {
        _rightButton
        .selected = YES;
        [self showPreview];
    }
}
#pragma makr 创建预览页面
- (void)showPreview{
    WPInterviewLightspotPreview *preview = [[WPInterviewLightspotPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    NSString * string = [WPMySecurities textFromBase64String:self.lightStr];
    string =  [WPMySecurities textFromEmojiString:string];
    if (string.length) {
        self.lightStr = string;
    }
    
    preview.lightStr = self.lightStr;
    preview.lightspotStr = self.buttonString;
    [preview initSubview];
    [self.view addSubview:preview];
}

- (void)removePreview{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[WPInterviewLightspotPreview class]]) {
            [view removeFromSuperview];
        }
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

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _bottomView.backgroundColor = [UIColor colorWithRed:0  green:175/256.0 blue:248/256.0 alpha:1];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(SCREEN_WIDTH-50, 0, 40, 49);
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        [button normalTitle:@"确认" Color:RGB(255,255,255) Font:kFONT(16)];
        [button addTarget:self action:@selector(completeLightspotActions) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomView addSubview:line];
    }
    return _bottomView;
}

- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _tableHeadView.backgroundColor = [UIColor whiteColor];
        NSArray *array = [self.buttonString componentsSeparatedByString:SEPARATOR];
        
        NSArray *title = @[@"沟通能力强",@"执行力强",@"学习力强",@"有亲和力",@"诚信正直",@"责任心强",@"雷厉风行",@"沉稳内敛",@"阳光开朗",@"人脉广",@"善于创新",@"有创业经历"];
        
        UIView *lastview = nil;
        for (int i = 0; i < 12; i++) {
            CGFloat row = i/4;//行
            CGFloat col = i%4;//列
            CGFloat x = (col+1)*ButtonEdge+col*ButtonWidth;
            CGFloat y = (row+1)*ButtonEdge+row*ButtonHeight;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.tag = WPInterviewLightspotActionTypeOne+i;
            button.frame = CGRectMake(x, y, ButtonWidth,ButtonHeight);
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = RGB(226, 226, 226).CGColor;
            [button normalTitle:title[i] Color:RGB(0, 0, 0) Font:kFONT(12)];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(0, 172, 255)] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(constantLightspotActions:) forControlEvents:UIControlEventTouchUpInside];
            [_tableHeadView addSubview:button];
            lastview = button;
            
            for (NSString *str in array) {
                if ([title[i] isEqualToString:str]) {
                    button.selected = YES;
                }
            }
        }
        
        _tableHeadView.height = lastview.bottom+kListEdge+8;
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _tableHeadView.height-8, SCREEN_WIDTH, 8)];
        line.backgroundColor = RGB(235, 235, 235);
        [_tableHeadView addSubview:line];
    }
    return _tableHeadView;
}

- (WPActionSheet *)actionSheet{
    if (!_actionSheet) {
        WS(ws);
        _actionSheet = [[WPActionSheet alloc]initWithOtherButtonTitle:@[@"保存",@"不保存"] imageNames:nil top:64 actions:^(NSInteger type) {
            if (type == 1) {
                [ws completeLightspotActions];
            }
            if (type == 2) {
                [ws.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    return _actionSheet;
}

- (void)backToFromViewController:(UIButton *)sender{
    if(self.actionSheet.frame.origin.y < 0&&sender.selected){
        sender.selected = !sender.selected;
    }
    sender.selected = !sender.selected;
    if(sender.selected){
        BOOL isNull = YES;
        for (int i = WPInterviewLightspotActionTypeOne; i <= WPInterviewLightspotActionTypeTwelve; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            if (button.selected) {
                isNull = NO;
            }
        }
        if (self.lightStr.length||!isNull) {
            if (!isEdit) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
//                [self.actionSheet showInView:self.view];
                UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alert show];
                
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.actionSheet hideFromView:self.view];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}
#pragma mark - 右边按钮事件
- (void)rightButtonAction:(UIButton *)sender{
    NSString *constantStr = @"";
    for (int i = WPInterviewLightspotActionTypeOne; i <= WPInterviewLightspotActionTypeTwelve; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        if (button.selected) {
            constantStr = [NSString stringWithFormat:@"%@%@%@",constantStr,button.titleLabel.text,SEPARATOR];
        }
    }
    if (constantStr.length) {
        constantStr = [constantStr substringToIndex:constantStr.length-1];
    }
    self.buttonString = constantStr;
    if (!self.buttonString.length && (!self.lightStr.length)) {
        return;
    }
    else
    {
        [sender setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    }
    
    
    [self.tableView endEditing:YES];
    sender.selected = !sender.selected;
    
//    NSString *constantStr = @"";
//    for (int i = WPInterviewLightspotActionTypeOne; i <= WPInterviewLightspotActionTypeTwelve; i++) {
//        UIButton *button = (UIButton *)[self.view viewWithTag:i];
//        if (button.selected) {
//            constantStr = [NSString stringWithFormat:@"%@%@%@",constantStr,button.titleLabel.text,SEPARATOR];
//        }
//    }
//    if (constantStr.length) {
//        constantStr = [constantStr substringToIndex:constantStr.length-1];
//    }
//    self.buttonString = constantStr;
    
    
    if (sender.selected) {
        [self showPreview];
        [self.view addSubview:self.bottomView];
    }else{
        [self removePreview];
        [self.bottomView removeFromSuperview];
    }
}

- (void)completeLightspotActions{
    if (self.delegate) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"haseChangeD" object:nil];//保存就说明了有改动，发送通知在创建求职者的简历返回时进行保存
        NSString *constantStr = @"";
        for (int i = WPInterviewLightspotActionTypeOne; i <= WPInterviewLightspotActionTypeTwelve; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            if (button.selected) {
                constantStr = [NSString stringWithFormat:@"%@%@%@",constantStr,button.titleLabel.text,SEPARATOR];
                
            }
        }
        if (constantStr.length) {
            constantStr = [constantStr substringToIndex:constantStr.length-1];
        }
        [self.delegate getLightspotWithConstant:constantStr content:self.lightStr];
        [self.navigationController popViewControllerAnimated:YES];
    }

}
#pragma mark 点击头部的亮点
- (void)constantLightspotActions:(UIButton *)sender{
    sender.selected = !sender.selected;
    isEdit = YES;
    
    UIButton * rightBtn = nil;
    for (UIView * view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UIButton class]]&&(view.tag == 200)) {
            rightBtn = (UIButton*)view;
        }
    }
    BOOL isOrNot = NO;
    for (int i = WPInterviewLightspotActionTypeOne; i<=WPInterviewLightspotActionTypeTwelve; i++) {
        UIButton * button1 = (UIButton*)[self.view viewWithTag:i];
        if (button1.selected) {
            isOrNot = YES;
        }
    }
    if (isOrNot) {
        [rightBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    }
    else
    {
        [rightBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    }
    
}

#pragma mark - tableve delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"ahhahahhahhaaha  %lu",(unsigned long)self.objects.count/2+1);
//    return self.objects.count*2 + 1;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NearAddCell *cell = [NearAddCell cellWithTableView:tableView];
        cell.titleLabel.text = @"亮点描述:";
        UIColor *color = RGB(170, 170, 170);
        cell.TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写亮点描述" attributes:@{NSForegroundColorAttributeName: color}];
        cell.TextField.text = self.lightStr;
        cell.TextField.tintColor = color;
        if (self.objects.count == 0) {
            cell.contentView.backgroundColor = [UIColor whiteColor];//whiteColor
        } else {
            cell.contentView.backgroundColor = RGB(235, 235, 235);
        }
    if (self.lightStr.length) {
        cell.TextField.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.contentLabel.hidden = NO;
        cell.contentLabel.text = [NSString stringWithFormat:@"亮点描述：%@",self.lightStr];
        
        CGSize strSize = [[NSString stringWithFormat:@"亮点描述：%@",self.lightStr] getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-2*kHEIGHT(12)];
        
        CGRect rect = cell.contentLabel.frame;
        rect.size.height = strSize.height;
        cell.contentLabel.frame = rect;
        
        if (self.heightArray.count) {
            CGFloat height = [self.heightArray[0] floatValue];
            cell.contentLabel.centerY = height/2;
        }
        else
        {
          cell.contentLabel.centerY = (kHEIGHT(43))/2;
        }
        
    }
    else
    {
        cell.TextField.hidden = NO;
        cell.titleLabel.hidden = NO;
        cell.contentLabel.text = @"";
        cell.contentLabel.hidden = YES;
    }
    
    
        return cell;
    
    
    
//    } else {
//        NearShowCell *cell = [NearShowCell cellWithTableView:tableView];
//        NSInteger index = (indexPath.row - 1)/2;
//        //if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]]) {
//            //cell.asset = self.objects[index];
//        //} else {
//            //cell.attributedString = self.objects[index];
//        //}
//        if ([self.objects[index] isKindOfClass:[NSAttributedString class]]) {
//            cell.attributedString = self.objects[index];
//        }else{
//            cell.asset = self.objects[index];
//        }
//
//        cell.deleteClickBlock = ^(){
//            NSLog(@"删除");
//            self.deletIndex = index;
//            [[[UIAlertView alloc] initWithTitle:nil message:@"确定删除此段?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
//        };
//        cell.upClickBlock = ^(){
//            NSLog(@"上移");
//            if (index == 0) {
//                [MBProgressHUD alertView:nil Message:@"不能再上移了!"];
//                return ;
//            }
//            [self moveFrom:index To:index - 1];
//        };
//        cell.downClickBlock = ^(){
//            NSLog(@"下移");
//            if (index == self.objects.count - 1) {
//                [MBProgressHUD alertView:nil Message:@"不能再下移了!"];
//                return ;
//            }
//            [self moveFrom:index To:index + 1];
//        };
//        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row%2 == 0) { //加号
       isEdit = YES;
        NearAddCell*cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.addBtn.hidden = NO;
        cell.segment.hidden = YES;
    
#pragma mark 点击亮点描述的回调
        ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
       if (cell.TextField.text.length) {//将亮点描述传到下个界面
        editing.textFieldString = self.lightStr.length?self.lightStr
           :@"";
       }
        editing.verifyClickBlock = ^(NSAttributedString *attributedString){
        //将回调的数据赋给数组
            NSString * string = [NSString stringWithFormat:@"%@",attributedString];
            if (string.length) {
                CGSize strSize = [[NSString stringWithFormat:@"亮点描述：%@",string] getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-2*kHEIGHT(12)];
                if (strSize.height+26 < kHEIGHT(43)) {
                    strSize.height = kHEIGHT(43);
                }
                [self.heightArray removeAllObjects];
                [self.heightArray addObject:[NSString stringWithFormat:@"%f",(strSize.height==kHEIGHT(43))?kHEIGHT(43):strSize.height+26]];
                [self.tableView reloadData];
            }
            else
            {
                [self.heightArray removeAllObjects];
                [self.heightArray addObject:[NSString stringWithFormat:@"%ld",kHEIGHT(43)]];
                [self.tableView reloadData];
            }
            
//        cell.TextField.text = [NSString stringWithFormat:@"%@",attributedString];
        self.lightStr = [NSString stringWithFormat:@"%@",attributedString];
            if (self.lightStr.length) {//改变完成的颜色
                [_rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
            }
        };
        [self.navigationController pushViewController:editing animated:YES];
//    } else {
//        __weak typeof(self) weakSelf = self;
//        __block NSInteger index = (indexPath.row - 1)/2;
//        if ([self.objects[index] isKindOfClass:[NSAttributedString class]]) {
//            ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
//            editing.attributedString = self.objects[index];
//            editing.attributedString = [[NSAttributedString alloc] initWithAttributedString:self.objects[index]];
//            //            NSLog(@"****%@",self.objects[index]);
//            editing.verifyClickBlock = ^(NSAttributedString *attributedString){
//                [weakSelf.objects replaceObjectAtIndex:index withObject:attributedString];
//                [weakSelf.tableView reloadData];
//                [weakSelf updateHeight];
//            };
//            [self.navigationController pushViewController:editing animated:YES];
//        }else{
//            MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
//            // 默认显示相册里面的内容SavePhotos
//            pickerVc.status = PickerViewShowStatusCameraRoll;
//            pickerVc.minCount = 1;
//            //        [pickerVc show];
//            pickerVc.callBack = ^(NSArray *assets){
//                //                    for (NSInteger i = assets.count; i > 0; i--) {
//                //                       [weakSelf.objects ins]
//                //                    }
//                //                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, assets.count)];
//                //                [weakSelf.objects insertObjects:assets atIndexes:indexSet];
//                [weakSelf.objects replaceObjectAtIndex:index withObject:assets[0]];
//                //                    [weakSelf.objects addObjectsFromArray:assets];
//                [weakSelf.tableView reloadData];
//                [weakSelf updateHeight];
//            };
//            [self presentViewController:pickerVc animated:YES completion:NULL];
//        }

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
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        if (self.heightArray.count) {
            return [self.heightArray[0] floatValue];
        }
        else
        {
            return kHEIGHT(43);
        }
//        return kHEIGHT(43);
    } else {
        NSInteger index = (indexPath.row - 1)/2;
        [self getcellHeightArrayWithContent];
        NSString *str = self.cellHeightArray[index];
        
        return [str floatValue];

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
                
                /*
                UIImageView *imageV = [UIImageView new];
                WS(ws);
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.objects[i]]];
                [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    CGFloat weakHeight = ((SCREEN_WIDTH)/image.size.width)*image.size.height;
                    NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                    [ws.cellHeightArray replaceObjectAtIndex:i withObject:str];
                    
                }];*/
                
                // 根据当前row的imgURL作为Key 获取图片缓存
                NSString *imgURL = [IPADDRESS stringByAppendingString:self.objects[i]];
                
                UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
                
                if (!img) {
                    img = [UIImage resizedImageWithName:@"gray_background.png"];
                }
                
                CGFloat height = img.size.height * kScreenW/img.size.width; // Image宽度为屏幕宽度 ，计算宽高比求得对应的高度
                NSString *str = [NSString stringWithFormat:@"%f",height];
                [self.cellHeightArray replaceObjectAtIndex:i withObject:str];
            }
        }
    }
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 1:
//            [self.objects removeObjectAtIndex:self.deletIndex];
//            [self.tableView reloadData];
//            [self updateHeight];
//            break;
//            
//        default:
//            break;
//    }
//}

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
                    weakHeight = ((SCREEN_WIDTH)/image.size.width)*image.size.height;
                    //[ws.tableView reloadData];
                }];
                height = height+cellHeight;
            }
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
    WPActionSheet *action =[[WPActionSheet alloc] initWithDelegate:self otherButtonTitle:@[@"相册",@"拍照"] imageNames:nil top:0];
    //    action.tag = 2;
    [action showInView:self.view];
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    switch (buttonIndex) {
        case 1:
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            break;
        case 2:
            
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
