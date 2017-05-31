 //
//  CollectViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/3/28.
//  Copyright © 2016年 WP. All rights reserved.
//
#define kCollection @"/ios/collection_new.ashx"

#import "CollectViewController.h"
#import "WPHttpTool.h"
#import "CollectTypeModel.h"
#import "RKAlertView.h"
#import "MBProgressHUD+MJ.h"
#import "CollectionManager.h"
#import "WPCollectTypeCell.h"
#import "WPCollectionController.h"
#import "WPMySecurities.h"
#import "MTTMessageEntity.h"
#import "MTTGroupEntity.h"
#import "DDUserModule.h"
@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,CollectionManagerDelegate,UIAlertViewDelegate,UITextFieldDelegate,WPCollectTypeCellDelegate>
{
    BOOL isFirst;
    BOOL alsoFirst;
    NSString *type_id;
    BOOL needSelect;
    NSString *types;
    NSString *currentType;
//    用于存放被修改的类名typeid
    NSMutableArray *typeIdArray;
//    用于存放修改的后的类名
    NSMutableArray *typeNameArray;
}
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *dataSource;
@property (nonatomic ,strong) UIButton *editBtn;
@property (nonatomic ,strong) UIView *editView;

@property (nonatomic ,strong) UIButton *deleteBtn;
@property (nonatomic ,strong) UIButton *selectedBtn;

@property(nonatomic,strong) UIButton *countBtn;

@property(nonatomic,assign) NSInteger countNum;

@property (nonatomic ,strong) NSMutableArray *selectedArr;

@property (nonatomic, copy)NSString *nameString;
@property (nonatomic, strong)NSDictionary* zhaoPinDic;
@end


@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.title) {
        self.title = @"收藏到";
    }
    typeIdArray = [[NSMutableArray alloc]init];
    typeNameArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = RGB(235, 235, 235);
    [self requestTypeArr];
    [self initNav];
    if (_isCheck)
    {
        if (_isFromChat) {//从聊天界面来
        }
        else
        {
            if (![self.title isEqualToString:@"收藏到"]) {
               [self createEditView];
            }
//            [self createEditView];
        }
    }
    
    if (!self.isCollectionFromChat && !self.isCollectionFromChatMuch && !self.muchDic.count) {//收藏招聘的药请求企业的相关信息
        NSArray * array = [_jobid componentsSeparatedByString:@","];
        if (array.count==1 ) {
            [self requstModel:^(id json) {
                self.zhaoPinDic = json;
            }];
        }
       
    }
    
}

-(void)requstModel:(void(^)(id))Success
{
    NSDictionary * dic = nil;
    NSString * urlStr = nil;
    if ([self.collect_class isEqualToString:@"5"] ||([self.collect_class isEqualToString:@"7"]&& [self.shareStr isEqualToString:@"3"])) {
        dic = @{@"action":@"GetJobDraftInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"job_id":self.jobid};
        urlStr = [NSString stringWithFormat:@"%@/ios/inviteJob.ashx",IPADDRESS];
    }
    else if([self.collect_class isEqualToString:@"6"]||([self.collect_class isEqualToString:@"7"]&&[self.shareStr isEqualToString:@"2"]))
    {
        dic = @{@"action":@"GetResumeInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"resume_id":self.jobid};
        urlStr = [NSString stringWithFormat:@"%@/ios/resume_new.ashx",IPADDRESS];
    }
    else
    {
        return;
    }
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        Success(json);
    } failure:^(NSError *error) {
    }];
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

#pragma mark  点击返回
- (void)backToFromViewController:(UIButton *)sender
{
    if (needSelect) {//编辑状态下点击返回
        [self backToNoEdit];
    }else{
        [super backToFromViewController:sender];
    }
}

#pragma mark 点击完成
- (void)backToNoEdit
{
    if (0 != typeIdArray.count) {
        [self modityfyClass:typeIdArray andName:typeNameArray success:^(id json) {
            NSLog(@"%@",json);
            [self requestTypeArr];
        }];
    }
    needSelect = NO;
    self.editBtn.hidden = NO;
    self.selectedBtn.hidden = YES;
    [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    self.deleteBtn.enabled = NO;
    self.countNum = 0;
    self.deleteBtn.hidden = YES;
    [self.countBtn setTitle:@"" forState:UIControlStateNormal];
    self.countBtn.hidden = YES;
    for (CollectTypeModel * model in self.dataSource) {
        model.selected = NO;
    }
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
    self.selectedBtn.titleLabel.font = kFONT(15);
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
    self.deleteBtn.titleLabel.font = kFONT(15);
    self.deleteBtn.hidden = YES;
    [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:_deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editView.mas_right).with.offset(-kHEIGHT(10));
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@(normalSize.width+10));
    }];
    
    CGSize normalSize1 = [@"字体" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.editBtn = [[UIButton alloc] init];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = kFONT(15);
    self.editBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (self.dataSource.count)
    {
       [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
     [self.editBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    }
//    [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:_editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editView.mas_right).with.offset(-kHEIGHT(10));
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@(normalSize1.width+10));
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


- (void)buttonAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        if (self.dataSource.count == 0) {
            return;
        }
        needSelect = YES;
        self.selectedBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.editBtn.hidden = YES;
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick:)];
//        WPCollectTypeCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        [cell.titleLabel becomeFirstResponder];
//        cell.titleLabel.delegate = self;
        
//         [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification object: nil];
//        UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//        [tempWindow setAlpha:0];
//        [self.view endEditing:YES];
        
        
    }else if ([sender.titleLabel.text isEqualToString:@"全选"]){
        types = nil;
        for (CollectTypeModel *model in self.dataSource) {
            model.selected = YES;
            [self.tableView reloadData];
            _countNum = self.dataSource.count;
        }
        self.countBtn.hidden = NO;
        self.deleteBtn.enabled = YES;
        [self.deleteBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
        [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_countNum] forState:UIControlStateNormal];
        [sender setTitle:@"取消全选" forState:UIControlStateNormal];
    }else if ([sender.titleLabel.text isEqualToString:@"取消全选"]){
        for (CollectTypeModel *model in self.dataSource) {
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
        
        for (CollectTypeModel *model in self.dataSource) {
            if (model.selected) {
                if (types.length > 0) {
                    types = [NSString stringWithFormat:@"%@,%@",types ,model.type_id];
                }else{
                    types = model.type_id;
                }
            }
            
        }
        if (types) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除类别并删除该类别内的所有收藏" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
            
        }else{
            [[[UIAlertView alloc]initWithTitle:@"请至少选择一项" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
        }
        
    }
}


- (void)requestTypeArr
{
    CollectionManager *manager = [CollectionManager sharedManager];
    manager.delegate = self;
    [manager requestForCollectionTypeList];
}

#pragma mark 请求收藏列表
- (void)reloadData
{
    self.dataSource = nil;
    self.dataSource = [NSArray arrayWithArray:[CollectionManager sharedManager].typeArr];
    [self.tableView reloadData];
    if (self.dataSource.count) {
        [self setBottomBtn];
    }
    else
    {
       [self backToNoEdit];
        if ([self.title isEqualToString:@"收藏到"]) {
            UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:@"新建类别" message:@"请输入新建类别名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
            customAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[customAlertView textFieldAtIndex:0] addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            customAlertView.tag = 1;
            customAlertView.delegate = self;
            [customAlertView show];
        }
    }
    
    if (!self.dataSource.count) {
        [self.editBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    }
    else
    {
        [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    
}
#pragma mark 设置底部的状态
-(void)setBottomBtn
{
    [self.selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
    self.countNum = 0;
    [self.countBtn setTitle:@"" forState:UIControlStateNormal];
    self.countBtn.hidden = YES;
    
    [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    self.deleteBtn.enabled = NO;
}

- (void)initNav
{
//    self.title = _isFromChat?@"收藏":@"收藏到";
    self.navigationItem.rightBarButtonItem = _isFromChat?nil:[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collect"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick:)];
}

#pragma mark - 添加新类别
- (void)rightBtnClick:(UIBarButtonItem *)sender
{
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
    
    if ([alertView.title isEqualToString:@"提示"]) {
        if (buttonIndex == 1) {
            [[CollectionManager sharedManager]requestToDeleteCollectionTypeWithTypes:types success:^(id json) {
                [self requestTypeArr];
            }];
        }
        
    }
    [[alertView textFieldAtIndex:0] resignFirstResponder];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.view endEditing:YES];
    if ([alertView.title isEqualToString:[NSString stringWithFormat:@"是否确定转移到%@",currentType]]) {
        if (buttonIndex == 1) {
            [[CollectionManager sharedManager]requestToMoveCollections:self.collectionIDs toType:type_id success:^(id json) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:json[@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                alert.tag = 2;
//                alert.delegate = self;
//                [alert show];
                [self delegateAction];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }
        return;
    }
    if (alertView.tag == 2) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([alertView.title isEqualToString:@"新建类别"]) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            NSLog(@"确认了输入：%@",[alertView textFieldAtIndex:0].text);
            if ([alertView textFieldAtIndex:0].text.length == 0) {
                [self performSelector:@selector(delayToShow) withObject:nil afterDelay:0.2];
            } else {
                NSString * titleString = [alertView textFieldAtIndex:0].text;
                BOOL isSame = NO;
                for (CollectTypeModel * model in self.dataSource) {
                    if ([model.type_name isEqualToString:titleString]) {
                        isSame = YES;
                    }
                }
                if (isSame) {
                    [MBProgressHUD createHUD:@"该类别已存在！" View:self.view];
                    return;
                }
                
                [[CollectionManager sharedManager]requestToAddCollectionTypeWithTypename:[alertView textFieldAtIndex:0].text success:^(id json) {
                    if ([json[@"status"] integerValue] == 1) {
                        
                        if ([self.title isEqualToString:@"收藏到"]) {
                            //直接收藏[self.title isEqualToString:@"收藏到"]&& !self.dataSource.count
                            if (self.isCollectionFromChat)//聊天界面的单个收藏
                            {
                                [self collectionFromChat:nil and:json[@"id"]];
                            }
                            else
                            {
                                if (self.isCollectionFromChatMuch)//从聊天界面进行批量收藏
                                {
                                    [self collectionFromChatMuch:nil and:json[@"id"]];
                                }
                                else
                                {
                                    if (self.muchDic.count)
                                    {
                                        [self collectionOtherCollection:nil and:json[@"id"]];
                                    }
                                    else
                                    {
                                        [self collectWithIndexPath:nil and:json[@"id"]];
                                        [self delegateAction];
                                    }
                                }
                            }
                        }
                        else
                        {
                           [self requestTypeArr];
                        }
                    
//                        [self requestTypeArr];
                    }
                }];
            }
        }
    }
}

- (void)delayToShow
{
    [MBProgressHUD createHUD:@"创建类别不能为空！" View:self.view];
}

#pragma WPCollectTypeCell代理
- (void)editTypeId:(NSString *)typeId andeditValue:(NSString *)value
{
    
//    [typeIdArray addObject:typeId];
//    [typeNameArray addObject:value];
    for (int i = 0 ; i < typeIdArray.count; i++) {
        NSString * string = typeIdArray[i];
        if ( [string isEqualToString:typeId]) {
            [typeIdArray removeObject:string];
            [typeNameArray removeObjectAtIndex:i];
        }
    }
    [typeIdArray addObject:typeId];
    [typeNameArray addObject:value];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSString * toBeString = textField.text;
    NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [textField markedTextRange];
        UITextPosition * position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > 14) {
                textField.text = [toBeString substringToIndex:14];
            }
        }
        
        else{
            
        }
    }
    else
    {
        if (toBeString.length > 14) {
            textField.text = [toBeString substringToIndex:14];
        }
    }
//    if (textField.text.length > 14) {
//        textField.text = [textField.text substringToIndex:14];
//    }
}


- (UITableView *)tableView{
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49) style:UITableViewStyleGrouped];
        if ([self.title isEqualToString:@"收藏到"])
        {
          _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        }
        else
        {
          _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49) style:UITableViewStyleGrouped];
        }
        
        
        
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CollectID";
    WPCollectTypeCell *cell = [[WPCollectTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.delegate = self;
    if (needSelect) {
        cell.needSelect = needSelect;
    }
    cell.model = self.dataSource[indexPath.row];
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
        if (_countNum == self.dataSource.count) {
            [self.selectedBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        }
        else
        {
            [self.selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        [self addAnimationToCountBtn];
    };
    if (needSelect)
    {
       cell.accessoryView = [[UIView alloc]init];
    }
    else
    {
       cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
    }
    return cell;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (needSelect) {
        return;
    }
    CollectTypeModel *model = self.dataSource[indexPath.row];
    if (_isCheck) {//点击查看收藏的具体内容
        WPCollectionController *VC = [[WPCollectionController alloc]init];
        VC.typeId =  model.type_id;
        VC.title = model.type_name;
        VC.isFromChat = self.isFromChat;
        [self.navigationController pushViewController:VC animated:YES];
    }else{//点击进行转移
        if ([self.controller isEqualToString:@"WPCollectionController"] || [self.controller isEqualToString:@"MuchCollectionFromChatDetail"]) {
            type_id = model.type_id;
            currentType = model.type_name;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否确定转移到%@",currentType] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 2;
            alert.delegate = self;
            [alert show];
        }else{//点击收藏到具体的位置
            if (self.isCollectionFromChat)//聊天界面的单个收藏
            {
                [self collectionFromChat:indexPath and:nil];
            }
            else
            {
                if (self.isCollectionFromChatMuch)//从聊天界面进行批量收藏
                {
                    [self collectionFromChatMuch:indexPath and:nil];
                }
                else
                {
                    if (self.muchDic.count)
                    {
                        [self collectionOtherCollection:indexPath and:nil];
                    }
                    else
                    {
                        [self collectWithIndexPath:indexPath and:nil];
                        [self delegateAction];
                    }
                }
            }
        }
    }
}
#pragma mark 收藏别人收藏的
-(void)collectionOtherCollection:(NSIndexPath*)indexpath and:(NSString*)typeID
{
    NSDictionary * sendDic = @{
                               @"action":@"addcoll",
                               @"username":kShareModel.username,
                               @"password":kShareModel.password,
                               @"user_id":kShareModel.userId,
                               @"typeid":typeID.length?typeID:[self.dataSource[indexpath.row] type_id],
                               @"class":@"22",
                               @"lt_msg_id":self.muchDic[@"id"],
                               @"lt_from_user_id":self.muchDic[@"from_user_id"],
                               @"lt_from_user_name":self.muchDic[@"from_user_id"],//from_user_name
                               @"col4":self.col4,
                               @"my_user_id":kShareModel.userId
                               
                               };
    [[CollectionManager sharedManager]requestToaddCollectionWithParams:sendDic success:^(id json) {
        if ([json[@"status"] integerValue] == 1) {
            if (self.collectSuccessBlock) {
                self.collectSuccessBlock();
            }
            [MBProgressHUD showHudTipStr:json[@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showHudTipStr:json[@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(void)collectionFromChatMuch:(NSIndexPath*)indexpath and:(NSString*)typeID
{
    NSMutableArray * msg_infoArray = [NSMutableArray array];
    NSMutableArray * timeArray = [NSMutableArray array];
    NSMutableArray * messageArray = [NSMutableArray array];
    NSString * msg_type = [NSString string];
    NSString * msg_to_id= [NSString string];
    for (id objc in self.collectionFromMuchArray) {
        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
            MTTMessageEntity * message = (MTTMessageEntity*)objc;
            if (message.itemSelected) {
                [messageArray addObject:message];
                id objc = message.msgContent;
                if ([objc isKindOfClass:[NSString class]]) {
                    
                   
                    msg_type = (self.sessionType == SessionTypeSessionTypeSingle)?@"1":@"2";
                    msg_to_id = [NSString stringWithFormat:@"%@",[message.sessionId componentsSeparatedByString:@"_"][1]];

                    NSString * contentStr = (NSString*)objc;
                    NSData * data1 = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                     NSString * baseStr = [data1 base64EncodedStringWithOptions:0];
                    
                    NSString *display_type = [self getDisPlayType:message];
                    NSDate * date = [NSDate dateWithTimeIntervalSince1970:message.msgTime];
                    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    NSString * timeStr = [formatter stringFromDate:date];
                    
                    if (timeArray.count)//将时间排序
                    {
                      timeArray = [self timeOrder:timeStr andArray:timeArray];
                    }
                    else
                    {
                        [timeArray addObject:[timeStr componentsSeparatedByString:@" "][0]];
                    }
                    
                    //获取当前时间判断年份
                    NSDate * nowDate = [NSDate date];
                    NSDateFormatter * formatterNow = [[NSDateFormatter alloc]init];
                    formatterNow.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    NSString * dateStr = [formatterNow stringFromDate:nowDate];
                    NSArray * dateNowArr = [dateStr componentsSeparatedByString:@"_"];
                    NSArray * timeArr = [timeStr componentsSeparatedByString:@"_"];
                    if ([dateNowArr[0] intValue] > [timeArr[0] intValue]) {
                        timeStr = [timeStr componentsSeparatedByString:@" "][0];
                    }
                    else
                    {
                        NSArray * array= [timeStr componentsSeparatedByString:@" "];
                        NSString * strFirst = array[0];
                        NSArray * firstArray = [strFirst componentsSeparatedByString:@"-"];
                        NSString * firstString = [NSString stringWithFormat:@"%@-%@",firstArray[1],firstArray[2]];
                        
                        
                        
                        NSString * string  = array[1];
                        NSArray * array1 = [string componentsSeparatedByString:@":"];
                        NSString * string1 = [NSString stringWithFormat:@"%@:%@",array1[0],array1[1]];
                        timeStr = [NSString stringWithFormat:@"%@ %@",firstString,string1];
                    }

                    NSArray * userArray = [message.senderId componentsSeparatedByString:@"_"];
                    NSString * userId = [NSString stringWithFormat:@"%@",userArray[1]];
                    NSDictionary * dic = @{@"display_type":display_type,
                                           @"create_time":[NSString stringWithFormat:@"%f",message.msgTime],//timeStr
                                           @"from_id":userId,
                                           @"content":baseStr};
                    [msg_infoArray addObject:dic];
                }
            }
        }
    }
    
    //获取前三条消息
    NSString * threeMessage = [self getFirstMessage:messageArray];
    
    NSString * timeSepar = [NSString stringWithFormat:@"%@～%@",timeArray[0],timeArray[timeArray.count-1]];
    if (timeArray.count == 1)
    {
        timeSepar = [NSString stringWithFormat:@"%@",timeArray[0]];
    }
    
    NSDictionary * send = @{@"msg_list":msg_infoArray};
    NSData * sendData = [NSJSONSerialization dataWithJSONObject:send options:NSJSONWritingPrettyPrinted error:nil];
    NSString * sendStr = [[NSString alloc]initWithData:sendData encoding:NSUTF8StringEncoding];
    NSDictionary * sendDic = @{
                               @"action":@"addcoll",
                               @"username":kShareModel.username,
                               @"password":kShareModel.password,
                               @"typeid":typeID.length?typeID:[self.dataSource[indexpath.row] type_id],
                               @"msg_type":msg_type,
                               @"msg_to_id":msg_to_id,
                               @"msg_from_id":kShareModel.userId,
                               @"msg_time":timeSepar,
                               @"msg_info":sendStr,
                               @"msg_from_title":kShareModel.nick_name,
                               @"class":@"21",
                               @"msg_detail":threeMessage.length?threeMessage:@"",
                               @"col4":@"",
                               @"my_user_id":kShareModel.userId
                               
                               };
    [[CollectionManager sharedManager]requestToaddCollectionWithParams:sendDic success:^(id json) {
        if ([json[@"status"] integerValue] == 1) {
            if (self.collectSuccessBlock) {
                self.collectSuccessBlock();
            }
            [MBProgressHUD showHudTipStr:json[@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showHudTipStr:json[@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

    
}
-(NSString *)getFirstMessage:(NSMutableArray*)messageArray
{
   
    for (int i = 0 ; i < messageArray.count-1; i++) {
        for (int j = i+1 ; j < messageArray.count ; j++) {
            MTTMessageEntity * message = messageArray[i];
            MTTMessageEntity * message1 = messageArray[j];
            if (message.msgTime > message1.msgTime) {
                MTTMessageEntity * message2 = message1;
                [messageArray replaceObjectAtIndex:j withObject:message];
                [messageArray replaceObjectAtIndex:i withObject:message2];
            }
        }
    }
    
    NSString * firstStr = [NSString string];
    NSString * secondStr = [NSString string];
    NSString * thirdStr = [NSString string];
    
    for (int i = 0 ; i < ((messageArray.count>2)?3:2); i++) {
        
        MTTMessageEntity * message = messageArray[i];
        
        
        
        [[DDUserModule shareInstance] getUserForUserID:message.senderId Block:^(MTTUserEntity *user) {
            if (user) {
               
                switch (message.msgContentType) {
                    case DDMessageTypeText:
                        _nameString = [NSString stringWithFormat:@"%@:%@",user.nick,message.msgContent];
                        break;
                    case DDMessageTypeImage:
                        _nameString = [NSString stringWithFormat:@"%@:[图片]",user.nick];
                        break;
                    case DDMEssagePersonalaCard:
                    {
                        NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
                        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        _nameString = [NSString stringWithFormat:@"%@:推荐了%@",user.nick,dic[@"nick_name"]];
                    }
                        break;
                    case DDMEssageMyApply:
                    {
                        NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
                        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        _nameString = [NSString stringWithFormat:@"%@:[求职:%@]",user.nick,dic[@"qz_position"]];
                        
                    }
                        break;
                    case DDMEssageMyWant:
                    {
                        NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
                        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        _nameString = [NSString stringWithFormat:@"%@:[招聘:%@]",user.nick,dic[@"zp_position"]];
                        
                    }
                        break;
                    case DDMEssageMuchCollection:
                    {
                        NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
                        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        _nameString = [NSString stringWithFormat:@"%@:%@",user.nick,dic[@"title"]];
                        
                    }
                        break;
                    case DDMEssageMuchMyWantAndApply:
                    {
                        NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
                        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        _nameString = [NSString stringWithFormat:@"%@:[%@]",user.nick,dic[@"title"]];
                        
                    }
                        break;
                    case DDMEssageSHuoShuo:
                    {
                        NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
                        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        _nameString = [NSString stringWithFormat:@"%@:[%@]",user.nick,dic[@"nick_name"]];
                        
                    }
                        break;
                    case DDMEssageLitterVideo:
                        _nameString = [NSString stringWithFormat:@"%@:[视频]",user.nick];
                        break;
                    default:
                        break;
                }
//                [self.userName setText:user.nick];
            }
            
        }];
        
//        switch (message.msgContentType) {
//            case DDMessageTypeText:
//                string = [NSString stringWithFormat:@"%@:%@",message.senderName,message.msgContent];
//                break;
//            case DDMessageTypeImage:
//                string = [NSString stringWithFormat:@"%@:[图片]",message.senderName];
//                break;
//            case DDMEssagePersonalaCard:
//            {
//                NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
//                NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                string = [NSString stringWithFormat:@"%@:推荐了%@",message.senderName,dic[@"nick_name"]];
//            }
//                break;
//            case DDMEssageMyApply:
//            {
//                NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
//                NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                string = [NSString stringWithFormat:@"%@:[求职:%@]",message.senderName,dic[@"qz_position"]];
//            
//            }
//                break;
//            case DDMEssageMyWant:
//            {
//                NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
//                NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                string = [NSString stringWithFormat:@"%@:[招聘:%@]",message.senderName,dic[@"zp_position"]];
//                
//            }
//                break;
//            case DDMEssageMuchMyWantAndApply:
//            {
//                NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
//                NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                string = [NSString stringWithFormat:@"%@:[%@]",message.senderName,dic[@"title"]];
//                
//            }
//                break;
//            case DDMEssageSHuoShuo:
//            {
//                NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
//                NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                string = [NSString stringWithFormat:@"%@:[%@]",message.senderName,dic[@"name"]];
//                
//            }
//                break;
//            case DDMEssageLitterVideo:
//                string = [NSString stringWithFormat:@"%@:[视频]",message.senderName];
//                break;
//            default:
//                break;
//        }
        if (i == 0) {
            firstStr = _nameString;
        }
        else if (i == 1)
        {
            secondStr = _nameString;
        }
        else
        {
            thirdStr = _nameString;
        }
    }
    NSDictionary * dic = @{@"msg_0":firstStr.length?firstStr:@"",
                           @"msg_1":secondStr.length?secondStr:@"",
                           @"msg_2":thirdStr.length?thirdStr:@""};
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData * data1 = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString * baseStr = [data1 base64EncodedStringWithOptions:0];
   
    
    return baseStr;
}
-(NSMutableArray*)timeOrder:(NSString*)time andArray:(NSMutableArray*)timeArray
{
    NSDate * date1 = [NSDate dateWithString:time format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timeInte1 = [date1 timeIntervalSince1970];

    for (int i = (int)timeArray.count-1 ; i >=0 ; i--) {
        NSString *timeStr = timeArray[i];
        NSDate * date = [NSDate dateWithString:timeStr format:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval timeInte = [date timeIntervalSince1970];
        if ( i == 0) {
            if (timeInte1 >= timeInte) {
                [timeArray insertObject:[time componentsSeparatedByString:@" "][0] atIndex:i+1];
            }
            else
            {
              [timeArray insertObject:[time componentsSeparatedByString:@" "][0] atIndex:0];
            }
        }
        else
        {
            if (timeInte1 >= timeInte) {
                [timeArray insertObject:[time componentsSeparatedByString:@" "][0] atIndex:i+1];
                break;
            }
        }
    }
    return timeArray;
}

-(NSString*)getDisPlayType:(MTTMessageEntity*)message
{
    NSString * display_type = [NSString string];
    switch (message.msgContentType) {
        case DDMessageTypeText:
            display_type = @"1";
            break;
        case DDMessageTypeImage:
            display_type = @"2";
            break;
        case DDMessageTypeVoice:
            display_type = @"3";
            break;
        case DDMEssageEmotion:
            display_type = @"1";
            break;
        case DDMEssagePersonalaCard:
            display_type = @"6";
            break;
        case DDMEssageMyApply:
            display_type = @"8";
            break;
        case DDMEssageMyWant:
            display_type = @"9";
            break;
        case DDMEssageMuchMyWantAndApply:
            display_type = @"10";
            break;
        case DDMEssageSHuoShuo:
            display_type = @"11";
            break;
        case DDMEssageLitterVideo:
            display_type = @"7";
            break;
        case DDMEssageLitterInviteAndApply:
            display_type = @"12";
            break;
        case DDMEssageLitteralbume:
            display_type = @"13";
            break;
        case DDMEssageAcceptApply:
            display_type = @"14";
            break;//DDMEssageMuchCollection
        case DDMEssageMuchCollection:
            display_type = @"15";
            break;
        default:
            break;
    }
    
    
    return display_type;
}
-(void)collectionFromChat:(NSIndexPath*)indexpath and:(NSString*)typeID
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary * dictionary = @{@"action":@"addcoll",
                                  @"username":model.username,
                                  @"password":model.password,
                                  @"user_id":self.user_id,//model.userId
                                  @"typeid":typeID.length?typeID:[self.dataSource[indexpath.row] type_id],
                                  @"class":@"20",//
                                  @"kuozhan_flag":self.collectionFlag,
                                  @"kuozhan_id":self.collectionId,
                                  @"kuozhan_url":self.collectionUrl,
                                  @"kuozhan_type":@"",
                                  @"col4":self.col4.length?self.col4:@"",
                                  @"my_user_id":kShareModel.userId};
    
    [[CollectionManager sharedManager]requestToaddCollectionWithParams:dictionary success:^(id json) {
        if ([json[@"status"] integerValue] == 1) {
            if (self.collectSuccessBlock) {
                self.collectSuccessBlock();
            }
            [MBProgressHUD showHudTipStr:json[@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showHudTipStr:json[@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)collectWithIndexPath:(NSIndexPath *)index and:(NSString*)typeID
{
    
    WPShareModel *model = [WPShareModel sharedModel];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"addcoll";
    params[@"my_user_id"] = kShareModel.userId;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"typeid"] =typeID.length?typeID:[self.dataSource[index.row] type_id];
    params[@"class"] = self.collect_class;
    
    if (self.titles != nil) {
        self.titleArray = self.titles;
    }else{
        self.titles = self.titleArray;
    }
    
    if ([self.collect_class isEqualToString:@"0"]) { //文字
        params[@"content"] = self.content;
        params[@"user_id"] = self.user_id;
    } else if ([self.collect_class isEqualToString:@"1"]) { //图片
        params[@"user_id"] = self.user_id;
        params[@"img_url"] = self.img_url;
    } else if ([self.collect_class isEqualToString:@"2"]) { //视频
        params[@"user_id"] = self.user_id;
        params[@"img_url"] = self.img_url;
        params[@"vd_url"] = self.vd_url;
    } else if ([self.collect_class isEqualToString:@"3"]) { //音频
        
    } else if ([self.collect_class isEqualToString:@"4"]) { //动态
        
        if (self.isComeDetail) { //来自详情界面的收藏
            params[@"user_id"] = self.user_id;
            NSString *shareType = [NSString stringWithFormat:@"%@",self.dynamicInfo[@"share"]];
//            NSArray *images = self.dynamicInfo[@"small_photos"];
             NSMutableArray *image_urls = [NSMutableArray array];
            if ([shareType isEqualToString:@"2"]||[shareType isEqualToString:@"3"])//求职的说说
            {
                
                if ([shareType isEqualToString:@"2"]) {
                    params[@"company"] = [NSString stringWithFormat:@"%@ %@ %@ %@",self.dynamicInfo[@"shareMsg"][@"name"],self.dynamicInfo[@"shareMsg"][@"sex"],self.dynamicInfo[@"shareMsg"][@"education"],self.dynamicInfo[@"shareMsg"][@"WorkTime"]];
                }
                else
                {
                    params[@"company"] = self.dynamicInfo[@"shareMsg"][@"name"];
                }
                
                
                 params[@"share"] = shareType;
                NSDictionary * shareMsg = self.dynamicInfo[@"shareMsg"];
                NSArray * jobPhoto = shareMsg[@"jobPhoto"];
                for (NSDictionary * dic in jobPhoto) {
                    NSString *small_address = dic[@"small_address"];
                    [image_urls addObject:small_address];
                }
            }
            else if ([shareType isEqualToString:@"0"])//正常发送的说说
            {
              NSArray *images = self.dynamicInfo[@"small_photos"];
                for (NSDictionary * dic in images) {
                    NSString *small_address = dic[@"small_address"];
                    [image_urls addObject:small_address];
                }
            }
            else
            {
                params[@"share"] = shareType;
                NSDictionary * shareMsg = self.dynamicInfo[@"shareMsg"];
                NSArray * array = shareMsg[@"small_photos"];
                for (NSDictionary * dic in array) {
                    NSString *small_address = dic[@"small_address"];
                    [image_urls addObject:small_address];
                }
            }

            params[@"user_id"] = self.dynamicInfo[@"user_id"];
            
            if ([shareType isEqualToString:@"1"])
            {
                NSString * contentStr = [NSString stringWithFormat:@"%@",self.dynamicInfo[@"speak_comment_content"]];//[@"shareMsg"]
                NSString * string = [WPMySecurities textFromBase64String:contentStr];
                NSString * string1 = [WPMySecurities textFromEmojiString:string];
                params[@"content"] = [NSString stringWithFormat:@"%@:%@",self.dynamicInfo[@"speak_comment_state"],string1];
                params[@"img_url"] = [NSString stringWithFormat:@"%@",self.dynamicInfo[@"shareMsg"][@"avatar"]];
            }
            else
            {
                
                NSString * contentString = self.dynamicInfo[@"speak_comment_content"];
                contentString = [WPMySecurities textFromBase64String:contentString];
                contentString = [WPMySecurities textFromEmojiString:contentString];
                
                
                params[@"content"] =[NSString stringWithFormat:@"%@:%@",self.dynamicInfo[@"speak_comment_state"],contentString.length?contentString:self.dynamicInfo[@"speak_comment_content"]];//self.dynamicInfo[@"speak_comment_content"]
                params[@"img_url"] = [image_urls componentsJoinedByString:@","];
            }
            
            
            params[@"jobid"] = self.dynamicInfo[@"sid"];
            params[@"share_id"] = self.dynamicInfo[@"jobids"];
            if ([shareType isEqualToString:@"0"]) {
                params[@"share_content"] = @"";
                params[@"share_img"] = @"";
            } else {
                NSDictionary *shareMsg = self.dynamicInfo[@"shareMsg"];
                NSArray *share_imgs = shareMsg[@"small_photos"];
                NSMutableArray *image_share = [NSMutableArray array];
                for (NSDictionary *dict in share_imgs) {
                    NSString *small_address = dict[@"small_address"];
                    [image_share addObject:small_address];
                }
                params[@"share_img"] = [image_share componentsJoinedByString:@","];
                if ([shareType isEqualToString:@"1"]) {
                    params[@"share_content"] = shareMsg[@"speak_comment_content"];
                } else {
                    params[@"share_content"] = shareMsg[@"share_title"];
                }
            }
            
            //判断是否时是视频
            NSArray * original_photos = self.dynamicInfo[@"original_photos"];
            if (original_photos.count)
            {
                NSString * media_address = [NSString stringWithFormat:@"%@",original_photos[0][@"media_address"]];
                if ([media_address hasSuffix:@".mp4"])
                {
                    params[@"vd_url"] = media_address;
                }
            }
            
        } else { // 来自其他界面的收藏
            params[@"user_id"] = self.user_id;
            params[@"content"] = self.content;
            params[@"img_url"] = self.img_url;
            params[@"jobid"] = self.jobid;
            params[@"share_id"] = @"";
            params[@"share_img"] = @"";
            params[@"share_content"] = @"";
            params[@"share"] = self.shareStr;
        }
        
    } else if ([self.collect_class isEqualToString:@"5"]) { //招聘
//        NSLog(@"招聘");
        
        if (self.zhaoPinDic.count) {
            NSString * despri = nil;
//            despri = [WPMySecurities textFromBase64String:despri];
//            despri = [WPMySecurities textFromEmojiString:despri];
            NSArray * array = self.zhaoPinDic[@"epRemarkList"];
            if (array.count) {
                despri = array[0][@"txtcontent"];
//                despri = [WPMySecurities textFromBase64String:despri];
//                despri = [WPMySecurities textFromEmojiString:despri];
            }
            else
            {
             despri = @"";
            }
            
            
//            NSString * string = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@",self.zhaoPinDic[@"enterprise_name"],self.zhaoPinDic[@"dataIndustry"],self.zhaoPinDic[@"enterprise_properties"],self.zhaoPinDic[@"enterprise_scale"],self.zhaoPinDic[@"enterprise_address"],self.zhaoPinDic[@"enterprise_brief"],despri.length?despri:@""];
            
            
            NSString * string = [WPMySecurities textFromBase64String:despri];
            string = [WPMySecurities textFromEmojiString:string];
            string.length?(despri = string):0;
            params[@"col2"] = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@",self.zhaoPinDic[@"enterprise_name"],self.zhaoPinDic[@"dataIndustry"],self.zhaoPinDic[@"enterprise_properties"],self.zhaoPinDic[@"enterprise_scale"],self.zhaoPinDic[@"enterprise_address"],self.zhaoPinDic[@"enterprise_brief"],despri.length?despri:@""];
        }
        
        params[@"user_id"] = self.user_id;
        params[@"jobid"] = self.jobid;
        params[@"title"] = self.titles;
        params[@"img_url"] = self.img_url;
        params[@"company"] = self.companys;
        params[@"isHeBing"] = self.isHeBing.length?self.isHeBing:@"";
    } else if ([self.collect_class isEqualToString:@"6"]) { //求职
        
        if (self.zhaoPinDic.count) {
            NSString * despri = self.zhaoPinDic[@"txtcontent"];
            despri = [WPMySecurities textFromBase64String:despri];
            despri = [WPMySecurities textFromEmojiString:despri];
            
            params[@"col2"] = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[self.zhaoPinDic[@"name"] length]?self.zhaoPinDic[@"name"]:@"",[self.zhaoPinDic[@"age"] length]?self.zhaoPinDic[@"age"]:@"",[self.zhaoPinDic[@"sex"] length]?self.zhaoPinDic[@"sex"]:@"",[self.zhaoPinDic[@"education"] length]?self.zhaoPinDic[@"education"]:@"",[self.zhaoPinDic[@"WorkTime"] length]?self.zhaoPinDic[@"WorkTime"]:@"",despri.length?despri:@""];
        }
        
        params[@"user_id"] = self.user_id;
        params[@"jobid"] = self.jobid;
        params[@"title"] = self.titles;
        params[@"img_url"] = self.img_url;
        params[@"company"] = self.companys;
        params[@"isHeBing"] = self.isHeBing.length?self.isHeBing:@"";
    } else if ([self.collect_class isEqualToString:@"7"]) { //URL链接
        if ([self.shareStr isEqualToString:@"2"])
        {
            NSString * contentStr = _zhaoPinDic[@"txtcontent"];
            NSString * string = [WPMySecurities textFromBase64String:contentStr];
            NSString * string1 = [WPMySecurities textFromEmojiString:string];
            if (string1.length) {
                contentStr = string1;
            }
            
          params[@"col2"] = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",[self.zhaoPinDic[@"name"] length]?self.zhaoPinDic[@"name"]:@"",[self.zhaoPinDic[@"age"] length]?self.zhaoPinDic[@"age"]:@"",[self.zhaoPinDic[@"sex"] length]?self.zhaoPinDic[@"sex"]:@"",[self.zhaoPinDic[@"education"] length]?self.zhaoPinDic[@"education"]:@"",[self.zhaoPinDic[@"WorkTime"] length]?self.zhaoPinDic[@"WorkTime"]:@"",contentStr];
        }
        else if ([self.shareStr isEqualToString:@"3"])
        {
            NSString * contentStr = _zhaoPinDic[@"enterprise_brief"];
            NSString * string = [WPMySecurities textFromBase64String:contentStr];
            NSString * string1 = [WPMySecurities textFromEmojiString:string];
            if (string1.length) {
                contentStr = string1;
            }
            
           params[@"col2"] = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.zhaoPinDic[@"enterprise_name"],self.zhaoPinDic[@"dataIndustry"],self.zhaoPinDic[@"enterprise_properties"],self.zhaoPinDic[@"enterprise_scale"],self.zhaoPinDic[@"enterprise_address"],contentStr];
        }
        params[@"user_id"] = self.user_id;
        params[@"url"] = self.url;
        params[@"img_url"] = self.img_url;
        params[@"company"] = self.companys;
        params[@"share_content"] = self.content;
        params[@"jobid"] = self.jobid;
        params[@"share"] = self.shareStr;
        params[@"title"] = self.titleArray;
    } else if ([self.collect_class isEqualToString:@"8"]) { //名片
        params[@"user_id"] = self.user_id;
        params[@"title"] = self.titles;
        params[@"address"] = self.wpNumber;
        
    } else if ([self.collect_class isEqualToString:@"9"]) {//群相册
        params[@"user_id"] = self.user_id;
        params[@"content"] = self.content;
        params[@"img_url"] = self.img_url;
        params[@"jobid"] = self.jobid;
    }
    
    //匿名吐槽时需要传
    if (self.col3.length) {
        params[@"col3"] = self.col3;
    }
    if (self.col4.length) {
        params[@"col4"] = self.col4;
    }
    
    [[CollectionManager sharedManager]requestToaddCollectionWithParams:params success:^(id json) {
        NSLog(@"%@---%@",json,json[@"info"]);
        if ([json[@"status"] integerValue] == 1) {
            if (self.collectSuccessBlock) {
                self.collectSuccessBlock();
            }
        }
        [MBProgressHUD showHudTipStr:json[@"info"]];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)delegateAction
{
    if (self.controller) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(isAlready)]) {
            [self.delegate isAlready];
        }
    }
}

- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
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
