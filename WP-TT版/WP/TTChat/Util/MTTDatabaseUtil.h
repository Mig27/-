//
//  MTTDatabaseUtil.h
//  Duoduo
//
//  Created by zuoye on 14-3-21.
//  Copyright (c) 2015年 MoguIM All rights reserved.
//  本地数据库

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class MTTDepartment;
@class MTTMessageEntity;
@class MTTGroupEntity;
@class MTTSessionEntity;
@class MessageEntity,MTTUserEntity;

@interface MTTDatabaseUtil : NSObject
@property(strong)NSString *recentsession;

//在数据库上的操作
@property (nonatomic,readonly)dispatch_queue_t databaseMessageQueue;


+ (instancetype)instance;

- (void)openCurrentUserDB;

@end

typedef void(^LoadMessageInSessionCompletion)(NSArray* messages,NSError* error);
typedef void(^MessageCountCompletion)(NSInteger count);
typedef void(^DeleteSessionCompletion)(BOOL success);
typedef void(^DDDBGetLastestMessageCompletion)(MTTMessageEntity* message,NSError* error);
typedef void(^DDUpdateMessageCompletion)(BOOL result);
typedef void(^DDGetLastestCommodityMessageCompletion)(MTTMessageEntity* message);
typedef void(^loadBlackName)(NSArray* array);
typedef void(^removeAllBlackName)(BOOL result);

typedef void(^upDateShuoShuo)(NSError*error);
typedef void(^loadShuoShuo) (NSArray*array);

@interface MTTDatabaseUtil(Message)


//职场说说
-(void)deleteAllShuoshuo;
-(void)getShuoShuosurrent:(int)currentNum :(loadShuoShuo)completion;
-(void)upDateShuoShuo:(NSArray*)array and:(upDateShuoShuo)completion;
-(void)getAllShuo:(loadShuoShuo)completion;
-(void)getOneShuoshuo:(NSString*)shuoID success:(loadShuoShuo)completion;
/**
 *  在|databaseMessageQueue|执行查询操作，分页获取聊天记录
 *
 *  @param sessionID  会话ID
 *  @param pagecount  每页消息数
 *  @param page       页数
 *  @param completion 完成获取
 */
- (void)loadMessageForSessionID:(NSString*)sessionID pageCount:(int)pagecount index:(NSInteger)index completion:(LoadMessageInSessionCompletion)completion;
-(void)loadMessgaeForSeeeionID:(NSString *)sessionID andMessage:(NSUInteger)messageID completion:(LoadMessageInSessionCompletion)completion;

-(void)loadAllMessage:(NSString*)sesionId completion:(LoadMessageInSessionCompletion)completion;
- (void)loadMessageForSessionID:(NSString*)sessionID afterMessage:(MTTMessageEntity*)message completion:(LoadMessageInSessionCompletion)completion;
- (void)searchHistory:(NSString*)key completion:(LoadMessageInSessionCompletion)completion;
- (void)searchHistoryBySessionId:(NSString*)key sessionId:(NSString *)sessionId completion:(LoadMessageInSessionCompletion)completion;
-(void)loadSingleMessage:(NSString*)mesageId comple:(LoadMessageInSessionCompletion)completion;
/**
 *  获取对应的Session的最新的自己发送的商品气泡
 *
 *  @param sessionID  会话ID
 *  @param completion 完成获取
 */
- (void)getLasetCommodityTypeImageForSession:(NSString*)sessionID completion:(DDGetLastestCommodityMessageCompletion)completion;

/**
 *  在|databaseMessageQueue|执行查询操作，获取DB中
 *
 *  @param sessionID  sessionID
 *  @param completion 完成获取最新的消息
 */
- (void)getLastestMessageForSessionID:(NSString*)sessionID completion:(DDDBGetLastestMessageCompletion)completion;

/**
 *  在|databaseMessageQueue|执行查询操作，分页获取聊天记录
 *
 *  @param sessionID  会话ID
 *  @param completion 完成block
 */
- (void)getMessagesCountForSessionID:(NSString*)sessionID completion:(MessageCountCompletion)completion;

/**
 *  批量插入message，需要用户必须在线，避免插入离线时阅读的消息
 *
 *  @param messages message集合
 *  @param success 插入成功
 *  @param failure 插入失败
 */
- (void)insertMessages:(NSArray*)messages
               success:(void(^)())success
               failure:(void(^)(NSString* errorDescripe))failure;

/**
 *  删除相应会话的所有消息
 *
 *  @param sessionID  会话
 *  @param completion 完成删除
 */
- (void)deleteMesagesForSession:(NSString*)sessionID completion:(DeleteSessionCompletion)completion;

/**
 *  更新数据库中的某条消息
 *
 *  @param message    更新后的消息
 *  @param completion 完成更新
 */
- (void)updateMessageForMessage:(MTTMessageEntity*)message completion:(DDUpdateMessageCompletion)completion;

-(void)updateVoiceMessage:(MTTMessageEntity*)message completion:(DDUpdateMessageCompletion)completion;
@end

//-----------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------

typedef void(^LoadRecentContactsComplection)(NSArray* contacts,NSError* error);
typedef void(^LoadAllContactsComplection)(NSArray* contacts,NSError* error);
typedef void(^LoadAllSessionsComplection)(NSArray* session,NSError* error);
typedef void(^UpdateRecentContactsComplection)(NSError* error);
typedef void(^InsertsRecentContactsCOmplection)(NSError* error);

@interface MTTDatabaseUtil(Users)

/**
 *  加载本地数据库的最近联系人列表
 *
 *  @param completion 完成加载
 */
- (void)loadContactsCompletion:(LoadRecentContactsComplection)completion;

/**
 *  更新本地数据库的最近联系人信息
 *
 *  @param completion 完成更新本地数据库
 */
- (void)updateContacts:(NSArray*)users inDBCompletion:(UpdateRecentContactsComplection)completion;

/**
 *  更新本地数据库某个用户的信息
 *
 *  @param user       某个用户
 *  @param completion 完成更新本地数据库
 */


/**
 *  插入本地数据库的最近联系人信息
 *
 *  @param users      最近联系人数组
 *  @param completion 完成插入
 */
- (void)insertUsers:(NSArray*)users completion:(InsertsRecentContactsCOmplection)completion;
/**
 *  插入组织架构信息
 *
 *  @param departments 组织架构数组
 *  @param completion  完成插入
 */
- (void)insertDepartments:(NSArray*)departments completion:(InsertsRecentContactsCOmplection)completion;

- (void)getDepartmentFromID:(NSString*)departmentID completion:(void(^)(MTTDepartment *department))completion;
- (void)insertAllUser:(NSArray*)users completion:(InsertsRecentContactsCOmplection)completion;

- (void)getAllUsers:(LoadAllContactsComplection )completion;

- (void)getUserFromID:(NSString*)userID completion:(void(^)(MTTUserEntity *user))completion;

- (void)updateRecentGroup:(MTTGroupEntity *)group completion:(InsertsRecentContactsCOmplection)completion;
- (void)updateRecentSessions:(NSArray *)sessions completion:(InsertsRecentContactsCOmplection)completion;
- (void)updateRecentSession:(MTTSessionEntity *)session completion:(InsertsRecentContactsCOmplection)completion;
- (void)loadGroupsCompletion:(LoadRecentContactsComplection)completion;
- (void)loadSessionsCompletion:(LoadAllSessionsComplection)completion;
-(void)removeSession:(NSString *)sessionID;
- (void)deleteMesages:(MTTMessageEntity * )message completion:(DeleteSessionCompletion)completion;
- (void)loadGroupByIDCompletion:(NSString *)groupID Block:(LoadRecentContactsComplection)completion;
-(void)loadBlackNamecompletion:(loadBlackName)completion;
-(void)removeFromBlackName:(NSArray*)array completion:(DeleteSessionCompletion)completion;
-(void)updateBlackName:(NSArray*)array completion:(InsertsRecentContactsCOmplection)completion;
-(void)removeAllBlackName:(removeAllBlackName)completion;
-(void)upDataIndustry:(NSArray*)array;
-(void)getIndustry:(loadShuoShuo)completion;
-(void)removeIndustry;
-(void)upDatePosition:(NSArray*)array;
-(void)getPositionInfo:(loadShuoShuo)completion;
-(void)removePosition;
-(void)updateCompany:(NSArray*)array;
-(void)removeCompany;
-(void)getCompanyInfo:(loadShuoShuo)completion;

-(void)getPersonalApply:(loadShuoShuo)completion;
-(void)upDatePersonalInvite:(NSArray*)array;
-(void)getPersonalPrrly:(loadShuoShuo)completion;
-(void)removePersonalApply;

//企业招聘
-(void)upDateCompanyInvite:(NSArray*)array;
-(void)removeCompanyInvite;
//回忆录
-(void)upDateMyShuoshuo:(NSArray*)array and:(upDateShuoShuo)completion;
-(void)getMyShuoshuo:(loadShuoShuo)completion;
-(void)deleteMyShuoshuo:(NSString*)idString;
-(void)deleteAllMyShuoshuo;
-(void)deleteMyShuoshuouserID:(NSString*)userID;
-(void)getMyShuoUserid:(NSString*)userid success:(loadShuoShuo)completion;
//通讯录
-(void)upDateLinkMan:(NSArray*)array;
-(void)getLinkMan:(loadShuoShuo)completion;
-(void)deleteAllLinkMan;
-(void)getOneLinkMan:(NSString*)friendsID success:(loadShuoShuo)completion;
//新的好友
-(void)upDateNewFriends:(NSArray*)array;
-(void)getNewFriends:(loadShuoShuo)completion;
-(void)deleteAllNewFriends;
//我的群组
-(void)getMyGroup:(loadShuoShuo)completion;
-(void)upDateMyGroup:(NSArray*)array;
-(void)deleteAllMyGroup;
//好友类别
-(void)deleteAllFriendsCategory;
-(void)upDateFriendsCategory:(NSArray*)array;
-(void)getFriendsCategory:(loadShuoShuo)completion;
-(void)deleteFriendsCategory:(NSString*)categoryId;
//好友类别列表
-(void)deleteFriendsCategoryDetail:(NSString*)type;
-(void)getFriendsCategoryDetail:(NSString*)typeId success:(loadShuoShuo)completion;
-(void)upDataFriendsCategoryDetail:(NSArray*)array;
//手机联系人
-(void)upDatePhoneLinkMan:(NSArray*)array;
-(void)getPhoneLinkMan:(loadShuoShuo)completion;
-(void)deletePhoneMan;
//好友资料
-(void)upDatePersonalInfo:(NSArray*)array;
-(void)deletePersonalInfo:(NSString*)uid;
-(void)getPersonalInfo:(NSString*)friendID success:(loadShuoShuo)completion;
//群组资料
-(void)upDateGroupInfo:(NSArray*)array;
-(void)deleteGroupInfo:(NSString*)groupID;
-(void)deleteGroupInfoGroupID:(NSString*)groupID;
-(void)getGroupInfo:(NSString*)groupID success:(loadShuoShuo)completion;
//群相册
-(void)deleteAllAlbum;
-(void)deleteAlbum:(NSString*)albumID;
-(void)upDateGroupAlbum:(NSArray*)array groupID:(NSString*)groupid;
-(void)getAllAlbum:(loadShuoShuo)completion;
-(void)getGroupAlbum:(NSString*)groupAlbumID success:(loadShuoShuo)completion;
//群成员
-(void)upDateGroupMember:(NSArray*)array;
-(void)deleteGroupMember:(NSString*)groupID;
-(void)getGroupMember:(NSString*)groupID success:(loadShuoShuo)completion;
//群公告
-(void)upDataGroupGongGao:(NSArray*)array;
-(void)deleteGroupGongGao:(NSString*)groupID;
-(void)deleteGroupGongGao:(NSString*)groupId gong:(NSString*)gongGaoID;
-(void)getGroupGongGao:(NSString*)groupID success:(loadShuoShuo)completion;
//收藏列表
-(void)deleteAllCollectionList;
-(void)upDateCollectionList:(NSArray*)array;
-(void)getCollectionList:(loadShuoShuo)completion;
-(void)deleteCollectionList:(NSString*)collectionID;
//收藏列表详情
-(void)upDateCollectionDetail:(NSArray*)array;
-(void)getCollectionDetail:(NSString*)detailID success:(loadShuoShuo)completion;
-(void)deleteCollectionDetail:(NSString*)classType;
-(void)deleteCollectionDetail:(NSString*)classTyPe and:(NSString*)detailID;
//我的求职个人信息
-(void)deleteAllMyPersonalInfo;
-(void)upDateMyPersonalInfo:(NSArray*)array;
-(void)deleteMyPersonalInfo:(NSString*)infoID;
-(void)getMyPersonalInfo:(loadShuoShuo)completion;
//我的企业信息
-(void)deleteMyCompoanyInfo;
-(void)upDateMyCompanyInfo:(NSArray*)array;
-(void)getMyComoanyInfo:(loadShuoShuo)completion;
//我发布的求职
-(void)deleteAllMyApply;
-(void)deleteMyApply:(NSString*)applyID;
-(void)upDateMyApply:(NSDictionary*)dictionary;
-(void)getMyApply:(void(^)(NSDictionary*))success;
//我发布的招聘
-(void)deleteAllInvite;
-(void)deleteMyInvite:(NSString*)applyID;
-(void)updateMyInvite:(NSDictionary*)dictionary;
-(void)getMyInvite:(void(^)(NSDictionary*dic))success;
//说说的话题
-(void)uploadTopic:(NSArray*)array;
-(void)getShuoShuoTopic:(NSString*)num success:(loadShuoShuo)completion;
@end
