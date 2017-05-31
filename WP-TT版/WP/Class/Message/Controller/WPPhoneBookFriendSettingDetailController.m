//
//  WPPhoneBookFriendSettingDetailController.m
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//  好友设置详情页面
//

#import "WPPhoneBookFriendSettingDetailController.h"
#import "WPDragIntoBlackListHttp.h"
#import "WPRemarkSettingHttp.h"
#import "WPGetFriendCategoryListHttp.h"
#import "CCAlertView.h"
#import "WPAddFriendCategoryHttp.h"
#import "WPTransferFriendToNewCateogryHttp.h"
#import "WPGetFriendInfoHttp.h"
#import "WPJoinInTypeHttp.h"

@interface WPPhoneBookFriendSettingDetailController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) WPGetFriendInfoResult *result;

@end

@implementation WPPhoneBookFriendSettingDetailController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getSettingInfo];
}
#pragma mark - 数据相关
-(void)getSettingInfo{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPGetFriendInfoParam *param = [[WPGetFriendInfoParam alloc] init];
    param.action = @"userinfo";
    param.friend_id = self.friendID;
    param.user_id = userInfo[@"userid"];
    
    [WPGetFriendInfoHttp WPGetFriendInfoHttpWithParam:param success:^(WPGetFriendInfoResult *result) {
        self.result = result;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.vcTitle isEqualToString:@"推荐给好友"]) {
        self.title = @"通讯录";
    }
    self.title = self.vcTitle;
    self.view.backgroundColor= RGBCOLOR(238, 238, 238);
    [self loadViewWithvcTitle];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordLimit) name:UITextFieldTextDidChangeNotification object:self.tf];
}

#pragma mark -  键盘通知方法
-(void)wordLimit{
   
    NSString *tobeString = self.tf.text;
    NSString *lang = self.textInputMode.primaryLanguage;  //获取键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self.tf markedTextRange];
        if (!selectedRange) {
            if (tobeString.length > 22) {
                [MBProgressHUD createHUD:@"超过字数限制" View:self.view];
                self.tf.text = [tobeString substringToIndex:22];
            }
        }
        
    }else{
        if (tobeString.length > 22) {
            [MBProgressHUD createHUD:@"超过字数限制" View:self.view];
            self.tf.text = [tobeString substringToIndex:22];
        }
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/22",_tf.text.length];
    
}

#pragma mark -  网路相关
-(void)friendRemarkSetting{
    WPShareModel *model = [WPShareModel sharedModel];
    WPRemarkSettingParam *param = [[WPRemarkSettingParam alloc] init];
    param.action = @"RemarkToHe";
    param.username = model.username;
    param.password = model.password;
    param.user_id = model.userId;
//    if ([self.tf.text isEqualToString:@""]|| self.tf.text == nil) {
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    param.post_remark = self.tf.text;
    param.friend_id = self.friendID;
    [WPRemarkSettingHttp WPRemarkSettingHttpWithParam:param success:^(WPRemarkSettingResult *result) {
        if (result.status.intValue == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.tf.text,@"RemarkName",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostRemarkName" object:self userInfo:dict];
            [MBProgressHUD createHUD:result.info View:self.view];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];

}

-(void)getFriendCategoryList{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPGetFriendCategoryListParam *param = [[WPGetFriendCategoryListParam alloc] init];
    param.action = @"GetFtype";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    
    [WPGetFriendCategoryListHttp wPGetFriendCategoryListHttpWithParam:param success:^(WPGetFriendCategoryListResult *result) {
        if (result.status.intValue == 1) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:result.list];
            [self.tableView reloadData];
        }else{
//            [MBProgressHUD showError:result.info];
            
            
            if ([self.vcTitle isEqualToString:@"设置好友类别"]) {
                UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:@"新建类别" message:@"请输入新建类别名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
                customAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                customAlertView.tag = 1;
                customAlertView.delegate = self;
                [customAlertView show];
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}

-(void)addFriendCategoryWithName:(NSString *)name success:(void(^)(NSString*))Success{
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPAddFriendCategoryParam *param = [[WPAddFriendCategoryParam alloc] init];
    param.action = @"AddFtype";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    param.typename = name;
    
    [WPAddFriendCategoryHttp wPAddFriendCategoryHttpWithParam:param success:^(WPAddFriendCategoryResult *result) {
        if (result.status.intValue == 1) {
            Success(result.typeID);
            [self.tableView reloadData];
            [self getFriendCategoryList];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
}

-(void)tranferFriendToNewCategoryWithID:(NSString *)typeID andTypeName:(NSString *)name{
    WPShareModel *model = [WPShareModel sharedModel];
    WPTransferFriendToNewCateogryParam *param = [[WPTransferFriendToNewCateogryParam alloc] init];
    param.action = @"ToFried";
    param.friend_id = self.friendID;
    param.username = model.username;
    param.password = model.password;
    param.typeid = typeID;
    param.user_id = model.userId;

    [WPTransferFriendToNewCateogryHttp WPTransferFriendToNewCateogryHttpWithParam:param success:^(WPTransferFriendToNewCateogryResult *result) {
        if (result.status.intValue == 1) {
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:name,@"CategoryName",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostNewCategoryName" object:self userInfo:dict];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"设置成功"];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];

}



#pragma mark - 根据vcTitle 分别加载不同页面
-(void)loadViewWithvcTitle{
    if ([self.vcTitle isEqualToString:@"设置备注名称"]) {
        [self setupNavWithType:@"remarkSetting"];
        [self loadSettingRemarkView];
    }
    if ([self.vcTitle isEqualToString:@"推荐给好友"]) {
         [self setupNavWithType:@"推荐给好友"];
//         [self loadSettingRemarkView];
    }
    if ([self.vcTitle isEqualToString:@"设置好友类别"]) {
        [self setupNavWithType:@"设置好友类别"];
        [self loadTableViewWithType:@"设置好友类别"];
    }
    if ([self.vcTitle isEqualToString:@"话题设置"]) {
        [self setupNavWithType:@"话题设置"];
        [self loadTableViewWithType:@"话题设置"];
        
    }
    if ([self.vcTitle isEqualToString:@"求职设置"]) {
        [self setupNavWithType:@"求职设置"];
        [self loadTableViewWithType:@"求职设置"];
    }
    if ([self.vcTitle isEqualToString:@"招聘设置"]) {
        [self setupNavWithType:@"招聘设置"];
        [self loadTableViewWithType:@"招聘设置"];
    }
    if ([self.vcTitle isEqualToString:@"举报"]) {
        [self setupNavWithType:@"举报"];
        [self loadTableViewWithType:@"举报"];
    }
    
    
}


#pragma mark - Nav  设置
-(void)setupNavWithType:(NSString *)type{
   
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *vcTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    vcTitle.text = @"返回";
    vcTitle.font = kFONT(14);
    [back addSubview:vcTitle];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
    
    if ([type isEqualToString:@"remarkSetting"]) {
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    }
    if ([type isEqualToString:@"设置好友类别"]) {
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collect"] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    }
    if ([type isEqualToString:@"话题设置"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain  target:self action:nil];
    }
  
    
}

#pragma mark - Nav  rightItem  click
-(void)rightItemClick{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"完成"]) {
        //如果点击完成 对比还是带过来姓名 就不执行下面的操作  而且还必须是在没设置备注的情况下
        NSString *tfText = self.tf.text;
        if (self.result.fremark==nil||self.result.fremark.length==0) {
            if ([self.TFContent isEqualToString:tfText]) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }

        }
        [self friendRemarkSetting];
    }
    if (self.navigationItem.rightBarButtonItem.image) {
        UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:@"新建类别" message:@"请输入新建类别名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        customAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        customAlertView.tag = 1;
        customAlertView.delegate = self;
        [customAlertView show];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.view endEditing:YES];
  
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        if ([alertView textFieldAtIndex:0].text.length == 0) {
            [self performSelector:@selector(delayToShow) withObject:nil afterDelay:0.2];
        } else {
            if ([self.vcTitle isEqualToString:@"设置好友类别"] && !self.dataList.count)
            {
                __weak typeof(self) weakSelf = self;
                [self addFriendCategoryWithName:[alertView textFieldAtIndex:0].text success:^(NSString *string) {
                     [weakSelf joinToTypeWithIds:string];
                }];
            }
            else
            {
                [self addFriendCategoryWithName:[alertView textFieldAtIndex:0].text success:^(NSString *string) {
                    
                }];
                [self getFriendCategoryList];
            }
//            [self addFriendCategoryWithName:[alertView textFieldAtIndex:0].text];
//            [self getFriendCategoryList];
            
        }
    }
    

}

- (void)delayToShow
{
    [MBProgressHUD createHUD:@"创建类别不能为空！" View:self.view];
}



#pragma mark - Nav  leftItem  click
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置备注名称
-(void)loadSettingRemarkView{
    UIView *settingView = [[UIView alloc] init];
    settingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:settingView];
    [settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64+15);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    
    
    //创建textFiled
    UITextField *tf = [[UITextField alloc] init];
    tf.backgroundColor = [UIColor whiteColor];
    tf.text = self.TFContent;
    NSLog(@"%@",self.TFContent);
    tf.placeholder = @"请填写备注名称";
    self.tf = tf;
    
    //缩进View
    UIView *indentView = [[UIView alloc] init];
    indentView.frame = CGRectMake(0, 0, 10, 10);
    tf.leftView = indentView;
    tf.leftViewMode = UITextFieldViewModeAlways;

    [settingView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(settingView.mas_top).with.offset(0);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    //创建0/22 label
    UILabel *countLabel = [[UILabel alloc] init];
    if (self.TFContent) {
        countLabel.text = [NSString stringWithFormat:@"%lu/22",(unsigned long)self.TFContent.length];
    }else{
        countLabel.text = @"0/22";
    }
    
    self.countLabel = countLabel;
    [settingView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tf.mas_bottom).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.height.equalTo(@20);
    }];

}


#pragma mark - 好友类别
-(void)loadTableViewWithType:(NSString *)type{
    //设置tableView
    if ([type isEqualToString:@"话题设置"]) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 44) style:UITableViewStyleGrouped];
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 44) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= RGBCOLOR(238, 238, 238);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    //对于无数据的cell 不显示分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    if ([type isEqualToString:@"设置好友类别"]) {
        [self getFriendCategoryList];
    }
    
}

#pragma mark - 数据源,代理方法

/**
 *  每一行显示怎样的cell
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.vcTitle isEqualToString:@"设置好友类别"]) {
        UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = [self.dataList[indexPath.row] typename];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if ([self.vcTitle isEqualToString:@"话题设置"]){
        if (indexPath.section == 0) {
            UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"不让他(她)看我的话题";
            UISwitch *switchView = [[UISwitch alloc] init];
            [cell addSubview:switchView];
            cell.accessoryView = switchView;
            return cell;
        }else{
            UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"不看他(她)的话题";
            UISwitch *switchView = [[UISwitch alloc] init];
            [cell addSubview:switchView];
            cell.accessoryView = switchView;
            return cell;
        }
        
    }else if ([self.vcTitle isEqualToString:@"求职设置"]){
        if (indexPath.section == 0) {
            UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"不让他(她)看我的求职";
            UISwitch *switchView = [[UISwitch alloc] init];
            [cell addSubview:switchView];
            cell.accessoryView = switchView;
            return cell;
        }else{
            UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"不看他(她)的求职";
            UISwitch *switchView = [[UISwitch alloc] init];
            [cell addSubview:switchView];
            cell.accessoryView = switchView;
            return cell;
        }
    }else if ([self.vcTitle isEqualToString:@"招聘设置"]){
        if (indexPath.section == 0) {
            UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"不让他(她)看我的招聘";
            UISwitch *switchView = [[UISwitch alloc] init];
            [cell addSubview:switchView];
            cell.accessoryView = switchView;
            return cell;
        }else{
            UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"不看他(她)的招聘";
            UISwitch *switchView = [[UISwitch alloc] init];
            [cell addSubview:switchView];
            cell.accessoryView = switchView;
            return cell;
        }
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *message = [NSString stringWithFormat:@"确定将%@放到%@类别?",self.friendName,[self.dataList[indexPath.row] typename]];
    CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"提示" message:message];
    [alert addBtnTitle:@"取消" action:^{

    }];
    [alert addBtnTitle:@"确定" action:^{
        NSString *typeId = [self.dataList[indexPath.row] id];
//        NSString *name = [self.dataList[indexPath.row] typename];
        [self joinToTypeWithIds:typeId];
    }];
    [alert showAlertWithSender:self];
}

-(void)joinToTypeWithIds:(NSString *)Ids{
    WPShareModel *model = [WPShareModel sharedModel];
    WPJoinInTypeParam *param = [[WPJoinInTypeParam alloc] init];
    param.action = @"JoinInType";
    param.username = model.username;
    param.password = model.password;
    param.user_id = model.userId;
    param.typeid = Ids;
    param.friend_id = self.friendID;
    [WPJoinInTypeHttp WPJoinInTypeHttpWithParam:param success:^(WPJoinInTypeResult *result) {
        if (result.status.intValue == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"设置成功"];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma mark - lazy load
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


@end
