//
//  WPWriteController.m
//  WP
//
//  Created by Asuna on 15/5/25.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPWriteController.h"
#import "WPSearchBar.h"
#import "WPWriteController.h"
#import "SmallOneModel.h"
#import "WPTableCellThree.h"
#import "WPHttpTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@interface WPWriteController ()<UITextFieldDelegate>

@property (nonatomic,strong) NSArray *array;
@property (nonatomic,weak) UITextField *textField;
@property (nonatomic,strong) UIView *viewOne;

@property (nonatomic,weak) UIButton* buttonOne;
@property (nonatomic,weak) UIButton* buttonTwo;
@property (nonatomic,weak) UIButton* buttonThree;
@property (nonatomic,weak) UIButton* buttonFour;
@property (nonatomic,weak) UIButton* buttonFive;

@end

@implementation WPWriteController

-(NSArray *)array
{
    NSMutableArray *arrayO = [NSMutableArray array];
    if (_array == nil) {
        SmallOneModel *smallOne = [[SmallOneModel alloc]init];
        smallOne.icon = @"地址";
        smallOne.string = @"所在位置";
        smallOne.image = @"箭头";
        [arrayO addObject:smallOne];
        
        SmallOneModel *smallTwo = [[SmallOneModel alloc]init];
        smallTwo.icon = @"匿名";
        smallTwo.string = @"匿名发布";
        smallTwo.image = @"分享";
        [arrayO addObject:smallTwo];
        
        SmallOneModel *smallThree = [[SmallOneModel alloc]init];
        smallThree.icon = @"分享";
        smallThree.string = @"分享到";
        smallThree.image = @"新浪灰";
        [arrayO addObject:smallThree];
    }
    return arrayO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写写";
    
    UIBarButtonItem * item  =    [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick:)];
    item.tag = 0;
    self.navigationItem.rightBarButtonItem = item;
    
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 180);
    headView.backgroundColor = WPColor(255, 255, 255);
    
    UITextField *textView = [[UITextField alloc]initWithFrame:CGRectMake(0, -45, headView.bounds.size.width, headView.bounds.size.height - 70)];
    textView.placeholder = @"写写现在的想法";
    self.textField = textView;
    self.textField.delegate = self;
    [headView addSubview:textView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"write_bounds"]];
    imageView.frame = CGRectMake(0, headView.bounds.size.height - 70, 70, 70);
    [headView addSubview:imageView];
    
    self.tableView.tableHeaderView = headView;
    
    //3.设置手势
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

}


-(void)buttonClick:(UIBarButtonItem*)sender
{
    [self dismissKeyBoard];
    
    [self setSendView];
    
    if (sender.tag == 0) {
        sender.tag = 1;
    } else {
        sender.tag = 0;
        [self sendDataWithPicture];
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}



-(void)sendDataWithoutPicture
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"]        = @"releaseDynamic";
    params[@"user_id"]       = @"33";
    params[@"nick_name"]     = @"Jack";
    params[@"speak_content"] = self.textField.text;
    params[@"comment_type"]  = @"1";
    params[@"longitude"]     = @"10.1";
    params[@"latitude"]      = @"10.2";
    params[@"is_nearby"]     = @"0";
    params[@"is_anoymous"]   = @"0";
    params[@"is_friends"]    = @"0";
    params[@"is_fans"]       = @"0";
    NSString * strPath = [IPADDRESS stringByAppendingString:@"/tools/speak_manage.ashx"];
    
    [mgr POST:strPath parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [MBProgressHUD showSuccess:@"发送成功"];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [MBProgressHUD showError:@"发送失败"];
      }];
    
}

-(void)sendDataWithPicture
{
    NSString* path = nil;
    NSString* thumb = nil;
    [self getPicPath:&path thumb:&thumb];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"]        = @"releaseDynamic";
    params[@"user_id"]       = @"33";
    params[@"nick_name"]     = @"Jack";
    params[@"speak_content"] = self.textField.text;
    params[@"comment_type"]  = @"1";
    params[@"longitude"]     = @"10.1";
    params[@"latitude"]      = @"10.2";
    params[@"is_nearby"]     = @"0";
    params[@"is_anoymous"]   = @"0";
    params[@"is_friends"]    = @"0";
    params[@"is_fans"]       = @"0";
    params[@"media_type"]    = @"2";
    params[@"img_big"]       = path;
    params[@"img_address"]   = thumb;
    
    NSString * strPath = [IPADDRESS stringByAppendingString:@"/tools/speak_manage.ashx"];
    
   [mgr POST:strPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       [MBProgressHUD showSuccess:@"发送成功"];
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [MBProgressHUD showError:@"发送失败"];
   }];
}

-(void)getPicPath:(NSString**)path thumb:(NSString**)thumb
{
    NSString *picPath = [[NSBundle mainBundle] pathForResource:@"square_ad@2x.png" ofType:nil];
    NSLog(@"%@",picPath);
    NSString *str = [self postRequestWithURL:@"http://192.168.1.110/tools/upload_img.ashx" postParems:nil picFilePath:picPath picFileName:@"square_ad@2x.png"];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    *path = dict[@"path"];
    *thumb = dict[@"thumb"];
}

static NSString * const FORM_FLE_INPUT = @"file";

- (NSString *)postRequestWithURL: (NSString *)url                   //
                      postParems: (NSMutableDictionary *)postParems //
                     picFilePath: (NSString *)picFilePath           //
                     picFileName: (NSString *)picFileName;          //
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    if(picFilePath){
        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&urlResponese error:&error];
    NSLog(@"---resultData-----%@",resultData);
    NSLog(@"----urlResponese-----%@",urlResponese);
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",request);
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        return result;
    }
    return nil;
}

-(void)setSendView
{

    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    view.backgroundColor = WPColor(235, 235, 235);
    
    UIButton *buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOne.frame = CGRectMake(0, 43*0, self.view.bounds.size.width, 43);
    buttonOne.backgroundColor = [UIColor whiteColor];
    [buttonOne setTitle:@"全部" forState:UIControlStateNormal];
    [buttonOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [buttonOne setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    // [buttonOne setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateHighlighted];
    [buttonOne setImageEdgeInsets:UIEdgeInsetsMake(12, 180, 11, 140)];
    [buttonOne setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 160)];
    [buttonOne addTarget:self action:@selector(buttonOneClick:) forControlEvents:UIControlEventTouchDown];
    [buttonOne setTag:0];
    self.buttonOne = buttonOne;
    [view addSubview:buttonOne];
    
    UIButton *buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonTwo.frame = CGRectMake(0, 43*1+1, self.view.bounds.size.width, 43);
    buttonTwo.backgroundColor =  [UIColor whiteColor];
    [buttonTwo setTitle:@"附近" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonTwo setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    // [buttonTwo setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateHighlighted];
    [buttonTwo setImageEdgeInsets:UIEdgeInsetsMake(12, 180, 11, 140)];
    [buttonTwo setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 160)];
    [buttonTwo addTarget:self action:@selector(buttonTwoClick:) forControlEvents:UIControlEventTouchDown];
    [buttonTwo setTag:0];
    self.buttonTwo = buttonTwo;
    [view addSubview:buttonTwo];
    
    UIButton *buttonThree = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonThree.frame = CGRectMake(0,43*2+2, self.view.bounds.size.width, 43);
    buttonThree.backgroundColor =  [UIColor whiteColor];
    [buttonThree setTitle:@"粉丝" forState:UIControlStateNormal];
    [buttonThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonThree setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    //[buttonThree setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateHighlighted];
    [buttonThree setImageEdgeInsets:UIEdgeInsetsMake(12, 180, 11, 140)];
    [buttonThree setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 160)];
    [buttonThree addTarget:self action:@selector(buttonThreeClick:) forControlEvents:UIControlEventTouchDown];
    [buttonThree setTag:0];
    self.buttonThree = buttonThree;
    [view addSubview:buttonThree];
    
    UIButton *buttonFour = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonFour.frame = CGRectMake(0, 43*3 + 3, self.view.bounds.size.width, 43);
    buttonFour.backgroundColor = [UIColor whiteColor];
    [buttonFour setTitle:@"好友" forState:UIControlStateNormal];
    [buttonFour setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonFour setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    //[buttonFour setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateHighlighted];
    [buttonFour setImageEdgeInsets:UIEdgeInsetsMake(12, 180, 11, 140)];
    [buttonFour setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 160)];
    [buttonFour addTarget:self action:@selector(buttonFourClick:) forControlEvents:UIControlEventTouchDown];
    [buttonFour setTag:0];
    self.buttonFour = buttonFour;
    [view addSubview:buttonFour];
    
    UIButton *buttonFive = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonFive.frame  = CGRectMake(0, 43*4 +4, self.view.bounds.size.width, 43);
    buttonFive.backgroundColor =  [UIColor whiteColor];
    [buttonFive setTitle:@"选择" forState:UIControlStateNormal];
    [buttonFive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [buttonFive setImage:[UIImage imageNamed:@"small_plus"] forState:UIControlStateNormal];
    // [buttonFive setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateHighlighted];
    [buttonFive setImageEdgeInsets:UIEdgeInsetsMake(12, 180, 11, 140)];
    [buttonFive setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 160)];
    [buttonFive addTarget:self action:@selector(buttonFiveClick:) forControlEvents:UIControlEventTouchDown];
    [buttonFive setTag:0];
    self.buttonFive = buttonFive;
    [view addSubview:buttonFive];
    
    UIButton *buttonSix = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSix.frame = CGRectMake(0, 43*5+5 + 11, self.view.bounds.size.width, 43);
    [buttonSix setImage:[UIImage imageNamed:@"menu_cancel"] forState:UIControlStateNormal];
    
    [buttonSix setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSix setBackgroundColor:[UIColor whiteColor]];
    
    [buttonSix setImageEdgeInsets:UIEdgeInsetsMake(5, (SCREEN_WIDTH - 33)/2, 5, (SCREEN_WIDTH - 33)/2)];
    [buttonSix addTarget:self action:@selector(buttonHiden) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonSix];
    self.viewOne = view;
    
    [self.view addSubview:view];
}

-(void)buttonOneClick:(UIButton*)sender
{
    if (sender.tag == 0) {
        [sender setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        sender.tag = 1;
        [self.buttonTwo setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        self.buttonTwo.tag = 1;
        [self.buttonThree setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        self.buttonThree.tag = 1;
        [self.buttonFour setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        self.buttonFour.tag = 1;
        
    } else {
        [self.buttonOne setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
        sender.tag = 0;
        [self.buttonTwo setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
        self.buttonTwo.tag = 0;
        [self.buttonThree setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
        self.buttonThree.tag = 0;
        [self.buttonFour setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
        self.buttonFour.tag = 0;
    }
}

-(void)buttonTwoClick:(UIButton*)sender
{
    [self buttonAllClick:sender];}

-(void)buttonThreeClick:(UIButton*)sender
{
    [self buttonAllClick:sender];
}

-(void)buttonFourClick:(UIButton*)sender
{
    [self buttonAllClick:sender];
}

-(void)buttonFiveClick:(UIButton*)sender
{
    
}

-(void)buttonAllClick:(UIButton*)sender
{
    if (sender.tag == 0)
    {
        sender.tag = 1;
        [sender setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        if (self.buttonTwo.tag && self.buttonThree.tag && self.buttonFour.tag) {
            self.buttonOne.tag = 1;
            [self.buttonOne setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        }
    }
    else
    {
        sender.tag = 0;
        [sender setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
        self.buttonOne.tag = 0;
        [self.buttonOne setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    }
}
-(void)buttonHiden
{
    [self.viewOne setHidden:YES];
}
- (void)dismissKeyBoard
{
    [self.view endEditing:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    //  [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    switch (indexPath.row) {
        case 0:
        {
            SmallOneModel *model = self.array[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:model.icon];
            
            cell.textLabel.text = model.string;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            break;
        }
            
        case 1:
        {
            SmallOneModel *model = self.array[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:model.icon] ;
            cell.textLabel.text = model.string;
            [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
        case 2:
        {
            SmallOneModel *model = self.array[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:model.icon] ;
            cell.textLabel.text = model.string;
            [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    return cell;
}








@end
