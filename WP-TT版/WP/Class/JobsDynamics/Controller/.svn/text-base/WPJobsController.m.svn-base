//
//  WPJobsController.m
//  WP
//
//  Created by Asuna on 15/6/4.
//  Copyright (c) 2015年 WP. All rights reserved.
//  工作圈第一版

#import "WPJobsController.h"
#import "UIImageView+WebCache.h"
#import "WPStatus.h"
#import "WPStatusFrame.h"
#import "MJExtension.h"
#import "WPStatusCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"

#import "WPStatusParam.h"
#import "WPStatusResult.h"
#import "WPStatusTool.h"

#import "WPDetailControllerThree.h"
#import "CHTumblrMenuView.h"
#import "WPWriteController.h"
//#import "XHAlbumOperationView.h"
#import "WPPhoto.h"
#import "MBProgressHUD+MJ.h"

#import "WPStatusView.h"
#import "commentView.h"

#import "YcKeyBoardView.h"

@interface WPJobsController ()<WPStatusViewDelegate,commentViewDelegate,YcKeyBoardViewDelegate>
@property (nonatomic, strong) NSMutableArray *statusFrames;
@property (nonatomic,strong)YcKeyBoardView *key;
//@property (nonatomic, weak) MJRefreshFooterView *footer;
//@property (nonatomic, weak) MJRefreshHeaderView *header;
@property (nonatomic,assign) CGFloat keyBoardHeight;
@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) CGFloat angle;
@property (nonatomic,assign) int gTag;

@property (nonatomic,strong) NSTimer* updateTimer;
//@property (nonatomic, weak) NSMutableArray *indexPathArray;


@end

@implementation WPJobsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
    [self.tableView addSubview:self.imageView ];
    [self setupRefreshView];
}



//定义navbar的样式
-(void)setNavBar
{
    self.title = @"职场动态";
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"discover2.jpg"]];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    self.tableView.tableHeaderView = imageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"smll_camera"] style:UIBarButtonItemStyleDone target:self action:@selector(buttonMenu)];
    self.tableView.backgroundColor = WPColor(226, 226, 226);
   // self.tableView.contentInset = UIEdgeInsetsMake(0, 0, WPStatusTableBorder, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 *  集成刷新控件
 */
- (void)setupRefreshView
{

//    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//    header.scrollView = self.tableView;
//    header.delegate = self;
//
//    [header beginRefreshing];
//    self.header = header;
//    
//    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//    footer.scrollView = self.tableView;
//    footer.delegate = self;
//    self.footer = footer;
}
//释放刷新控件
//- (void)dealloc
//{
//    [self.header free];
//    [self.footer free];
//}
//
//
//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    [self.updateTimer setFireDate:[NSDate date]];
//    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
//        [self loadMoreData];
//    } else {
//        
//        [self loadNewData];
//    } 
//}

-(void)loadMoreData
{
    
}

//发送请求，加载新的数据
-(void)loadNewData
{
    
    WPStatusParam *param = [[WPStatusParam alloc]init];
    param.action = @"getSpeakionList";
    
    [WPStatusTool jobsStatusesWithParam:param success:^(WPStatusResult *result) {
        //创建frame模型对象
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (WPStatus *status in result.list) {
            WPStatusFrame *statusFrame = [[WPStatusFrame alloc]init];
            statusFrame.status = status;
            [statusFrameArray addObject:statusFrame];
        }
    
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObjectsFromArray:statusFrameArray];
        [tempArray addObjectsFromArray:self.statusFrames];
        self.statusFrames = tempArray;
        
        [self.tableView reloadData];
//        [self.header endRefreshing];
        [self.updateTimer setFireDate:[NSDate distantFuture]];
        //显示消息更新数据
        [self showNewStatusCount:(int)statusFrameArray.count];
    } failure:^(NSError *error) {
        [self.updateTimer setFireDate:[NSDate distantFuture]];
//        [self.header endRefreshing];
    }];
}

//显示更新的数据数量
- (void)showNewStatusCount:(int)count
{
    // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    
    // 2.设置图片和文字
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:[UIImage resizedImageWithName:@"timeline_new_status_background"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    if (count) {
        NSString *title = [NSString stringWithFormat:@"共有%d条新的信息", count];
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"没有新的信息" forState:UIControlStateNormal];
    }
    
    // 3.设置按钮的初始frame
    CGFloat btnH = 30;
    CGFloat btnY = 64 - btnH;
    CGFloat btnX = 2;
    CGFloat btnW = self.view.frame.size.width - 2 * btnX;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    [UIView animateWithDuration:0.7 animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, btnH + 2);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {

            [btn removeFromSuperview];
        }];
        
    }];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.statusFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WPStatusCell *cell = [WPStatusCell cellWithTableView:tableView];
    cell.statusFrame = self.statusFrames[indexPath.row];

    cell.topView.delegate = self;
    cell.topView.rubbishbutton.tag = indexPath.row;
    
    cell.topView.theCommentView.delegate = self;
    cell.topView.theCommentView.buttonGood.tag = indexPath.row;
    cell.topView.theCommentView.buttonComment.tag = indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPDetailControllerThree *vc = [[WPDetailControllerThree alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (NSMutableArray *)statusFrames
{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)buttonMenu
{
    CHTumblrMenuView* menuView = [[CHTumblrMenuView alloc] init];
    [menuView addMenuItemWithTitle:@"写写"
                           andIcon:[UIImage imageNamed:@"menu_write"]
                  andSelectedBlock:^{
                      WPWriteController* writeController = [[WPWriteController alloc] init];
                      [self.navigationController pushViewController:writeController animated:YES];
                  }];
    [menuView addMenuItemWithTitle:@"晒晒"
                           andIcon:[UIImage imageNamed:@"menu_picture"]
                  andSelectedBlock:^{
                      NSLog(@"Photo menu_picture");
                  }];
    [menuView addMenuItemWithTitle:@"拍照"
                           andIcon:[UIImage imageNamed:@"menu_photo"]
                  andSelectedBlock:^{
                      NSLog(@"Quote menu_photo");
                      
                  }];
    [menuView addMenuItemWithTitle:@"视频"
                           andIcon:[UIImage imageNamed:@"menu_vedio"]
                  andSelectedBlock:^{
                      NSLog(@"Link menu_vedio");
                      
                  }];
    [menuView addMenuItemWithTitle:@"模板"
                           andIcon:[UIImage imageNamed:@"menu_template"]
                  andSelectedBlock:^{
                      NSLog(@"Chat menu_template");
                      
                  }];
    [menuView addMenuItemWithTitle:@"更多"
                           andIcon:[UIImage imageNamed:@"menu_more"]
                  andSelectedBlock:^{
                      NSLog(@"Video menu_more");
                      
                  }];
    
    [menuView show];
}


//删除数据
- (void)deleteDataCell:(int)tag
{
    WPStatusFrame *statusFrame = [[WPStatusFrame alloc]init];
    statusFrame = self.statusFrames[tag];
    
    WPStatus *status = [[WPStatus alloc]init];
    status = statusFrame.status;
    
    NSMutableString *strPhoto = nil;
    //根据图片的数量来拼接地址
    if (status.original_photos.count > 1) {
        for (WPPhoto* photos in status.original_photos) {
            [strPhoto stringByAppendingString:[NSString stringWithFormat:@"%@|",photos.media_address]];
        }
        
        [strPhoto substringToIndex:(strPhoto.length -1)];
    } else
    {
        WPPhoto* photoes = [status.original_photos lastObject];
        strPhoto = [NSMutableString stringWithString:photoes.media_address];
    }
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"deleteDynamic";
    
    params[@"id"] = [NSString stringWithFormat:@"%d",statusFrame.status.sid];
    //判断是否有图片
    if (strPhoto != nil) {
        params[@"img_address"] = strPhoto;
    }
    
    NSString *strPath = [IPADDRESS stringByAppendingString:@"/tools/speak_manage.ashx"];
    [mgr POST:strPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];

    [self.statusFrames removeObjectAtIndex:tag];
    [self.tableView reloadData];
}

//评论
- (void)comment:(int)tag
{
    
    self.gTag = tag;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    if(self.key==nil){
        self.key=[[YcKeyBoardView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40)];
    }
    self.key.delegate=self;
    [self.key.textView becomeFirstResponder];
    self.key.textView.returnKeyType=UIReturnKeySend;
    [[self.view superview] addSubview:self.key];

//    [self.tableView reloadData];
    
}
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    self.keyBoardHeight=deltaY;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.key.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.key.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        self.key.textView.text=@"";
        [self.key removeFromSuperview];
    }];
    
}
-(void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    
    WPStatusFrame *statusFrame = [[WPStatusFrame alloc]init];
    statusFrame = self.statusFrames[self.gTag];
    
    WPStatus *status = [[WPStatus alloc]init];
    status = statusFrame.status;
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *strPath = [IPADDRESS stringByAppendingString:@"/tools/speak_manage.ashx"];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"action"]    = @"replySpeak";
    param[@"speak_id"]  = [NSString stringWithFormat:@"%d",status.sid];
    param[@"user_id"]   = [NSString stringWithFormat:@"%d",status.user_id];//@"33";
    param[@"nick_name"] = @"刘备";//status.nick_name;
    
    param[@"by_nick_name"] = @"关羽";
    param[@"speak_comment_content"] = contentView.text;
    NSLog(@"%@",contentView.text);
    param[@"speak_reply"] = @"0";
    
    [mgr POST:strPath parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", [responseObject valueForKey:@"info"]);
        [MBProgressHUD showSuccess:@"评论成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"评论失败"];
    }];
    
    [contentView resignFirstResponder];
    
}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self.key.textView resignFirstResponder];
}
//点赞
- (void)good:(int)tag
{
    WPStatusFrame *statusFrame = [[WPStatusFrame alloc]init];
    statusFrame = self.statusFrames[tag];
    
    WPStatus *status = [[WPStatus alloc]init];
    status = statusFrame.status;
    
    //1.建立请求管理器
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //2.设置请求的URL路径
    NSString *strPath = [IPADDRESS stringByAppendingString:@"/tools/speak_manage.ashx"];
    //3.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"prisestate";
    params[@"user_id"] = @"33";
    params[@"speak_trends_id"] = [NSString stringWithFormat:@"%d",statusFrame.status.sid];
    //4.发送请求
    [mgr POST:strPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //5.请求成功
       // [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //6.请求失败
        //[MBProgressHUD showError:@"发送失败"];
    }];
    
   
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"prise";
    param[@"user_id"] = @"33";
    param[@"nick_name"] = statusFrame.status.nick_name;
    param[@"speak_trends_id"] = [NSString stringWithFormat:@"%d",statusFrame.status.sid];
    param[@"is_type"] = @"1";
    param[@"wp_speak_click_type"] = @"1";
    param[@"odd_domand_id"] = @"0";
    param[@"wp_speak_click_state"] = @"0";
    [mgr POST:strPath parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"info: %@", [responseObject valueForKeyPath:@"info"]);
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"userguide_moments_icon"]];
        
        CGFloat xPos = 20;
        CGFloat yPos = 30;
        CGFloat Width = 30;
        CGFloat height = 30;
        _imageView.frame = CGRectMake(xPos, yPos, Width, height);
        self.angle = 0.0;
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*0.38);
        _imageView.transform = transform;
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval: 0.00001 target: self selector:@selector(transformAction) userInfo: nil repeats: YES];
    }
    return _imageView;
}

-(void)transformAction {
    self.angle = self.angle + 0.03;//angle角度 double angle;
    if (self.angle > 6.28) {
        //大于 M_PI*2(360度) 角度再次从0开始
        self.angle = 0;
    }
    CGAffineTransform transform=CGAffineTransformMakeRotation(self.angle);
    self.imageView.transform = transform;
}

@end
