//
//  WPReplyValidateMsgCell.m
//  WP
//
//  Created by Kokia on 16/5/17.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPReplyValidateMsgCell.h"
#import "WPValidateReplyCell.h"
#import "CCAlertView.h"

@interface WPReplyValidateMsgCell()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *msgList;

@property (nonatomic, copy) NSString *replytext;


@end

@implementation WPReplyValidateMsgCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    //注册通知
    WPReplyValidateMsgCell *cell; //这个cell没必要重用
    if (cell == nil) {
          cell = [[WPReplyValidateMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 根据返回格子数组的个数  决定tableView的高度
        [self createUI];
    }
    return self;
}



-(void)setMsgArray:(NSArray *)msgArray{
    _msgArray = msgArray;
    self.msgList = msgArray;
    [self createUI];
    [self.tableView reloadData];
}

-(void)createUI{
    NSLog(@"createUIcreateUI");
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= RGBCOLOR(238, 238, 238);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    //对于无数据的cell 不显示分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.contentView addSubview:self.tableView];
    
    //TableView不显示没内容的Cell
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    self.tableView.scrollEnabled = NO;
    
    
    self.tableView.estimatedRowHeight = kHEIGHT(43);//先给一个预估行高
    self.tableView.rowHeight = UITableViewAutomaticDimension;// 自动拉伸
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(16, 0, 0, 0));
    }];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPValidateReplyCell *cell = [WPValidateReplyCell cellWithTableView:tableView];
    cell.msgModel = self.msgList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    UIButton *sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendMsg setTitle:@"回复" forState:UIControlStateNormal];
    sendMsg.titleLabel.font = kFONT(12);
    [sendMsg setBackgroundColor:RGB(247, 247, 247)];
    [sendMsg.layer setMasksToBounds:YES];
    [sendMsg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendMsg.layer.masksToBounds = YES;
    sendMsg.layer.cornerRadius = 5;
    sendMsg.layer.borderWidth = 0.5;
    sendMsg.layer.borderColor = RGB(226, 226, 226).CGColor;
    [sendMsg addTarget:self action:@selector(replyMsg) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sendMsg];
    
    
    [sendMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(footerView.mas_bottom).with.offset(-16);
        make.right.equalTo(footerView.mas_right).with.offset(-16);
        make.height.equalTo(@(kHEIGHT(26)));
        make.width.equalTo(@(kHEIGHT(41)));
    }];
    
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
    
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //不支持系统表情的输入
    if ([[[textField textInputMode ]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}
//过滤表情
- (NSString *)filterEmoji:(NSString *)string {
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [string UTF8String];
    char *newUTF8 = malloc( sizeof(char) * len );
    int j = 0;
    
    //0xF0(4) 0xE2(3) 0xE3(3) 0xC2(2) 0x30---0x39(4)
    for ( int i = 0; i < len; i++ ) {
        unsigned int c = utf8;
        BOOL isControlChar = NO;
        if ( c == 4294967280 ||
            c == 4294967089 ||
            c == 4294967090 ||
            c == 4294967091 ||
            c == 4294967092 ||
            c == 4294967093 ||
            c == 4294967094 ||
            c == 4294967095 ||
            c == 4294967096 ||
            c == 4294967097 ||
            c == 4294967088 ) {
            i = i + 3;
            isControlChar = YES;
        }
        if ( c == 4294967266 || c == 4294967267 ) {
            i = i + 2;
            isControlChar = YES;
        }
        if ( c == 4294967234 ) {
            i = i + 1;
            isControlChar = YES;
        }
        if ( !isControlChar ) {
            newUTF8[j] = utf8;
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [NSString stringWithCString:(const char*)newUTF8
                                             encoding:NSUTF8StringEncoding];
    free( newUTF8 );
    return encrypted;
}

-(void)replyMsg{
    UIAlertView * alert =
    [[UIAlertView alloc] initWithTitle:@"回复" message:@"" delegate:self
                     cancelButtonTitle:@"取消" otherButtonTitles:@"发送",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf=[alert textFieldAtIndex:0];
    tf.clearsOnBeginEditing = YES;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.delegate = self;
    [[[tf textInputMode] primaryLanguage] isEqualToString:@"emoji"];
    [alert show];
}


-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //得到输入框
    if (buttonIndex == 1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        self.replytext= tf.text;
        self.replyBlock(self.replytext);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kHEIGHT(43);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgList.count;
}


-(NSArray *)msgList{
    if (_msgList == nil) {
        _msgList = [NSMutableArray array];
    }
    return _msgList;
}


@end
