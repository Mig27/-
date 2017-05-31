
//
//  WPGroupInformationCell2.m
//  WP
//
//  Created by 沈亮亮 on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupInformationCell2.h"
#import "GroupInformationModel.h"
#import "WPDownLoadVideo.h"
@implementation WPGroupInformationCell2

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
    }
    
    return self;
}

- (void)createUI
{
    CGSize normalSize1 = [@"群相册" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, normalSize1.width, kHEIGHT(72))];
    self.itemLabel.font = kFONT(15);
    self.itemLabel.textColor = RGB(127, 127, 127);
//    titleLabel.text = @"工作日记";
    [self.contentView addSubview:self.itemLabel];
    
    CGFloat y = kHEIGHT(72)/2 - kHEIGHT(43)/2;
    
    for (int i = 0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.itemLabel.right + kHEIGHT(25) + (kHEIGHT(43) + 8)*i, y, kHEIGHT(43), kHEIGHT(43))];
        imageView.layer.cornerRadius = 5;
        imageView.clipsToBounds = YES;
        imageView.tag = i + 1;
        [self.contentView addSubview:imageView];
        
        if (i == 0) {
            self.imageV1 = imageView;
        } else if (i == 1) {
            self.imageV2 = imageView;
        } else if (i == 2) {
            self.imageV3 = imageView;
        } else {
            self.imageV4 = imageView;
        }
    }
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 8 - 80 - 4, 0, 80, kHEIGHT(72))];
    self.numberLabel.font = kFONT(12);
    self.numberLabel.textColor = RGB(127, 127, 127);
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.numberLabel];

}
-(NSData*)imageData:(NSString*)imageStr
{
    NSArray * pathArray = [imageStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    return data;
}
- (void)setPhotoWith:(NSArray *)arr andCount:(NSString *)count item:(NSString *)item isAvatar:(BOOL)isAvatar
{
    NSInteger k = arr.count > 3 ? 3 : arr.count;
    for (int i = 0; i< k ; i++) {
        if (!isAvatar) {
            PhotoListModel *model = arr[i];
            UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
            NSString *url = [IPADDRESS stringByAppendingString:model.thumb_path];
            
            NSData * data = [self imageData:url];
            if (data) {
                imageV.image = [UIImage imageWithData:data];
            }
            else
            {
                WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [down downLoadImage:url success:^(id response) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            imageV.image = [UIImage imageWithData:response];
                        });
                    } failed:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            imageV.image = [UIImage imageNamed:@"small_cell_person"];
                        });
                    }];
                });
                
            }
           
    
            //[imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
        } else {
            
            NSMutableArray * muarray= [NSMutableArray array];
            [muarray addObjectsFromArray:arr];
            for (MenberListModel*listModel in arr) {
                if ([listModel.is_create isEqualToString:@"1"]) {
                    [muarray removeObject:listModel];
                    [muarray insertObject:listModel atIndex:0];
                    break;
                }
            }
            MenberListModel *model = muarray[i];
            UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
            NSString *url = [IPADDRESS stringByAppendingString:model.avatar];
            
            NSData * data = [self imageData:url];
            if (data) {
                imageV.image = [UIImage imageWithData:data];
            }
            else
            {
                WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [down downLoadImage:url success:^(id response) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          imageV.image = [UIImage imageWithData:response];
                      });
                    } failed:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            imageV.image = [UIImage imageNamed:@"small_cell_person"];
                        });
                    }];
                });
                
            }
            
            
            //[imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
        }
    }
    
    if (k== 1)
    {
       UIImageView *imageV = (UIImageView *)[self viewWithTag:3];
       UIImageView *imageV1 = (UIImageView *)[self viewWithTag:4];
        imageV.image = [UIImage imageNamed:@""];
        imageV1.image = [UIImage imageNamed:@""];
    }
    
    if (k == 2)
    {
        UIImageView * imageView = (UIImageView*)[self viewWithTag:4];
        imageView.image = [UIImage imageNamed:@""];
    }
    
    UIImageView *imageV = (UIImageView *)[self viewWithTag:k + 1];
    imageV.userInteractionEnabled = YES;
    if (!isAvatar) {
        imageV.image = [UIImage imageNamed:@"groupInfo_camera"];
    } else {
        imageV.image = [UIImage imageNamed:@"groupInfo_add"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addGroupMember)];
        [imageV addGestureRecognizer:tap];
    }
    
    self.itemLabel.text = item;
    self.numberLabel.text = count;
}

- (void)addGroupMember
{
//    NSLog(@"添加群成员");
    if (self.addNewMemberBlock) {
        self.addNewMemberBlock();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WPGroupInformationCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"WPGroupInformationCell2Id"];
    if (!cell) {
        cell = [[WPGroupInformationCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WPGroupInformationCell2Id"];
    }
    return cell;
}


+ (CGFloat)rowHeight
{
    return kHEIGHT(72);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
