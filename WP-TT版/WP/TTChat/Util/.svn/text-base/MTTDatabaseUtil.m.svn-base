
//  MTTDatabaseUtil.m
//  Duoduo
//
//  Created by zuoye on 14-3-21.
//  Copyright (c) 2015年 MoguIM All rights reserved.
//

#import "MTTDatabaseUtil.h"
#import "MTTMessageEntity.h"
#import "MTTUserEntity.h"
#import "DDUserModule.h"
#import "MTTGroupEntity.h"
#import "NSString+DDPath.h"
#import "NSDictionary+Safe.h"
#import "MTTDepartment.h"
#import "MTTSessionEntity.h"
#import "MTTUtil.h"
#import "WPMySecurities.h"
#import "WPBlackNameModel.h"
#import "WPHotPositionModel.h"
#import "WPHotCompanyModel.h"
#import "WPHotIndustryModel.h"
#import "WPNewResumeModel.h"
#import "LinkManModel.h"
#import "LinkMobileModel.h"
#import "LinkMobileModel.h"
#import "WPGetFriendInfoResult.h"
#import "WPReplyListModel.h"
#import "WPFriendInfoImgListModel.h"

#define DB_FILE_NAME                    @"tt.sqlite"
#define TABLE_MESSAGE                   @"message"
#define TABLE_ALL_CONTACTS              @"allContacts"
#define TABLE_DEPARTMENTS               @"departments"
#define TABLE_GROUPS                    @"groups"
#define TABLE_RECENT_SESSION            @"recentSession"
#define BLACK_NAME                      @"blackName"//黑名单
#define POSITION_SHUOSHUO               @"positionShuoshuo"//说说
#define SECOND_POSITION                 @"position"//职位
#define COMPANY                         @"company"//公司
#define INDUSTRY                        @"industry"//行业
#define PERSONALAPPLY                   @"personalApply"//面试
#define COMPANYINVITE                   @"companyInvite"//企业招聘
#define MYREMEMBERSHUOSHUO              @"myRememberShuoshuo"//回忆录
#define LINKMAN                         @"linkMan"//通讯录
#define NEWFRIENDS                      @"newFriends"//新的好友
#define MYGROUP                         @"myGroup"//我的群组
#define FRIENDSCATEGORY                 @"friendsCategory"//好友类别
#define FRIENDSCATEGORYDETAIL           @"friendsCategoryDetail"//好友类别列表
#define PHONELINKMAN                    @"phoneLinkMan"//手机联系人
#define PERSONALINFO                    @"personalInfo"//好友资料
#define GROUPINFO                       @"groupInfo"//群组资料
#define GROUPALBUM                      @"groupAlbum"//群相册
#define GROUPMENBER                     @"groupMember"//群成员
#define GROUPGONGGAO                    @"groupGongGao"//群公告
#define COLLECTIONLIST                  @"collectionList"//收藏列表
#define COLLECTIONDETAIL                @"collectionDetail"//收藏详情
#define MYPERSONALINFO                  @"myPersonalInfo"//我的求职个人信息
#define MYCOMPANYINFO                   @"myCompanyInfo"//我的招聘我的企业
#define MYAPPLYINFO                     @"myApplyInfo"//我发布的求职
#define MYINVITEINFO                    @"myInviteInfo"//我发布的招聘
#define ShuoShuoTOPIC                   @"shuoshuotopig"//说说的话题

#define SQL_CREAT_ShuoShuoTOPIC            [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id text primary key,CoutSum text ,icon_url text,remarks text,sid text,sort text,type_name text,user_id text)",ShuoShuoTOPIC]

#define SQL_CREAT_MYINVITEINFO            [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id text primary key,attention_state text ,avatar1 text,company text,ep_id text,info text,nick_name text,position1 text,user_id1 text,UnReadCount text ,avatar text,comcount text,dataIndustry text,enterprise_address text,enterprise_brief text,enterprise_name text,enterprise_properties text,enterprise_scale text,epname text,is_auto text,pageView text,position text,ranking text,resumeId text,shareCount text,shelvesDown text,signCount text,signUp text,sys_count text,sys_message text,update_Time text,user_id text)",MYINVITEINFO]

#define SQL_CREAT_MYAPPLYINFO            [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id text primary key,attention_state text ,avatar1 text,company text,info text,nick_name text,position1 text,user_id1 text,age text,avatar text,comcount text,education text,nike_name text,pageView text,position text,ranking text,resumeId text,sex text,shareCount text,signUp text,sys_message text,txtcontent text,update_Time text,user_id text,worktime text,resume_user_id text)",MYAPPLYINFO]


#define SQL_CREAT_MYCOMPANYINFO             [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (QR_code text ,dataIndustry text,enterprise_name text,enterprise_properties text,enterprise_scale text,ep_id text)",MYCOMPANYINFO]

#define SQL_CREAT_MYPERSONALINFO              [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Address_id text ,PhotoList blob,Position text,PositionNo text,Tel text,VideoList blob,WorkTime text,address text,age text,birthday text,cardNo text,cardType text,companyName text,education text,email text,homeTown text,homeTown_id text,industry text,industryNo text,isDefault text,lightspot text,marriage text,name text,nowSalary text,nowSalaryType text,qq text,sex text,sid text,user_avatar text,webchat text,workexperience text)",MYPERSONALINFO]

#define SQL_CREAT_COLLECTIONDETAIL              [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (add_time text ,address text,avatar text,classN text,classType text,col1 text,col2 text,col3 text,col4 text,col5 text,col6 text,col7 text,companName text,company text,content text,id text,img_url blob,jobid text,nick_name text,nick_title text,position text,share text,speak_class text,title text,url blob,user_id text,wp_id text)",COLLECTIONDETAIL]

#define SQL_CREAT_COLLECTIONLIST              [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (add_time text ,id text,typename text)",COLLECTIONLIST]

#define SQL_CREAT_GROUPGONGGAO              [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (DistanceTime text ,add_time text,group_id text,group_name text ,id text,isEdit text,nick_name text,notice_content text,notice_photo text,notice_title text,user_id text,user_name text)",GROUPGONGGAO]

#define SQL_CREAT_GROUPMENBER              [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (admin text ,avatar text,is_create text,nick_name text ,post_remark text,remark_name text,user_id text,user_name text,group_id text)",GROUPMENBER]

#define SQL_CREAT_GROUPALBUM                [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (CommentList blob,PhotoList blob,PraiseList blob,add_time text ,address text,album_name text,albumnId text ,avatar text,commentCount text,company text,cr_user_id text ,created_user_id text,folder_id text,isAttent text,latitude text,longitude text ,myPraise text,photoNum text,position text ,praiseCount text,remark text,user_name text,group_id text)",GROUPALBUM]


#define SQL_CREAT_GROUPINFO                [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Industry_id text,MenberCount text,MenberList blob,MilliTime text ,NoticeList blob,PhotoList blob,Post_time text ,Sum_Limit text,add_address text,add_addressDesc text,add_addressID text ,add_time text,admin text,authentication text,exa_user_id text,exa_user_name text ,g_id text,group_Industry text,group_IndustryID text ,group_bgImg text,group_cont text,group_icon text,group_name text,group_no text ,group_status text,group_type text,iconList blob,id text,is_create text,is_near text,is_notice text ,is_sound text,is_to text,latitude text,longitude text,photoCount text,remark_name text,user_id text,user_name text,user_sum text)",GROUPINFO]

#define SQL_CREAT_PERSONALINFO                [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (address text,ImgList blob,avatar text,company text ,form_state text,fremark text,friendValidate text ,fstate text,hobby text,industry text,inviteJob text ,iresume text,is_circle text,is_fcircle text,is_fjob text,is_fresume text ,is_job text,is_read text,is_resume text ,is_shield text,mobile text,nick_name text,position text,profession text ,replyList blob,sex text,signature text,specialty text,type_name text,uid text,user_name text ,workAddress text,wp_id text)",PERSONALINFO]

#define SQL_CREAT_PHONELINKMAN                  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (avatar text,fk_id text,isatt text ,mobile text,mobileName text,user_id text,user_name text)",PHONELINKMAN]

#define SQL_CREAT_FRIENDSCATEGORYDETAIL                 [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (friend_id text,add_fuser_state text,avatar text,company text ,form_state text,ftypeid text,is_be text ,is_circle text,is_fcircle text,is_fjob text,is_fresume text ,is_job text,is_read text,is_resume text,is_shield text,nick_name text ,position text,post_remark text,user_id text ,user_name text,wp_id text)",FRIENDSCATEGORYDETAIL]

#define SQL_CREAT_FRIENDSCATEGORY                  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (add_time text,id text,state text ,typename text,user_id text)",FRIENDSCATEGORY]

#define SQL_CREAT_MYGROUP                   [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (MilliTime text,create_user_id text,g_id text ,group_icon text,group_id text, group_name text, user_lest blob)",MYGROUP]

#define SQL_CREAT_NEWFRIENDS                    [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (fk_id text,avatar text,belongGroup text ,form_state text,is_mf text, isatt text, mobile text, mobileName text,user_id text,user_name text)",NEWFRIENDS]

#define SQL_CREAT_LINKMAN                     [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (add_fuser_state text,avatar text ,company text,form_state text,friend_id text, ftypeid text, is_be text, is_circle text,is_fcircle text,is_fjob text,is_fresume text,is_job text,is_read text,is_resume text,is_shield text,nick_name text,position text,post_remark text,user_id text,user_name text,wp_id text)",LINKMAN]

#define SQL_CREAT_POSITION_SHUOSHUO           [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID text UNIQUE,DiscussUser blob,POSITION text,Row text,add_fuser_state text, address text, audioCount text, avatar text,commentCount text,company text,form_state text,imgCount text,is_anoymous text,is_del text,is_good text,is_hide text,is_own text, jobNo text, jobids text, nick_name text,original_photos blob,post_remark text,praiseUser blob,sex text, share text, shareCount text, shareUser blob,share_farther_id text,share_title text,share_url text,sid text, small_photos blob, speak_add_time text, speak_address text,speak_browse_coun text,speak_check_state text,speak_comment_content text,speak_comment_state text, speak_latitude text,speak_longitude text,speak_praise_count text,speak_trends_person text,user_id text,videoCount text,shareMsg text)",POSITION_SHUOSHUO]

#define SQL_CREAT_MYREMEMBERSHUOSHUO           [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id text UNIQUE,DiscussUser blob,POSITION text,Row text,add_fuser_state text, address text, audioCount text, avatar text,commentCount text,company text,cstatus text,form_state text,guid text,imgCount text,is_anoymous text,is_del text,is_good text,is_hide text,is_own text, jobNo text, jobids text,mm text, nick_name text,original_photos blob,post_remark text,praiseUser blob,sex text, share text, shareCount text, shareUser blob,share_farther_id text,share_title text,share_url text,sid text, small_photos blob, speak_add_time text, speak_address text,speak_browse_coun text,speak_check_state text,speak_comment_content text,speak_comment_state text, speak_latitude text,speak_longitude text,speak_praise_count text,speak_trends_person text,user_id text,videoCount text,shareMsg text)",MYREMEMBERSHUOSHUO]

#define SQL_CREAT_BLACK_NAME            [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (userId text,userState text)",BLACK_NAME]

#define SQL_CREATE_MESSAGE              [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (messageID integer,sessionId text ,fromUserId text,toUserId text,content text, status integer, msgTime real, sessionType integer,messageContentType integer,messageType integer,info text,reserve1 integer,reserve2 text,primary key (messageID,sessionId))",TABLE_MESSAGE]

#define SQL_CREATE_MESSAGE_INDEX        [NSString stringWithFormat:@"CREATE INDEX msgid on %@(messageID)",TABLE_MESSAGE]

//singleSendId
#define SQL_CREATE_DEPARTMENTS      [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID text UNIQUE,parentID text,title text, description text,leader text, status integer,count integer)",TABLE_DEPARTMENTS]


#define SQL_CREATE_ALL_CONTACTS      [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID text UNIQUE,Name text,Nick text,Avatar text, Department text,DepartID text, Email text,Postion text,Telphone text,Sex integer,updated real,pyname text,signature text)",TABLE_ALL_CONTACTS]

#define SQL_CREATE_GROUPS     [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID text UNIQUE,Avatar text, GroupType integer, Name text,CreatID text,Users Text,LastMessage Text,updated real,isshield integer,version integer,isFixTop integer)",TABLE_GROUPS]

#define SQL_CREATE_CONTACTS_INDEX        [NSString stringWithFormat:@"CREATE UNIQUE ID on %@(ID)",TABLE_ALL_CONTACTS]

#define SQL_CREATE_RECENT_SESSION     [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID text UNIQUE,avatar text, type integer, name text,updated real,isshield integer,users Text , unreadCount integer, lasMsg text , lastMsgId integer,lastMsgFromUserId integer,lastMesageName text,singleSendId text,singleReceiveId text,isFixTop integer)",TABLE_RECENT_SESSION]

#define SQL_ADD_CONTACTS_SIGNATURE        [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN signature TEXT",TABLE_ALL_CONTACTS]

#define SQL_CREATE_SECOND_POSITION     [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (address text ,fatherID text,id text, industryID text,industryName text, layer text,positionID text,positionName text,recommend text,sid text)",SECOND_POSITION]

#define SQL_CREATE_INDUSTRY    [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (address text ,fatherID text,hotCount text, id text,industryID text, industryName text,layer text,recommend text,rowNumber text,sid text)",INDUSTRY]

#define SQL_CREATE_COMPANY     [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (companyId text ,company_name text,logo text)",COMPANY]

#define SQL_CREATE_PERSONALAPPLY   [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Hope_Position text ,WorkTim text,avatar text,birthday text,education text,id text,name text,sex text,sid text,txtcontent text,update_Time text,user_id text,type text,time text)",PERSONALAPPLY]

#define SQL_CREATE_COMPANYINVITE  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (enterprise_address text ,enterprise_name text,enterprise_properties text,enterprise_scale text,ep_Industry text,ep_id text,id text,jobPositon text,logo text,lookCount text,txtcontent text,update_Time text,user_id text,type text,time text)",COMPANYINVITE]




@implementation MTTDatabaseUtil
{
    FMDatabase* _database;
    FMDatabaseQueue* _dataBaseQueue;
}
+ (instancetype)instance
{
    static MTTDatabaseUtil* g_databaseUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_databaseUtil = [[MTTDatabaseUtil alloc] init];
        [NSString stringWithFormat:@""];
        
    });
    
    return g_databaseUtil;
}
-(void)reOpenNewDB
{
    
    [self openCurrentUserDB];
}
- (id)init
{
    self = [super init];
    if (self)
    {
        //初始化数据库
        [self openCurrentUserDB];
    }
    return self;
}

- (void)openCurrentUserDB
{
    if (_database)
    {
        [_database close];
        _database = nil;
    }
    _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:[MTTDatabaseUtil dbFilePath]];
    _database = [FMDatabase databaseWithPath:[MTTDatabaseUtil dbFilePath]];
    if (![_database open])
    {
        DDLog(@"打开数据库失败");
    }
    else
    {
        // 更新数据库字段增加signature
        if(![_database columnExists:@"signature" inTableWithName:@"allContacts"]){
            // 不存在,需要allContacts增加signature字段
            [_database executeUpdate:SQL_ADD_CONTACTS_SIGNATURE];
            // 版本号变0,全部重新获取用户信息
            __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@(0) forKey:@"alllastupdatetime"];
        }
        
        // 检查是否需要 重新获取数据
        NSInteger dbVersion = [MTTUtil getDBVersion];
        NSInteger lastDbVersion = [MTTUtil getLastDBVersion];
        if(dbVersion > lastDbVersion){
            //删除联系人数据 重新获取.
            [self clearTable:TABLE_ALL_CONTACTS];
            [self clearTable:TABLE_DEPARTMENTS];
            [self clearTable:TABLE_GROUPS];
            [self clearTable:TABLE_RECENT_SESSION];
            [self clearTable:BLACK_NAME];
            [self clearTable:POSITION_SHUOSHUO];
            [self clearTable:SECOND_POSITION];
            [self clearTable:COMPANY];
            [self clearTable:INDUSTRY];
            [self clearTable:PERSONALAPPLY];
            [self clearTable:COMPANYINVITE];
            [self clearTable:MYREMEMBERSHUOSHUO];
            [self clearTable:LINKMAN];
            [self clearTable:NEWFRIENDS];
            [self clearTable:MYGROUP];
            [self clearTable:FRIENDSCATEGORY];
            [self clearTable:FRIENDSCATEGORYDETAIL];
            [self clearTable:PHONELINKMAN];
            [self clearTable:PERSONALINFO];
            [self clearTable:GROUPINFO];
            [self clearTable:GROUPALBUM];
            [self clearTable:GROUPMENBER];
            [self clearTable:GROUPGONGGAO];
            [self clearTable:COLLECTIONLIST];
            [self clearTable:COLLECTIONDETAIL];
            [self clearTable:MYPERSONALINFO];
            [self clearTable:MYCOMPANYINFO];
            [self clearTable:MYAPPLYINFO];
            [self clearTable:ShuoShuoTOPIC];
            [self clearTable:MYINVITEINFO];
            [MTTUtil setLastDBVersion:dbVersion];
        }
        
        //创建
        [_dataBaseQueue inDatabase:^(FMDatabase *db) {
            if (![_database tableExists:TABLE_MESSAGE])
            {
                [self createTable:SQL_CREATE_MESSAGE];
            }
            if (![_database tableExists:TABLE_DEPARTMENTS])
            {
                [self createTable:SQL_CREATE_DEPARTMENTS];
            }
            if (![_database tableExists:TABLE_ALL_CONTACTS]) {
                [self createTable:SQL_CREATE_ALL_CONTACTS];
            }
            if (![_database tableExists:TABLE_GROUPS]) {
                [self createTable:SQL_CREATE_GROUPS];
            }
            if (![_database tableExists:TABLE_RECENT_SESSION]) {
                [self createTable:SQL_CREATE_RECENT_SESSION];
            }
            if (![_database tableExists:BLACK_NAME]) {
                [self createTable:SQL_CREAT_BLACK_NAME];
            }
            if (![_database tableExists:POSITION_SHUOSHUO]) {
                [self createTable:SQL_CREAT_POSITION_SHUOSHUO];
            }
            if (![_database tableExists:SECOND_POSITION]) {
                [self createTable:SQL_CREATE_SECOND_POSITION];
            }
            if (![_database tableExists:COMPANY]) {
                [self createTable:SQL_CREATE_COMPANY];
            }
            if (![_database tableExists:INDUSTRY]) {
                [self createTable:SQL_CREATE_INDUSTRY];
            }
            if (![_database tableExists:PERSONALAPPLY]) {
                [self createTable:SQL_CREATE_PERSONALAPPLY];
            }
            if (![_database tableExists:COMPANYINVITE]) {
                [self createTable:SQL_CREATE_COMPANYINVITE];
            }
            if (![_database tableExists:MYREMEMBERSHUOSHUO]) {
                [self createTable:SQL_CREAT_MYREMEMBERSHUOSHUO];
            }
            if (![_database tableExists:LINKMAN]) {
                [self createTable:SQL_CREAT_LINKMAN];
            }
            if (![_database tableExists:NEWFRIENDS]) {
                [self createTable:SQL_CREAT_NEWFRIENDS];
            }
            if (![_database tableExists:MYGROUP]) {
                [self createTable:SQL_CREAT_MYGROUP];
            }
            if (![_database tableExists:FRIENDSCATEGORY]) {
                [self createTable:SQL_CREAT_FRIENDSCATEGORY];
            }
            if (![_database tableExists:FRIENDSCATEGORYDETAIL]) {
                [self createTable:SQL_CREAT_FRIENDSCATEGORYDETAIL];
            }
            if (![_database tableExists:PHONELINKMAN]) {
                [self createTable:SQL_CREAT_PHONELINKMAN];
            }
            if (![_database tableExists:PERSONALINFO]) {
                [self createTable:SQL_CREAT_PERSONALINFO];
            }
            if (![_database tableExists:GROUPINFO]) {
                [self createTable:SQL_CREAT_GROUPINFO];
            }
            if (![_database tableExists:GROUPALBUM]) {
                [self createTable:SQL_CREAT_GROUPALBUM];
            }
            if (![_database tableExists:GROUPMENBER]) {
                [self createTable:SQL_CREAT_GROUPMENBER];
            }
            if (![_database tableExists:GROUPGONGGAO]) {
                [self createTable:SQL_CREAT_GROUPGONGGAO];
            }
            if (![_database tableExists:COLLECTIONLIST]) {
                [self createTable:SQL_CREAT_COLLECTIONLIST];
            }
            if (![_database tableExists:COLLECTIONDETAIL]) {
                [self createTable:SQL_CREAT_COLLECTIONDETAIL];
            }
            if (![_database tableExists:MYPERSONALINFO]) {
                [self createTable:SQL_CREAT_MYPERSONALINFO];
            }
            if (![_database tableExists:MYCOMPANYINFO]) {
                [self createTable:SQL_CREAT_MYCOMPANYINFO];
            }
            if (![_database tableExists:MYAPPLYINFO]) {
                [self createTable:SQL_CREAT_MYAPPLYINFO];
            }
            if (![_database tableExists:MYINVITEINFO]) {
                [self createTable:SQL_CREAT_MYINVITEINFO];
            }
            if (![_database tableExists:ShuoShuoTOPIC]) {
                [self createTable:SQL_CREAT_ShuoShuoTOPIC];
            }
        }];
    }
}

+(NSString *)dbFilePath
{
    NSString* directorPath = [NSString userExclusiveDirection];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //改用户的db是否存在，若不存在则创建相应的DB目录
    BOOL isDirector = NO;
    BOOL isExiting = [fileManager fileExistsAtPath:directorPath isDirectory:&isDirector];
    
    if (!(isExiting && isDirector))
    {
        BOOL createDirection = [fileManager createDirectoryAtPath:directorPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        if (!createDirection)
        {
        }
    }
    NSString *dbPath = [directorPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",TheRuntime.user.objID,DB_FILE_NAME]];
    NSLog(@"本地数据库文件位置 %@", dbPath);
    return dbPath;
}

-(BOOL)createTable:(NSString *)sql          //创建表
{
    BOOL result = NO;
    [_database setShouldCacheStatements:YES];
    NSString *tempSql = [NSString stringWithFormat:@"%@",sql];
    result = [_database executeUpdate:tempSql];
    // [_database executeUpdate:SQL_CREATE_MESSAGE_INDEX];
    //BOOL dd =[_database executeUpdate:SQL_CREATE_CONTACTS_INDEX];
    
    return result;
}
-(BOOL)clearTable:(NSString *)tableName
{
    BOOL result = NO;
    [_database setShouldCacheStatements:YES];
    NSString *tempSql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    result = [_database executeUpdate:tempSql];
    //    [_database executeUpdate:SQL_CREATE_MESSAGE_INDEX];
    //    //BOOL dd =[_database executeUpdate:SQL_CREATE_CONTACTS_INDEX];
    //
    return result;
}
#pragma mark 职场说说话题
-(void)uploadTopic:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?)",ShuoShuoTOPIC];
                BOOL result = [_database executeUpdate:sql,dic[@"id"],dic[@"CoutSum"],dic[@"icon_url"],dic[@"remarks"],dic[@"sid"],dic[@"sort"],dic[@"type_name"],dic[@"user_id"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getShuoShuoTopic:(NSString*)num success:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ limit ?,?",ShuoShuoTOPIC];
        FMResultSet * result = [_database executeQuery:sql,num.numberValue,[NSNumber numberWithInt:10]];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary * dic = [self getShuoTopic:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary *)getShuoTopic:(FMResultSet*)resultSet
{
    NSString* CoutSum = [resultSet stringForColumn:@"CoutSum"];
    NSString* icon_url = [resultSet stringForColumn:@"icon_url"];
    NSString* remarks = [resultSet stringForColumn:@"remarks"];
    NSString* sid = [resultSet stringForColumn:@"sid"];
    NSString* sort = [resultSet stringForColumn:@"sort"];
    NSString* type_name = [resultSet stringForColumn:@"type_name"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* hid = [resultSet stringForColumn:@"id"];
    NSDictionary * dic = @{@"CoutSum":CoutSum,@"icon_url":icon_url,
                           @"remarks":remarks,
                           @"sid":sid,
                           @"sort":sort,@"type_name":type_name,@"user_id":user_id,@"id":hid};
    return dic;
}
#pragma mark 我发布的招聘
-(void)updateMyInvite:(NSDictionary*)dictionary
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            NSArray * array = dictionary[@"list"];
            
            NSMutableArray * deleteIDArr = [NSMutableArray array];
            
            NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",MYINVITEINFO];   //本地
            FMResultSet * result = [_database executeQuery:sql];
            
            while ([result next])
            {//
                for (int i = 0; i < array.count; i++) {
                    NSDictionary*dicObj = array[i];
                    NSDictionary*dic =[self myInvite:result];
                    if ([dic[@"id"] isEqualToString:dicObj[@"id"]]) {
                        continue;
                    }else if (i == (array.count - 1)){
                        [deleteIDArr addObject:dic[@"id"]];
                    }
                }
            }
            
            for (NSString * idString in deleteIDArr) {
                NSString* sql = @"DELETE FROM myInviteInfo WHERE id = ?";
                [_database executeUpdate:sql,idString];
            }
            
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",MYINVITEINFO];
                BOOL result = [_database executeUpdate:sql,dic[@"id"],dictionary[@"attention_state"],dictionary[@"avatar"],dictionary[@"company"],dic[@"ep_id"], dictionary[@"info"],dictionary[@"nick_name"],dictionary[@"position"],dictionary[@"user_id"],dic[@"UnReadCount"],dic[@"avatar"],dic[@"comcount"],dic[@"dataIndustry"],dic[@"enterprise_address"],dic[@"enterprise_brief"],dic[@"enterprise_name"],dic[@"enterprise_properties"],dic[@"enterprise_scale"],dic[@"epname"],dic[@"is_auto"],dic[@"pageView"],dic[@"position"],dic[@"ranking"],dic[@"resumeId"],dic[@"shareCount"],dic[@"shelvesDown"],dic[@"signCount"],dic[@"signUp"],dic[@"sys_count"],dic[@"sys_message"],dic[@"update_Time"],dic[@"user_id"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
            }
            else
            {
                [_database commit];
            }
        }
    }];
    
}
-(void)getMyInvite:(void(^)(NSDictionary*dic))success
{

    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",MYINVITEINFO];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self myInvite:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (muarray.count) {
                NSDictionary * dic = muarray[0];
                NSDictionary * dictionary = @{@"attention_state":dic[@"attention_state"],@"avatar":dic[@"avatar1"],@"company":dic[@"company"],@"info":dic[@"info"],@"nick_name":dic[@"nick_name"],@"position":dic[@"position"],@"user_id":dic[@"user_id"],@"list":muarray};
                success(dictionary);
            }
            else
            {
                success(nil);
            }
        });
    }];
}

-(void)deleteMyInvite:(NSString*)applyID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myInviteInfo WHERE id = ?";
        [_database executeUpdate:sql,applyID];
    }];
}
-(void)deleteAllInvite
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myInviteInfo";
        [_database executeUpdate:sql];
    }];
}
-(NSDictionary*)myInvite:(FMResultSet*)resultSet
{
    NSString* attention_state = [resultSet stringForColumn:@"attention_state"];
    NSString* avatar1 = [resultSet stringForColumn:@"avatar1"];
    NSString* company = [resultSet stringForColumn:@"company"];
    NSString* info = [resultSet stringForColumn:@"info"];
    NSString* nick_name = [resultSet stringForColumn:@"nick_name"];
    NSString* position1 = [resultSet stringForColumn:@"position1"];
    NSString* user_id1 = [resultSet stringForColumn:@"user_id1"];
    NSString* ep_id = [resultSet stringForColumn:@"ep_id"];
    NSString* UnReadCount = [resultSet stringForColumn:@"UnReadCount"];
    NSString* avatar = [resultSet stringForColumn:@"avatar"];
    NSString* comcount = [resultSet stringForColumn:@"comcount"];
    NSString* dataIndustry = [resultSet stringForColumn:@"dataIndustry"];
    NSString* hid = [resultSet stringForColumn:@"id"];
    NSString* enterprise_address = [resultSet stringForColumn:@"enterprise_address"];
    NSString* enterprise_brief = [resultSet stringForColumn:@"enterprise_brief"];
    NSString* enterprise_name = [resultSet stringForColumn:@"enterprise_name"];
    NSString* enterprise_properties = [resultSet stringForColumn:@"enterprise_properties"];
    NSString* enterprise_scale = [resultSet stringForColumn:@"enterprise_scale"];
    NSString* epname = [resultSet stringForColumn:@"epname"];
    NSString* is_auto = [resultSet stringForColumn:@"is_auto"];
    NSString* pageView = [resultSet stringForColumn:@"pageView"];
    NSString* position = [resultSet stringForColumn:@"position"];
    NSString* ranking = [resultSet stringForColumn:@"ranking"];
    NSString* resumeId = [resultSet stringForColumn:@"resumeId"];
    NSString* shareCount = [resultSet stringForColumn:@"shareCount"];
    NSString* shelvesDown = [resultSet stringForColumn:@"shelvesDown"];
    
    NSString* signCount = [resultSet stringForColumn:@"signCount"];
    NSString* signUp = [resultSet stringForColumn:@"signUp"];
    NSString* sys_count = [resultSet stringForColumn:@"sys_count"];
    NSString* sys_message = [resultSet stringForColumn:@"sys_message"];
    NSString* update_Time = [resultSet stringForColumn:@"update_Time"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSDictionary * dic = @{@"attention_state":attention_state,@"avatar1":avatar1,
                           @"company":company,
                           @"info":info,
                           @"nick_name":nick_name,@"position1":position1,@"user_id1":user_id1,
                           @"UnReadCount":UnReadCount,
                           @"avatar":avatar,
                           @"comcount":comcount,
                           @"dataIndustry":dataIndustry,@"id":hid
                           ,@"enterprise_address":enterprise_address,
                           @"enterprise_brief":enterprise_brief,
                           @"enterprise_name":enterprise_name,
                           @"enterprise_properties":enterprise_properties,@"enterprise_scale":enterprise_scale
                           ,@"epname":epname,
                           @"is_auto":is_auto,
                           @"pageView":pageView,
                           @"position":position,@"ranking":ranking,
                           @"ep_id":ep_id,
                           @"resumeId":resumeId,
                           @"shareCount":shareCount,@"shelvesDown":shelvesDown
                           ,
                           @"signCount":signCount,
                           @"signUp":signUp,@"sys_count":sys_count
                           ,
                           @"sys_message":sys_message,
                           @"update_Time":update_Time,@"user_id":user_id};
    return dic;
}
#pragma mark 我发布的求职
-(void)upDateMyApply:(NSDictionary*)dictionary
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {

            NSMutableArray * deleteIDArr = [NSMutableArray array];
            NSArray * array = dictionary[@"list"];// 服务器
            
            NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",MYAPPLYINFO];   //本地
            FMResultSet * result = [_database executeQuery:sql];
            
            while ([result next])
            {
                for (int i = 0; i < array.count; i++) {
                    NSDictionary*dicObj = array[i];
                    NSDictionary*dic =[self myAplyDic:result];
                    if ([dic[@"resume_user_id"] isEqualToString:dicObj[@"resume_user_id"]]) {
                        continue;
                    }else if (i == (array.count - 1)){
                        [deleteIDArr addObject:dic[@"resume_user_id"]];
                    }
                }
            }
            
            for (NSString * idString in deleteIDArr) {
                NSString* sql = @"DELETE FROM myApplyInfo WHERE resume_user_id = ?";
                [_database executeUpdate:sql,idString];
            }
            
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",MYAPPLYINFO];
                BOOL result = [_database executeUpdate:sql,dic[@"id"],dictionary[@"attention_state"],dictionary[@"avatar"],dictionary[@"company"], dictionary[@"info"],dictionary[@"nick_name"],dictionary[@"position"],dictionary[@"user_id"],dic[@"age"],dic[@"avatar"],dic[@"comcount"],dic[@"education"],dic[@"nike_name"],dic[@"pageView"],dic[@"position"],dic[@"ranking"],dic[@"resumeId"],dic[@"sex"],dic[@"shareCount"],dic[@"signUp"],dic[@"sys_message"],dic[@"txtcontent"],dic[@"update_Time"],dic[@"user_id"],dic[@"worktime"],dic[@"resume_user_id"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
            
            
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getMyApply:(void(^)(NSDictionary*))success
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",MYAPPLYINFO];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self myAplyDic:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (muarray.count) {
                NSDictionary * dic = muarray[0];
                NSDictionary * dictionary = @{@"attention_state":dic[@"attention_state"],@"avatar":dic[@"avatar1"],@"company":dic[@"company"],@"info":dic[@"info"],@"nick_name":dic[@"nick_name"],@"position":dic[@"position"],@"user_id":dic[@"user_id"],@"list":muarray};
                success(dictionary);
            }
            else
            {
                success(nil);
            }
        });
    }];
}
-(NSDictionary*)myAplyDic:(FMResultSet*)resultSet
{
    NSString* attention_state = [resultSet stringForColumn:@"attention_state"];
    NSString* avatar1 = [resultSet stringForColumn:@"avatar1"];
    NSString* company = [resultSet stringForColumn:@"company"];
    NSString* info = [resultSet stringForColumn:@"info"];
    NSString* nick_name = [resultSet stringForColumn:@"nick_name"];
    NSString* position1 = [resultSet stringForColumn:@"position1"];
    NSString* user_id1 = [resultSet stringForColumn:@"user_id1"];
    NSString * resume_user_id = [resultSet stringForColumn:@"resume_user_id"];
    NSString* age = [resultSet stringForColumn:@"age"];
    NSString* avatar = [resultSet stringForColumn:@"avatar"];
    NSString* comcount = [resultSet stringForColumn:@"comcount"];
    NSString* education = [resultSet stringForColumn:@"education"];
    NSString* hid = [resultSet stringForColumn:@"id"];
    NSString* nike_name = [resultSet stringForColumn:@"nike_name"];
    NSString* pageView = [resultSet stringForColumn:@"pageView"];
    NSString* position = [resultSet stringForColumn:@"position"];
    NSString* ranking = [resultSet stringForColumn:@"ranking"];
    NSString* resumeId = [resultSet stringForColumn:@"resumeId"];
    NSString* sex = [resultSet stringForColumn:@"sex"];
    NSString* shareCount = [resultSet stringForColumn:@"shareCount"];
    NSString* signUp = [resultSet stringForColumn:@"signUp"];
    NSString* sys_message = [resultSet stringForColumn:@"sys_message"];
    NSString* txtcontent = [resultSet stringForColumn:@"txtcontent"];
    NSString* update_Time = [resultSet stringForColumn:@"update_Time"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* worktime = [resultSet stringForColumn:@"worktime"];
    
    NSDictionary * dic = @{@"attention_state":attention_state,
                           @"avatar1":avatar1,
                           @"company":company,
                           @"info":info,
                           @"nick_name":nick_name,
                           @"position1":position1,
                           @"user_id1":user_id1,
                           @"age":age,
                           @"avatar":avatar,
                           @"comcount":comcount,
                           @"education":education,
                           @"id":hid,
                           @"nike_name":nike_name,
                           @"pageView":pageView,
                           @"position":position,
                           @"ranking":ranking,
                           @"resumeId":resumeId,
                           @"resume_user_id":resume_user_id,
                           @"sex":sex,
                           @"shareCount":shareCount,
                           @"signUp":signUp,
                           @"sys_message":sys_message,
                           @"txtcontent":txtcontent,
                           @"update_Time":update_Time,
                           @"user_id":user_id,
                           @"worktime":worktime};
    return dic;
}
-(void)deleteMyApply:(NSString*)applyID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myApplyInfo WHERE id = ?";
        [_database executeUpdate:sql,applyID];
    }];
}
-(void)deleteAllMyApply
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myApplyInfo";
        [_database executeUpdate:sql];
    }];
}




#pragma mark 我的企业
-(void)upDateMyCompanyInfo:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            
            //去删除我的招聘对应的企业id招聘本地数据
            
            NSMutableArray * deleteIDArr = [NSMutableArray array];
            
            NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",MYINVITEINFO];   //本地
            FMResultSet * result = [_database executeQuery:sql];
            
            while ([result next])
            {//
                for (int i = 0; i < array.count; i++) {
                    NSDictionary*dicObj = array[i];
                    NSDictionary*dic =[self myInvite:result];
                    if ([dic[@"ep_id"] isEqualToString:dicObj[@"ep_id"]]) {
                        continue;
                    }else if (i == (array.count - 1)){
                        [deleteIDArr addObject:dic[@"ep_id"]];
                    }
                }
            }
            
            for (NSString * idString in deleteIDArr) {
                NSString* sql = @"DELETE FROM myInviteInfo WHERE ep_id = ?";
                [_database executeUpdate:sql,idString];
            }
            
            
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?)",MYCOMPANYINFO];
                BOOL result = [_database executeUpdate:sql,dic[@"QR_code"],dic[@"dataIndustry"],dic[@"enterprise_name"],dic[@"enterprise_properties"],dic[@"enterprise_scale"],dic[@"ep_id"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getMyComoanyInfo:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",MYCOMPANYINFO];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self myCompanyInfo:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)myCompanyInfo:(FMResultSet*)resultSet
{
    NSString* QR_code = [resultSet stringForColumn:@"QR_code"];
    NSString* dataIndustry = [resultSet stringForColumn:@"dataIndustry"];
    NSString* enterprise_name = [resultSet stringForColumn:@"enterprise_name"];
    NSString* enterprise_properties = [resultSet stringForColumn:@"enterprise_properties"];
    NSString* enterprise_scale = [resultSet stringForColumn:@"enterprise_scale"];
    NSString* ep_id = [resultSet stringForColumn:@"ep_id"];
    NSDictionary * dic = @{@"QR_code":QR_code,@"dataIndustry":dataIndustry,
                           @"enterprise_name":enterprise_name,
                           @"enterprise_properties":enterprise_properties,
                           @"enterprise_scale":enterprise_scale,@"ep_id":ep_id};
    return dic;
}
-(void)deleteMyCompoanyInfo
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myCompanyInfo";
        [_database executeUpdate:sql];
    }];
}
#pragma mark 个人信息
-(void)upDateMyPersonalInfo:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            
            NSMutableArray * deleteIDArr = [NSMutableArray array];
            
            NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",MYAPPLYINFO];   //本地
            FMResultSet * result = [_database executeQuery:sql];
            
            while ([result next])
            {
                for (int i = 0; i < array.count; i++) {
                    NSDictionary*dicObj = array[i];
                    NSDictionary*dic =[self myAplyDic:result];
                    if ([dic[@"id"] isEqualToString:dicObj[@"id"]]) {
                        continue;
                    }else if (i == (array.count - 1)){
                        [deleteIDArr addObject:dic[@"id"]];
                    }
                }
            }
            
            for (NSString * idString in deleteIDArr) {
                NSString* sql = @"DELETE FROM myApplyInfo WHERE id = ?";
                [_database executeUpdate:sql,idString];
            }
            
            
            
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                
                NSArray * photoArray = dic[@"PhotoList"];
                NSArray * videoArray = dic[@"VideoList"];
                NSData * imageData = [NSKeyedArchiver archivedDataWithRootObject:photoArray];
                NSData * urlData = [NSKeyedArchiver archivedDataWithRootObject:videoArray];
                
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",MYPERSONALINFO];
                BOOL result = [_database executeUpdate:sql,dic[@"Address_id"],imageData,dic[@"Position"],dic[@"PositionNo"],dic[@"Tel"],urlData,dic[@"WorkTime"],dic[@"address"],dic[@"age"],dic[@"birthday"],dic[@"cardNo"],dic[@"cardType"],dic[@"companyName"],dic[@"education"],dic[@"email"],dic[@"homeTown"],dic[@"homeTown_id"],dic[@"industry"],dic[@"industryNo"],dic[@"isDefault"],dic[@"lightspot"],dic[@"marriage"],dic[@"name"],dic[@"nowSalary"],dic[@"nowSalaryType"],dic[@"qq"],dic[@"sex"],dic[@"sid"],dic[@"user_avatar"],dic[@"webchat"],dic[@"workexperience"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getMyPersonalInfo:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",MYPERSONALINFO];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self myaPersonalInfo:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)myaPersonalInfo:(FMResultSet*)resultSet
{
    NSString* Address_id = [resultSet stringForColumn:@"Address_id"];
    NSString* Position = [resultSet stringForColumn:@"Position"];
    NSString* PositionNo = [resultSet stringForColumn:@"PositionNo"];
    NSString* Tel = [resultSet stringForColumn:@"Tel"];
    NSString* WorkTime = [resultSet stringForColumn:@"WorkTime"];
    NSString* address = [resultSet stringForColumn:@"address"];
    NSString* age = [resultSet stringForColumn:@"age"];
    NSString* birthday = [resultSet stringForColumn:@"birthday"];
    NSString* cardNo = [resultSet stringForColumn:@"cardNo"];
    NSString* cardType = [resultSet stringForColumn:@"cardType"];
    NSString* companyName = [resultSet stringForColumn:@"companyName"];
    NSString* education = [resultSet stringForColumn:@"education"];
    NSString* email = [resultSet stringForColumn:@"email"];
    NSString* homeTown = [resultSet stringForColumn:@"homeTown"];
    NSString* homeTown_id = [resultSet stringForColumn:@"homeTown_id"];
    NSString* industry = [resultSet stringForColumn:@"industry"];
    NSString* industryNo = [resultSet stringForColumn:@"industryNo"];
    NSString* isDefault = [resultSet stringForColumn:@"isDefault"];
    NSString* lightspot = [resultSet stringForColumn:@"lightspot"];
    NSString* marriage = [resultSet stringForColumn:@"marriage"];
    NSString* name = [resultSet stringForColumn:@"name"];
    NSString* nowSalary = [resultSet stringForColumn:@"nowSalary"];
    NSString* nowSalaryType = [resultSet stringForColumn:@"nowSalaryType"];
    NSString* qq = [resultSet stringForColumn:@"qq"];
    NSString* sex = [resultSet stringForColumn:@"sex"];
    NSString* sid = [resultSet stringForColumn:@"sid"];
    NSString* user_avatar = [resultSet stringForColumn:@"user_avatar"];
    NSString* webchat = [resultSet stringForColumn:@"webchat"];
    NSString* workexperience = [resultSet stringForColumn:@"workexperience"];
    
    NSData * imageData = [resultSet dataForColumn:@"PhotoList"];
    NSData * urlData = [resultSet dataForColumn:@"VideoList"];
    NSArray * imageArray =[NSKeyedUnarchiver unarchiveObjectWithData:imageData];
    NSArray * urlArray = [NSKeyedUnarchiver unarchiveObjectWithData:urlData];
    
    NSDictionary * dic = @{@"Address_id":Address_id,@"PhotoList":imageArray,@"Position":Position,
                           @"PositionNo":PositionNo,
                           @"Tel":Tel,@"VideoList":urlArray,@"WorkTime":WorkTime,
                           @"address":address,
                           @"age":age
                           ,@"birthday":birthday,
                           @"cardNo":cardNo,
                           @"cardType":cardType
                           ,
                           @"companyName":companyName,@"education":education,@"email":email,
                           @"homeTown":homeTown,
                           @"homeTown_id":homeTown_id
                           ,@"industryNo":industryNo,
                           @"isDefault":isDefault,
                           @"lightspot":lightspot,
                           @"marriage":marriage
                           ,
                           @"name":name,@"nowSalary":nowSalary,@"nowSalaryType":nowSalaryType,
                           @"qq":qq,
                           @"sex":sex,
                           @"sid":sid
                           ,
                           @"user_avatar":user_avatar
                           ,@"webchat":webchat,
                           @"workexperience":workexperience,@"industry":industry};
    return dic;
}
-(void)deleteMyPersonalInfo:(NSString*)infoID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myPersonalInfo WHERE sid = ?";
        [_database executeUpdate:sql,infoID];
    }];
}
-(void)deleteAllMyPersonalInfo
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myPersonalInfo";
        [_database executeUpdate:sql];
    }];
}
#pragma mark 收藏列表详情
-(void)upDateCollectionDetail:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                
                NSArray * imageArray = dic[@"img_url"];
                NSArray * urlArray = dic[@"url"];
                NSData * imageData = [NSKeyedArchiver archivedDataWithRootObject:imageArray];
                NSData * urlData = [NSKeyedArchiver archivedDataWithRootObject:urlArray];
                
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",COLLECTIONDETAIL];
                BOOL result = [_database executeUpdate:sql,dic[@"add_time"],dic[@"address"],dic[@"avatar"],dic[@"classN"],dic[@"classType"],dic[@"col1"],dic[@"col2"],dic[@"col3"],dic[@"col4"],dic[@"col5"],dic[@"col6"],dic[@"col7"],dic[@"companName"],dic[@"company"],dic[@"content"],dic[@"id"],imageData,dic[@"jobid"],dic[@"nick_name"],dic[@"nick_title"],dic[@"position"],dic[@"share"],dic[@"speak_class"],dic[@"title"],urlData,dic[@"user_id"],dic[@"wp_id"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getCollectionDetail:(NSString*)detailID success:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE classType = ?",COLLECTIONDETAIL];
        FMResultSet * result = [_database executeQuery:sql,detailID];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self collectionDetail:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)collectionDetail:(FMResultSet*)resultSet
{
    NSString* add_time = [resultSet stringForColumn:@"add_time"];
    NSString* address = [resultSet stringForColumn:@"address"];
    NSString* avatar = [resultSet stringForColumn:@"avatar"];
    NSString* classN = [resultSet stringForColumn:@"classN"];
    NSString* classType = [resultSet stringForColumn:@"classType"];
    NSString* col1 = [resultSet stringForColumn:@"col1"];
    NSString* col2 = [resultSet stringForColumn:@"col2"];
    NSString* col3 = [resultSet stringForColumn:@"col3"];
    NSString* col4 = [resultSet stringForColumn:@"col4"];
    NSString* col5 = [resultSet stringForColumn:@"col5"];
    NSString* col6 = [resultSet stringForColumn:@"col6"];
    NSString* col7 = [resultSet stringForColumn:@"col7"];
    NSString* companName = [resultSet stringForColumn:@"companName"];
    NSString* company = [resultSet stringForColumn:@"company"];
    NSString* content = [resultSet stringForColumn:@"content"];
    NSString* hid = [resultSet stringForColumn:@"id"];
    NSString* jobid = [resultSet stringForColumn:@"jobid"];
    NSString* nick_name = [resultSet stringForColumn:@"nick_name"];
    NSString* nick_title = [resultSet stringForColumn:@"nick_title"];
    NSString* position = [resultSet stringForColumn:@"position"];
    NSString* share = [resultSet stringForColumn:@"share"];
    NSString* speak_class = [resultSet stringForColumn:@"speak_class"];
    NSString* title = [resultSet stringForColumn:@"title"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* wp_id = [resultSet stringForColumn:@"wp_id"];
    
    NSData * imageData = [resultSet dataForColumn:@"img_url"];
    NSData * urlData = [resultSet dataForColumn:@"url"];
    NSArray * imageArray =[NSKeyedUnarchiver unarchiveObjectWithData:imageData];
    NSArray * urlArray = [NSKeyedUnarchiver unarchiveObjectWithData:urlData];
    
    NSDictionary * dic = @{@"add_time":add_time,@"address":address,@"avatar":avatar,
                           @"classN":classN,
                           @"classType":classType,@"col1":col1,@"col2":col2,
                           @"col3":col3,
                           @"col4":col4
                           ,@"col5":col5,
                           @"col6":col6,
                           @"col7":col7
                           ,
                           @"companName":companName,@"company":company,@"content":content,
                           @"id":hid,
                           @"img_url":imageArray
                           ,@"jobid":jobid,
                           @"nick_name":nick_name,
                           @"nick_title":nick_title
                           ,
                           @"position":position,@"share":share,@"speak_class":speak_class,
                           @"title":title,
                           @"url":urlArray
                           ,@"user_id":user_id,
                           @"wp_id":wp_id};
    return dic;
}
-(void)deleteCollectionDetail:(NSString*)classType
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM collectionDetail WHERE classType = ?";
        [_database executeUpdate:sql,classType];
    }];
}
-(void)deleteCollectionDetail:(NSString*)classTyPe and:(NSString*)detailID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM collectionDetail WHERE classType = ? AND id = ?";
        [_database executeUpdate:sql,classTyPe,detailID];
    }];
}
#pragma mark 收藏列表
-(void)upDateCollectionList:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?)",COLLECTIONLIST];
                BOOL result = [_database executeUpdate:sql,dic[@"add_time"],dic[@"id"],dic[@"typename"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getCollectionList:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",COLLECTIONLIST];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self collectionDic:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)collectionDic:(FMResultSet*)resultSet
{
    NSString* add_time = [resultSet stringForColumn:@"add_time"];
    NSString* hid = [resultSet stringForColumn:@"id"];
    NSString* typename = [resultSet stringForColumn:@"typename"];
    NSDictionary * dic = @{@"add_time":add_time,@"id":hid,@"typename":typename};
    return dic;
}
-(void)deleteCollectionList:(NSString*)collectionID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM collectionList WHERE id = ?";
        [_database executeUpdate:sql,collectionID];
    }];
}
-(void)deleteAllCollectionList
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM collectionList";
        [_database executeUpdate:sql];
    }];
}
#pragma mark 群公告
-(void)upDataGroupGongGao:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",GROUPGONGGAO];
                BOOL result = [_database executeUpdate:sql,dic[@"DistanceTime"],dic[@"add_time"],dic[@"group_id"],dic[@"group_name"],dic[@"id"],dic[@"isEdit"],dic[@"nick_name"],dic[@"notice_content"],dic[@"notice_photo"],dic[@"notice_title"],dic[@"user_id"],dic[@"user_name"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getGroupGongGao:(NSString*)groupID success:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE group_id = ?",GROUPGONGGAO];
        FMResultSet * result = [_database executeQuery:sql,groupID];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self groupGongGao:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)groupGongGao:(FMResultSet*)resultSet
{
    NSString* DistanceTime = [resultSet stringForColumn:@"DistanceTime"];
    NSString* add_time = [resultSet stringForColumn:@"add_time"];
    NSString* group_id = [resultSet stringForColumn:@"group_id"];
    NSString* group_name = [resultSet stringForColumn:@"group_name"];
    NSString* hid = [resultSet stringForColumn:@"id"];
    NSString* isEdit = [resultSet stringForColumn:@"isEdit"];
    NSString* nick_name = [resultSet stringForColumn:@"nick_name"];
    NSString* notice_content = [resultSet stringForColumn:@"notice_content"];
    NSString* notice_photo = [resultSet stringForColumn:@"notice_photo"];
    NSString* notice_title = [resultSet stringForColumn:@"notice_title"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* user_name = [resultSet stringForColumn:@"user_name"];
    
    NSDictionary * dic = @{@"DistanceTime":DistanceTime,@"add_time":add_time,@"group_id":group_id,
                           @"id":hid,
                           @"isEdit":isEdit,@"nick_name":nick_name,@"notice_content":notice_content,
                           @"group_name":group_name,
                           @"notice_photo":notice_photo
                           ,@"notice_title":notice_title,
                           @"user_id":user_id,
                           @"user_name":user_name};
    return dic;
}
-(void)deleteGroupGongGao:(NSString*)groupID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM groupGongGao WHERE group_id = ?";
        [_database executeUpdate:sql,groupID];
    }];
}
-(void)deleteGroupGongGao:(NSString*)groupId gong:(NSString*)gongGaoID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM groupGongGao WHERE group_id = ? AND id = ?";
        [_database executeUpdate:sql,groupId,gongGaoID];
    }];
}
#pragma mark 群成员
-(void)upDateGroupMember:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?)",GROUPMENBER];
                BOOL result = [_database executeUpdate:sql,dic[@"admin"],dic[@"avatar"],dic[@"is_create"],dic[@"nick_name"],dic[@"post_remark"],dic[@"remark_name"],dic[@"user_id"],dic[@"user_name"],dic[@"group_id"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getGroupMember:(NSString*)groupID success:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE group_id = ?",GROUPMENBER];
        FMResultSet * result = [_database executeQuery:sql,groupID];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self groupMember:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)groupMember:(FMResultSet*)resultSet
{
    NSString* admin = [resultSet stringForColumn:@"admin"];
    NSString* avatar = [resultSet stringForColumn:@"avatar"];
    NSString* is_create = [resultSet stringForColumn:@"is_create"];
    NSString* nick_name = [resultSet stringForColumn:@"nick_name"];
    NSString* post_remark = [resultSet stringForColumn:@"post_remark"];
    NSString* remark_name = [resultSet stringForColumn:@"remark_name"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* user_name = [resultSet stringForColumn:@"user_name"];
    NSString* group_id = [resultSet stringForColumn:@"group_id"];
    
    NSDictionary * dic = @{@"admin":admin,@"avatar":avatar,@"is_create":is_create,
                           @"nick_name":nick_name,
                           @"post_remark":post_remark,@"remark_name":remark_name,@"user_id":user_id,
                           @"user_name":user_name,
                           @"group_id":group_id};
    return dic;
}
-(void)deleteGroupMember:(NSString*)groupID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM groupMember WHERE group_id = ?";
        [_database executeUpdate:sql,groupID];
    }];
}
#pragma mark 群相册
-(void)upDateGroupAlbum:(NSArray*)array groupID:(NSString*)groupid
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                NSArray * CommentList = dic[@"CommentList"];
                NSArray * PhotoList = dic[@"PhotoList"];
                NSArray * PraiseList = dic[@"PraiseList"];
                
                
                NSData * commenData = [NSKeyedArchiver archivedDataWithRootObject:CommentList];
                NSData * photoData = [NSKeyedArchiver archivedDataWithRootObject:PhotoList];
                NSData * praiseData = [NSKeyedArchiver archivedDataWithRootObject:PraiseList];
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",GROUPALBUM];
                BOOL result = [_database executeUpdate:sql,commenData,photoData,praiseData,dic[@"add_time"],dic[@"address"],dic[@"album_name"],dic[@"albumnId"],dic[@"avatar"],dic[@"commentCount"],dic[@"company"],dic[@"cr_user_id"],dic[@"created_user_id"],dic[@"folder_id"],dic[@"isAttent"],dic[@"latitude"],dic[@"longitude"],dic[@"myPraise"],dic[@"photoNum"],dic[@"position"],dic[@"praiseCount"],dic[@"remark"],dic[@"user_name"],groupid];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getAllAlbum:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",GROUPALBUM];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self albumInfo:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(void)getGroupAlbum:(NSString*)groupAlbumID success:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE albumnId = ?",GROUPALBUM];
        FMResultSet * result = [_database executeQuery:sql,groupAlbumID];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self albumInfo:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)albumInfo:(FMResultSet*)resultSet
{
    NSString* add_time = [resultSet stringForColumn:@"add_time"];
    NSString* address = [resultSet stringForColumn:@"address"];
    NSString* album_name = [resultSet stringForColumn:@"album_name"];
    NSString* albumnId = [resultSet stringForColumn:@"albumnId"];
    NSString* avatar = [resultSet stringForColumn:@"avatar"];
    NSString* commentCount = [resultSet stringForColumn:@"commentCount"];
    NSString* company = [resultSet stringForColumn:@"company"];
    NSString* cr_user_id = [resultSet stringForColumn:@"cr_user_id"];
    NSString* created_user_id = [resultSet stringForColumn:@"created_user_id"];
    NSString* folder_id = [resultSet stringForColumn:@"folder_id"];
    NSString* isAttent = [resultSet stringForColumn:@"isAttent"];
    NSString* latitude = [resultSet stringForColumn:@"latitude"];
    NSString* longitude = [resultSet stringForColumn:@"longitude"];
    NSString* myPraise = [resultSet stringForColumn:@"myPraise"];
    NSString* photoNum = [resultSet stringForColumn:@"photoNum"];
    NSString* position = [resultSet stringForColumn:@"position"];
    NSString* praiseCount = [resultSet stringForColumn:@"praiseCount"];
    NSString* remark = [resultSet stringForColumn:@"remark"];
    NSString* user_name = [resultSet stringForColumn:@"user_name"];
    NSString * group_id = [resultSet stringForColumn:@"group_id"];
    
    NSData * commenData = [resultSet dataForColumn:@"CommentList"];
    NSData * photoData= [resultSet dataForColumn:@"PhotoList"];
    NSData * praiseData = [resultSet dataForColumn:@"PraiseList"];
    NSArray * menArray = [NSKeyedUnarchiver unarchiveObjectWithData:commenData];
    NSArray * noticeArray = [NSKeyedUnarchiver unarchiveObjectWithData:photoData];
    NSArray * photoArray = [NSKeyedUnarchiver unarchiveObjectWithData:praiseData];
    
    NSDictionary * dic = @{@"CommentList":menArray,@"PhotoList":noticeArray,@"PraiseList":photoArray,
                           @"add_time":add_time,
                           @"address":address,@"album_name":album_name,@"albumnId":albumnId,
                           @"avatar":avatar,
                           @"commentCount":commentCount,@"company":company,@"cr_user_id":cr_user_id,
                           @"created_user_id":created_user_id,
                           @"folder_id":folder_id,@"isAttent":isAttent,@"latitude":latitude,
                           @"longitude":longitude,
                           @"myPraise":myPraise,@"photoNum":photoNum,@"position":position,
                           @"praiseCount":praiseCount,
                           @"remark":remark,
                           @"user_name":user_name,
                           @"group_id":group_id};
    return dic;
}
-(void)deleteAllAlbum
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM groupAlbum";
        [_database executeUpdate:sql];
    }];
}
-(void)deleteAlbum:(NSString*)albumID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM groupAlbum WHERE group_id = ?";
        [_database executeUpdate:sql,albumID];
    }];
}
#pragma mark 群组资料
-(void)upDateGroupInfo:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary*dic = (NSDictionary*)obj;
                NSArray * MenberList = dic[@"MenberList"];
                NSArray * NoticeList = dic[@"NoticeList"];
                NSArray * PhotoList = dic[@"PhotoList"];
                NSArray * iconList = dic[@"iconList"];
                
                NSData * MenberData = [NSKeyedArchiver archivedDataWithRootObject:MenberList];
                NSData * NoticeData = [NSKeyedArchiver archivedDataWithRootObject:NoticeList];
                NSData * PhotoData = [NSKeyedArchiver archivedDataWithRootObject:PhotoList];
                NSData * iconData = [NSKeyedArchiver archivedDataWithRootObject:iconList];
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",GROUPINFO];
                BOOL result = [_database executeUpdate:sql,dic[@"Industry_id"],dic[@"MenberCount"],MenberData,dic[@"MilliTime"],NoticeData,PhotoData,dic[@"Post_time"],dic[@"Sum_Limit"],dic[@"add_address"],dic[@"add_addressDesc"],dic[@"add_addressID"],dic[@"add_time"],dic[@"admin"],dic[@"authentication"],dic[@"exa_user_id"],dic[@"exa_user_name"],dic[@"g_id"],dic[@"group_Industry"],dic[@"group_IndustryID"],dic[@"group_bgImg"],dic[@"group_cont"],dic[@"group_icon"],dic[@"group_name"],dic[@"group_no"],dic[@"group_status"],dic[@"group_type"],iconData,dic[@"id"],dic[@"is_create"],dic[@"is_near"],dic[@"is_notice"],dic[@"is_sound"],dic[@"is_to"],dic[@"latitude"],dic[@"longitude"],dic[@"photoCount"],dic[@"remark_name"],dic[@"user_id"],dic[@"user_name"],dic[@"user_sum"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getGroupInfo:(NSString*)groupID success:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE g_id = ?",GROUPINFO];
        FMResultSet * result = [_database executeQuery:sql,groupID];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self groupInfo:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary *)groupInfo:(FMResultSet*)resultSet
{
    NSString* Industry_id = [resultSet stringForColumn:@"Industry_id"];
    NSString* MenberCount = [resultSet stringForColumn:@"MenberCount"];
    NSString* MilliTime = [resultSet stringForColumn:@"MilliTime"];
    NSString* Post_time = [resultSet stringForColumn:@"Post_time"];
    NSString* Sum_Limit = [resultSet stringForColumn:@"Sum_Limit"];
    NSString* add_address = [resultSet stringForColumn:@"add_address"];
    NSString* add_addressDesc = [resultSet stringForColumn:@"add_addressDesc"];
    NSString* add_addressID = [resultSet stringForColumn:@"add_addressID"];
    NSString* add_time = [resultSet stringForColumn:@"add_time"];
    NSString* admin = [resultSet stringForColumn:@"admin"];
    NSString* authentication = [resultSet stringForColumn:@"authentication"];
    NSString* exa_user_id = [resultSet stringForColumn:@"exa_user_id"];
    NSString* exa_user_name = [resultSet stringForColumn:@"exa_user_name"];
    NSString* g_id = [resultSet stringForColumn:@"g_id"];
    NSString* group_Industry = [resultSet stringForColumn:@"group_Industry"];
    NSString* group_IndustryID = [resultSet stringForColumn:@"group_IndustryID"];
    NSString* group_bgImg = [resultSet stringForColumn:@"group_bgImg"];
    NSString* group_cont = [resultSet stringForColumn:@"group_cont"];
    NSString* group_icon = [resultSet stringForColumn:@"group_icon"];
    NSString* group_name = [resultSet stringForColumn:@"group_name"];
    NSString* group_no = [resultSet stringForColumn:@"group_no"];
    NSString* group_status = [resultSet stringForColumn:@"group_status"];
    NSString* group_type = [resultSet stringForColumn:@"group_type"];
    NSString* hid = [resultSet stringForColumn:@"id"];
    NSString* is_create = [resultSet stringForColumn:@"is_create"];
    NSString* is_near = [resultSet stringForColumn:@"is_near"];
    NSString* is_notice = [resultSet stringForColumn:@"is_notice"];
    NSString* is_sound = [resultSet stringForColumn:@"is_sound"];
    NSString* is_to = [resultSet stringForColumn:@"is_to"];
    NSString* latitude = [resultSet stringForColumn:@"latitude"];
    NSString* longitude = [resultSet stringForColumn:@"longitude"];
    NSString* photoCount = [resultSet stringForColumn:@"photoCount"];
    NSString* remark_name = [resultSet stringForColumn:@"remark_name"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* user_name = [resultSet stringForColumn:@"user_name"];
    NSString* user_sum = [resultSet stringForColumn:@"user_sum"];
    
    NSData * menData = [resultSet dataForColumn:@"MenberList"];
    NSData * noticeData= [resultSet dataForColumn:@"NoticeList"];
    NSData * photoData = [resultSet dataForColumn:@"PhotoList"];
    NSData * iconData = [resultSet dataForColumn:@"iconList"];
    NSArray * menArray = [NSKeyedUnarchiver unarchiveObjectWithData:menData];
    NSArray * noticeArray = [NSKeyedUnarchiver unarchiveObjectWithData:noticeData];
    NSArray * photoArray = [NSKeyedUnarchiver unarchiveObjectWithData:photoData];
    NSArray * iconArray = [NSKeyedUnarchiver unarchiveObjectWithData:iconData];
    
    NSDictionary * dic = @{@"Industry_id":Industry_id,@"MenberCount":MenberCount,@"MilliTime":MilliTime,
                           @"Post_time":Post_time,
                           @"Sum_Limit":Sum_Limit,@"add_address":add_address,@"add_addressDesc":add_addressDesc,
                           @"add_addressID":add_addressID,
                           @"add_time":add_time,@"admin":admin,@"authentication":authentication,
                           @"exa_user_id":exa_user_id,
                           @"exa_user_name":exa_user_name,@"g_id":g_id,@"group_Industry":group_Industry,
                           @"group_IndustryID":group_IndustryID,
                           @"group_bgImg":group_bgImg,@"group_cont":group_cont,@"group_icon":group_icon,
                           @"group_name":group_name,
                           @"group_no":group_no,
                           @"group_status":group_status,@"group_type":group_type,@"id":hid,
                           @"is_create":is_create,
                           @"is_near":is_near,@"is_notice":is_notice,@"is_sound":is_sound,
                           @"is_to":is_to,
                           @"latitude":latitude,@"longitude":longitude,@"photoCount":photoCount,
                           @"remark_name":remark_name,
                           @"user_id":user_id,@"user_name":user_name,@"user_sum":user_sum,
                           @"MenberList":menArray,@"NoticeList":noticeArray,
                           @"PhotoList":photoArray,@"iconList":iconArray};
    return dic;
}
-(void)deleteGroupInfo:(NSString*)groupID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM groupInfo WHERE g_id = ?";
        BOOL success =  [_database executeUpdate:sql,groupID];
    }];
}
-(void)deleteGroupInfoGroupID:(NSString*)groupID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM groupInfo WHERE id = ?";
        BOOL success =  [_database executeUpdate:sql,groupID];
    }];
}
#pragma mark 好友资料
-(void)upDatePersonalInfo:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                WPGetFriendInfoResult*model = (WPGetFriendInfoResult*)obj;
                NSArray * ImgList = model.ImgList;
                NSArray * replyList = model.replyList;
                NSMutableArray * imageMuarray = [NSMutableArray array];
                NSMutableArray * replayArray = [NSMutableArray array];
                //                for (WPFriendInfoImgListModel* model in ImgList) {
                //                    NSDictionary * dic = @{@"media_type":model.media_type,@"thumb_path":model.thumb_path,@"original_path":model.original_path};
                //                    [imageMuarray addObject:dic];
                //                }
                for (NSDictionary*dictionary in ImgList) {
                    NSDictionary * dic = @{@"media_type":dictionary[@"media_type"],@"thumb_path":dictionary[@"thumb_path"],@"original_path":dictionary[@"original_path"]};
                    [imageMuarray addObject:dic];
                }
                
                
                for (WPReplyListModel* model in replyList) {
                    NSDictionary * dic = @{@"id":model.id,@"user_id":model.user_id,@"friend_id":model.friend_id,@"add_time":model.add_time,@"username":model.username,@"friendname":model.friendname,@"v_content":model.v_content};
                    [replayArray addObject:dic];
                }
                NSData * imageDat = [NSKeyedArchiver archivedDataWithRootObject:imageMuarray];
                NSData * replyData = [NSKeyedArchiver archivedDataWithRootObject:replayArray];
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",PERSONALINFO];
                BOOL result = [_database executeUpdate:sql,@"0",imageDat,model.avatar,@"0",model.form_state,model.fremark,@"0",model.fstate,@"0",model.industry,model.inviteJob,model.iresume,model.is_circle,model.is_fcircle,model.is_fjob,model.is_fresume,model.is_job,@"0",model.is_resume,model.is_shield,@"0",model.nick_name,model.position,@"0",replyData,model.sex,@"0",@"0",model.type_name,model.uid,@"0",@"0",model.wp_id];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getPersonalInfo:(NSString*)friendID success:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = ?",PERSONALINFO];
        FMResultSet * result = [_database executeQuery:sql,friendID];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            WPGetFriendInfoResult*model =[self personalInfoModel:result];
            [muarray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(WPGetFriendInfoResult*)personalInfoModel:(FMResultSet*)resultSet
{
    WPGetFriendInfoResult * model = [[WPGetFriendInfoResult alloc]init];
    model.avatar = [resultSet stringForColumn:@"avatar"];
    model.uid = [resultSet stringForColumn:@"uid"];
    model.nick_name = [resultSet stringForColumn:@"nick_name"];
    model.wp_id = [resultSet stringForColumn:@"wp_id"];
    model.position = [resultSet stringForColumn:@"position"];
    model.industry = [resultSet stringForColumn:@"industry"];
    model.sex = [resultSet stringForColumn:@"sex"];
    model.inviteJob = [resultSet stringForColumn:@"inviteJob"];
    model.iresume = [resultSet stringForColumn:@"iresume"];
    model.fstate = [resultSet stringForColumn:@"fstate"];
    model.form_state = [resultSet stringForColumn:@"form_state"];
    model.fremark = [resultSet stringForColumn:@"fremark"];
    model.is_circle = [resultSet stringForColumn:@"is_circle"];
    model.is_fcircle = [resultSet stringForColumn:@"is_fcircle"];
    model.is_resume = [resultSet stringForColumn:@"is_resume"];
    model.is_fresume = [resultSet stringForColumn:@"is_fresume"];
    model.is_job = [resultSet stringForColumn:@"is_job"];
    model.is_fjob = [resultSet stringForColumn:@"is_fjob"];
    model.is_shield = [resultSet stringForColumn:@"is_shield"];
    model.type_name = [resultSet stringForColumn:@"type_name"];
    model.status = @"1";
    NSData* replyList = [resultSet dataForColumn:@"replyList"];
    NSData * ImgList = [resultSet dataForColumn:@"ImgList"];
    NSArray * imageArray = [NSKeyedUnarchiver unarchiveObjectWithData:ImgList];
    NSArray * teplyArray = [NSKeyedUnarchiver unarchiveObjectWithData:replyList];
    
    NSMutableArray * imageMu = [NSMutableArray array];
    NSMutableArray * replayMu = [NSMutableArray array];
    for (NSDictionary * dic  in imageArray) {
        WPFriendInfoImgListModel * model = [[WPFriendInfoImgListModel alloc]init];
        model.media_type = dic[@"media_type"];
        model.thumb_path = dic[@"thumb_path"];
        model.original_path = dic[@"original_path"];
        [imageMu addObject:model];
    }
    for (NSDictionary*dic in teplyArray) {
        WPReplyListModel * model = [[WPReplyListModel alloc]init];
        model.id = dic[@"id"];
        model.user_id = dic[@"user_id"];
        model.username = dic[@"username"];
        model.friend_id = dic[@"friend_id"];
        model.add_time = dic[@"add_time"];
        model.friendname = dic[@"friendname"];
        model.v_content = dic[@"v_content"];
        [replayMu addObject:model];
    }
    
    
    model.ImgList = imageMu;
    model.replyList = replayMu;
    return model;
}

-(void)deletePersonalInfo:(NSString*)uid
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM personalInfo WHERE uid = ?";
        BOOL success =  [_database executeUpdate:sql,uid];
    }];
}
#pragma mark 手机联系人
-(void)upDatePhoneLinkMan:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary * dictionary = nil;
                LinkMobileListModel * model = nil;
                BOOL isOrNot = NO;
                if ([obj isKindOfClass:[LinkMobileListModel class]]) {
                    model = (LinkMobileListModel*)obj;
                    isOrNot = YES;
                }
                else
                {
                    dictionary = (NSDictionary*)obj;
                    isOrNot = NO;
                }
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?)",PHONELINKMAN];
                BOOL result = [_database executeUpdate:sql,isOrNot?model.avatar:dictionary[@"avatar"],isOrNot?model.fk_id:dictionary[@"fk_id"],isOrNot?model.isatt:dictionary[@"isatt"],isOrNot?model.mobile:dictionary[@"mobile"],isOrNot?model.mobileName:dictionary[@"mobileName"],isOrNot?model.user_id:dictionary[@"user_id"],isOrNot?model.user_name:dictionary[@"user_name"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getPhoneLinkMan:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",PHONELINKMAN];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self phoneMan:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary *)phoneMan:(FMResultSet*)resultSet
{
    NSString* avatar = [resultSet stringForColumn:@"avatar"];
    NSString* fk_id = [resultSet stringForColumn:@"fk_id"];
    NSString* isatt = [resultSet stringForColumn:@"isatt"];
    NSString* mobile = [resultSet stringForColumn:@"mobile"];
    NSString* mobileName = [resultSet stringForColumn:@"mobileName"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* user_name = [resultSet stringForColumn:@"user_name"];
    
    NSDictionary * dic = @{@"avatar":avatar,@"fk_id":fk_id,@"isatt":isatt,
                           @"mobile":mobile,
                           @"mobileName":mobileName,@"user_id":user_id,@"user_name":user_name
                           };
    return dic;
}
-(void)deletePhoneMan
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM phoneLinkMan";
        BOOL success =  [_database executeUpdate:sql];
    }];
}
#pragma mark好友类别列表
-(void)upDataFriendsCategoryDetail:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary * dictionary = (NSDictionary*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",FRIENDSCATEGORYDETAIL];
                BOOL result = [_database executeUpdate:sql,dictionary[@"friend_id"],dictionary[@"add_fuser_state"],dictionary[@"avatar"],dictionary[@"company"],dictionary[@"form_state"],dictionary[@"ftypeid"],dictionary[@"is_be"],dictionary[@"is_circle"],dictionary[@"is_fcircle"],dictionary[@"is_fjob"],dictionary[@"is_fresume"],dictionary[@"is_job"],dictionary[@"is_read"],dictionary[@"is_resume"],dictionary[@"is_shield"],dictionary[@"nick_name"],dictionary[@"position"],dictionary[@"post_remark"],dictionary[@"user_id"],dictionary[@"user_name"],dictionary[@"wp_id"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getFriendsCategoryDetail:(NSString*)typeId success:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ where ftypeid = ?",FRIENDSCATEGORYDETAIL];
        FMResultSet * result = [_database executeQuery:sql,typeId];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self detailFriendsCategory:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)detailFriendsCategory:(FMResultSet*)resultSet
{
    NSString* add_fuser_state = [resultSet stringForColumn:@"add_fuser_state"];
    NSString* avatar = [resultSet stringForColumn:@"avatar"];
    NSString* company = [resultSet stringForColumn:@"company"];
    NSString* form_state = [resultSet stringForColumn:@"form_state"];
    NSString* friend_id = [resultSet stringForColumn:@"friend_id"];
    NSString* ftypeid = [resultSet stringForColumn:@"ftypeid"];
    NSString* is_be = [resultSet stringForColumn:@"is_be"];
    NSString* is_circle = [resultSet stringForColumn:@"is_circle"];
    NSString* is_fcircle = [resultSet stringForColumn:@"is_fcircle"];
    NSString* is_fjob = [resultSet stringForColumn:@"is_fjob"];
    NSString* is_fresume = [resultSet stringForColumn:@"is_fresume"];
    NSString* is_job = [resultSet stringForColumn:@"is_job"];
    NSString* is_read = [resultSet stringForColumn:@"is_read"];
    NSString* is_resume = [resultSet stringForColumn:@"is_resume"];
    NSString* is_shield = [resultSet stringForColumn:@"is_shield"];
    NSString* nick_name = [resultSet stringForColumn:@"nick_name"];
    NSString* position = [resultSet stringForColumn:@"position"];
    NSString* post_remark = [resultSet stringForColumn:@"post_remark"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* user_name = [resultSet stringForColumn:@"user_name"];
    NSString* wp_id = [resultSet stringForColumn:@"wp_id"];
    NSDictionary * dic = @{@"add_fuser_state":add_fuser_state,@"avatar":avatar,@"company":company,
                           @"form_state":form_state,
                           @"friend_id":friend_id,@"ftypeid":ftypeid,@"is_be":is_be,
                           @"is_circle":is_circle,
                           @"is_fcircle":is_fcircle,@"is_fjob":is_fjob,@"is_fresume":is_fresume,
                           @"is_job":is_job,
                           @"is_read":is_read,@"is_resume":is_resume,@"is_shield":is_shield,
                           @"nick_name":nick_name,
                           @"position":position,@"post_remark":post_remark,@"user_id":user_id,
                           @"user_name":user_name,
                           @"wp_id":wp_id};
    return dic;
}
-(void)deleteFriendsCategoryDetail:(NSString*)type
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM friendsCategoryDetail WHERE ftypeid = ?";
        BOOL success =  [_database executeUpdate:sql,type];
        
    }];
}
#pragma makr 好友类别
-(void)upDateFriendsCategory:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary * dictionary = (NSDictionary*)obj;
                NSArray * arr = dictionary[@"user_lest"];
                NSData * disData = [NSKeyedArchiver archivedDataWithRootObject:arr];
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?)",FRIENDSCATEGORY];
                BOOL result = [_database executeUpdate:sql,dictionary[@"add_time"],dictionary[@"id"],dictionary[@"state"],dictionary[@"typename"],dictionary[@"user_id"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getFriendsCategory:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",FRIENDSCATEGORY];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self friendsCategory:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)friendsCategory:(FMResultSet*)resultSet
{
    NSString* add_time = [resultSet stringForColumn:@"add_time"];
    NSString* create_user_id = [resultSet stringForColumn:@"id"];
    NSString* state = [resultSet stringForColumn:@"state"];
    NSString* typename = [resultSet stringForColumn:@"typename"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSDictionary * dic = @{@"add_time":add_time,@"id":create_user_id,@"state":state,
                           @"typename":typename,
                           @"user_id":user_id};
    return dic;
}
-(void)deleteFriendsCategory:(NSString*)categoryId
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM friendsCategory WHERE id = ?";
        BOOL isOr = [_database executeUpdate:sql,categoryId];
        //        NSLog(@"%@",isOr);
    }];
}
-(void)deleteAllFriendsCategory
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM friendsCategory";
        [_database executeUpdate:sql];
    }];
}
#pragma mark 我的群组
-(void)upDateMyGroup:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary * dictionary = (NSDictionary*)obj;
                NSArray * arr = dictionary[@"user_lest"];
                NSData * disData = [NSKeyedArchiver archivedDataWithRootObject:arr];
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?)",MYGROUP];
                BOOL result = [_database executeUpdate:sql,dictionary[@"MilliTime"],dictionary[@"create_user_id"],dictionary[@"g_id"],dictionary[@"group_icon"],dictionary[@"group_id"],dictionary[@"group_name"],disData];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getMyGroup:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",MYGROUP];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self myGroup:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)myGroup:(FMResultSet*)resultSet
{
    NSString* MilliTime = [resultSet stringForColumn:@"MilliTime"];
    NSString* create_user_id = [resultSet stringForColumn:@"create_user_id"];
    NSString* g_id = [resultSet stringForColumn:@"g_id"];
    NSString* group_icon = [resultSet stringForColumn:@"group_icon"];
    NSString* group_id = [resultSet stringForColumn:@"group_id"];
    NSString* group_name = [resultSet stringForColumn:@"group_name"];
    NSData* user_lest = [resultSet dataForColumn:@"user_lest"];
    NSArray * disArray = [NSKeyedUnarchiver unarchiveObjectWithData:user_lest];
    NSDictionary * dic = @{@"MilliTime":MilliTime,@"create_user_id":create_user_id,@"g_id":g_id,
                           @"group_icon":group_icon,
                           @"group_id":group_id,@"group_name":group_name,@"user_lest":disArray};
    return dic;
}
-(void)deleteAllMyGroup
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myGroup";
        [_database executeUpdate:sql];
    }];
}
#pragma mark 新的好友
-(void)upDateNewFriends:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?)",NEWFRIENDS];
                
                LinkMobileListModel* model = nil;
                NSDictionary * dictionary = nil;
                BOOL isModelOrNot = NO;
                if ([obj isKindOfClass:[LinkMobileListModel class]]) {
                    model = (LinkMobileListModel*)obj;
                    isModelOrNot = YES;
                }
                else
                {
                    isModelOrNot = NO;
                    dictionary = (NSDictionary*)obj;
                }
                BOOL result = [_database executeUpdate:sql,isModelOrNot?model.fk_id:dictionary[@"fk_id"],isModelOrNot?model.avatar:dictionary[@"avatar"],isModelOrNot?model.belongGroup:dictionary[@"belongGroup"],isModelOrNot?model.form_state:dictionary[@"form_state"],isModelOrNot?model.is_mf:dictionary[@"is_mf"],isModelOrNot?model.isatt:dictionary[@"isatt"],isModelOrNot?model.mobile:dictionary[@"mobile"],isModelOrNot?model.mobileName:dictionary[@"mobileName"],isModelOrNot?model.user_id:dictionary[@"user_id"],isModelOrNot?model.user_name:dictionary[@"user_name"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getNewFriends:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",NEWFRIENDS];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self newsFriends:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary*)newsFriends:(FMResultSet*)resultSet
{
    NSString* avatar = [resultSet stringForColumn:@"avatar"];
    NSString* belongGroup = [resultSet stringForColumn:@"belongGroup"];
    NSString* fk_id = [resultSet stringForColumn:@"fk_id"];
    NSString* form_state = [resultSet stringForColumn:@"form_state"];
    NSString* is_mf = [resultSet stringForColumn:@"is_mf"];
    NSString* isatt = [resultSet stringForColumn:@"isatt"];
    NSString* mobile = [resultSet stringForColumn:@"mobile"];
    NSString* mobileName = [resultSet stringForColumn:@"mobileName"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* user_name = [resultSet stringForColumn:@"user_name"];
    NSDictionary * dic = @{@"avatar":avatar,@"belongGroup":belongGroup,@"fk_id":fk_id,@"form_state":form_state,
                           @"is_mf":is_mf,@"isatt":isatt,@"mobile":mobile,@"mobileName":mobileName,
                           @"user_id":user_id,@"user_name":user_name};
    return dic;
}
-(void)deleteAllNewFriends
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM newFriends";
        [_database executeUpdate:sql];
    }];
}
#pragma mark 通讯录
-(void)upDateLinkMan:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary * dic = (NSDictionary*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",LINKMAN];
                BOOL result = [_database executeUpdate:sql,dic[@"add_fuser_state"],dic[@"avatar"],dic[@"company"],dic[@"form_state"],dic[@"friend_id"],dic[@"ftypeid"],dic[@"is_be"],dic[@"is_circle"],dic[@"is_fcircle"],dic[@"is_fjob"],dic[@"is_fresume"],dic[@"is_job"],dic[@"is_read"],dic[@"is_resume"],dic[@"is_shield"],dic[@"nick_name"],dic[@"position"],dic[@"post_remark"],dic[@"user_id"],dic[@"user_name"],dic[@"wp_id"]];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getOneLinkMan:(NSString*)friendsID success:(loadShuoShuo)completion
{//friend_id
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE friend_id = ?",LINKMAN];
        FMResultSet * result = [_database executeQuery:sql,friendsID];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self linkDic:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(void)getLinkMan:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",LINKMAN];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary*dic =[self linkDic:result];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(NSDictionary *)linkDic:(FMResultSet*)resultSet
{
    NSString* add_fuser_state = [resultSet stringForColumn:@"add_fuser_state"];
    NSString* avatar = [resultSet stringForColumn:@"avatar"];
    NSString* company = [resultSet stringForColumn:@"company"];
    NSString* form_state = [resultSet stringForColumn:@"form_state"];
    NSString* friend_id = [resultSet stringForColumn:@"friend_id"];
    NSString* ftypeid = [resultSet stringForColumn:@"ftypeid"];
    NSString* is_be = [resultSet stringForColumn:@"is_be"];
    NSString* is_circle = [resultSet stringForColumn:@"is_circle"];
    NSString* is_fcircle = [resultSet stringForColumn:@"is_fcircle"];
    NSString* is_fjob = [resultSet stringForColumn:@"is_fjob"];
    NSString* is_fresume = [resultSet stringForColumn:@"is_fresume"];
    NSString* is_job = [resultSet stringForColumn:@"is_job"];
    NSString* is_read = [resultSet stringForColumn:@"is_read"];
    NSString* is_resume = [resultSet stringForColumn:@"is_resume"];
    NSString* is_shield = [resultSet stringForColumn:@"is_shield"];
    NSString* nick_name = [resultSet stringForColumn:@"nick_name"];
    NSString* position = [resultSet stringForColumn:@"position"];
    NSString* post_remark = [resultSet stringForColumn:@"post_remark"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* user_name = [resultSet stringForColumn:@"user_name"];
    NSString* wp_id = [resultSet stringForColumn:@"wp_id"];
    
    NSDictionary*dic = @{@"add_fuser_state":add_fuser_state,@"avatar":avatar,@"company":company,@"form_state":form_state,
                         @"friend_id":friend_id,@"ftypeid":ftypeid,@"is_be":is_be,@"is_circle":is_circle,
                         @"is_fcircle":is_fcircle,@"is_fjob":is_fjob,@"is_fresume":is_fresume,@"is_job":is_job,
                         @"is_read":is_read,@"is_resume":is_resume,@"is_shield":is_shield,@"nick_name":nick_name,
                         @"position":position,@"post_remark":post_remark,@"user_id":user_id,@"user_name":user_name,
                         @"wp_id":wp_id};
    return dic;
}
-(void)deleteAllLinkMan
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM linkMan";
        [_database executeUpdate:sql];
    }];
}
#pragma mark 企业招聘
-(void)upDateCompanyInvite:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                WPNewResumeListModel * model = (WPNewResumeListModel*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",COMPANYINVITE];
                BOOL result = [_database executeUpdate:sql,model.enterprise_address,model.enterpriseName,model.enterprise_properties,model.enterprise_scale,@"",model.epId,@"",model.jobPositon,model.logo,@"",model.txtcontent,model.updateTime,model.userId,[NSString stringWithFormat:@"%ld",(long)model.type],model.time];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}

-(void)getPersonalApply:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",COMPANYINVITE];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            WPNewResumeListModel * model =[self personalInfo:result];
            [muarray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(WPNewResumeListModel*)personalInfo:(FMResultSet*)resultSet
{
    WPNewResumeListModel* model = [[WPNewResumeListModel alloc]init];
    model.enterprise_address = [resultSet stringForColumn:@"enterprise_address"];
    model.enterpriseName = [resultSet stringForColumn:@"enterprise_name"];
    model.enterprise_properties = [resultSet stringForColumn:@"enterprise_properties"];
    model.enterprise_scale = [resultSet stringForColumn:@"enterprise_scale"];
    model.epId = [resultSet stringForColumn:@"ep_id"];
    model.jobPositon = [resultSet stringForColumn:@"jobPositon"];
    model.logo = [resultSet stringForColumn:@"logo"];
    model.txtcontent = [resultSet stringForColumn:@"txtcontent"];
    model.updateTime = [resultSet stringForColumn:@"update_Time"];
    model.userId = [resultSet stringForColumn:@"user_id"];
    model.type = [[resultSet stringForColumn:@"type"] intValue];
    model.time = [resultSet stringForColumn:@"time"];
    return model;
}
-(void)removeCompanyInvite
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM companyInvite";
        [_database executeUpdate:sql];
    }];
}
#pragma mark 面试
-(void)upDatePersonalInvite:(NSArray*)array
{
    
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                WPNewResumeListModel * model = (WPNewResumeListModel*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",PERSONALAPPLY];
                BOOL result = [_database executeUpdate:sql,model.HopePosition,model.WorkTim,model.avatar,model.birthday,model.education,model.resumeId,model.name,model.sex,@"",model.txtcontent,model.updateTime,model.userId,[NSString stringWithFormat:@"%ld",(long)model.type],model.time];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getPersonalPrrly:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",PERSONALAPPLY];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            WPNewResumeListModel * model =[self personalModel:result];
            [muarray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(WPNewResumeListModel*)personalModel:(FMResultSet*)resultSet
{
    WPNewResumeListModel* model = [[WPNewResumeListModel alloc]init];
    model.HopePosition = [resultSet stringForColumn:@"Hope_Position"];
    model.WorkTim = [resultSet stringForColumn:@"WorkTim"];
    model.avatar = [resultSet stringForColumn:@"avatar"];
    model.birthday = [resultSet stringForColumn:@"birthday"];
    model.education = [resultSet stringForColumn:@"education"];
    model.resumeId = [resultSet stringForColumn:@"id"];
    model.name = [resultSet stringForColumn:@"name"];
    model.sex = [resultSet stringForColumn:@"sex"];
    model.txtcontent = [resultSet stringForColumn:@"txtcontent"];
    model.updateTime = [resultSet stringForColumn:@"update_Time"];
    model.userId = [resultSet stringForColumn:@"user_id"];
    model.type = [[resultSet stringForColumn:@"type"] intValue];
    model.time = [resultSet stringForColumn:@"time"];
    return model;
}
-(void)removePersonalApply
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM personalApply";
        [_database executeUpdate:sql];
    }];
}
#pragma mark 行业
-(void)upDataIndustry:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                WPHotIndustryListModel * model = (WPHotIndustryListModel*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?)",INDUSTRY];
                BOOL result = [_database executeUpdate:sql,model.address,model.fatherID,model.hotCount,model.sid,model.industryID,model.industryName,model.layer,model.recommend,model.rowNumber,@""];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入行业失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getIndustry:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",INDUSTRY];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            WPHotIndustryListModel * model =[self industry:result];
            [muarray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}

-(WPHotIndustryListModel*)industry:(FMResultSet*)resultSet{
    WPHotIndustryListModel* model = [[WPHotIndustryListModel alloc]init];
    model.address = [resultSet stringForColumn:@"address"];
    model.fatherID = [resultSet stringForColumn:@"fatherID"];
    model.hotCount = [resultSet stringForColumn:@"hotCount"];
    model.sid = [resultSet stringForColumn:@"id"];
    model.industryID = [resultSet stringForColumn:@"industryID"];
    model.industryName = [resultSet stringForColumn:@"industryName"];
    model.layer = [resultSet stringForColumn:@"layer"];
    model.recommend = [resultSet stringForColumn:@"recommend"];
    model.rowNumber = [resultSet stringForColumn:@"rowNumber"];
    model.sid = [resultSet stringForColumn:@"sid"];
    return model;
}
-(void)removeIndustry
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM industry";
        BOOL result = [_database executeUpdate:sql];
    }];
}

#pragma mark 职位
-(void)upDatePosition:(NSArray*)array
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                WPHotPositionListModel * model = (WPHotPositionListModel*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?)",SECOND_POSITION];
                BOOL result = [_database executeUpdate:sql,model.iconAddress,model.fatherID,@"",model.industryID,model.industryName,model.layer,model.positionID,model.positionName,model.recommend,model.sid];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入职位失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getPositionInfo:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",SECOND_POSITION];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            WPHotPositionListModel*model =[self position:result];
            [muarray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}

-(WPHotPositionListModel*)position:(FMResultSet*)resultSet
{
    WPHotPositionListModel* model = [[WPHotPositionListModel alloc]init];
    model.iconAddress = [resultSet stringForColumn:@"address"];
    model.fatherID = [resultSet stringForColumn:@"fatherID"];
    model.industryID = [resultSet stringForColumn:@"industryID"];
    model.industryName = [resultSet stringForColumn:@"industryName"];
    model.layer = [resultSet stringForColumn:@"layer"];
    model.positionID = [resultSet stringForColumn:@"positionID"];
    model.positionName = [resultSet stringForColumn:@"positionName"];
    model.recommend = [resultSet stringForColumn:@"recommend"];
    model.sid = [resultSet stringForColumn:@"sid"];
    return model;
}
-(void)removePosition
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM position";
        BOOL result = [_database executeUpdate:sql];
    }];
}
#pragma mark  公司
-(void)updateCompany:(NSArray*)array
{
    
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                WPHotCompanyListModel * model = (WPHotCompanyListModel*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?)",COMPANY];
                BOOL result = [_database executeUpdate:sql,model.sid,model.company_name,model.logo];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入公司失败" code:0 userInfo:nil];
                NSLog(@"%@",error.description);
            }
            else
            {
                [_database commit];
            }
        }
    }];
}
-(void)getCompanyInfo:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",COMPANY];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            WPHotCompanyListModel * model =[self getConpamy:result];
            [muarray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(WPHotCompanyListModel*)getConpamy:(FMResultSet*)resultSet
{
    WPHotCompanyListModel*model = [[WPHotCompanyListModel alloc]init];
    model.sid = [resultSet stringForColumn:@"companyId"];
    model.company_name = [resultSet stringForColumn:@"company_name"];
    model.logo = [resultSet stringForColumn:@"logo"];
    
    return model;
}

-(void)removeCompany
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM company";
        BOOL result = [_database executeUpdate:sql];
    }];
}
#pragma mark 回忆录
-(void)upDateMyShuoshuo:(NSArray*)array and:(upDateShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary * dic = (NSDictionary*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",MYREMEMBERSHUOSHUO];
                NSArray * DiscussUser = dic[@"DiscussUser"];
                NSArray * original_photos = dic[@"original_photos"];
                NSArray * praiseUser = dic[@"praiseUser"];
                NSArray * shareUser = dic[@"shareUser"];
                NSArray * small_photos = dic[@"small_photos"];
                NSDictionary * shareMsg = dic[@"shareMsg"];
                NSData * shareMsgData = nil;
                if (!shareMsg) {
                    shareMsgData =  [NSJSONSerialization dataWithJSONObject:@{} options:NSJSONWritingPrettyPrinted error:nil];
                }
                else
                {
                    shareMsgData = [NSJSONSerialization dataWithJSONObject:shareMsg options:NSJSONWritingPrettyPrinted error:nil];
                }
                NSString * shareMsgStr = [[NSString alloc]initWithData:shareMsgData encoding:NSUTF8StringEncoding];
                
                
                NSData * disData = [NSKeyedArchiver archivedDataWithRootObject:DiscussUser];
                NSData * originalData = [NSKeyedArchiver archivedDataWithRootObject:original_photos];
                NSData * praiseUserData = [NSKeyedArchiver archivedDataWithRootObject:praiseUser];
                NSData * shareUserData = [NSKeyedArchiver archivedDataWithRootObject:shareUser];
                NSData * small_photosData = [NSKeyedArchiver archivedDataWithRootObject:small_photos];
                
                BOOL result = [_database executeUpdate:sql,dic[@"id"],disData,dic[@"POSITION"],dic[@"Row"],dic[@"add_fuser_state"],dic[@"address"],dic[@"audioCount"],dic[@"avatar"],dic[@"commentCount"],dic[@"company"],dic[@"cstatus"],dic[@"form_state"],dic[@"guid"],dic[@"imgCount"],dic[@"is_anoymous"],dic[@"is_del"],dic[@"is_good"],dic[@"is_hide"],dic[@"is_own"],dic[@"jobNo"],dic[@"jobids"],dic[@"mm"],dic[@"nick_name"],originalData,dic[@"post_remark"],praiseUserData,dic[@"sex"],dic[@"share"],dic[@"shareCount"],shareUserData,dic[@"share_farther_id"],dic[@"share_title"],dic[@"share_url"],dic[@"sid"],small_photosData,dic[@"speak_add_time"],dic[@"speak_address"],dic[@"speak_browse_coun"],dic[@"speak_check_state"],dic[@"speak_comment_content"],dic[@"speak_comment_state"],dic[@"speak_latitude"],dic[@"speak_longitude"],dic[@"speak_praise_count"],dic[@"speak_trends_person"],dic[@"user_id"],dic[@"videoCount"],shareMsgStr];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入说说失败" code:0 userInfo:nil];
                completion(error);
            }
            else
            {
                [_database commit];
                completion(nil);
            }        }
    }];
}
-(void)getMyShuoshuo:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC",MYREMEMBERSHUOSHUO];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary * dic = [self getShuoFrom:result Bool:YES];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(void)getMyShuoUserid:(NSString*)userid success:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE user_id = ?",MYREMEMBERSHUOSHUO];
        FMResultSet * result = [_database executeQuery:sql,userid];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary * dic = [self getShuoFrom:result Bool:YES];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(void)deleteMyShuoshuo:(NSString*)idString
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myRememberShuoshuo WHERE id = ?";
        [_database executeUpdate:sql,idString];
    }];
}
-(void)deleteAllMyShuoshuo
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myRememberShuoshuo";
        [_database executeUpdate:sql];
    }];
}
-(void)deleteMyShuoshuouserID:(NSString*)userID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM myRememberShuoshuo WHERE user_id = ?";
        [_database executeUpdate:sql,userID];
    }];
}
#pragma mark  职场说说
-(void)upDateShuoShuo:(NSArray*)array and:(upDateShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary * dic = (NSDictionary*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",POSITION_SHUOSHUO];
                NSArray * DiscussUser = dic[@"DiscussUser"];
                NSArray * original_photos = dic[@"original_photos"];
                NSArray * praiseUser = dic[@"praiseUser"];
                NSArray * shareUser = dic[@"shareUser"];
                NSArray * small_photos = dic[@"small_photos"];
                NSDictionary * shareMsg = dic[@"shareMsg"];
                NSData * shareMsgData = nil;
                if (!shareMsg) {
                    shareMsgData =  [NSJSONSerialization dataWithJSONObject:@{} options:NSJSONWritingPrettyPrinted error:nil];
                }
                else
                {
                    shareMsgData = [NSJSONSerialization dataWithJSONObject:shareMsg options:NSJSONWritingPrettyPrinted error:nil];
                }
                NSString * shareMsgStr = [[NSString alloc]initWithData:shareMsgData encoding:NSUTF8StringEncoding];
                
                
                NSData * disData = [NSKeyedArchiver archivedDataWithRootObject:DiscussUser];
                NSData * originalData = [NSKeyedArchiver archivedDataWithRootObject:original_photos];
                NSData * praiseUserData = [NSKeyedArchiver archivedDataWithRootObject:praiseUser];
                NSData * shareUserData = [NSKeyedArchiver archivedDataWithRootObject:shareUser];
                NSData * small_photosData = [NSKeyedArchiver archivedDataWithRootObject:small_photos];
                
                BOOL result = [_database executeUpdate:sql,dic[@"ID"],disData,dic[@"POSITION"],dic[@"Row"],dic[@"add_fuser_state"],dic[@"address"],dic[@"audioCount"],dic[@"avatar"],dic[@"commentCount"],dic[@"company"],dic[@"form_state"],dic[@"imgCount"],dic[@"is_anoymous"],dic[@"is_del"],dic[@"is_good"],dic[@"is_hide"],dic[@"is_own"],dic[@"jobNo"],dic[@"jobids"],dic[@"nick_name"],originalData,dic[@"post_remark"],praiseUserData,dic[@"sex"],dic[@"share"],dic[@"shareCount"],shareUserData,dic[@"share_farther_id"],dic[@"share_title"],dic[@"share_url"],dic[@"sid"],small_photosData,dic[@"speak_add_time"],dic[@"speak_address"],dic[@"speak_browse_coun"],dic[@"speak_check_state"],dic[@"speak_comment_content"],dic[@"speak_comment_state"],dic[@"speak_latitude"],dic[@"speak_longitude"],dic[@"speak_praise_count"],dic[@"speak_trends_person"],dic[@"user_id"],dic[@"videoCount"],shareMsgStr];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入说说失败" code:0 userInfo:nil];
                completion(error);
            }
            else
            {
                [_database commit];
                completion(nil);
            }
            
            
        }
    }];
}
-(void)deleteAllShuoshuo{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM positionShuoshuo";
        [_database executeUpdate:sql];
    }];
}
-(void)getShuoShuosurrent:(int)currentNum :(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY ID DESC limit ?,?",POSITION_SHUOSHUO];
        FMResultSet * result = [_database executeQuery:sql,[NSNumber numberWithInt:0],[NSNumber numberWithInt:10]];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary * dic = [self getShuoFrom:result Bool:NO];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(void)getOneShuoshuo:(NSString*)shuoID success:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ID = ?",POSITION_SHUOSHUO];
        FMResultSet * result = [_database executeQuery:sql,shuoID];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary * dic = [self getShuoFrom:result Bool:NO];
            [muarray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(muarray);
        });
    }];
}
-(void)getAllShuo:(loadShuoShuo)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY ID DESC",POSITION_SHUOSHUO];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            NSDictionary * dic = [self getShuoFrom:result Bool:NO];
            [muarray addObject:dic];
        }
        if (muarray.count>30) {
            for (int i = 30 ; i < muarray.count; i++) {
                NSDictionary * dic = muarray[i];
                [self deleteShuo:dic[@"ID"]];
            }
        }
    }];
}
-(void)deleteShuo:(NSString*)ID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM positionShuoshuo WHERE ID = ?";
        [_database executeUpdate:sql,ID];
    }];
}

-(NSDictionary*)getShuoFrom:(FMResultSet*)resultSet Bool:(BOOL)isMyOrNot
{
    NSDictionary* dic = [NSDictionary dictionary];
    NSString* ID = [resultSet stringForColumn:@"ID"];
    NSString* POSITION = [resultSet stringForColumn:@"POSITION"];
    NSString* Row = [resultSet stringForColumn:@"Row"];
    NSString* add_fuser_state = [resultSet stringForColumn:@"add_fuser_state"];
    NSString* address = [resultSet stringForColumn:@"address"];
    NSString* audioCount = [resultSet stringForColumn:@"audioCount"];
    NSString* avatar = [resultSet stringForColumn:@"avatar"];
    NSString* commentCount = [resultSet stringForColumn:@"commentCount"];
    NSString* company = [resultSet stringForColumn:@"company"];
    NSString* form_state = [resultSet stringForColumn:@"form_state"];
    NSString* imgCount = [resultSet stringForColumn:@"imgCount"];
    NSString* is_anoymous = [resultSet stringForColumn:@"is_anoymous"];
    NSString* is_del = [resultSet stringForColumn:@"is_del"];
    NSString* is_good = [resultSet stringForColumn:@"is_good"];
    NSString* is_hide = [resultSet stringForColumn:@"is_hide"];
    NSString* is_own = [resultSet stringForColumn:@"is_own"];
    NSString* jobNo = [resultSet stringForColumn:@"jobNo"];
    NSString* jobids = [resultSet stringForColumn:@"jobids"];
    NSString* nick_name = [resultSet stringForColumn:@"nick_name"];
    NSString* post_remark = [resultSet stringForColumn:@"post_remark"];
    NSString* sex = [resultSet stringForColumn:@"sex"];
    NSString* share = [resultSet stringForColumn:@"share"];
    NSString* shareCount = [resultSet stringForColumn:@"shareCount"];
    NSString* share_farther_id = [resultSet stringForColumn:@"share_farther_id"];
    
    NSString* share_title = [resultSet stringForColumn:@"share_title"];
    NSString* share_url = [resultSet stringForColumn:@"share_url"];
    NSString* sid = [resultSet stringForColumn:@"sid"];
    NSString* speak_add_time = [resultSet stringForColumn:@"speak_add_time"];
    NSString* speak_address = [resultSet stringForColumn:@"speak_address"];
    NSString* speak_browse_coun = [resultSet stringForColumn:@"speak_browse_coun"];
    NSString* speak_check_state = [resultSet stringForColumn:@"speak_check_state"];
    NSString* speak_comment_content = [resultSet stringForColumn:@"speak_comment_content"];
    NSString* speak_comment_state = [resultSet stringForColumn:@"speak_comment_state"];
    NSString* speak_latitude = [resultSet stringForColumn:@"speak_latitude"];
    NSString* speak_longitude = [resultSet stringForColumn:@"speak_longitude"];
    NSString* speak_praise_count = [resultSet stringForColumn:@"speak_praise_count"];
    NSString* speak_trends_person = [resultSet stringForColumn:@"speak_trends_person"];
    NSString* user_id = [resultSet stringForColumn:@"user_id"];
    NSString* videoCount = [resultSet stringForColumn:@"videoCount"];
    NSString* shareMsg = [resultSet stringForColumn:@"shareMsg"];
    NSData * shareMsgData = [shareMsg dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * shareMsgDic = [NSJSONSerialization JSONObjectWithData:shareMsgData options:NSJSONReadingMutableContainers error:nil];
    
    NSData* DiscussUser = [resultSet dataForColumn:@"DiscussUser"];
    NSData* original_photos = [resultSet dataForColumn:@"original_photos"];
    NSData* praiseUser = [resultSet dataForColumn:@"praiseUser"];
    NSData* shareUser = [resultSet dataForColumn:@"shareUser"];
    NSData* small_photos = [resultSet dataForColumn:@"small_photos"];
    
    NSArray * disArray = [NSKeyedUnarchiver unarchiveObjectWithData:DiscussUser];
    NSArray * original_Array = [NSKeyedUnarchiver unarchiveObjectWithData:original_photos];
    NSArray * praiseUserArray = [NSKeyedUnarchiver unarchiveObjectWithData:praiseUser];
    NSArray * shareUserArray = [NSKeyedUnarchiver unarchiveObjectWithData:shareUser];
    NSArray * smallArray = [NSKeyedUnarchiver unarchiveObjectWithData:small_photos];
    dic = @{@"ID":ID,@"POSITION":POSITION,@"Row":Row,@"add_fuser_state":add_fuser_state,
            @"address":address,@"audioCount":audioCount,@"avatar":avatar,@"commentCount":commentCount,
            @"company":company,@"form_state":form_state,@"imgCount":imgCount,@"is_anoymous":is_anoymous,
            @"is_del":is_del,@"is_good":is_good,@"is_hide":is_hide,@"is_own":is_own,
            @"jobNo":jobNo,@"jobids":jobids,@"nick_name":nick_name,@"post_remark":post_remark,
            @"sex":sex,@"share":share,@"shareCount":shareCount,@"share_farther_id":share_farther_id,
            @"share_title":share_title,@"share_url":share_url,@"sid":sid,@"speak_add_time":speak_add_time,
            @"speak_address":speak_address,@"speak_browse_coun":speak_browse_coun,@"speak_check_state":speak_check_state,
            @"speak_comment_content":speak_comment_content,@"speak_comment_state":speak_comment_state,
            @"speak_latitude":speak_latitude,@"speak_longitude":speak_longitude,@"speak_praise_count":speak_praise_count,
            @"speak_trends_person":speak_trends_person,@"user_id":user_id,@"videoCount":videoCount,
            @"DiscussUser":disArray,@"original_photos":original_Array,@"praiseUser":praiseUserArray,
            @"shareUser":shareUserArray,@"small_photos":smallArray,@"shareMsg":shareMsgDic};
    NSMutableDictionary * muDic = [NSMutableDictionary dictionary];
    [muDic addEntriesFromDictionary:dic];
    if (isMyOrNot) {
        NSString *  cstatus = [resultSet stringForColumn:@"cstatus"];
        NSString *  guid = [resultSet stringForColumn:@"guid"];
        [muDic setObject:cstatus forKey:@"cstatus"];
        [muDic setObject:guid forKey:@"guid"];
    }
    return muDic;
}
#pragma mark 黑名单
-(void)updateBlackName:(NSArray*)array completion:(InsertsRecentContactsCOmplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [array enumerateObjectsUsingBlock:^(WPBlackNameModel *session, NSUInteger idx, BOOL *stop) {
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?)",BLACK_NAME];
                BOOL result = [_database executeUpdate:sql,session.userId,session.state];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                //                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"插入黑名单失败" code:0 userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
            }
            else
            {
                [_database commit];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil);
                });
            }
        }
    }];
}
-(void)removeAllBlackName:(removeAllBlackName)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM blackName";
        BOOL result = [_database executeUpdate:sql];
        completion(result);
    }];
}
-(void)removeFromBlackName:(NSArray*)array completion:(DeleteSessionCompletion)completion
{
    for (WPBlackNameModel * model in array)
    {
        [_dataBaseQueue inDatabase:^(FMDatabase *db) {
            NSString* sql = @"DELETE FROM blackName WHERE userId = ?";
            BOOL result = [_database executeUpdate:sql,model.userId];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result);
            });
        }];
    }
}
-(void)loadBlackNamecompletion:(loadBlackName)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",BLACK_NAME];
        FMResultSet * result = [_database executeQuery:sql];
        NSMutableArray * muarray = [NSMutableArray array];
        while ([result next])
        {
            WPBlackNameModel * model = [self blackNameFromResult:result];
            [muarray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(muarray);
        });
    }];
}



-(WPBlackNameModel*)blackNameFromResult:(FMResultSet*)resultSet
{
    NSString * userId = [resultSet stringForColumn:@"userId"];
    NSString * userState = [resultSet stringForColumn:@"userState"];
    WPBlackNameModel * model = [[WPBlackNameModel alloc]init];
    model.userId = userId;
    model.state = userState;
    return model;
}

- (NSArray*)messageFromSearchResult:(FMResultSet*)resultSet
{
    
    NSString* sessionID = [resultSet stringForColumn:@"sessionId"];
    NSString* fromUserId = [resultSet stringForColumn:@"fromUserId"];
    NSString* toUserId = [resultSet stringForColumn:@"toUserId"];
    NSString* content = [resultSet stringForColumn:@"content"];
    NSTimeInterval msgTime = [resultSet doubleForColumn:@"msgTime"];
    MsgType messageType = [resultSet intForColumn:@"messageType"];
    NSUInteger messageContentType = [resultSet intForColumn:@"messageContentType"];
    NSUInteger messageID = [resultSet intForColumn:@"messageID"];
    NSUInteger messageState = [resultSet intForColumn:@"status"];
    NSUInteger count = [resultSet intForColumn:@"count(*)"];
    
    MTTMessageEntity* messageEntity = [[MTTMessageEntity alloc] initWithMsgID:messageID
                                                                      msgType:messageType
                                                                      msgTime:msgTime
                                                                    sessionID:sessionID
                                                                     senderID:fromUserId
                                                                   msgContent:content
                                                                     toUserID:toUserId];
    messageEntity.state = messageState;
    messageEntity.msgContentType = messageContentType;
    NSString* infoString = [resultSet stringForColumn:@"info"];
    if (infoString)
    {
        NSData* infoData = [infoString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
        NSMutableDictionary* mutalInfo = [NSMutableDictionary dictionaryWithDictionary:info];
        messageEntity.info = mutalInfo;
        
    }
    return [NSArray arrayWithObjects:@(count),messageEntity, nil];
}

- (MTTMessageEntity*)messageFromResult:(FMResultSet*)resultSet
{
    
    NSString* sessionID = [resultSet stringForColumn:@"sessionId"];
    NSString* fromUserId = [resultSet stringForColumn:@"fromUserId"];
    NSString* toUserId = [resultSet stringForColumn:@"toUserId"];
    NSString* content = [resultSet stringForColumn:@"content"];
    NSTimeInterval msgTime = [resultSet doubleForColumn:@"msgTime"];
    MsgType messageType = [resultSet intForColumn:@"messageType"];
    NSUInteger messageContentType = [resultSet intForColumn:@"messageContentType"];
    NSUInteger messageID = [resultSet intForColumn:@"messageID"];
    NSUInteger messageState = [resultSet intForColumn:@"status"];
    
    MTTMessageEntity* messageEntity = [[MTTMessageEntity alloc] initWithMsgID:messageID
                                                                      msgType:messageType
                                                                      msgTime:msgTime
                                                                    sessionID:sessionID
                                                                     senderID:fromUserId
                                                                   msgContent:content
                                                                     toUserID:toUserId];
    messageEntity.state = messageState;
    messageEntity.msgContentType = messageContentType;
    NSString* infoString = [resultSet stringForColumn:@"info"];
    if (infoString)
    {
        NSData* infoData = [infoString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
        NSMutableDictionary* mutalInfo = [NSMutableDictionary dictionaryWithDictionary:info];
        messageEntity.info = mutalInfo;
        
    }
    return messageEntity;
}

- (MTTUserEntity*)userFromResult:(FMResultSet*)resultSet
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic safeSetObject:[resultSet stringForColumn:@"Name"] forKey:@"name"];
    [dic safeSetObject:[resultSet stringForColumn:@"Nick"] forKey:@"nickName"];
    [dic safeSetObject:[resultSet stringForColumn:@"ID"] forKey:@"userId"];
    [dic safeSetObject:[resultSet stringForColumn:@"Department"] forKey:@"department"];
    [dic safeSetObject:[resultSet stringForColumn:@"Postion"] forKey:@"position"];
    [dic safeSetObject:[NSNumber numberWithInt:[resultSet intForColumn:@"Sex"]] forKey:@"sex"];
    [dic safeSetObject:[resultSet stringForColumn:@"DepartID"] forKey:@"departId"];
    [dic safeSetObject:[resultSet stringForColumn:@"Telphone"] forKey:@"telphone"];
    [dic safeSetObject:[resultSet stringForColumn:@"Avatar"] forKey:@"avatar"];
    [dic safeSetObject:[resultSet stringForColumn:@"Email"] forKey:@"email"];
    [dic safeSetObject:@([resultSet longForColumn:@"updated"]) forKey:@"lastUpdateTime"];
    [dic safeSetObject:[resultSet stringForColumn:@"pyname"] forKey:@"pyname"];
    [dic safeSetObject:[resultSet stringForColumn:@"signature"] forKey:@"signature"];
    MTTUserEntity* user = [MTTUserEntity dicToUserEntity:dic];
    
    return user;
}

-(MTTGroupEntity *)groupFromResult:(FMResultSet *)resultSet
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic safeSetObject:[resultSet stringForColumn:@"Name"] forKey:@"name"];
    [dic safeSetObject:[resultSet stringForColumn:@"ID"] forKey:@"groupId"];
    [dic safeSetObject:[resultSet stringForColumn:@"Avatar"] forKey:@"avatar"];
    [dic safeSetObject:[NSNumber numberWithInt:[resultSet intForColumn:@"GroupType"]] forKey:@"groupType"];
    [dic safeSetObject:@([resultSet longForColumn:@"updated"]) forKey:@"lastUpdateTime"];
    [dic safeSetObject:[resultSet stringForColumn:@"CreatID"] forKey:@"creatID"];
    [dic safeSetObject:[resultSet stringForColumn:@"Users"] forKey:@"Users"];
    [dic safeSetObject:[resultSet stringForColumn:@"LastMessage"] forKey:@"lastMessage"];
    [dic safeSetObject:[NSNumber numberWithInt:[resultSet intForColumn:@"isshield"]] forKey:@"isshield"];
    [dic safeSetObject:[NSNumber numberWithInt:[resultSet intForColumn:@"version"]] forKey:@"version"];
    [dic safeSetObject:[NSNumber numberWithInt:[resultSet intForColumn:@"isFixTop"]] forKey:@"isFixTop"];
    MTTGroupEntity* group = [MTTGroupEntity dicToMTTGroupEntity:dic];
    return group;
}

- (MTTDepartment*)departmentFromResult:(FMResultSet*)resultSet
{
    
    NSDictionary *dic = @{@"departID": [resultSet stringForColumn:@"ID"],
                          @"title":[resultSet stringForColumn:@"title"],
                          @"description":[resultSet stringForColumn:@"description"],
                          @"leader":[resultSet stringForColumn:@"leader"],
                          @"parentID":[resultSet stringForColumn:@"parentID"],
                          @"status":[NSNumber numberWithInt:[resultSet intForColumn:@"status"]],
                          @"count":[NSNumber numberWithInt:[resultSet intForColumn:@"count"]],
                          };
    MTTDepartment *deaprtment = [MTTDepartment departmentFromDic:dic];
    return deaprtment;
}


-(NSDictionary*)getLastMessage:(NSString*)string
{
    NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
#pragma mark Message
-(void)loadAllMessage:(NSString*)sesionId completion:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM message where sessionId=?"];
            FMResultSet* result = [_database executeQuery:sqlString,sesionId];
            while ([result next])
            {
                MTTMessageEntity* message = [self messageFromResult:result];
                //后加的
                id objc = message.msgContent;
                NSDictionary * dictionary = [NSDictionary dictionary];
                if ([objc isKindOfClass:[NSString class]]) {
                    NSString * messageCon = message.msgContent;
                    NSData * data = [messageCon dataUsingEncoding:NSUTF8StringEncoding];
                    dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                }
                if ([objc isKindOfClass:[NSDictionary class]]) {
                    dictionary = (NSDictionary*)objc;
                }
                
                if (dictionary.count == 5 && [dictionary[@"for_userid"] length]) {
                    message.msgContentType = DDMEssageLitterInviteAndApply;
                }
                
                if (dictionary.count == 2 && [dictionary[@"display_type"] isEqualToString:@"12"]) {
                    message.msgContentType = DDMEssageLitterInviteAndApply;
                }
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(array,nil);
            });
        }
    }];
}


- (void)loadMessageForSessionID:(NSString*)sessionID pageCount:(int)pagecount index:(NSInteger)index completion:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM message where sessionId = ? ORDER BY msgTime DESC limit ?,?"];
            FMResultSet* result = [_database executeQuery:sqlString,sessionID,[NSNumber numberWithInteger:index],[NSNumber numberWithInteger:pagecount]];
            while ([result next])
            {
                MTTMessageEntity* message = [self messageFromResult:result];
                //后加的
                id objc = message.msgContent;
                NSDictionary * dictionary = [NSDictionary dictionary];
                if ([objc isKindOfClass:[NSString class]]) {
                    NSString * messageCon = message.msgContent;
                    NSData * data = [messageCon dataUsingEncoding:NSUTF8StringEncoding];
                    dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                }
                if ([objc isKindOfClass:[NSDictionary class]]) {
                    dictionary = (NSDictionary*)objc;
                }
                
                if (dictionary.count == 5 && [dictionary[@"for_userid"] length]) {
                    message.msgContentType = DDMEssageLitterInviteAndApply;
                }
                
                if (dictionary.count == 2 && [dictionary[@"display_type"] isEqualToString:@"12"]) {
                    message.msgContentType = DDMEssageLitterInviteAndApply;
                }
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(array,nil);
            });
        }
    }];
}

- (void)loadMessageForSessionID:(NSString*)sessionID afterMessage:(MTTMessageEntity*)message completion:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"select * from %@ where sessionId = '%@' AND messageID >= ? order by msgTime DESC,messageID DESC",TABLE_MESSAGE,sessionID];
            FMResultSet* result = [_database executeQuery:sqlString,@(message.msgID)];
            while ([result next])
            {
                MTTMessageEntity* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

-(void)loadMessgaeForSeeeionID:(NSString *)sessionID andMessage:(NSUInteger)messageID completion:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            NSString* sqlString =@"SELECT * FROM message where sessionId=? and messageID=?";// @"SELECT * FROM message where sessionId = ? and messageID = ?";
            FMResultSet* result = [_database executeQuery:sqlString,sessionID,@(messageID)];
            while ([result next])
            {
                MTTMessageEntity* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}


- (void)searchHistory:(NSString *)key completion:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"select count(*),* from %@ where content like '%%%@%%' and content not like '%%&$#@~^@[{:%%' GROUP BY sessionId",TABLE_MESSAGE,key];
            FMResultSet* result = [_database executeQuery:sqlString];
            while ([result next])
            {
                NSArray* message = [self messageFromSearchResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)searchHistoryBySessionId:(NSString *)key sessionId:(NSString *)sessionId completion:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"select * from %@ where content like '%%%@%%' and sessionId = '%@' and content not like '%%&$#@~^@[{:%%'",TABLE_MESSAGE,key,sessionId];
            FMResultSet* result = [_database executeQuery:sqlString];
            while ([result next])
            {
                MTTMessageEntity* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)getLasetCommodityTypeImageForSession:(NSString*)sessionID completion:(DDGetLastestCommodityMessageCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * from %@ where sessionId=? AND messageType = ? ORDER BY msgTime DESC,rowid DESC limit 0,1",TABLE_MESSAGE];
            FMResultSet* result = [_database executeQuery:sqlString,sessionID,@(4)];
            MTTMessageEntity* message = nil;
            while ([result next])
            {
                message = [self messageFromResult:result];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(message);
            });
        }
    }];
}

- (void)getLastestMessageForSessionID:(NSString*)sessionID completion:(DDDBGetLastestMessageCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where sessionId= ? and status = 2  ORDER BY messageId DESC limit 0,1",TABLE_MESSAGE];
            
            FMResultSet* result = [_database executeQuery:sqlString,sessionID];
            MTTMessageEntity* message = nil;
            while ([result next])
            {
                message = [self messageFromResult:result];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(message,nil);
                });
                break;
            }
            if(message == nil){
                completion(message,nil);
            }
        }
    }];
}


#pragma mark  获取数据数量
- (void)getMessagesCountForSessionID:(NSString*)sessionID completion:(MessageCountCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where sessionId=?",TABLE_MESSAGE];
            
            FMResultSet* result = [_database executeQuery:sqlString,sessionID];
            int count = 0;
            while ([result next])
            {
                count = [result intForColumnIndex:0];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(count);
            });
        }
    }];
    
    
}

-(NSString*)getStrFromDic:(NSDictionary*)dic
{
    NSString * str = [NSString string];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError * error;
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return str;
}

- (void)lewVideoReadyToPlay
{
}
- (void)lewVideoLoadedProgress:(CGFloat)progress
{
}
#pragma mark插入数据
- (void)insertMessages:(NSArray*)messages
               success:(void(^)())success
               failure:(void(^)(NSString* errorDescripe))failure
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MTTMessageEntity* message = (MTTMessageEntity*)obj;
                NSLog(@"%@",message.msgContent);
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",TABLE_MESSAGE];
                NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:message.info options:NSJSONWritingPrettyPrinted error:nil];
                NSString* json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
                
                //将插入数据库中需要改变的类型进行改变
                NSString *content = [NSString stringWithFormat:@"%@",message.msgContent];
                NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                if (dic)
                {
                    NSString * display_type = [NSString stringWithFormat:@"%@",dic[@"display_type"]];
                    switch (display_type.intValue) {
                        case 1://文字
                            message.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
                            break;
                        case 2://图片
                            message.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
                            message.msgContentType = DDMessageTypeImage;
                            break;
                        case 3://语音
                            
                            break;
                        case 6://名片
                        {
                            id tempDic = dic[@"content"];
                            if ([tempDic isKindOfClass:[NSString class]]) { //字符串
                                NSString * tempString = (NSString *)tempDic;
                                message.msgContent = tempString;
                            }else {
                                NSDictionary * dictonary = (NSDictionary *)tempDic;
                                NSString * content = [self getStrFromDic:dictonary];
                                message.msgContent = [NSString stringWithFormat:@"%@",content];
                            }
                           // NSDictionary * dictonary = dic[@"content"];
                            //NSString * content = [self getStrFromDic:dictonary];
                            //message.msgContent = [NSString stringWithFormat:@"%@",content];
                            message.msgContentType = DDMEssagePersonalaCard;
                        }
                            break;
                        case 7://视频
                            message.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
                            message.msgContentType = DDMEssageLitterVideo;
                            break;
                        case 8://求职
                        {
                            id tempDic = dic[@"content"];
                            if ([tempDic isKindOfClass:[NSString class]]) { //字符串
                                NSString * tempString = (NSString *)tempDic;
                                message.msgContent = tempString;
                            }else {
                                NSDictionary * dictonary = (NSDictionary *)tempDic;
                                NSString * content = [self getStrFromDic:dictonary];
                                message.msgContent = [NSString stringWithFormat:@"%@",content];
                            }
                            //NSDictionary * dictonary = dic[@"content"];
                            //NSString * content = [self getStrFromDic:dictonary];
                            //message.msgContent = [NSString stringWithFormat:@"%@",content];
                            message.msgContentType = DDMEssageMyApply;
                        }
                            break;
                        case 9://招聘
                        {
                            id tempDic = dic[@"content"];
                            if ([tempDic isKindOfClass:[NSString class]]) { //字符串
                                NSString * tempString = (NSString *)tempDic;
                                message.msgContent = tempString;
                            }else {
                                NSDictionary * dictonary = (NSDictionary *)tempDic;
                                NSString * content = [self getStrFromDic:dictonary];
                                message.msgContent = [NSString stringWithFormat:@"%@",content];
                            }
                           // NSDictionary * dictonary = dic[@"content"];
                            //NSString * content = [self getStrFromDic:dictonary];
                            //message.msgContent = [NSString stringWithFormat:@"%@",content];
                            message.msgContentType = DDMEssageMyWant;
                        }
                            break;
                        case 10://多个招聘和面试
                        {
                            id tempDic = dic[@"content"];
                            if ([tempDic isKindOfClass:[NSString class]]) { //字符串
                                NSString * tempString = (NSString *)tempDic;
                                message.msgContent = tempString;
                            }else {
                                NSDictionary * dictonary = (NSDictionary *)tempDic;
                                NSString * content = [self getStrFromDic:dictonary];
                                message.msgContent = [NSString stringWithFormat:@"%@",content];
                            }
                          //  NSDictionary * dictonary = dic[@"content"];
                           // NSString * content = [self getStrFromDic:dictonary];
                           // message.msgContent = [NSString stringWithFormat:@"%@",content];
                            message.msgContentType = DDMEssageMuchMyWantAndApply;
                        }
                            break;
                        case 11://说说
                        {
                            id tempDic = dic[@"content"];
                            if ([tempDic isKindOfClass:[NSString class]]) { //字符串
                                NSString * tempString = (NSString *)tempDic;
                                message.msgContent = tempString;
                            }else {
                                NSDictionary * dictonary = (NSDictionary *)tempDic;
                                NSString * content = [self getStrFromDic:dictonary];
                                message.msgContent = [NSString stringWithFormat:@"%@",content];
                            }
                          //  NSDictionary * dictonary = dic[@"content"];
                           // NSString * content = [self getStrFromDic:dictonary];
                          //  message.msgContent = [NSString stringWithFormat:@"%@",content];
                            message.msgContentType = DDMEssageSHuoShuo;
                        }
                            break;
                        case 13://群相册
                        {
                            id tempDic = dic[@"content"];
                            if ([tempDic isKindOfClass:[NSString class]]) { //字符串
                                NSString * tempString = (NSString *)tempDic;
                                message.msgContent = tempString;
                            }else {
                                NSDictionary * dictonary = (NSDictionary *)tempDic;
                                NSString * content = [self getStrFromDic:dictonary];
                                message.msgContent = [NSString stringWithFormat:@"%@",content];
                            }
                           // NSDictionary * dictonary = dic[@"content"];
                          //  NSString * content = [self getStrFromDic:dictonary];
                           // message.msgContent = [NSString stringWithFormat:@"%@",content];
                            message.msgContentType = DDMEssageLitteralbume;
                        }
                            break;
                        case 14://接受申请
                        {
                            id tempDic = dic[@"content"];
                            if ([tempDic isKindOfClass:[NSString class]]) { //字符串
                                NSString * tempString = (NSString *)tempDic;
                                message.msgContent = tempString;
                            }else {
                                NSDictionary * dictonary = (NSDictionary *)tempDic;
                                NSString * content = [self getStrFromDic:dictonary];
                                message.msgContent = [NSString stringWithFormat:@"%@",content];
                            }
                            //NSDictionary * dictonary = dic[@"content"];
                           // NSString * content = [self getStrFromDic:dictonary];
                            //message.msgContent = [NSString stringWithFormat:@"%@",content];
                            message.msgContentType = DDMEssageAcceptApply;
                        }
                            break;
                        case 15://批量收藏
                        {
                            id tempDic = dic[@"content"];
                            if ([tempDic isKindOfClass:[NSString class]]) { //字符串
                                NSString * tempString = (NSString *)tempDic;
                                message.msgContent = tempString;
                            }else {
                                NSDictionary * dictonary = (NSDictionary *)tempDic;
                                NSString * content = [self getStrFromDic:dictonary];
                                message.msgContent = [NSString stringWithFormat:@"%@",content];
                            }
                            message.msgContentType = DDMEssageMuchCollection;
                        }
                            break;
                        default:
                            break;
                    }
                }
                
                
                
                BOOL result = [_database executeUpdate:sql,@(message.msgID),message.sessionId,message.senderId,message.toUserID,message.msgContent,@(message.state),@(message.msgTime),@(1),@(message.msgContentType),@(message.msgType),json,@(0),@""];
                
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
            failure(@"插入数据失败");
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                failure(@"插入数据失败");
            }
            else
            {
                [_database commit];
                success();
            }
        }
    }];
}
-(void)loadSingleMessage:(NSString *)mesageId comple:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT FROM %@ where messageID=?",TABLE_MESSAGE];
            
            FMResultSet* result = [_database executeQuery:sqlString,mesageId];
            NSMutableArray * array = [NSMutableArray array];
            while ([result next])
            {
                MTTMessageEntity* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)deleteMesagesForSession:(NSString*)sessionID completion:(DeleteSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM message WHERE sessionId = ?";
        BOOL result = [_database executeUpdate:sql,sessionID];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }];
}

- (void)deleteMesages:(MTTMessageEntity * )message completion:(DeleteSessionCompletion)completion
{
    
    NSLog(@"删除消息id: %lu",(unsigned long)message.msgID);
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM message WHERE messageID = ?";
        BOOL result = [_database executeUpdate:sql,@(message.msgID)];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }];
}

- (void)updateMessageForMessage:(MTTMessageEntity*)message completion:(DDUpdateMessageCompletion)completion
{
    //(messageID integer,sessionId text,fromUserId text,toUserId text,content text, status integer, msgTime real, sessionType integer,messageType integer,reserve1 integer,reserve2 text)
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"UPDATE %@ SET fromUserId = ? , toUserId = ? , content = ? , status = ? , msgTime = ? , sessionType = ?, messageType = ?, messageContentType = ? , info = ? WHERE messageID = ? AND sessionId = ? ",TABLE_MESSAGE];
        
        NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:message.info options:NSJSONWritingPrettyPrinted error:nil];
        NSString* json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
        
        BOOL result = [_database executeUpdate:sql,message.senderId,message.toUserID,message.msgContent,@(message.state),@(message.msgTime),@(message.sessionType),@(message.msgType),@(message.msgContentType),json,@(message.msgID),message.sessionId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }];
}

-(void)updateVoiceMessage:(MTTMessageEntity*)message completion:(DDUpdateMessageCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"UPDATE %@ SET fromUserId = ? , toUserId = ? , content = ? , status = ? , msgTime = ? , sessionType = ?, messageType = ?, messageContentType = ? , info = ? WHERE messageID = ? AND sessionId = ?",TABLE_MESSAGE];
        NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:message.info options:NSJSONWritingPrettyPrinted error:nil];
        NSString* json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
        
        BOOL result = [_database executeUpdate:sql,message.senderId,message.toUserID,message.msgContent,@(message.state),@(message.msgTime),@(message.sessionType),@(message.msgType),@(message.msgContentType),json,@(message.msgID),message.sessionId];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }];
}
#pragma mark - Users
//- (void)loadContactsCompletion:(LoadRecentContactsComplection)completion
//{
//     [_dataBaseQueue inDatabase:^(FMDatabase *db) {
//        NSMutableArray* array = [[NSMutableArray alloc] init];
//        if ([_database tableExists:TABLE_RECENT_CONTACTS])
//        {
//            [_database setShouldCacheStatements:YES];
//
//            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@",TABLE_RECENT_CONTACTS];
//            FMResultSet* result = [_database executeQuery:sqlString];
//            while ([result next])
//            {
//                MTTUserEntity* user = [self userFromResult:result];
//                [array addObject:user];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completion(array,nil);
//            });
//        }
//    }];
//}
//
//- (void)updateContacts:(NSArray*)users inDBCompletion:(UpdateRecentContactsComplection)completion
//{
//     [_dataBaseQueue inDatabase:^(FMDatabase *db) {
//        NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@",TABLE_RECENT_CONTACTS];
//        BOOL result = [_database executeUpdate:sql];
//        if (result)
//        {
//            //删除原先数据成功，添加新数据
//            [_database beginTransaction];
//            __block BOOL isRollBack = NO;
//            @try {
//                [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    MTTUserEntity* user = (MTTUserEntity*)obj;
//                    NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?)",TABLE_RECENT_CONTACTS];
//                    //ID,Name,Nick,Avatar,Role,updated,reserve1,reserve2
//                    BOOL result = [_database executeUpdate:sql,user.objID,user.name,user.nick,user.avatar,@(user.lastUpdateTime),@(0),@""];
//                    if (!result)
//                    {
//                        isRollBack = YES;
//                        *stop = YES;
//                    }
//                }];
//            }
//            @catch (NSException *exception) {
//                [_database rollback];
//            }
//            @finally {
//                if (isRollBack)
//                {
//                    [_database rollback];
//                    DDLog(@"insert to database failure content");
//                    NSError* error = [NSError errorWithDomain:@"插入最近联系人用户失败" code:0 userInfo:nil];
//                    completion(error);
//                }
//                else
//                {
//                    [_database commit];
//                    completion(nil);
//                }
//            }
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSError* error = [NSError errorWithDomain:@"清除数据失败" code:0 userInfo:nil];
//                completion(error);
//            });
//        }
//
//    }];
//}
//
//- (void)updateContact:(MTTUserEntity*)user inDBCompletion:(UpdateRecentContactsComplection)completion
//{
//     [_dataBaseQueue inDatabase:^(FMDatabase *db) {
//
//        //#define SQL_CREATE_RECENT_CONTACTS      [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID text,Name text,Nick text,Avatar text, Role integer, updated real,reserve1 integer,reserve2 text)",TABLE_RECENT_CONTACTS]
//
//        NSString* sql = [NSString stringWithFormat:@"UPDATE %@ set Name = ? , Nick = ? , Avatar = ? ,  updated = ? , reserve1 = ? , reserve2 = ?where ID = ?",TABLE_RECENT_CONTACTS];
//
//        BOOL result = [_database executeUpdate:sql,user.name,user.nick,user.avatar,@(user.lastUpdateTime),@(1),@(1),user.objID];
//        if (result)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completion(nil);
//            });
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSError* error = [NSError errorWithDomain:@"更新数据失败" code:0 userInfo:nil];
//                completion(error);
//            });
//        }
//
//    }];
//}
//
//- (void)insertUsers:(NSArray*)users completion:(InsertsRecentContactsCOmplection)completion
//{
//    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
//        [_database beginTransaction];
//        __block BOOL isRollBack = NO;
//        @try {
//            [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                MTTUserEntity* user = (MTTUserEntity*)obj;
//                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?)",TABLE_RECENT_CONTACTS];
//                //ID,Name,Nick,Avatar,Role,updated,reserve1,reserve2
//                BOOL result = [_database executeUpdate:sql,user.objID,user.name,user.nick,user.avatar,@(user.lastUpdateTime),@(0),@""];
//                if (!result)
//                {
//                    isRollBack = YES;
//                    *stop = YES;
//                }
//            }];
//        }
//        @catch (NSException *exception) {
//            [_database rollback];
//        }
//        @finally {
//            if (isRollBack)
//            {
//                [_database rollback];
//                DDLog(@"insert to database failure content");
//                NSError* error = [NSError errorWithDomain:@"插入最近联系人用户失败" code:0 userInfo:nil];
//                completion(error);
//            }
//            else
//            {
//                [_database commit];
//                completion(nil);
//            }
//        }
//    }];
//}
- (void)insertDepartments:(NSArray*)departments completion:(InsertsRecentContactsCOmplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [departments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MTTDepartment* department = [MTTDepartment departmentFromDic:obj];
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?)",TABLE_DEPARTMENTS];
                //ID,Name,Nick,Avatar,Role,updated,reserve1,reserve2
                BOOL result = [_database executeUpdate:sql,department.ID,department.parentID,department.title,department.description,department.leader,@(department.status),@(department.count)];
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入部门信息失败" code:0 userInfo:nil];
                completion(error);
            }
            else
            {
                [_database commit];
                completion(nil);
            }
        }
    }];
}
- (void)getDepartmentFromID:(NSString*)departmentID completion:(void(^)(MTTDepartment *department))completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_DEPARTMENTS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where ID=?",TABLE_DEPARTMENTS];
            
            FMResultSet* result = [_database executeQuery:sqlString,departmentID];
            MTTDepartment* department = nil;
            while ([result next])
            {
                department = [self departmentFromResult:result];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(department);
            });
        }
    }];
}

- (void)insertAllUser:(NSArray*)users completion:(InsertsRecentContactsCOmplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            
            [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MTTUserEntity* user = (MTTUserEntity *)obj;
                if (user.userStatus == 3) {
                    user.telphone=@"";
                    user.email = @"";
                    user.name=@"";
                }
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",TABLE_ALL_CONTACTS];
                //ID,Name,Nick,Avatar,Role,updated,reserve1,reserve2
                BOOL result = [_database executeUpdate:sql,user.objID,user.name,user.nick,user.avatar,user.department,user.departId,user.email,user.position,user.telphone,@(user.sex),user.lastUpdateTime,user.pyname,user.signature];
                
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入全部用户信息失败" code:0 userInfo:nil];
                completion(error);
            }
            else
            {
                [_database commit];
                completion(nil);
            }
        }
    }];
}

- (void)getAllUsers:(LoadAllContactsComplection )completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_ALL_CONTACTS])
        {
            [_database setShouldCacheStatements:YES];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ ",TABLE_ALL_CONTACTS];
            FMResultSet* result = [_database executeQuery:sqlString];
            MTTUserEntity* user = nil;
            while ([result next])
            {
                user = [self userFromResult:result];
                if (user.userStatus != 3) {
                    [array addObject:user];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)getUserFromID:(NSString*)userID completion:(void(^)(MTTUserEntity *user))completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_ALL_CONTACTS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where ID= ?",TABLE_ALL_CONTACTS];
            FMResultSet* result = [_database executeQuery:sqlString,userID];
            MTTUserEntity* user = nil;
            while ([result next])
            {
                user = [self userFromResult:result];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(user);
            });
        }
    }];
}
- (void)loadGroupByIDCompletion:(NSString *)groupID Block:(LoadRecentContactsComplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_GROUPS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where ID= ? ",TABLE_GROUPS];
            FMResultSet* result = [_database executeQuery:sqlString,groupID];
            while ([result next])
            {
                MTTGroupEntity* group = [self groupFromResult:result];
                [array addObject:group];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)loadGroupsCompletion:(LoadRecentContactsComplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_GROUPS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@",TABLE_GROUPS];
            FMResultSet* result = [_database executeQuery:sqlString];
            while ([result next])
            {
                MTTGroupEntity* group = [self groupFromResult:result];
                [array addObject:group];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)updateRecentGroup:(MTTGroupEntity *)group completion:(InsertsRecentContactsCOmplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?)",TABLE_GROUPS];
            NSString *users = @"";
            if ([group.groupUserIds count]>0) {
                users=[group.groupUserIds componentsJoinedByString:@"-"];
            }
            BOOL result = [_database executeUpdate:sql,group.objID,group.avatar,@(group.groupType),group.name,group.groupCreatorId,users,group.lastMsg,@(group.lastUpdateTime),@(group.isShield),@(group.objectVersion),@(group.isFixTop)];
            if (!result)
            {
                isRollBack = YES;
            }
            
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"插入最近群失败" code:0 userInfo:nil];
                completion(error);
            }
            else
            {
                [_database commit];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil);
                });
            }
        }
    }];
}

- (void)updateRecentSessions:(NSArray *)sessions completion:(InsertsRecentContactsCOmplection)completion{
    
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        [_database beginTransaction];
        
        __block BOOL isRollBack = NO;
        @try {
            
            [sessions enumerateObjectsUsingBlock:^(MTTSessionEntity *session, NSUInteger idx, BOOL *stop) {
                
                NSString * string = [WPMySecurities textFromBase64String:session.lastMsg];
                if (string.length) {
                    session.lastMsg = string;
                }
                
                
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",TABLE_RECENT_SESSION];
                //ID Avatar GroupType Name CreatID Users  LastMessage
                NSString *users = @"";
                if ([session.sessionUsers count]>0) {
                    users=[session.sessionUsers componentsJoinedByString:@"-"];
                }
                BOOL result = [_database executeUpdate:sql,session.sessionID,session.avatar,@(session.sessionType),session.name,@(session.timeInterval),@(session.isShield),users,@(session.unReadMsgCount),session.lastMsg,@(session.lastMsgID),@(session.lastMsgFromUserId),session.lastMesageName,session.singleSendId,session.singleReceiveId,@(session.isFixedTop)];
                
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"插入最近Session失败" code:0 userInfo:nil];
                //                completion(error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
            }
            else
            {
                [_database commit];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil);
                });
            }
        }
    }];
}

- (void)updateRecentSession:(MTTSessionEntity *)session completion:(InsertsRecentContactsCOmplection)completion{
    /*
     ID text UNIQUE,Avatar text, Type integer, Name text,LastMessage Text,updated real,isshield intege  Users Text
     */
    
    NSString * string = [WPMySecurities textFromBase64String:session.lastMsg];
    if (string.length) {
        session.lastMsg = string;
    }
    
    
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",TABLE_RECENT_SESSION];
            //ID Avatar GroupType Name CreatID Users  LastMessage
            NSString *users = @"";
            if ([session.sessionUsers count]>0) {
                users=[session.sessionUsers componentsJoinedByString:@"-"];
            }
            BOOL result = [_database executeUpdate:sql,session.sessionID,session.avatar,@(session.sessionType),session.name,@(session.timeInterval),@(session.isShield),users,@(session.unReadMsgCount),session.lastMsg,@(session.lastMsgID),@(session.lastMsgFromUserId),session.lastMesageName,session.singleSendId,session.singleReceiveId,@(session.isFixedTop)];
            if (!result)
            {
                isRollBack = YES;
            }
            
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"插入最近Session失败" code:0 userInfo:nil];
                completion(error);
            }
            else
            {
                [_database commit];
                completion(nil);
            }
        }
    }];
}

#pragma session
- (void)loadSessionsCompletion:(LoadAllSessionsComplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_RECENT_SESSION])
        {
            [_database setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ order BY updated DESC",TABLE_RECENT_SESSION];
            FMResultSet* result = [_database executeQuery:sqlString];
            while ([result next])
            {
                MTTSessionEntity* session = [self sessionFromResult:result];
                [array addObject:session];
            }
            //            dispatch_async(dispatch_get_main_queue(), ^{
            completion(array,nil);
            //            });
        }
    }];
    //    IPADDRESS
}

-(MTTSessionEntity *)sessionFromResult:(FMResultSet *)resultSet
{
    /*
     ID text UNIQUE,Avatar text, Type integer, Name text,updated real,isshield integer,Users Text
     */
    SessionType type =(SessionType)[resultSet intForColumn:@"type"];
    MTTSessionEntity* session = [[MTTSessionEntity alloc] initWithSessionID:[resultSet stringForColumn:@"ID"] SessionName:[resultSet stringForColumn:@"name"] type:type];
    session.avatar=[resultSet stringForColumn:@"avatar"];
    session.timeInterval=[resultSet longForColumn:@"updated"];
    session.lastMsg = [resultSet stringForColumn:@"lasMsg"];
    session.lastMsgID = [resultSet longForColumn:@"lastMsgId"];
    session.unReadMsgCount = [resultSet longForColumn:@"unreadCount"];
    session.lastMsgFromUserId = [resultSet longForColumn:@"lastMsgFromUserId"];
    session.lastMesageName = [resultSet stringForColumn:@"lastMesageName"];
    session.singleSendId = [resultSet stringForColumn:@"singleSendId"];
    session.singleReceiveId = [resultSet stringForColumn:@"singleReceiveId"];
    //  session.userName = [resultSet stringForColumn:@"username"];
    
    session.isShield = [resultSet longForColumn:@"isshield"];
    session.isFixedTop = [resultSet longForColumn:@"isFixTop"];
    return session;
}
-(void)removeSession:(NSString *)sessionID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM recentSession WHERE ID = ?";
        BOOL result = [_database executeUpdate:sql,sessionID];
        if(result)
        {
            NSString* sql = @"DELETE FROM message WHERE sessionId = ?";
            BOOL result = [_database executeUpdate:sql,sessionID];
        }
    }];
    
}
@end
