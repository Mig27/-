//
//  RequestManager.m
//  WP
//
//  Created by CBCCBC on 16/3/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "RequestManager.h"

#define INVITEJOB @"/ios/inviteJob.ashx"
#define RESUME_NEW @"/ios/resume_new.ashx"

@implementation RequestManager

+ (instancetype)shareManager
{
    static RequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RequestManager alloc]init];
    });
    return manager;
}
// 将 传递的参数 和 选择的方法 整理好 开始进行网络请求
- (void)getRequestWithAddress:(NSString *)address action:(NSString *)action params:(NSDictionary *)params dataArray:(NSArray *)dataArray status:(StatusBlock)status fail:(ErrorBlock)fail
{
    NSString *str = [IPADDRESS stringByAppendingString:address];
    [self requestWithUrlStr:str action:action params:params dataArray:dataArray returnValue:^(id json) {
        status(json);
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
        fail(error);
    }];
}
// 提供接口URL 后台方法Action post请求参数 获取返回值
- (void)requestWithUrlStr:(NSString *)str action:(NSString *)action params:(NSDictionary *)dictionaty dataArray:(NSArray *)dataArray returnValue:(void (^)(id json))returnValue fail:(void (^)(NSError *error))fail
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"action":action,
                                                                                   @"username":model.username,
                                                                                   @"password":model.password,
                                                                                   @"user_id":model.dic[@"userid"]}];
    [params setValuesForKeysWithDictionary:dictionaty];
    if (dataArray) {
        [WPHttpTool postWithURL:str params:params formDataArray:dataArray success:^(id json) {
            returnValue(json);
        } failure:^(NSError *error) {
            fail(error);
        }];
    }else{
        [WPHttpTool postWithURL:str params:params success:^(id json) {
            returnValue(json);
        } failure:^(NSError *error) {
            fail(error);
        }];
    }
}

- (void)getCollectionWithJobid:(NSString *)job_id state:(BOOL)state status:(StatusBlock)status fail:(ErrorBlock)fail
{
    NSDictionary *param = @{@"job_id":job_id};
    NSString *action;
    if (state) {
        action = @"JobCollect";
    }else{
        action = @"delCollect";
        param = @{@"job_id":job_id,@"my_user_id":kShareModel.userId};
    }
    [self getRequestWithAddress:INVITEJOB action:action params:param dataArray:nil status:^(id json) {
        status(json);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)getInviteJobWithJobid:(NSString *)job_id state:(BOOL)state status:(StatusBlock)status fail:(ErrorBlock)fail
{
    NSDictionary *param = @{@"job_id":job_id};
    NSString *action;
    if (status) {
        action = @"GetJobSignStatus";
    }else{
        
    }
    [self getRequestWithAddress:INVITEJOB action:action params:param dataArray:nil status:^(id json) {
        status(json);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)getCompanyInfoWithEpid:(NSString *)ep_id status:(StatusBlock)status fail:(ErrorBlock)fail
{
    NSDictionary *param = @{@"ep_id":ep_id};
    [self getRequestWithAddress:INVITEJOB action:@"GetCompanyInfo" params:param dataArray:nil status:^(id json) {
        status(json);
    }fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)updateCompanyInfoWithEpid:(NSString *)ep_id Images:(NSArray *)images Params:(NSDictionary *)params status:(StatusBlock)status fail:(ErrorBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"ep_id":ep_id}];
    [param setValuesForKeysWithDictionary:params];
    NSMutableArray *dataArray = [NSMutableArray array];
    int imageNumber = 0;
    for (UIImage *image in images) {
        WPFormData *formData = [[WPFormData alloc]init];
            UIImage  *img = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(image)];
            formData.data = UIImageJPEGRepresentation(img, 0.5);
        formData.name = [NSString stringWithFormat:@"img%d",imageNumber];
        formData.filename = [NSString stringWithFormat:@"img%d.jpg",imageNumber];
        [dataArray addObject:formData];//把数据流加入上传文件数组
        imageNumber++;
    }
    [self getRequestWithAddress:INVITEJOB action:@"UpdateCompanyInfo" params:param dataArray:images status:^(id json) {
        status(json);
    }fail:^(NSError *error) {
        fail(error);
    }];
}


- (void)getMyCompanyWithStatus:(StatusBlock)status fail:(ErrorBlock)fail
{
    [self getRequestWithAddress:INVITEJOB action:@"GetMyCompany" params:nil dataArray:nil status:^(id json) {
        status(json);
    }fail:^(NSError *error) {
        fail(error);
    }];
}


- (void)cancelApplicationJobWithJobid:(NSString *)job_id status:(StatusBlock)status fail:(ErrorBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"job_id":job_id}];
    [self getRequestWithAddress:INVITEJOB action:@"CancelApplicationJob" params:param dataArray:nil status:^(id json) {
        status(json);
    }fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)cancelApplicationResumeWithResumeid:(NSString *)resume_id status:(StatusBlock)status fail:(ErrorBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"resume_id":resume_id}];
    [self getRequestWithAddress:RESUME_NEW action:@"CancelApplicationResume" params:param dataArray:nil status:^(id json) {
        status(json);
    }fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)getJobSignStatusWithJobid:(NSString *)job_id status:(StatusBlock)status fail:(ErrorBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"job_id":job_id}];
    [self getRequestWithAddress:INVITEJOB action:@"GetJobSignStatus" params:param dataArray:nil status:^(id json) {
        status(json);
    }fail:^(NSError *error) {
        fail(error);
    }];
}


- (void)getResumeSignStatusWithResumeid:(NSString *)resume_id status:(StatusBlock)status fail:(ErrorBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"resume_id":resume_id}];
    [self getRequestWithAddress:RESUME_NEW action:@"GetResumeSignStatus" params:param dataArray:nil status:^(id json) {
        status(json);
    }fail:^(NSError *error) {
        fail(error);
    }];
}











































































































































@end
