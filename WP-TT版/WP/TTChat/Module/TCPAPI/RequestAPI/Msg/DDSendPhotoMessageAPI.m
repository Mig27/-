//
//  DDSendPhotoMessageAPI.m
//  IOSDuoduo
//
//  Created by 东邪 on 14-6-6.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "DDSendPhotoMessageAPI.h"
#import "AFHTTPRequestOperationManager.h"

#import "MTTMessageEntity.h"
#import "MTTPhotosCache.h"
#import "NSDictionary+Safe.h"
#import "MTTUtil.h"
static int max_try_upload_times = 5;
@interface DDSendPhotoMessageAPI ()
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)NSOperationQueue *queue;
@property(assign)bool isSending;
@end
@implementation DDSendPhotoMessageAPI
+ (DDSendPhotoMessageAPI *)sharedPhotoCache
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer.acceptableContentTypes
        = [NSSet setWithObject:@"text/html"];
        self.queue = [NSOperationQueue new];
        self.queue.maxConcurrentOperationCount = 1;
        
    }
    return self;
}
-(void)uploadVideo:(NSString *)videoPath success:(void(^)(NSString * videoUrl))success failure:(void(^)(id error))failure
{
    NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:[MTTUtil getMsfsUrl]];
        NSString *urlString =  [url.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        WPFormData *formDatas = [[WPFormData alloc]init];
        NSData * data = [NSData dataWithContentsOfFile:videoPath];
        if (!data) {
            NSError * error =[[NSError alloc]init];
            failure(error);
            return ;
        }
        formDatas.data = data;
        NSDate * date = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMdd";
        NSString * dateStr = [formatter stringFromDate:date];
//        formDatas.name = [NSString stringWithFormat:@"PhotoAddress%@",dateStr];
        formDatas.name = @"photoAddress0";
        formDatas.filename = [NSString stringWithFormat:@"PhotoAddress%@.mp4",dateStr];
        formDatas.mimeType = @"video/quicktime";
        
        NSDictionary * params = @{@"type":@"mp4"};
        NSString * postStr = [NSString stringWithFormat:@"%@/msg/upload.ashx",IPADDRESS];
        
        //urlString
        [WPHttpTool postWithURL:postStr params:params formDataArray:@[formDatas] success:^(id json) {
            success(json[@"url"]);
        } failure:^(NSError *error) {
            failure(nil);
        }];
    }];
    [self.queue addOperation:operation];
}
- (void)uploadImage:(NSString*)imagekey success:(void(^)(NSString* imageURL))success failure:(void(^)(id error))failure
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
        NSURL *url = [NSURL URLWithString:[MTTUtil getMsfsUrl]];
        NSString *urlString =  [url.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        @autoreleasepool
        {
            __block NSData *imageData = [[MTTPhotosCache sharedPhotoCache] photoFromDiskCacheForKey:imagekey];
            
            UIImage * Dataimage = [UIImage imageWithData:imageData];
            NSData * imageData1 = UIImageJPEGRepresentation(Dataimage, 1.0);

            if (imageData == nil) {
                failure(@"data is emplty");
                return;
            }
            __block UIImage *image = [UIImage imageWithData:imageData];
            NSString *imageName = [NSString stringWithFormat:@"image.png_%fx%f.png",image.size.width,image.size.height];
            NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:@"im_image",@"type", nil];
            NSString * postStr = [NSString stringWithFormat:@"%@/msg/upload.ashx",IPADDRESS];

            [self.manager POST:postStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                //imageData
                [formData appendPartWithFileData:imageData1 name:@"photoAddress0" fileName:imageName mimeType:@"video/quicktime"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                imageData =nil;
                image=nil;
                NSInteger statusCode = [operation.response statusCode];
                if (statusCode == 200) {
                    NSString *imageURL=nil;
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([[responseObject safeObjectForKey:@"error_code"] intValue]==0) {
                            imageURL = [responseObject safeObjectForKey:@"url"];
                            if ([imageURL isEqualToString:@"上传失败"]) {
                                imageURL = @"";
                            }
                        }else{
                            failure([responseObject safeObjectForKey:@"error_msg"]);
                        }
                    }
                    NSMutableString *url = [NSMutableString stringWithFormat:@"%@",DD_MESSAGE_IMAGE_PREFIX];
                    if (!imageURL)
                    {
                        max_try_upload_times --;
                        if (max_try_upload_times > 0)
                        {
                            [self uploadImage:imagekey success:^(NSString *imageURL) {
                                NSArray * array = [imageURL componentsSeparatedByString:@","];
                                NSString * string = [NSString stringWithFormat:@"%@%@",IPADDRESS,array[2]];
                                success(string);
                                
//                                success([NSString stringWithFormat:@"%@%@",IPADDRESS,imageURL]);//[self getUrlStreing:imageURL]
                            } failure:^(id error) {
                                failure(error);
                            }];
                        }
                        else
                        {
                            failure(nil);
                        }
                    }
                    if (imageURL) {
                        NSArray * array = [imageURL componentsSeparatedByString:@","];
                        if (array.count<3) {
                            failure(nil);
                            return ;
                        }
                        [url appendString:[NSString stringWithFormat:@"%@%@",IPADDRESS,array[2]]];
                        [url appendString:@":}]&$~@#@"];
                        
                        
//                        [url appendString:[NSString stringWithFormat:@"%@%@",IPADDRESS,imageURL]];//[self getUrlStreing:imageURL]
//                        [url appendString:@":}]&$~@#@"];
                        success(url);
                    }
                }
                else
                {
                    self.isSending=NO;
                    failure(nil);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                self.isSending=NO;
                NSDictionary* userInfo = error.userInfo;
                NSHTTPURLResponse* response = userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                NSInteger stateCode = response.statusCode;
                if (!(stateCode >= 300 && stateCode <=307))
                {
                    failure(@"断网");
                }
            }];

            
            
            
            
//            [self.manager POST:postStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                
//                //imageData
//                [formData appendPartWithFileData:imageData1 name:@"image" fileName:imageName mimeType:@"image/jpeg"];
//            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    
//                imageData =nil;
//                image=nil;
//                NSInteger statusCode = [operation.response statusCode];
//                if (statusCode == 200) {
//                    NSString *imageURL=nil;
//                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                        if ([[responseObject safeObjectForKey:@"error_code"] intValue]==0) {
//                                imageURL = [responseObject safeObjectForKey:@"url"];
//                        }else{
//                            failure([responseObject safeObjectForKey:@"error_msg"]);
//                        }
//                    }
//                    NSMutableString *url = [NSMutableString stringWithFormat:@"%@",DD_MESSAGE_IMAGE_PREFIX];
//                    if (!imageURL)
//                    {
//                        max_try_upload_times --;
//                        if (max_try_upload_times > 0)
//                        {
//                            
//                            [self uploadImage:imagekey success:^(NSString *imageURL) {
//                                success(imageURL);
//                            } failure:^(id error) {
//                                failure(error);
//                            }];
//                        }
//                        else
//                        {
//                            failure(nil);
//                        }
//                        
//                    }
//                    if (imageURL) {
//                        [url appendString:imageURL];
//                        [url appendString:@":}]&$~@#@"];
//                        success(url);
//                    }
//                }
//                else
//                {
//                    self.isSending=NO;
//                    failure(nil);
//                }
//
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                self.isSending=NO;
//                NSDictionary* userInfo = error.userInfo;
//                NSHTTPURLResponse* response = userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
//                NSInteger stateCode = response.statusCode;
//                if (!(stateCode >= 300 && stateCode <=307))
//                {
//                    failure(@"断网");
//                }
//            }];
        }
    }];
    [self.queue addOperation:operation];
}

-(NSString*)getUrlStreing:(NSString*)urlStr
{
    urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr];
    NSArray * array = [urlStr componentsSeparatedByString:@"/"];
    NSMutableArray * muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:array];
    NSString * string = array[array.count-1];
//    string= [NSString string@"%@%@",string,@"thumb_"];
    string = [NSString stringWithFormat:@"%@%@",@"thumb_",string];
    [muarray replaceObjectAtIndex:array.count-1 withObject:string];
    urlStr = [muarray componentsJoinedByString:@"/"];
    
    return urlStr;
}
+(NSString *)imageUrl:(NSString *)content{
    NSRange range = [content rangeOfString:@"path="];
    NSString* url = nil;
    if ([content length] > range.location + range.length)
    {
        url = [content substringFromIndex:range.location+range.length];
    }
    url = [(NSString *)url stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return url;
}

@end
