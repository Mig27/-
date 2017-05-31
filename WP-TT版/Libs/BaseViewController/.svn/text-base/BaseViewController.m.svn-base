//
//  BaseViewController.m
//  BoYue
//
//  Created by Spyer on 14/12/2.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "BaseViewController.h"
#import "WPRecruitApplyController.h"
@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

int prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
float prewMoveY; //编辑的时候移动的高度
int backTag;

//-(void)setEdgesForExtendedLayout:(UIRectEdge)edgesForExtendedLayout
//{
//   
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    //fixMe:添加属性
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    
    self.navigationController.navigationBar.tintColor = RGBColor(0, 0, 0);
    self.view.backgroundColor = RGB(235, 235, 235);
    
//    [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeTitle ItemName:self.title];
    
    // 添加返回按钮
    [self createBackButtonWithPushType:Push];
    
    
    
    
    
#pragma mark - c侧滑返回
    self.navigationController.interactivePopGestureRecognizer.delegate
    = (id<UIGestureRecognizerDelegate>)self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"dasdas");
}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#pragma mark - 设置主界面不能实现侧滑返回
//    if ([self isKindOfClass:[HeadViewController class]]||[self isKindOfClass:[GlanceViewController class]]||[self isKindOfClass:[CommunityViewController class]]||[self isKindOfClass:[HopeListViewController class]]||[self isKindOfClass:[PersonalViewController class]]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }else{
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//    if ([self isKindOfClass:[WPRecruitApplyController class]]) {
//        WPRecruitApplyController * recu = (WPRecruitApplyController*)self;
//        recu.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
    
//    NSArray * controllArr = self.navigationController.viewControllers;
//    NSMutableArray * muarray = [NSMutableArray array];
//    for (id objc in controllArr) {
//        if ([objc isKindOfClass:[WPRecruitApplyController class]]) {
//            [muarray removeObject:objc];
//        }
//    }
//    [self.navigationController setViewControllers:muarray];
    
}

-(void)layoutSubViews
{
    
}
#pragma mark-添加右按钮或者标题

-(void)createNavigationItemWithMNavigatioItem:(MNavigationItemType)itemType title:(NSString *)title
{
    if (itemType == MNavigationItemTypeTitle) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = DefaultControlColor;
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = GetFont(16);
        self.navigationItem.titleView = titleLabel;
    }
    if (itemType == MNavigationItemTypeRight) {
        
//        UIImage *image = [UIImage imageNamed:imageName];
        CGSize size = [title getSizeWithFont:FUCKFONT(14) Height:44];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, size.width, size.height);
        rightButton.titleLabel.font = kFONT(14);
        rightButton.tag = MNavigationItemTypeRight;
//        [rightButton setImage:image forState:UIControlStateNormal];
        [rightButton setTitle:title forState:UIControlStateNormal];
        [rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    }
}

#pragma mark - 添加返回按钮
-(void)createBackButtonWithPushType:(PushType)pushType
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    back.tag = pushType;
    backTag = pushType;
    [back addTarget:self action:@selector(backToFromViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark-Action
-(void)backToFromViewController:(UIButton *)sender
{
    if (sender.tag == Present) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (sender.tag == Push) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightButtonAction:(UIButton *)sender
{
//    mbuttonBlock (sender.tag);
    NSLog(@"点击完成");
}

//-(void)setButtonAction:(MButtonBlock)ablock
//{
//    mbuttonBlock = [ablock copy];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//支持自动旋转，固定为竖屏
-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFrame =  textField.frame;
    float textY = textFrame.origin.y+textFrame.size.height;
    float bottomY = self.view.frame.size.height-textY;
    if(bottomY>=252)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度,汉字键盘高度是252，这个根据输入的情况来定
    {
        prewTag = -1;
        return;
    }
    prewTag = (int) textField.tag;
    float moveY = 252-bottomY;
    prewMoveY = moveY;
    
    NSTimeInterval animationDuration = 0.50f;
    CGRect frame = self.view.frame;
    frame.origin.y -=moveY;//view的Y轴上移
    frame.size.height +=moveY; //View的高度增加
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}


-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if(prewTag == -1) //当编辑的View不是需要移动的View
    {
        return;
    }
    float moveY ;
    NSTimeInterval animationDuration = 0.50f;
    CGRect frame = self.view.frame;
    if(prewTag == textField.tag) //当结束编辑的View的TAG是上次的就移动
    {   //还原界面
        moveY =  prewMoveY;
        frame.origin.y +=moveY;
        frame.size. height -=moveY;
        self.view.frame = frame;
    }
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    CGRect textFrame =  textView.frame;
//    float textY = textFrame.origin.y+textFrame.size.height;
//    float bottomY = self.view.frame.size.height-textY;
//    if(bottomY>=300)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度,汉字键盘高度是252，这个根据输入的情况来定
//    {
//        prewTag = -1;
//        return;
//    }
//    prewTag = (int) textView.tag;
//    float moveY = 300-bottomY;
//    prewMoveY = moveY;
//    
//    NSTimeInterval animationDuration = 0.50f;
//    CGRect frame = self.view.frame;
//    frame.origin.y -=moveY;//view的Y轴上移
//    frame.size.height +=moveY; //View的高度增加
//    self.view.frame = frame;
//    [UIView beginAnimations:@"ResizeView" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    self.view.frame = frame;
//    [UIView commitAnimations];//设置调整界面的动画效果
//}
//
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if(prewTag == -1) //当编辑的View不是需要移动的View
//    {
//        return;
//    }
//    float moveY ;
//    NSTimeInterval animationDuration = 0.50f;
//    CGRect frame = self.view.frame;
//    if(prewTag == textView.tag) //当结束编辑的View的TAG是上次的就移动
//    {   //还原界面
//        moveY =  prewMoveY;
//        frame.origin.y +=moveY;
//        frame.size. height -=moveY;
//        self.view.frame = frame;
//    }
//    //self.view移回原位置
//    [UIView beginAnimations:@"ResizeView" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    self.view.frame = frame;
//    [UIView commitAnimations];
//    [textView resignFirstResponder];
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

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

@end
