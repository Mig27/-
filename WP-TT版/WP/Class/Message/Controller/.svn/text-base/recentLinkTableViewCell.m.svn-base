//
//  recentLinkTableViewCell.m
//  WP
//
//  Created by CC on 16/8/29.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "recentLinkTableViewCell.h"
#import "DDUserModule.h"
#import "DDGroupModule.h"
#import "NSURL+SafeURL.h"
#import "MTTAvatarManager.h"
#import "WPDownLoadVideo.h"
@implementation recentLinkTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, kHEIGHT(50)/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32))];
        self.iconImage.layer.cornerRadius = 5;
        self.iconImage.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImage];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, kHEIGHT(50)/2 - 10, SCREEN_WIDTH - kHEIGHT(32) - 80, 20)];
        self.nameLabel.font = kFONT(15);
        [self.contentView addSubview:self.nameLabel];
        
        
        self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-kHEIGHT(12), kHEIGHT(50)/2-6, 10, 12)];
        self.rightImage.image = [UIImage imageNamed:@"jinru"];
        self.rightImage.hidden = YES;
        [self.contentView addSubview:self.rightImage];
        
        
        self.groupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.groupBtn.frame = CGRectMake(self.nameLabel.right+10, (kHEIGHT(50)-kHEIGHT(14))/2, kHEIGHT(30), kHEIGHT(14));
        self.groupBtn.clipsToBounds = YES;
        self.groupBtn.layer.cornerRadius = 2.5;
        self.groupBtn.titleLabel.font = kFONT(10);
        self.groupBtn.layer.borderColor = RGB(0, 172, 255).CGColor;
        self.groupBtn.layer.borderWidth = 0.5;
        [self.groupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.groupBtn setBackgroundColor:RGB(0, 172, 255)];
        [self.groupBtn setImage:[UIImage imageNamed:@"xiaoxi_qunrenshu"] forState:UIControlStateNormal];
        [self.groupBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
        [self.contentView addSubview:self.groupBtn];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)resetNamelLabel:(BOOL)isFirst
{
//    self.nameLabel.left = 10;
//    if (isFirst)
//    {
//        self.nameLabel.text = @"通讯录";
//    }
//    else
//    {
//        self.nameLabel.top = 0;
//        self.nameLabel.height = 20;
//      self.nameLabel.text = @"最近聊天";
//    }
}
-(void)setNameAndImage:(MTTSessionEntity*)session
{
    self.nameLabel.text = session.name;
    
    
    if (session.sessionType == SessionTypeSessionTypeSingle) {
        CGRect rect = self.nameLabel.frame;
        rect = CGRectMake(self.iconImage.right + 10, kHEIGHT(50)/2 - 10, SCREEN_WIDTH - kHEIGHT(32) - 80, 20);//[[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, kHEIGHT(50)/2 - 10, SCREEN_WIDTH - kHEIGHT(32) - 80, 20)];
        self.nameLabel.frame = rect;
        self.groupBtn.hidden = YES;
        [self.iconImage setBackgroundColor:[UIColor clearColor]];
        [[DDUserModule shareInstance] getUserForUserID:session.sessionID Block:^(MTTUserEntity *user) {
          [self setAvatar:[user getAvatarUrl]];
        }];
    }else{
        self.groupBtn.hidden = NO;
        CGSize nameSize = [session.name sizeWithAttributes:@{NSFontAttributeName:GetFont(17)}];
        if (SCREEN_WIDTH-self.iconImage.right-10-10<kHEIGHT(30)+6+nameSize.width) {
            nameSize.width = SCREEN_WIDTH-self.iconImage.right-10-10-6-kHEIGHT(30);
        }
        CGRect rect = self.nameLabel.frame;
        rect.size = nameSize;
        self.nameLabel.frame = rect;
        self.groupBtn.left = self.nameLabel.right+6;
        [self loadGroupIcon:session];
        
        [[DDGroupModule instance] getGroupInfogroupID:session.sessionID completion:^(MTTGroupEntity *group) {
         [self.groupBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)group.groupUserIds.count] forState:UIControlStateNormal];
        }];
        
    }
    
}
-(void)loadGroupIcon:(MTTSessionEntity *)session
{
    NSString * avatarStr = [NSString stringWithFormat:@"%@",session.avatar];
    if ([avatarStr isEqualToString:@"(null)"]|| (!avatarStr.length))
    {
        [[DDGroupModule instance] getGroupInfogroupID:session.sessionID completion:^(MTTGroupEntity *group) {
            NSString * avatar = [NSString stringWithFormat:@"%@",group.avatar];
            NSData * data = [self imageData:avatar];
            if (data) {
                self.iconImage.image = [UIImage imageWithData:data];
            }
            else
            {
              
            }
            
            if (avatar.length)
            {
                NSData * data = [self imageData:avatar];
                if (data)
                {
                    self.iconImage.image = [UIImage imageWithData:data];
                }
                else
                {
                    NSString * string = [NSString stringWithFormat:@"%@%@",IPADDRESS,group.avatar];
                    WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [down downLoadImage:string success:^(id response) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.iconImage.image = [UIImage imageWithData:response];
                            });
                        } failed:^(NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.iconImage.image = [UIImage imageNamed:@"user_placeholder"];
                            });
                        }];
                    });
                }
            }
            else
            {
                [self.iconImage setImage:[UIImage imageNamed:@"user_placeholder"]];
            }
        }];
    }
    else
    {
        [self.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,session.avatar]] placeholder:[UIImage imageNamed:@"user_placeholder"]];
    }
//    [[DDGroupModule instance] getGroupInfogroupID:session.sessionID completion:^(MTTGroupEntity *group) {
//        if (group.groupUserIds.count == 1) {//当只有一个人的
//            [[DDUserModule shareInstance] getUserForUserID:group.groupCreatorId Block:^(MTTUserEntity *user) {
//                [self setAvatar:[user getAvatarUrl]];
//                //            [self setAvatar:session.avatar];
//            }];
//            return ;
//        }
//        NSMutableArray *ids = [[NSMutableArray alloc]init];
//        NSMutableArray *avatars = [[NSMutableArray alloc]init];
//        NSArray* data = [[group.groupUserIds reverseObjectEnumerator] allObjects];
//        if(data.count>=9){
//            for (int i=0; i<9; i++) {
//                [ids addObject:[data objectAtIndex:i]];
//            }
//        }else{
//            for (int i=0;i<data.count;i++) {
//                [ids addObject:[data objectAtIndex:i]];
//            }
//        }
//        [ids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSString* userID = (NSString*)obj;
//            [[DDUserModule shareInstance] getUserForUserID:userID Block:^(MTTUserEntity *user) {
//                if (user)
//                {
//                    NSString* avatar = [user getAvatarUrl];
//                    [avatars addObject:avatar];
//                }
//            }];
//        }];
//        //        NSLog(@"%@",avatars);
//        [self setAvatar:[avatars componentsJoinedByString:@";"] group:1];
//    }];
}
-(void)setAvatar:(NSString*)avatar group:(BOOL)group
{
    if (group)
    {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:avatar];
        if (image) {
            [self.iconImage setImage:image];
        }
        else
        {
            NSString* avatarKey = [avatar copy];
            if ([avatar hasSuffix:@";"])
            {
                avatar = [avatar substringToIndex:[avatar length] - 1];
            }
            NSArray* avatarArray = [avatar componentsSeparatedByString:@";"];
            [self p_setGroupAvatar:avatarKey avatars:avatarArray];
        }
    }
    else
    {
        //只有一个头像
        NSURL* avatarURL = [NSURL safeURLWithString:avatar];
        UIImage* placeholdImage = [UIImage imageNamed:@"user_placeholder"];
        [self.iconImage sd_setImageWithURL:avatarURL placeholderImage:placeholdImage];
    }
}
- (CGSize)p_avatarSizeForCount:(NSUInteger)avatarCount forScale:(NSUInteger)scale
{
    switch (avatarCount)
    {
        case 1:
            return CGSizeMake(22 * scale, 22  * scale);
        case 2:
        case 3:
        case 4:
            return CGSizeMake(22 * scale, 22 * scale);
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
            return CGSizeMake(14 * scale, 14 * scale);
        default:
            break;
    }
    return CGSizeZero;
}
- (NSUInteger)p_getRowForCount:(NSUInteger)avatarCount
{
    switch (avatarCount)
    {
        case 1:
        case 2:
            return 1;
        case 3:
        case 4:
        case 5:
        case 6:
            return 2;
        case 7:
        case 8:
        case 9:
            return 3;
    }
    return 0;
}
- (NSUInteger)p_getCountInRow:(NSUInteger)row avatarCount:(NSUInteger)avatarCount
{
    if (avatarCount <= 4)
    {
        if (avatarCount <= 2)
        {
            return avatarCount;
        }
        else
        {
            if (row == 0)
            {
                return avatarCount % 2 == 0 ? 2 : avatarCount % 2;
            }
            else
            {
                return 2;
            }
        }
    }
    else
    {
        if (row == 0)
        {
            return avatarCount % 3 == 0 ? 3 : avatarCount % 3;
        }
        else
        {
            return 3;
        }
    }
}
- (float)p_getLeftAndRightForAvatarCount:(NSUInteger)avatarCount forScale:(NSUInteger)scale
{
    return 2 * scale;
}

- (float)p_getUpAndDownGapForAvatarCount:(NSUInteger)avatarCount forScale:(NSUInteger)scale
{
    switch (avatarCount)
    {
        case 1:
        case 2:
            return 0;
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
            return 2 * scale;
    }
    return 0;
}

- (float)p_getOriginStartXForAvatarCount:(NSUInteger)avatarCount row:(NSUInteger)row forScale:(NSUInteger)scale
{
    if (avatarCount == 1 || avatarCount == 3)
    {
        if (row == 0)
        {
            return 14 * scale;
        }
    }
    if (avatarCount == 5 || avatarCount == 8)
    {
        if (row == 0)
        {
            return 10 * scale;
        }
    }
    if (avatarCount == 7)
    {
        if (row == 0)
        {
            return 18 * scale;
        }
    }
    return 2 * scale;
}
- (float)p_getOriginStartYForAvatarCount:(NSUInteger)avatarCount forScale:(NSUInteger)scale
{
    switch (avatarCount)
    {
        case 1:
        case 2:
            return 14 * scale;
            break;
        case 3:
        case 4:
            return 2 * scale;
        case 5:
        case 6:
            return 10 * scale;
        case 7:
        case 8:
        case 9:
            return 2 * scale;
    }
    return 0;
}
- (NSArray*)p_getAvatarLayout:(NSUInteger)avatarCount forScale:(NSUInteger)scale
{
    CGSize size = [self p_avatarSizeForCount:avatarCount forScale:scale];
    NSUInteger row = [self p_getRowForCount:avatarCount];
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    for (NSUInteger rowIndex = 0; rowIndex < row; rowIndex ++)
    {
        NSUInteger countInRow = [self p_getCountInRow:rowIndex avatarCount:avatarCount];
        for (NSUInteger index = 0; index < countInRow; index ++)
        {
            float leftRightGap = [self p_getLeftAndRightForAvatarCount:avatarCount forScale:scale];
            float upDownGap = [self p_getUpAndDownGapForAvatarCount:avatarCount forScale:scale];
            float startX = [self p_getOriginStartXForAvatarCount:avatarCount row:rowIndex forScale:scale];
            float startY = [self p_getOriginStartYForAvatarCount:avatarCount forScale:scale];
            float x = startX + leftRightGap * index + index * size.width;
            float y = startY + upDownGap * rowIndex + rowIndex * size.height;
            CGRect frame = CGRectMake(x, y, size.width, size.height);
            [frames addObject:[NSValue valueWithCGRect:frame]];
        }
    }
    return frames;
}
- (void)p_setGroupAvatar:(NSString*)avatar avatars:(NSArray*)avatarImages
{
    UIImage* placeholdImage = [UIImage imageNamed:@"user_placeholder"];
    NSArray* imageViewFrames = [self p_getAvatarLayout:[avatarImages count] forScale:1];
    NSArray* frames = [self p_getAvatarLayout:[avatarImages count] forScale:2];
    if (avatar&&[frames count] > 0)
    {
        [[MTTAvatarManager shareInstance] addKey:avatar Avatar:avatarImages forLayout:frames];
        
    }
    for (NSInteger index = 0; index < [imageViewFrames count]; index ++)
    {
        CGRect frame = [imageViewFrames[index] CGRectValue];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView.layer setCornerRadius:2];
        [imageView setClipsToBounds:YES];
        [imageView setUserInteractionEnabled:NO];
        NSString* avatar = avatarImages[index];
        NSURL* url = [NSURL safeURLWithString:[IPADDRESS stringByAppendingString:avatar]];
        [imageView sd_setImageWithURL:url placeholderImage:placeholdImage];
        [self.iconImage addSubview:imageView];
    }
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
- (void)setAvatar:(NSString*)avatar
{
//    NSString *url1 = [IPADDRESS stringByAppendingString:avatar];
   NSString *url1 = [NSString stringWithFormat:@"%@%@",IPADDRESS,avatar];
    NSData * data = [self imageData:url1];
    if (data) {
        self.iconImage.image = [UIImage imageWithData:data];
    }
    else
    {
        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [down downLoadImage:url1 success:^(id response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.iconImage.image = [UIImage imageWithData:response];
                });
            } failed:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.iconImage.image = [UIImage imageNamed:@"user_placeholder"];
                });
            }];
        });
        
    }
    
    
    
//    NSURL* avatarURL = [NSURL URLWithString:url1];
//    UIImage* placeholder = [UIImage imageNamed:@"user_placeholder"];
//    [self.iconImage sd_setImageWithURL:avatarURL placeholderImage:placeholder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
