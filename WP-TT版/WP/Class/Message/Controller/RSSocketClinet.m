//
//  RSSocketClinet.m
//  WP
//
//  Created by 沈亮亮 on 15/12/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "RSSocketClinet.h"
#import "WPShareModel.h"
#import "RSFmdbTool.h"
#import "User.h"
#import "Depart.h"
#import "RSChatMessageModel.h"
#import "WPHttpTool.h"
#import "LoginModel.h"
#import "MTTDatabaseUtil.h"
#import "MTTUserEntity.h"
#import "DDUserModule.h"
#import <sys/socket.h>
#import <netdb.h>
#import <arpa/inet.h>
#define HOST @"kuajie.iok.la"
#define PORTSERVER 9091

//设置连接超时
#define TIME_OUT 20

//设置读取超时 -1 表示不会使用超时
#define READ_TIME_OUT -1

//设置写入超时 -1 表示不会使用超时
#define WRITE_TIME_OUT -1

@implementation RSSocketClinet

+(instancetype)sharedSocketClinet
{
    static RSSocketClinet *rsSocketClinet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rsSocketClinet = [[self alloc] init];
        rsSocketClinet.sendText = [[NSString alloc] init];
        rsSocketClinet.receiveText = [[NSString alloc] init];
    });
    return rsSocketClinet;
}

-(NSString*)getIPWithHostName:(const NSString*)hostName
{
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    
    @try {
        phot = gethostbyname(hostN);
        
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    struct in_addr ip_addr;
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}

/* 接收客户端请求后，回调函数  */
//void AcceptCallBack(
//                    CFSocketRef socket,
//                    CFSocketCallBackType type,
//                    CFDataRef address,
//                    const void *data,
//                    void *info)
//{
//    CFReadStreamRef readStream = NULL;
//    CFWriteStreamRef writeStream = NULL;
//    /* data 参数涵义是，如果是kCFSocketAcceptCallBack类型，data是CFSocketNativeHandle类型的指针 */
//    CFSocketNativeHandle sock = *(CFSocketNativeHandle *) data;
//    /* 创建读写Socket流 */
//    CFStreamCreatePairWithSocket(kCFAllocatorDefault, sock,
//                                 &readStream, &writeStream);
//    if (!readStream || !writeStream) {
//        close(sock);
//        fprintf(stderr, "CFStreamCreatePairWithSocket() 失败\n");
//        return;
//    }
//    CFStreamClientContext streamCtxt = {0, NULL, NULL, NULL, NULL};
//    // 注册两种回调函数
//    CFReadStreamSetClient(readStream, kCFStreamEventHasBytesAvailable, ReadStreamClientCallBack, &streamCtxt);
//    CFWriteStreamSetClient(writeStream, kCFStreamEventCanAcceptBytes, WriteStreamClientCallBack, &streamCtxt);
//    //加入到循环当中
//    CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
//    CFWriteStreamScheduleWithRunLoop(writeStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
//    CFReadStreamOpen(readStream);
//    CFWriteStreamOpen(writeStream);
//}
//
///* 读取流操作 客户端有数据过来时候调用 */
//void ReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType eventType, void* clientCallBackInfo){
//    UInt8 buff[255];
//    CFReadStreamRef inputStream = stream;
//    if(NULL != inputStream)
//    {
//        //接收的数据
//        CFReadStreamRead(stream, buff, 255);
//        printf("接受到数据：%s\n",buff);
//        
//        NSString * string = [NSString stringWithFormat:@"%s",buff];
//        NSArray * array = [string componentsSeparatedByString:@"^"];
//        NSString * firstStr = array[0];
//        NSInteger isOrNot= 0;
//        if ([firstStr isEqualToString:@"5"])//上线通知
//        {
//            isOrNot = 0;
//        }
//        else if([firstStr isEqualToString:@"6"])//离线通知
//        {
//            isOrNot = 1;
//        }
//        else//安卓手机
//        {
//        }
//        string = [NSString stringWithFormat:@"user_%@",[string componentsSeparatedByString:@"^"][1]];
//       [[DDUserModule shareInstance] getUserFromUserID:string Block:^(MTTUserEntity *user) {
//           if (user) {
//               user.isOfLine = isOrNot;
//               [[DDUserModule shareInstance] addMaintanceUser:user];
//           }
//       }];
//        
//        
//        CFReadStreamClose(inputStream);
//        CFReadStreamUnscheduleFromRunLoop(inputStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
//        inputStream = NULL;
//    }
//}
//
///* 写入流操作 客户端在读取数据时候调用 */
//void WriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void* clientCallBackInfo)
//{
//    CFWriteStreamRef    outputStream = stream;
//    //输出
//    UInt8 buff[] = "Hello Client!";
//    if(NULL != outputStream)
//    {
//        CFWriteStreamWrite(outputStream, buff, strlen((const char*)buff)+1);
//        //关闭输出流
//        CFWriteStreamClose(outputStream);
//        CFWriteStreamUnscheduleFromRunLoop(outputStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
//        outputStream = NULL;
//        
//    }
//  
//    
//    
//}
//
//
//
////开启本机接收数据的服务器
//-(void)startServe
//{
//    self.kPORT = 18000;
//    CFSocketRef service;
//    CFSocketContext CTX = {0,NULL,NULL,NULL,NULL};
//    service = CFSocketCreate(NULL, PF_INET, SOCK_STREAM, IPPROTO_TCP,
//                             kCFSocketAcceptCallBack, (CFSocketCallBack)AcceptCallBack, &CTX);
//    if (service == NULL)
//        return ;
//    /* 设置是否重新绑定标志 */
//    int yes = 1;
//    /* 设置socket属性 SOL_SOCKET是设置tcp SO_REUSEADDR是重新绑定，yes 是否重新绑定*/
//    setsockopt(CFSocketGetNative(service), SOL_SOCKET, SO_REUSEADDR,
//               (void *)&yes, sizeof(yes));
//    
//    /* 设置端口和地址 */
//    struct sockaddr_in addr;
//    memset(&addr, 0, sizeof(addr));             //memset函数对指定的地址进行内存拷贝
//    addr.sin_len = sizeof(addr);
//    addr.sin_family = AF_INET;                  //AF_INET是设置 IPv4
//    addr.sin_port = htons(self.kPORT);                //htons函数 无符号短整型数转换成“网络字节序”
//    addr.sin_addr.s_addr = htonl(INADDR_ANY);   //INADDR_ANY有内核分配，htonl函数 无符号长整型数转换成“网络字节序”
//    /* 从指定字节缓冲区复制，一个不可变的CFData对象*/
//    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8*)&addr, sizeof(addr));
//    /* 设置Socket*/
//    if (CFSocketSetAddress(service, (CFDataRef)address) != kCFSocketSuccess) {
//        fprintf(stderr, "Socket绑定失败\n");
//        CFRelease(service);
//        return ;
//    }
//    /* 创建一个Run Loop Socket源 */
//    CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, service, 0);
//    /* Socket源添加到Run Loop中 */
//    CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
//    CFRelease(sourceRef);
//    //    printf("Socket listening on port %d\n", self.kPORT);
//    /* 运行Loop */
//    CFRunLoopRun();
//}


- (void)connectServer
{
    
    self.isFirst = YES;
    // 在连接前先进行手动断开
    [self cutOffSocket];
    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
    self.disConnectResaon = SocketDidDisConnectReasonByServer;
    
//    NSLog(@"发起socket连接");
    [self socketConnectHost];
    /*end 连接服务器*/
    
}
#pragma mark - 连接Socket
- (void)socketConnectHost
{
    self.disConnectResaon = SocketDidDisConnectReasonByServer;
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    NSString * string = HOST;//[self getIPWithHostName:HOST]
    if (![self.socket connectToHost:string onPort:PORTSERVER withTimeout:TIME_OUT error:&error]) {
        NSAssert(NO, @"服务器连接失败：%@",[error localizedDescription]);
    } else {
        NSLog(@"服务器连接成功");
        WPShareModel *model = [WPShareModel sharedModel];
        NSString *dataStr = [NSString stringWithFormat:@"%@",self.loginString];
        NSData *data2 = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        [self.socket writeData:data2 withTimeout:WRITE_TIME_OUT tag:0];
//        [self startServe];
    }
//    NSUserDefaults *infos = [NSUserDefaults standardUserDefaults];
//    NSString *runType = [infos objectForKey:@"runType"];
//    if ([runType isEqualToString:@"formal"]) {
//        if (![self.socket connectToHost:kSOCKETIP onPort:kSOCKETPORTFORMAL error:&error]) {
//            NSAssert(NO, @"服务器连接失败：%@",[error localizedDescription]);
//        }
//    } else {
//        if (![self.socket connectToHost:kSOCKETIP onPort:kSOCKETPORTTEST error:&error]) {
//            NSAssert(NO, @"服务器连接失败：%@",[error localizedDescription]);
//        }
//    }
}

#pragma mark - 断开Socket
- (void)cutOffSocket
{
//    NSLog(@"断开与服务器连接...");
    
    self.disConnectResaon = SocketDidDisConnectReasonByUser;
    [self.socket setDelegate:nil];
    [self.socket disconnect];
    [self.connectTimer invalidate];
}

//#pragma mark - 发送消息
//- (void)sendMessageWithType:(MessageType)type andDetails:(NSString *)text
//{
//    self.sendMediaType = type;
//    self.sendText = text;
//    switch (type) {
//        case MessageTypeText:
//        {
//            NSString *message = [NSString stringWithFormat:@"31488888888815956975045%@",text];
//            NSLog(@"******%@",message);
//            NSData *sendData = [message dataUsingEncoding:NSUTF8StringEncoding];
//            [self.socket writeData:sendData withTimeout:WRITE_TIME_OUT tag:1];
//            break;
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

-(void)sendNotificationMessage:(NSString*)message
{
    NSData * data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:WRITE_TIME_OUT tag:1];
}
#pragma mark - 发送消息
//- (void)sendMessageFromSender:(NSString *)sender toReceiver:(NSString *)receiver type:(MessageType)type andDetails:(id)message
//{
//    self.sendMediaType = type;
//    NSMutableString *identifier = [NSMutableString stringWithFormat:@"%@%@",sender,receiver];
//    switch (type) {
//        case MessageTypeText:
//        {
//            NSData *data1 = [self convertHexStrToData:@"3"];
//            NSMutableData *sendData = [[NSMutableData alloc] initWithData:data1];
////            [identifier insertString:@"3" atIndex:0];
//            NSData *identifierData = [identifier dataUsingEncoding:NSUTF8StringEncoding];
//            [sendData appendData:identifierData];
//            self.sendText = message;
//            NSData *detailData = [message dataUsingEncoding:NSUTF8StringEncoding];
//            [sendData appendData:detailData];
//            [self.socket writeData:sendData withTimeout:WRITE_TIME_OUT tag:1];
//            
//            [self writeToDatabaseWithType:MessageTypeText detail:message origin:MessageFromSelf memberID:receiver];
//            BOOL isExist = [self isExistWithMemberID:receiver];
//            if (!isExist) {
//                [self requestPersonalInfoWithID:self.userId type:MessageTypeText details:message time:[self stringFromDate:[NSDate date]] isEqual:YES];
//            } else {
//                RSChatMessageModel *chatModel = [RSChatMessageModel modelwithName:self.nick_name avatar:self.avatar no:[self.userId integerValue] type:MessageTypeText detail:message time:[self stringFromDate:[NSDate date]] noReadCount:0 loginID:[self getLoginID] timestamp:[self timestampFromDate:[NSDate date]]];
//                [self updateListDatabaseWith:chatModel isAddCount:NO];
//            }
//            break;
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//}



#pragma mark - AsyncSocketDelegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [self.socket readDataWithTimeout:READ_TIME_OUT tag:0]; /**< 接收心跳包 */
    [self.socket readDataWithTimeout:READ_TIME_OUT tag:1]; /**< 接收后台给我发送的消息 */
//    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(connectToServer:) userInfo:nil repeats:YES];
//    [self.connectTimer fire];

}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
   // NSLog(@"与服务器断开");
    if (self.disConnectResaon == SocketDidDisConnectReasonByServer) {
      //  NSLog(@"与服务器断开连接，正在重连...");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self connectServer];
        });
    } else if (self.disConnectResaon == SocketDidDisConnectReasonByUser) {
      //  NSLog(@"用户手动断开连接");
    }
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (tag == 0) {
      //  NSLog(@"心跳包发送成功!");
    } else if (tag == 1) {
       // NSLog(@"消息发送成功!");
        if (self.sendTextSucceed) {
            self.sendTextSucceed(self.sendMediaType,self.sendText);
        }
    } else {
      //  NSLog(@"发送其他东西成功!");
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    RSChatMessageModel *model = [RSChatMessageModel modelwithName:@"王路" avatar:@"111" no:15956975045 type:MessageTypeText detail:@"" time:@"" noReadCount:20];
//    BOOL isInsert = [RSFmdbTool insertModel:model];
//    if (isInsert) {
//        NSLog(@"插入成功");
//    } else {
//        NSLog(@"插入失败");
//    }
//    [self updateListDatabaseWith:nil];
//    NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length])];
//    NSData *identifierData = [data subdataWithRange:NSMakeRange(0, 1)];
//    NSString *identifier = [self convertDataToHexStr:identifierData];
//    NSLog(@"========%@-----%@====%@",identifier,identifierData,strData);
//    NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
//    if (tag == 0) {
//        NSLog(@"<****接收心跳包回调****>[%@]",msg);
//        [self.socket readDataWithTimeout:READ_TIME_OUT tag:0];
//    } else if (tag == 1) {
//        NSLog(@"<****接收消息回调****> <%@>",msg);
//        [self.socket readDataWithTimeout:READ_TIME_OUT tag:1];
//    }
//    if (data.length == 1) { /**< 主动给别人发东西回调 */
//        if ([identifier isEqualToString:@"99"]) {
//            NSLog(@"<****用户离线回复*****>");
//        } else if ([identifier isEqualToString:@"02"]) {
//            NSLog(@"<****接收心跳包回调*****>");
//        } else {
//            NSLog(@"<****接收消息回调，好友在线*****>");
//        }
//        NSLog(@"^^^%@^^",msg);
//    } else { /**< 别人给我发消息的回调 */
//        NSLog(@"<****接收别人给我发消息回调*****%@>",msg);
//        [self handleData:data];
//        NSData *infoData = [data subdataWithRange:NSMakeRange(0, 23)];
//        NSData *detailData = [data subdataWithRange:NSMakeRange(23, data.length - 23)];
//        NSString *msg1 = [[NSString alloc] initWithData:infoData encoding:NSUTF8StringEncoding];
//        NSString *msg2 = [[NSString alloc] initWithData:detailData encoding:NSUTF8StringEncoding];
//        NSLog(@">>>>%@===%@<<<<<",msg1,msg2);
//        NSString *identifier = [msg substringWithRange:NSMakeRange(0, 1)];
//        //            NSString *sender = [msg substringWithRange:NSMakeRange(1, 11)];
//        if ([identifier isEqualToString:@"3"]) { /**< 接收到的是文字消息 */
//            self.receiveMediaType = MessageTypeText;
//            self.receiveText = [msg substringFromIndex:23];
//            NSLog(@"%@",self.receiveText);
//            if (self.receiveTextSuccessed) {
//                self.receiveTextSuccessed(self.receiveMediaType,self.receiveText);
//            }
//        }
//    }
    
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    // id json1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (dic)
    {
        if (self.isFirst)
        {
            dispatch_queue_t queue = dispatch_get_main_queue();
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            uint64_t interval = (uint64_t)(2.0 * NSEC_PER_SEC);
            dispatch_source_set_timer(self.timer, start, interval, 0);
            dispatch_source_set_event_handler(self.timer, ^{
                self.isFirst = NO;
                [self connectToServer:nil];
            });
            // 启动定时器
            dispatch_resume(self.timer);
//            self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(connectToServer:) userInfo:nil repeats:YES];
//            [self.connectTimer fire];
//            self.isFirst = NO;
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //离线的人
#pragma mark 离线接受数据出现问题
        NSString *  ofline = [NSString stringWithFormat:@"%@",dic[@"offline"]];
     //   NSLog(@"收到的数据：：：：：%@===%@",string,dic);
        NSArray * ofLineArray = [ofline componentsSeparatedByString:@"-"];
        for (NSString * string  in ofLineArray) {
            [[DDUserModule shareInstance] getUserFromUserID:[NSString stringWithFormat:@"user_%@",string] Block:^(MTTUserEntity *user) {
                if (user) {
                    user.isOfLine = @"1";
                    [[DDUserModule shareInstance] addOffLineMa:user];
                }
            }];
        }
        //上线的人
        NSString * onLine = [NSString stringWithFormat:@"%@",dic[@"online"]];
        NSArray * onArray = [onLine componentsSeparatedByString:@"-"];
        if (onArray.count>=2) {
            for (NSString * string  in onArray) {
                [[DDUserModule shareInstance] getOffLine:[NSString stringWithFormat:@"user_%@",string] Block:^(MTTUserEntity *user) {
                    if (user) {//掉线的字典中有则将其移除
                        [[DDUserModule shareInstance] reMoveOffline:[NSString stringWithFormat:@"user_%@",string]];
                    }
                }];
            }
        }
    });
    [self.socket readDataWithTimeout:READ_TIME_OUT tag:0];
    [self.socket readDataWithTimeout:READ_TIME_OUT tag:1];
}

#pragma mark - 处理接收到的数据
- (void)handleData:(NSData *)receiveData
{
//    NSData *identifierData = [receiveData subdataWithRange:NSMakeRange(0, 1)];
//    NSString *identifier = [self convertDataToHexStr:identifierData];
//    NSData *infoData = [receiveData subdataWithRange:NSMakeRange(0, 23)];
//    NSString *info = [[NSString alloc] initWithData:infoData encoding:NSUTF8StringEncoding];
//    //发送人的ID
//    NSString *senderInfo = [info substringWithRange:NSMakeRange(1, 11)];
////    NSLog(@"*****%@",senderInfo);
////    if ([senderInfo isEqualToString:@"18756938586"]) {
////        NSLog(@"同一人");
////    } else {
////        NSLog(@"不是同一人");
////    }
//    NSData *detailData = [receiveData subdataWithRange:NSMakeRange(23, receiveData.length - 23)];
//    NSString *msg2 = [[NSString alloc] initWithData:detailData encoding:NSUTF8StringEncoding];
//    NSLog(@"接收数据****%@*****%@****%@====%@",identifier,info,msg2,senderInfo);
////    NSString *msg1 = [[NSString alloc] initWithData:infoData encoding:NSUTF8StringEncoding];
//    if ([identifier isEqualToString:@"03"]) { /**< 接收到的是文字消息 */
//        self.receiveMediaType = MessageTypeText;
//        NSString *msg2 = [[NSString alloc] initWithData:detailData encoding:NSUTF8StringEncoding];
//        self.receiveText = msg2;
//        NSLog(@"%@",self.receiveText);
//        [self writeToDatabaseWithType:MessageTypeText detail:msg2 origin:MessageFromOpposite memberID:senderInfo];
//        
//        BOOL isExist = [self isExistWithMemberID:senderInfo];
//        BOOL isEqual = [senderInfo isEqualToString:self.userId] ? YES : NO;
//        if (isEqual) {      //收到的是当前聊天人信息
//            if (!isExist) { //不存在，插入新的数据
//                [self requestPersonalInfoWithID:self.userId type:MessageTypeText details:msg2 time:[self stringFromDate:[NSDate date]] isEqual:YES];
////                [self writeToMessageListWith:chatModel];
//            } else {        //存在，更新最后的一条数据的内容
//                RSChatMessageModel *chatModel = [RSChatMessageModel modelwithName:self.nick_name avatar:self.avatar no:[self.userId integerValue] type:MessageTypeText detail:msg2 time:[self stringFromDate:[NSDate date]] noReadCount:0 loginID:[self getLoginID] timestamp:[self timestampFromDate:[NSDate date]]];
//                [self updateListDatabaseWith:chatModel isAddCount:NO];
//            }
//            if (self.receiveTextSuccessed) {
//                self.receiveTextSuccessed(self.receiveMediaType,self.receiveText);
//            }
//        } else {            //收到的不是当前聊天人信息
//            if (!isExist) { //不存在，请求头像和昵称，插入消息列表
//                [self requestPersonalInfoWithID:senderInfo type:MessageTypeText details:msg2 time:[self stringFromDate:[NSDate date]] isEqual:NO];
//            } else {        //存在，
//                RSChatMessageModel *chatModel = [RSChatMessageModel modelwithName:@"" avatar:@"" no:[senderInfo integerValue] type:MessageTypeText detail:msg2 time:[self stringFromDate:[NSDate date]] noReadCount:0 loginID:[self getLoginID] timestamp:[self timestampFromDate:[NSDate date]]];
//                [self updateListDatabaseWith:chatModel isAddCount:YES];
//            }
//        }
//        
//    } else if ([identifier isEqualToString:@""]){ /**< 接收的是图片信息 */
//      
//    }
}


- (void)requestPersonalInfoWithID:(NSString *)ID type:(NotiMessageType)type details:(NSString *)details time:(NSString *)time isEqual:(BOOL)equal
{
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/userInfo.ashx"];
//    NSDictionary *params = @{@"action" : @"userinfo",
//                             @"mobile" : ID,
//                             @"username" : kShareModel.username,
//                             @"password" : kShareModel.password};
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
////        NSLog(@"%@",json);
//        NSString *avatar = json[@"avatar"];
//        NSString *nick_name = json[@"nick_name"];
//        if (equal) {
//            RSChatMessageModel *chatModel = [RSChatMessageModel modelwithName:nick_name avatar:avatar no:[ID integerValue] type:type detail:details time:time noReadCount:0 loginID:[self getLoginID] timestamp:[self timestampFromDate:[NSDate date]]];
//            [self writeToMessageListWith:chatModel];
//        } else {
//            RSChatMessageModel *chatModel = [RSChatMessageModel modelwithName:nick_name avatar:avatar no:[ID integerValue] type:type detail:details time:time noReadCount:1 loginID:[self getLoginID] timestamp:[self timestampFromDate:[NSDate date]]];
//            [self writeToMessageListWith:chatModel];
//        }
//    } failure:^(NSError *error) {
//        
//    }];

}

#pragma mark - 将接收到的内容写入数据库
- (void)writeToDatabaseWithType:(NotiMessageType)type detail:(NSString *)detail origin:(MessageFrom)from memberID:(NSString *)ID
{
//    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
//    dispatch_async(q1, ^{
//    User *user = [[User alloc] init];
//    user.messageType = type;
//    user.messageDetail = detail;
//    user.messageFrom = from;
//    user.messageID = [ID integerValue];
//    user.login_ID = [self getLoginID];
//    user.meaageTime = [self stringFromDate:[NSDate date]];
//    user.timestamp = [self timestampFromDate:[NSDate date]];
//    [user save];
//    });
}

#pragma mark - 更新列表数据库
- (void)updateListDatabaseWith:(RSChatMessageModel *)model isAddCount:(BOOL)isAdd
{
    if (!isAdd) { //不需要更改未读数据的数量
        BOOL success;
        if (model.avatarName.length == 0 || model.avatarUrl.length == 0) {
            NSString *modifySql = [NSString stringWithFormat:@"UPDATE t_modals SET time = '%@',detail = '%@', type = '%zd',amount = '%zd',timestamp = '%zd' WHERE ID_No = '%zd' AND login_ID = '%zd'",model.meaageTime, model.messageDetail, model.messageType,model.noReadCount,model.timestamp, model.messageID ,model.loginID];
            success = [RSFmdbTool modifyData:modifySql];
        } else {
            NSString *modifySql = [NSString stringWithFormat:@"UPDATE t_modals SET time = '%@',detail = '%@',avatar = '%@',name = '%@',type = '%zd',amount = '%zd',timestamp = '%zd' WHERE ID_No = '%zd' AND login_ID = '%zd'",model.meaageTime, model.messageDetail, model.avatarUrl, model.avatarName, model.messageType,model.noReadCount,model.timestamp, model.messageID,model.loginID];
            success = [RSFmdbTool modifyData:modifySql];
        }
        if (success) {
            NSLog(@"第一种情况更新成功");
        } else {
            NSLog(@"第一种情况更新失败");
        }
    } else {    //需要更改未读数据的数量
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_modals WHERE ID_No = '%zd'",model.messageID];
        NSArray *data = [RSFmdbTool queryData:querySql];
        RSChatMessageModel *messageModel = data[0];
        NSInteger count = messageModel.noReadCount + 1;
        BOOL success;
        if (model.avatarName.length == 0 || model.avatarUrl.length == 0) {
            NSString *modifySql = [NSString stringWithFormat:@"UPDATE t_modals SET time = '%@',detail = '%@', type = '%zd',amount = '%zd',timestamp = '%zd' WHERE ID_No = '%zd' AND login_ID = '%zd'",model.meaageTime, model.messageDetail, model.messageType,count,model.timestamp, model.messageID ,model.loginID];
            success = [RSFmdbTool modifyData:modifySql];
        } else {
            NSString *modifySql = [NSString stringWithFormat:@"UPDATE t_modals SET time = '%@',detail = '%@',avatar = '%@',name = '%@',type = '%zd',amount = '%zd',timestamp = '%zd' WHERE ID_No = '%zd' AND login_ID = '%zd'",model.meaageTime, model.messageDetail, model.avatarUrl, model.avatarName, model.messageType,count,model.timestamp, model.messageID ,model.loginID];
            success = [RSFmdbTool modifyData:modifySql];
        }
        if (success) {
            NSLog(@"第二种情况更新成功");
        } else {
            NSLog(@"第二种情况更新失败");
        }
    }
    [self sendNotification];
}

#pragma mark - 判断这条这个人是否已在数据库中
- (BOOL)isExistWithMemberID:(NSString *)ID
{
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_modals WHERE ID_No = '%@' AND login_ID = '%zd'",ID,[self getLoginID]];
    NSArray *data = [RSFmdbTool queryData:querySql];
    if (data.count == 0) {
        return NO;
    }
    return YES;
}

- (void)sendNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateList" object:self];
}

#pragma mark - 将最新的数据插到
- (void)writeToMessageListWith:(RSChatMessageModel *)model
{
    BOOL success = [RSFmdbTool insertModel:model];
    if (success) {
        NSLog(@"插入消息列表成功");
    } else {
        NSLog(@"插入消息列表失败");
    }
    [self sendNotification];
}

#pragma mark - NSTimer Method
- (void)connectToServer:(NSTimer *)timer
{
    
    WPShareModel *model = [WPShareModel sharedModel];
//    NSData *data1 = [self convertHexStrToData:@"2"];
//    NSMutableData *userData = [[NSMutableData alloc] initWithData:data1];
    NSString *dataStr = [NSString stringWithFormat:@"1^%@",model.userId];
    NSData *data2 = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
//    [userData appendData:data2];
    [self.socket writeData:data2 withTimeout:WRITE_TIME_OUT tag:0];
}


#pragma mark - 讲十六进制转换成NSData
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

#pragma mark - 将NSData转换成十六进制
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

/**
 *  将NSDate类型转换成字符串
 *
 *  @param date NSDate类型
 *
 *  @return 时间字符串
 */
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

- (NSInteger)timestampFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    NSLog(@"%@",destDateString);
    return destDateString.integerValue;

}


- (NSInteger)getLoginID
{
    NSMutableDictionary *userInfo = kShareModel.dic;
    return [userInfo[@"userid"] integerValue];
}


@end
