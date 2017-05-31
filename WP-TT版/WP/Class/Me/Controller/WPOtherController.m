//
//  WPOtherInfoController.m
//  WP
//
//  Created by CBCCBC on 15/9/15.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPOtherController.h"
#import "WPPhotoWallController.h"
#import "WPAddFriendController.h"
#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "PersonalView.h"
#import "UIButton+Extension.h"
#import "WPStrangerCell.h"
#import "WPFriendCell.h"
#import "SPButton.h"

@implementation OtherInfoModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"userName":@"user_name",
             @"nickName":@"nick_name",
             @"industryID":@"industry_id",
             @"hometownID":@"hometown_id",
             @"wpId":@"wp_id",
             @"userId":@"id",
             @"attentionCount":@"atten_count",
             @"friendsCount":@"friend_count",
             @"fansCount":@"ret_atten_count"
             };
}

+(NSDictionary *)objectClassInArray
{
    return @{
             @"Photolist":@"PhotoListModel"
             };
}

@end


@interface WPOtherController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) TouchTableView *tableView;/**< tableView */
@property (strong, nonatomic) PersonalView *personalView;/**< 个人信息墙（头标题） */
@property (strong, nonatomic) UIView *friendView;/**< 好友模式下操作按钮 */
@property (strong, nonatomic) UIView *strangerView;/**< 陌生人模式下操作按钮 */

@property (strong, nonatomic) NSArray *imageArr;/**< 图片名数组 */
@property (strong, nonatomic) NSArray *titleArr;/**< 标题数组 */
@property (strong, nonatomic) NSMutableArray *contentArr;/**< 内容数组 */

@property (strong, nonatomic) OtherInfoModel *dataModel;

@property (assign, nonatomic) NSInteger isAttent;

@end

@implementation WPOtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBColor(211, 211, 211);
    self.title = @"个人资料";
    
    [self tableView];
    [self request];
}

#pragma mark - 数据请求及刷新
- (void)request
{
    [MBProgressHUD showMessage:@"" toView:self.view];
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];

    NSDictionary *dic = @{@"action":@"userInfoByID",@"username":model.username,@"password":model.password,@"look_user_id":self.lookUserId,@"user_id":model.dic[@"userid"]};
    [WPHttpTool postWithURL:str params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _dataModel = [OtherInfoModel mj_objectWithKeyValues:json];
        [self reloadData:_dataModel];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD alertView:nil Message:error.localizedDescription];
    }];
}

-(void)reloadData:(OtherInfoModel *)model
{
    PersonalModel *Pmodel = [[PersonalModel alloc]init];
    Pmodel.photoWallArr = model.Photolist;
    Pmodel.headImageStr = model.avatar;
    Pmodel.nameStr = model.userName;
    Pmodel.nicknameStr = model.nickName;
    Pmodel.WPidStr = model.wpId;
    Pmodel.attentionCount = model.attentionCount;
    Pmodel.fansCount = model.fansCount;
    Pmodel.friendsCount = model.friendsCount;
    
    self.personalView.model = Pmodel;
    [self.personalView reloadData];
    
    self.tableView.tableHeaderView = self.personalView;
    
    self.friendView.hidden = !model.isFriend;
    self.strangerView.hidden = model.isFriend;
    
    _isAttent = model.isAttent;
    SPButton *button = (SPButton *)[self.view viewWithTag:101];
    
    switch (model.isAttent) {
        case 0:
            button.contentLabel.text = @"关注";
            break;
        case 1:
            button.contentLabel.text = @"已关注";
            break;
        case 2:
            button.contentLabel.text = @"被关注";
            break;
        case 3:
            button.contentLabel.text = @"互关注";
            break;
        default:
            break;
    }
    
    NSArray *arr = @[@[model.signature],
                     @[model.company,model.industry,model.position],
                     @[],
                     @[model.hobby,model.specialty]
                     ];
    [self.contentArr removeAllObjects];
    [self.contentArr addObjectsFromArray:arr];
    [self.tableView reloadData];
}

#pragma mark - 初始化数组
-(NSArray *)imageArr
{
    if (!_imageArr) {
        
        _imageArr = @[@[@"gexingqianming"],
                      @[@"qiye",@"hangye",@"zhiwei"],
                      @[@"wangzhan",@"wodefabu",@"huiyilu"],
                      @[@"xingqu",@"shanchang"]
                      ];
    }
    return _imageArr;
}

-(NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@[@"个性签名"],
                      @[@"企业",@"行业",@"职位"],
                      @[@"企业网站",@"我的发布",@"回忆录"],
                      @[@"爱好兴趣",@"擅长"]
                      ];
    }
    return _titleArr;
}

-(NSMutableArray *)contentArr
{
    if (!_contentArr) {
        
        NSArray *arr = @[@[@"个性签名"],
                         @[@"企业",@"行业",@"职位"],
                         @[],
                         @[@"爱好兴趣",@"擅长"]
                         ];
        _contentArr = [[NSMutableArray alloc]initWithArray:arr];
    }
    return _contentArr;
}

#pragma mark - 初始化子视图
-(TouchTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TouchTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-43) style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 10;
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.tableHeaderView = self.personalView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(PersonalView *)personalView
{
    if (!_personalView) {
        _personalView = [[PersonalView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 311+10)];
        _personalView.isAllowEdit = NO;
        _personalView.backgroundColor = WPColor(235, 235, 235);
        __weak typeof(self) unself = self;
        
        //用户关系
        _personalView.personalConenction = ^(NSInteger number){

            
        };
        //照片墙
        _personalView.photoWallDetail = ^(){
            WPPhotoWallController *photowall = [[WPPhotoWallController alloc]init];
            photowall.title = @"照片";
            photowall.photos = unself.personalView.model.photoWallArr;
            [unself.navigationController pushViewController:photowall animated:YES];
        };
    }
    return _personalView;
}

-(UIView *)friendView
{
    if (!_friendView) {
        _friendView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-43, SCREEN_WIDTH, 43)];
        UIButton *button = [[SPButton alloc]initWithFrame:_friendView.bounds title:@"聊聊" ImageName:@"liaoliao" Target:self Action:@selector(userOperationClick:)];
        button.tag = 100;
        [_friendView addSubview:button];
        [self.view addSubview:_friendView];
    }
    return _friendView;
}

-(UIView *)strangerView
{
    if (!_strangerView) {
        _strangerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-43, SCREEN_WIDTH, 43)];
        _strangerView.backgroundColor = [UIColor redColor];
        
        NSArray *titles = @[@"聊聊",@"关注",@"加好友"];
        NSArray *images = @[@"liaoliao",@"guanzhu",@"jiahaoyou"];
        for (int i = 0; i< 3; i++) {
            UIButton *button = [[SPButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 43) title:titles[i] ImageName:images[i] Target:self Action:@selector(userOperationClick:)];
            button.tag = 100+i;
            [_strangerView addSubview:button];
        }
        [self.view addSubview:_strangerView];
    }
    return _strangerView;
}

#pragma mark - 用户操作点击事件
-(void)userOperationClick:(UIButton *)sender
{
    switch (sender.tag-100) {
        case 0:
            NSLog(@"聊聊");
            break;
        case 1:
            [self attention];
            break;
        case 2:
            [self addFriend];
            break;
            
        default:
            break;
    }
}

-(void)attention
{
    NSString *nickname;
    if ([_dataModel.nickName isEqualToString:@""]) {
        nickname = _dataModel.userName;
    }else{
        nickname = _dataModel.nickName;
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSDictionary *dic = @{@"action":@"attentionSigh",
                          @"username":model.username,
                          @"password":model.password,
                          @"nick_name":userInfo[@"nick_name"],
                          @"user_id":userInfo[@"userid"],
                          @"by_user_id":_dataModel.userId,
                          @"by_nick_name":nickname,
                          };
    [WPHttpTool postWithURL:url params:dic success:^(id json) {
       
        SPButton *button = (SPButton *)[self.view viewWithTag:101];
        if ([json[@"status"] isEqualToString:@"1"]) {
            switch (_isAttent) {
                case 0:/**< 关注 */
                    button.contentLabel.text = @"已关注";
                    _isAttent = 1;
                    break;
                case 1:/**< 已关注 */
                    button.contentLabel.text = @"关注";
                    _isAttent = 0;
                    break;
                case 2:/**< 被关注 */
                    button.contentLabel.text = @"互关注";
                    _isAttent = 3;
                    break;
                case 3:/**< 互关注 */
                    button.contentLabel.text = @"被关注";
                    _isAttent = 2;
                    break;
                default:
                    break;
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}

-(void)addFriend
{
    WPAddFriendController *addFriend = [[WPAddFriendController alloc]init];
    addFriend.title = @"申请验证";
    [self.navigationController pushViewController:addFriend animated:YES];
}

#pragma mark - tableView代理事件
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
        case 2:
            return 3;
        case 3:
            return 2;
        default:
            return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2) {
        static NSString *cellId = @"";
        WPFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WPFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.headImageView.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
        cell.titleLabel.text = self.titleArr[indexPath.section][indexPath.row];
        return cell;
    }else{
        static NSString *cellId = @"cellId";
        WPStrangerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WPStrangerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.headImageView.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
        cell.titleLabel.text = self.titleArr[indexPath.section][indexPath.row];
        cell.contentLabel.text = self.contentArr[indexPath.section][indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        
        switch (indexPath.row) {
            case 0:
                NSLog(@"企业网站");
                break;
            case 1:
                NSLog(@"求职/招聘");
                break;
            case 2:
                NSLog(@"回忆录");
                break;
            default:
                break;
        }
    }
}

#pragma mark - tableView分割线左移至0
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
