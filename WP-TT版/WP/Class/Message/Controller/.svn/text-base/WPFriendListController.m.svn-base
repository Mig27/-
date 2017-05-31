//
//  WPFriendListController.m
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPFriendListController.h"
#import "WPFriendListByCategoryController.h"
#import "WPGetFriendCategoryListHttp.h"
#import "WPAddFriendCategoryHttp.h"
#import "WPDeleteFriendCategoryHttp.h"
#import "WPPhoneBookFriendCategoryCell.h"
#import "WPModifyFriendCategoryHttp.h"
#import "MTTDatabaseUtil.h"
#import "WPPhoneBookCheckCell.h"
#define kCollection @"/ios/collection_new.ashx"

#import "CollectViewController.h"
#import "WPHttpTool.h"
#import "CollectTypeModel.h"
#import "RKAlertView.h"
#import "MBProgressHUD+MJ.h"
#import "CollectionManager.h"
#import "WPCollectTypeCell.h"
#import "WPCollectionController.h"
#import "CCAlertView.h"
#import "WPTransferFriendToNewCateogryHttp.h"

@interface WPFriendListController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,WPPhoneBookFriendCategoryCellDelegate,WPPhoneBookCheckCellDelegate>
{
    BOOL isFirst;
    BOOL alsoFirst;
    NSString *type_id;
    NSString *types;
    NSString *currentType;
    BOOL needSelect;
    //    用于存放被修改的类名typeid
    NSMutableArray *typeIdArray;
    //    用于存放修改的后的类名
    NSMutableArray *typeNameArray;

}
//@property (nonatomic,strong) UITableView *tableView;
//
//@property (nonatomic,strong) UIButton *selectAllBtn;
//@property (nonatomic,strong) UIButton *editBtn;
//
//@property (nonatomic,strong) UIView *bottomView;
//
//
//@property (nonatomic,strong) NSMutableArray *deleteList;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIButton *editBtn;
@property (nonatomic ,strong) UIView *editView;
@property (nonatomic ,strong) UIButton *selectedBtn;
@property (nonatomic ,strong) UIButton *deleteBtn;

@property(nonatomic,strong) UIButton *countBtn;

@property(nonatomic,assign) NSInteger countNum;

@property (nonatomic ,strong) NSMutableArray *selectedArr;





@end

@implementation WPFriendListController

#pragma mark -  lazy load
-(NSArray *)selectedArr{
    if (_selectedArr == nil) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}

-(NSArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

-(void)addAnimationToCountBtn{
    [self.countBtn.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [self.countBtn.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友类别";
    self.view.backgroundColor = [UIColor whiteColor];
    typeIdArray = [[NSMutableArray alloc]init];
    typeNameArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = RGB(235, 235, 235);
    [self getFriendCategoryList];
    [self initNav];
    [self createEditView];
    if (_isCheck) {
        [self.view addSubview:self.editView];
    }
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    

}

#pragma mark - 数据相关
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
            [self.dataList removeAllObjects];
            [self backToNoEdit];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    

}

-(void)addFriendCategoryWithName:(NSString *)name{
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
            [self.tableView reloadData];
            [self getFriendCategoryList];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}

-(void)deleteFriendCategoryWithId:(NSString *)ids{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPDeleteFriendCategoryParam *param = [[WPDeleteFriendCategoryParam alloc] init];
    param.action = @"DelFtype";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    param.typeid = ids;
    
    [WPDeleteFriendCategoryHttp wPDeleteFriendCategoryHttpWithParam:param success:^(WPDeleteFriendCategoryResult *result) {
     if (result.status.intValue == 1) {
         types = nil; //删除成功就清空
//         [self backToNoEdit];   现在删除操作之后 还是保留编辑的状态
         [self getFriendCategoryList];
         
         [self reloadData];
         [self.tableView setNeedsDisplay];
         
         NSArray * array = [ids componentsSeparatedByString:@","];
         for (NSString* string in array) {//数据库中删除列表
              [[MTTDatabaseUtil instance] deleteFriendsCategoryDetail:string];
             [[MTTDatabaseUtil instance] deleteFriendsCategory:string];
         }
        
     }else{
        [MBProgressHUD showError:result.info];
     }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}


-(void)modifyFriendCategoryNameWithTypeIds:(NSMutableArray *)typeIdArr andTypeNameArr:(NSMutableArray *)TypeNameArr{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPModifyFriendCategoryParam *param = [[WPModifyFriendCategoryParam alloc] init];
    param.action = @"UpdateName";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    
    NSString *idstr,*nameStr;
    for (NSString *str in typeIdArr) {
        idstr = [NSString stringWithFormat:@"%@,%@",idstr,str];
    }
    idstr = [idstr substringFromIndex:7];
    
    for (NSString *str in TypeNameArr) {
        nameStr = [NSString stringWithFormat:@"%@,%@",nameStr,str];
    }
    nameStr = [nameStr substringFromIndex:7];

    param.typeid = idstr;
    param.typename = nameStr;
    
    [WPModifyFriendCategoryHttp WPModifyFriendCategoryHttpWithParam:param success:^(WPModifyFriendCategoryResult *result) {
        if (result.status.intValue == 1) {
            [MBProgressHUD showSuccess:result.info];
            [MBProgressHUD hideHUD];
            [self getFriendCategoryList];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];

}

-(void)tranferFriendToNewCategoryWithID:(NSString *)typeID{
    WPShareModel *model = [WPShareModel sharedModel];
    WPTransferFriendToNewCateogryParam *param = [[WPTransferFriendToNewCateogryParam alloc] init];
    param.action = @"ToFried";
    param.friend_id = self.transferIDs;
    param.username = model.username;
    param.password = model.password;
    param.user_id = model.userId;
    param.typeid = typeID;
    
    [WPTransferFriendToNewCateogryHttp WPTransferFriendToNewCateogryHttpWithParam:param success:^(WPTransferFriendToNewCateogryResult *result) {
        if (result.status.intValue == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
}



#pragma mark - cell 代理
- (void)editTypeId:(NSString *)typeId andeditValue:(NSString *)value
{
    [typeIdArray addObject:typeId];
    [typeNameArray addObject:value];
}


#pragma mark -  初始化UI
- (void)initNav{
    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(0, 0, 50, 22);
//    [back addTarget:self action:@selector(backToFromVC) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
//    imageV.image = [UIImage imageNamed:@"fanhui"];
//    [back addSubview:imageV];
//    
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
//    title.text = @"返回";
//    title.font = kFONT(14);
//    [back addSubview:title];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collect"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick:)];
}


//点击返回 分两种情况：返回未编辑状态  或者  是返回上一层
//-(void)backToFromVC{
//    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"完成"]) {
//        [self backToNoEdit];
//        return;
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//}

//- (void)backToFromViewController:(UIButton *)sender
//{
//    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"完成"]) {
//        [self backToNoEdit];
//        return;
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//
//}


#pragma mark - 设置tableView
-(void)setupTableView{
    //设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 ) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= RGBCOLOR(235, 235, 235);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 50;
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
}


#pragma mark - 数据源,代理方法

/**
 *  每一行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 根据标识去缓存池找cell
    static NSString *cellId = @"FriendCategoryCell";
    
    WPPhoneBookCheckCell *cell = [[WPPhoneBookCheckCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    __weak __typeof(cell)weakSelf = cell;
    cell.checkboxBlock = ^(){
        if (weakSelf.model.selected == YES) {
            _countNum++;
        }else{
            _countNum--;
        }
        if (_countNum < 0 ) {
            _countNum =0;
        }
        if (_countNum == 0) {
            self.countBtn.hidden = YES;
            [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
            self.deleteBtn.enabled = NO;
        }else{
            self.countBtn.hidden = NO;
            self.deleteBtn.enabled = YES;
            [self.deleteBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
            [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_countNum] forState:UIControlStateNormal];
        }
        // 当不是全选操作的时候  单步多次全部选中  全选变取消全选  反之亦然
        if (_countNum== self.dataList.count) {
            self.selectedBtn.hidden = NO;
            [self.selectedBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        }else if(_countNum == 0){
            [self.selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
        }else{
            [self.selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        [self addAnimationToCountBtn];
    };
    cell.delegate = self;
    if (needSelect) {
        cell.needSelect = needSelect;
    }
    cell.model = self.dataList[indexPath.row];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataList.count == 0) {  //在这里写是因为 很多地方都是要刷新数据源
        self.editBtn.enabled = NO;
        [self.editBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    }else{
        self.editBtn.enabled = YES;
        [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self.dataList.count;
}



- (void)backToFromViewController:(UIButton *)sender
{
    if (needSelect) {
        [self backToNoEdit];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backToNoEdit
{
    for (WPPhoneBookFriendCategoryModel *model in self.dataList) {
        model.selected = NO;
        types = nil;
        [self.tableView reloadData];
    }
    if (0 != typeIdArray.count) {
        [self modityfyClass:typeIdArray andName:typeNameArray success:^(id json) {
            NSLog(@"%@",json);
            [self getFriendCategoryList];
        }];
    }
    needSelect = NO;
    self.editBtn.hidden = NO;
    self.selectedBtn.hidden = YES;
    self.deleteBtn.hidden = YES;
    self.countBtn.hidden = YES;
    self.deleteBtn.enabled = NO;
    _countNum = 0;
    [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collect"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick:)];
}

- (void)modityfyClass:(NSMutableArray *)idArray andName:(NSMutableArray *)nameArray success:(void (^)(id))success
{
    NSString *idstr,*nameStr;
    for (NSString *str in idArray) {
        idstr = [NSString stringWithFormat:@"%@,%@",idstr,str];
    }
    idstr = [idstr substringFromIndex:7];
    
    for (NSString *str in nameArray) {
        nameStr = [NSString stringWithFormat:@"%@,%@",nameStr,str];
    }
    nameStr = [nameStr substringFromIndex:7];
    NSLog(@"nameArray%@;idstr%@",nameStr,idstr);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"updatetype", @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,@"typeid":idstr,@"typename":nameStr,
                                                                                  @"my_user_id":kShareModel.userId}];
    //
    NSString *url = [IPADDRESS stringByAppendingString:kCollection];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        success(json);
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        NSLog(@"%@",@"error");
    }];
    [typeIdArray removeAllObjects];
    [typeNameArray removeAllObjects];
}

-(void)createEditView{
    self.editView = [[UIView alloc] init];
    self.editView.backgroundColor = [UIColor redColor];
    self.editView.layer.borderWidth = 0.5;
    self.editView.backgroundColor = [UIColor whiteColor];
    self.editView.layer.borderColor = RGBColor(178, 178, 178).CGColor;
    [self.view addSubview:_editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    self.selectedBtn = [[UIButton alloc] init];
    [self.selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
    self.selectedBtn.titleLabel.font = kFONT(14);
    self.selectedBtn.hidden = YES;
    self.selectedBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -kHEIGHT(10), 0, 0);
    self.selectedBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.selectedBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    [self.selectedBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:self.selectedBtn];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editView.mas_left);
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@80);
    }];
    
    
    
    CGSize normalSize = [@"字体" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = kFONT(14);
    self.deleteBtn.hidden = YES;
    [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:_deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editView.mas_right).with.offset(-kHEIGHT(10));
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@(normalSize.width));
    }];
    
    CGSize normalSize1 = [@"字体" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.editBtn = [[UIButton alloc] init];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = kFONT(14);
    self.editBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:_editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editView.mas_right).with.offset(-kHEIGHT(10));
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@(normalSize1.width));
    }];
    
    
    //选中计数按钮
    UIButton *countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countBtn = countBtn;
    self.countBtn.backgroundColor = RGB(0, 172, 255);
    self.countBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.countBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.countBtn.clipsToBounds = YES;
    self.countBtn.hidden = YES;
    self.countBtn.layer.cornerRadius = 10;
    [self.countBtn setTitle:[NSString stringWithFormat:@"%lu",_countNum] forState:UIControlStateNormal];
    [self.editView addSubview:self.countBtn];
    [self.countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteBtn.mas_left).with.offset(-3);
        make.centerY.equalTo(self.deleteBtn);
        make.width.height.equalTo(@20);
    }];
    
}


//  点击编辑按钮 或者 是删除按钮 触发的操作
- (void)buttonAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        if (self.dataList.count == 0) {
            return;
        }
        needSelect = YES;
        self.selectedBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.editBtn.hidden = YES;
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick:)];
    }else if ([sender.titleLabel.text isEqualToString:@"全选"]){
        types = nil;
        for (WPPhoneBookFriendCategoryModel *model in self.dataList) {
            model.selected = YES;
            [self.tableView reloadData];
            _countNum = self.dataList.count;
        }
        self.countBtn.hidden = NO;
        [self.deleteBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
        [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_countNum] forState:UIControlStateNormal];
        [sender setTitle:@"取消全选" forState:UIControlStateNormal];

    }else if ([sender.titleLabel.text isEqualToString:@"取消全选"]){
        for (WPPhoneBookFriendCategoryModel *model in self.dataList) {
            model.selected = NO;
            types = nil;
            _countNum = 0;
            [self.tableView reloadData];
        }
        self.countBtn.hidden = YES;
        self.deleteBtn.enabled = NO;
        [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [sender setTitle:@"全选" forState:UIControlStateNormal];

    }else{
        
        for (WPPhoneBookFriendCategoryModel *model in self.dataList) {
            if (model.selected) {
                if (types.length > 0) {
                    types = [NSString stringWithFormat:@"%@,%@",types ,model.id];
                }else{
                    types = model.id;
                }
            }
            
        }
        if (types) {  // 如果删除数组里面有值提示这个提示框
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除类别?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"请至少选择一项" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
        }
        
    }
}



- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark - add new type
- (void)rightBtnClick:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
    if (typeIdArray.count != 0) {
        [self modifyFriendCategoryNameWithTypeIds:typeIdArray andTypeNameArr:typeNameArray];
    }
    if ([sender.title isEqualToString:@"完成"]) {
        [self backToNoEdit];
        return;
    }
    UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:@"新建类别" message:@"请输入新建类别名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    customAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[customAlertView textFieldAtIndex:0] addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    customAlertView.tag = 1;
    customAlertView.delegate = self;
    [customAlertView show];
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"确认删除类别?"]) {
        if (buttonIndex == 1) {
            [self deleteFriendCategoryWithId:types];  //types就是要删除的ids
            [self getFriendCategoryList];

            _countNum = 0;
            [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
            self.deleteBtn.enabled = NO;
            self.countBtn.hidden = YES;

        }
    }
    [[alertView textFieldAtIndex:0] resignFirstResponder];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.view endEditing:YES];
    if ([alertView.title isEqualToString:[NSString stringWithFormat:@"是否确定转移到%@",currentType]]) {
        if (buttonIndex == 1) {  // 这里是点击确定按钮的效果
            
            
        }
        return;
    }
    if (alertView.tag == 2) {  // 这里是点击转移按钮
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([alertView.title isEqualToString:@"新建类别"]) {   // 这里是点击了添加类别
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            NSLog(@"确认了输入：%@",[alertView textFieldAtIndex:0].text);
            if ([alertView textFieldAtIndex:0].text.length == 0) {
                [self performSelector:@selector(delayToShow) withObject:nil afterDelay:0.2];
            } else {
                [self addFriendCategoryWithName:[alertView textFieldAtIndex:0].text];
                [self getFriendCategoryList];
                
            }
        }
    }
}

- (void)delayToShow
{
    [MBProgressHUD createHUD:@"创建类别不能为空！" View:self.view];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 14) {
        textField.text = [textField.text substringToIndex:14];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.rowHeight = [TopicCell cellHeight];
        _tableView.rowHeight = kHEIGHT(43);
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WPPhoneBookFriendCategoryModel *model = self.dataList[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.transferIDs.length > 0) {
        CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"提示" message:@"是否确定转移当前收藏内容到指定收藏类别?"];
        [alert addBtnTitle:@"取消" action:^{
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }];
        [alert addBtnTitle:@"确定" action:^{
            //执行转移操作
            [self tranferFriendToNewCategoryWithID:model.id];
        }];
        [alert showAlertWithSender:self];
    }
    if (needSelect) {
        return;
    }
  
    if (![self.navigationItem.rightBarButtonItem.title isEqualToString:@"完成"]) {
        WPFriendListByCategoryController *VC = [[WPFriendListByCategoryController alloc]init];
        VC.typeId =  model.id;
        VC.categoryName = model.typename;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
//        WPPhoneBookCheckCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        WPPhoneBookFriendCategoryModel *model = self.dataList[indexPath.row];
//        // 说明是在编辑状态
//        cell.button.selected = !cell.button.selected;
//        model.selected = cell.button.selected;
//       
//        
//        //编辑状态下面还要对title进行处理self.dataList[indexPath.section][indexPath.row];
//        if (cell.model.selected == YES) {
//            _countNum ++;
//        }else{
//            _countNum --;
//        }
//        if (_countNum < 0) {
//            _countNum = 0;
//        }
//        if (_countNum == 0) {
//            self.countBtn.hidden = YES;
//            self.deleteBtn.enabled = NO;
//            [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
//        }else{
//            self.countBtn.hidden = NO;
//            self.deleteBtn.enabled = YES;
//            [self.deleteBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
//            [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_countNum] forState:UIControlStateNormal];
//        }
//        [self addAnimationToCountBtn];
//        [self.tableView reloadData];
    }
}

//取消一项
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"完成"]) {
        WPPhoneBookFriendCategoryModel *model = self.dataList[indexPath.row];
        if (model.selected == YES) {
            model.selected = NO;
        }
        [self.tableView reloadData];

    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //将分割线拉伸到屏幕的宽度
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}





- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
