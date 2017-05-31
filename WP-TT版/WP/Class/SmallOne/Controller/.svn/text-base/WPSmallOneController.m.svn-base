
#import "WPSmallOneController.h"
#import "WPSmallCell.h"
#import "CHTumblrMenuView.h"
#import "WPWriteController.h"
#import "WPDetailControllerThree.h"
@interface WPSmallOneController () <WPSmallCellDelegate>
@property (nonatomic, weak) UIView* keyboardView;
@property (nonatomic,weak) UITextField *textField;
@property (nonatomic,weak) UIButton *button;
@end

@implementation WPSmallOneController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"微动态";

    UIImage* image = [[UIImage imageNamed:@"smll_camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(buttonMenu)];

    self.tableView.rowHeight = [WPSmallCell rowHeight];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    self.navigationController.navigationBar.translucent = NO;
    //3.设置手势
    // UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    //tapGesture.cancelsTouchesInView = NO;
    //[self.view addGestureRecognizer:tapGesture];
    
    // 3.监听键盘的通知
    //[IWNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[IWNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}


- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    if (self.keyboardView != nil) {
        [self.keyboardView removeFromSuperview];
    }
    
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 200;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 1. 通过类方法快速实例化Cell
    WPSmallCell* cell = [WPSmallCell cellWithTableView:tableView];
    cell.delegate = self;
    // 2. 使用模型为单元格赋值
    //cell.messageModel = self.messageArray[indexPath.row];

    return cell;
}
- (void)clickKeyboard:(WPSmallCell*)smallCell
{
    UIView* keyboardTopView = [[UIView alloc] init];
    CGFloat toolbarH = 40;
    CGFloat toolbarW = self.view.frame.size.width;
    CGFloat toolbarX = 0;
    CGFloat toolbarY = self.view.frame.size.height - toolbarH-188;
    keyboardTopView.frame = CGRectMake(toolbarX, toolbarY,toolbarW, toolbarH);
    keyboardTopView.backgroundColor = WPColor(235, 235, 235);

    UIButton* btnspeak = [[UIButton alloc] init];
    btnspeak.frame = CGRectMake(0, 0, 40, 40);
    [btnspeak setImage:[UIImage imageNamed:@"keyboard_keyboard"] forState:UIControlStateNormal];
    [btnspeak addTarget:self action:@selector(btnWrite:) forControlEvents:UIControlEventTouchDown];
    btnspeak.tag = 0;
    [keyboardTopView addSubview:btnspeak];

    UITextField* textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(40, 6, 200, 28);
    textField.placeholder = @"写点什么";
    textField.leftViewMode = UITextFieldViewModeAlways;
    [textField becomeFirstResponder];
    [textField setBackground:[UIImage imageNamed:@"keyboard_text"]];
    self.textField = textField;
    [keyboardTopView addSubview:textField];

    UIButton* btnIcon = [[UIButton alloc] init];
    btnIcon.frame = CGRectMake(240, 0, 40, 40);
    [btnIcon setImage:[UIImage imageNamed:@"keyboard_face"] forState:UIControlStateNormal];
    [keyboardTopView addSubview:btnIcon];

    UIButton* btnSend = [[UIButton alloc] init];
    btnSend.frame = CGRectMake(280, 0, 40, 40);
    [btnSend setImage:[UIImage imageNamed:@"keyboard_send_blue"] forState:UIControlStateNormal];
    [keyboardTopView addSubview:btnSend];
    
    [[self.view superview] insertSubview:keyboardTopView aboveSubview:self.view];
    self.keyboardView = keyboardTopView;
}

-(void)btnWrite:(UIButton*)sender
{
    
    if (sender.tag == 0) {
        sender.tag = 1;
        [sender setImage:[UIImage imageNamed:@"keyboard_sound"] forState:UIControlStateNormal];
        
        //[textField removeFromSuperview];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, 6, 200, 28);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 5;
        [button setTitle:@"按住说话" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button becomeFirstResponder];
        self.button = button;
        [self.textField removeFromSuperview];
        [self.keyboardView addSubview:button];
    }
    else
    {
        sender.tag = 0;
        [sender setImage:[UIImage imageNamed:@"keyboard_keyboard"] forState:UIControlStateNormal];
        [self.button removeFromSuperview];
        
        UITextField* textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(40, 6, 200, 28);
        textField.placeholder = @"写点什么";
        textField.leftViewMode = UITextFieldViewModeAlways;
        [textField becomeFirstResponder];
        [textField setBackground:[UIImage imageNamed:@"keyboard_text"]];
        self.textField = textField;
        [self.button removeFromSuperview];
        [self.keyboardView addSubview:self.textField];
    }
}

/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.取出键盘的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.keyboardView.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
    }];
    
    //self.keyboardView.frame
}

/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.keyboardView.transform = CGAffineTransformIdentity;
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    WPDetailControllerThree *vc = [[WPDetailControllerThree alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
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


@end
