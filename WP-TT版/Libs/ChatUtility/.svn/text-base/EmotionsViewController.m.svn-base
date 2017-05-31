//
//  DDEmotionsViewController.m
//  Emoji
//
//  Created by YiLiFILM on 14/12/13.
//  Copyright (c) 2014年 YiLiFILM. All rights reserved.
//

#import "EmotionsViewController.h"
#import "EmotionsModule.h"
#import "YYEmotionModule.h"
#import "ChattingMainViewController.h"

@interface EmotionsViewController ()

- (void)clickTheSendButton:(id)sender;

@property (nonatomic,copy) NSString *normalOrYY; //1 normal


@property (nonatomic,strong) UIButton *releaseButton;
@property (nonatomic,strong) UIView *menuView;
@property (nonatomic,strong) UIButton *settingButton;

@property (nonatomic,strong) UIButton *normalButton;
@property (nonatomic,strong) UIButton *yyButton;


@end
//#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define  keyboardHeight 216
#define  facialViewWidth SCREEN_WIDTH-20
//#define facialViewHeight (42/320.0*SCREEN_WIDTH*3)
#define facialViewHeight (((SCREEN_WIDTH-20)/7)*3)
@implementation EmotionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshReleaseButton) name:@"refreshReleaseButton" object:nil];
//    refreshReleaseBtnWhenDelete
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshReleaseBtnWhenDelete) name:@"refreshReleaseBtnWhenDelete" object:nil];
    
    self.view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, WPKeyboardHeight);
    if (self.scrollView==nil) {
        self.scrollView=[[UIScrollView alloc] initWithFrame:self.view.frame];
        [self.scrollView setBackgroundColor:RGB(247, 247, 247)];
        [self showEmojiView];
    }
    
    
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*3, WPKeyboardHeight);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    [self.view addSubview:self.scrollView];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(178, 178, 178);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.right.top.equalTo(self.view);
//        make.top.equalTo(self.view.mas_top).offset(1);
    }];
    
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2+10)/2, (WPKeyboardHeight -30 - kHEIGHT(32) - facialViewHeight - 5)/2 + facialViewHeight + 5-6, (SCREEN_WIDTH - 20)/2, 30)];
//    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2+10)/2, WPKeyboardHeight -30 - kHEIGHT(32) , (SCREEN_WIDTH - 20)/2, 30)];
    [self.pageControl setCurrentPage:0];
    self.pageControl.pageIndicatorTintColor=RGB(178, 178, 178);
    self.pageControl.currentPageIndicatorTintColor= RGB(127, 127, 127);
    self.pageControl.numberOfPages = 3;
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
//    self.pageControl.backgroundColor = [UIColor yellowColor];
    [self.pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
    
    UIView* menuView = [[UIView alloc] initWithFrame:CGRectMake(0, WPKeyboardHeight - kHEIGHT(32), SCREEN_WIDTH, kHEIGHT(32))];
    [menuView setBackgroundColor:[UIColor whiteColor]];
    self.menuView = menuView;

    
    //2016 chenchao
#pragma mark 加号按钮
//    UIButton* plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [plusButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH/8, kHEIGHT(32))];
//    [plusButton setImage:[UIImage imageNamed:@"common_tianjiabiaoqing"] forState:UIControlStateNormal];
//    [plusButton addTarget:self action:@selector(showMoreEmotion) forControlEvents:UIControlEventTouchUpInside];
//    [menuView addSubview:plusButton];
    
//    UIView *line1 = [[UIView alloc] init];
//    line1.backgroundColor = RGB(226, 226, 226);
//    [self.menuView addSubview:line1];
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(plusButton.mas_right);
//        make.top.bottom.equalTo(self.menuView);
//        make.width.equalTo(@1);
//    }];

#pragma mark 表情按钮
    UIButton* normalEmotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [normalEmotionButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH/8, kHEIGHT(32))];//(plusButton.right, 0, SCREEN_WIDTH/8, kHEIGHT(32))
    [normalEmotionButton setImage:[UIImage imageNamed:@"common_morenbiaoqing"] forState:UIControlStateNormal];
    self.normalButton = normalEmotionButton;
    self.normalButton.selected = YES;
    [normalEmotionButton setBackgroundImage:[UIImage creatUIImageWithColor:RGB(247, 247, 247)] forState:UIControlStateSelected];
    [normalEmotionButton addTarget:self action:@selector(showNormalEmotion) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:normalEmotionButton];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = RGB(226, 226, 226);
    [self.menuView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(normalEmotionButton.mas_right);
        make.top.bottom.equalTo(self.menuView);
        make.width.equalTo(@1);
    }];
    
    //YY表情,已屏蔽,暂时不适用
//    UIButton* yyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.yyButton = yyButton;
//    [yyButton setFrame:CGRectMake(normalEmotionButton.right, 0, SCREEN_WIDTH/8, kHEIGHT(32))];
//    [yyButton setImage:[UIImage imageNamed:@"common_morenbiaoqing"] forState:UIControlStateNormal];
//    [yyButton addTarget:self action:@selector(showYYEmotion) forControlEvents:UIControlEventTouchUpInside];
//    [yyButton setBackgroundImage:[UIImage imageWithColor:RGB(247, 247, 247)] forState:UIControlStateSelected];
//    [menuView addSubview:yyButton];
//    
//    UIView *line3 = [[UIView alloc] init];
//    line3.backgroundColor = RGB(226, 226, 226);
//    [self.menuView addSubview:line3];
//    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(yyButton.mas_right);
//        make.top.bottom.equalTo(self.menuView);
//        make.width.equalTo(@1);
//    }];
#pragma mark  收藏按钮
//    UIButton* collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [collectButton setFrame:CGRectMake(normalEmotionButton.right, 0, SCREEN_WIDTH/8, kHEIGHT(32))];
//    [collectButton setImage:[UIImage imageNamed:@"tb_shoucangdetubiao"] forState:UIControlStateNormal];
//    [collectButton addTarget:self action:@selector(showCollectEmotion) forControlEvents:UIControlEventTouchUpInside];
////    [menuView addSubview:collectButton];
//    
//    UIView *line4 = [[UIView alloc] init];
//    line4.backgroundColor = RGB(226, 226, 226);
//    [self.menuView addSubview:line4];
//    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(collectButton.mas_right);
//        make.top.bottom.equalTo(self.menuView);
//        make.width.equalTo(@1);
//    }];
    
    
    //发布按钮  
    UIButton* releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [releaseButton setTitle:@"发送" forState:UIControlStateNormal];
    releaseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [releaseButton setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    [releaseButton.titleLabel setFont:kFONT(14)];
    [releaseButton addTarget:self action:@selector(releaseClick) forControlEvents:UIControlEventTouchUpInside];
    releaseButton.userInteractionEnabled = NO;
    self.releaseButton =releaseButton;
    [menuView addSubview:releaseButton];
    [releaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(menuView);
        make.top.bottom.equalTo(self.menuView);
        make.width.equalTo(@(SCREEN_WIDTH/8));
    }];
    
    
    UIView *line5 = [[UIView alloc] init];
    line5.backgroundColor = RGB(226, 226, 226);
    [self.menuView addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(releaseButton.mas_left);
        make.top.bottom.equalTo(self.menuView);
        make.width.equalTo(@1);
    }];
    [self.view addSubview:menuView];
}

//2016  chenchap 点击表情框底下的发送
-(void)releaseClick{
    if (self.delegate)
    {
        [self.delegate emotionViewClickSendButton];
    }
}


//通知回调方法
-(void)refreshReleaseButton{
    [self.releaseButton setBackgroundColor:RGB(0, 172, 255)];
    [self.releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.releaseButton.userInteractionEnabled = YES;
}

-(void)refreshReleaseBtnWhenDelete{
    [self.releaseButton setBackgroundColor:[UIColor clearColor]];
    [self.releaseButton setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    self.releaseButton.userInteractionEnabled = NO;
}

//移除监听
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)showEmojiView{
    [self.scrollView removeAllSubviews];
    if (![self.normalOrYY isEqualToString:@"0"]) {
        self.releaseButton.hidden = NO;
        self.settingButton.hidden = YES;
        for (int i=0; i<3; i++) {
            EmojiFaceView *fview=[[EmojiFaceView alloc] initWithFrame:CGRectMake(10+SCREEN_WIDTH*i, 5, facialViewWidth, facialViewHeight)];
            [fview setBackgroundColor:[UIColor clearColor]];
//            fview.backgroundColor = [UIColor cyanColor];
            [fview loadFacialView:i size:CGSizeMake((SCREEN_WIDTH-20)/7, (SCREEN_WIDTH-20)/7)];
            fview.delegate=self;
            [self.scrollView addSubview:fview];
        }

    }else{
        //这里表情键盘不显示发送按钮 显示设置按钮
        self.releaseButton.hidden = YES;
        UIButton* settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingButton setImage:[UIImage imageNamed:@"common_guanlibiaoqing"] forState:UIControlStateNormal];
        [settingButton addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:settingButton];
        self.settingButton = settingButton;
        [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.menuView);
            make.top.bottom.equalTo(self.menuView);
            make.width.equalTo(@(SCREEN_WIDTH/8));
        }];
        
        for (int i=0; i<3; i++) {
            [self p_loadFacialViewWithRow:i CGSize:CGSizeMake((FULL_WIDTH - 10)/4, 70)];
        }

    }
}


#pragma mark - yy表情
- (void)p_loadFacialViewWithRow:(NSUInteger)page CGSize:(CGSize)size
{
    NSArray* emotions = [NSArray arrayWithArray:[YYEmotionModule shareInstance].emotionUnicodeDic.allKeys];
    UIView* yayaview=[[UIView alloc] initWithFrame:CGRectMake(12+FULL_WIDTH*page, 5, FULL_WIDTH-30, facialViewHeight)];
    [yayaview setBackgroundColor:[UIColor clearColor]];
    
    for (int i=0; i< 2; i++) {
        for (int y=0; y< 4; y++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*size.width, i*size.height, size.width, size.height)];
        
            if ((i * 4 + y + page * 8) >= [emotions count]) {
                break ;
            }else{
                button.tag=i*4+y+(page*8);
                NSString *emotionStr = [[YYEmotionModule shareInstance].emotionUnicodeDic objectForKey:emotions[i*4 + y + page*8]];
                UIImage* emotionImage = [UIImage imageNamed:emotionStr];
//                [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(247, 247, 247)] forState:UIControlStateNormal];
                [button setImage:emotionImage forState:UIControlStateNormal];
                //button 按钮图片不被拉伸
                button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [button addTarget:self action:@selector(p_selected:) forControlEvents:UIControlEventTouchUpInside];
                [yayaview addSubview:button];
            }
        }
    }
    [self.scrollView addSubview:yayaview];
}

-(void)p_selected:(UIButton*)button
{
    NSArray* emotions = [YYEmotionModule shareInstance].emotions;
    NSString *str=[emotions objectAtIndex:button.tag];
    [self selectedYYView:str];
}


-(void)showNormalEmotion{
//    self.normalButton.selected = !self.normalButton.selected;
    self.yyButton.selected = !self.normalButton.selected;
    self.normalOrYY = @"1";
    [self showEmojiView];
}

// 20160614 显示YY表情键盘
-(void)showYYEmotion{
    self.yyButton.selected = !self.yyButton.selected;
    self.normalButton.selected = !self.yyButton.selected;
    self.normalOrYY = @"0";
    [self showEmojiView];
}

-(void)showMoreEmotion{
    //展示更多表情
}

-(void)showCollectEmotion{
    //展示收藏的表情
}

//2016 显示设置页面
-(void)showSettingView{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    self.pageControl.currentPage = page;
}

- (IBAction)changePage:(id)sender {
    NSInteger page = self.pageControl.currentPage;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0)];
}


//2016 chenchao 添加emoji表情
-(void)selectedFacialView:(NSString*)str
{
    if ([str isEqualToString:@"delete"]) {
        [[ChattingMainViewController shareInstance] deleteEmojiFace];
        return;
    }
    [[ChattingMainViewController shareInstance] insertEmojiFace:str];
}

-(void)selectedYYView:(NSString*)str
{
    if ([str isEqualToString:@"delete"]) {
        [[ChattingMainViewController shareInstance] deleteEmojiFace];
        return;
    }
    [[ChattingMainViewController shareInstance] insertYYFace:str];
}

#pragma mark - privateAPI
//- (void)clickTheSendButton:(id)sender
//{
//    if (self.delegate)
//    {
//        [self.delegate emotionViewClickSendButton];
//    }
//}
@end
