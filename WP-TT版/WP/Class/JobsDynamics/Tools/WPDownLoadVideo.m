//
//  WPDownLoadVideo.m
//  WP
//
//  Created by CC on 16/9/29.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPDownLoadVideo.h"
#define shuoShuoVideo @"/shuoShuoVideo"

//static NSProgress * doProgress;

@interface WPDownLoadVideo()

{
    NSProgress * videoProgress;
}
@end

@implementation WPDownLoadVideo
+(void)downLoadVideo:(NSArray*)array
{
    for (NSString * path in array) {
        
        NSArray * pathArray = [path componentsSeparatedByString:@"/"];
        NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
        NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
//        [self downloadFileURL:path savePath:savePath fileName:fileName tag:1];
         NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
       NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileName1]) {
//           NSData *audioData = [NSData dataWithContentsOfFile:fileName1];
//            NSLog(@"%@",audioData);
            continue;
        }
//        <1>获取下载的文件的路径
        NSString * string = path;
        //<2>如果下载的文件路径中存在中文 不能转换成NSURL 所以必须转码
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //<3>将字符串网址转化成NSURL
        NSURL * url = [NSURL URLWithString:string];
        //<4>封装成请求对象
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        //<5>创建下载管理者对象
        AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        //参数是监控进度的变化 也就是KVO
        NSProgress * tempProgress = nil;
        //<6>创建下载任务
        /*
         1、请求对象的指针
         2、下载进度的对象指针
         3、下载的文件的存放的路径
         */
        NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:&tempProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
             [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
            NSData * data = [NSData dataWithContentsOfURL:targetPath];
            [data writeToFile:fileName1 atomically:YES];
            return targetPath;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"%@",error.description);
        }];
        //<8>开始下载
        [task resume];
    }
}

- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
        NSData *audioData = [NSData dataWithContentsOfFile:fileName];
        NSLog(@"%@",audioData);
        //...视频下载完毕操作
    }else{
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:aSavePath]) {
            [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //下载附件
        NSURL *url = [[NSURL alloc] initWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.inputStream   = [NSInputStream inputStreamWithURL:url];
        operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
        //下载进度控制
        /*
         [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
         NSLog(@is download：%f, (float)totalBytesRead/totalBytesExpectedToRead);
         }];
         */
        
        //已完成下载
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
//            NSData *audioData = [NSData dataWithContentsOfFile:fileName];
            NSData *audioData= (NSData*)responseObject;
            [audioData writeToFile:aFileName atomically:YES];
            //设置下载数据到res字典对象中并用代理返回下载数据NSData
            //...视频下载完毕操作
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            //下载失败
            //...视频下载失败操作
        }];
        [operation start];
    }
}
-(void)downLoadVideo:(NSString * )filePath success:(void(^)(id response))success failed:(void(^)(NSError*error))failed progress:(void(^)(NSProgress*progreee))progress
{
    NSArray * pathArray = [filePath componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName1]) {
        return;
    }
    //<1>获取下载的文件的路径
    NSString * string = filePath;
    //<2>如果下载的文件路径中存在中文 不能转换成NSURL 所以必须转码
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //<3>将字符串网址转化成NSURL
    NSURL * url = [NSURL URLWithString:string];
    //<4>封装成请求对象
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    //<5>创建下载管理者对象
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //参数是监控进度的变化 也就是KVO
    NSProgress * tempProgress = nil;
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:&tempProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSData * data = [NSData dataWithContentsOfURL:targetPath];
        [data writeToFile:fileName1 atomically:YES];
        
        if (data)
        {
            if (success) {
                success(data);
            }
        }
        else
        {
            NSError * error =  nil;
            if (failed) {
                failed(error);
            }
            
        }
        return targetPath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
    }];
    //<8>开始下载
    [task resume];

}
//下载轮播图的图片
-(void)downLoadScrollerImage:(NSString*)imageStr success:(void(^)(id response))Success failed:(void(^)(NSError*error))Failed
{
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, imageStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName1]) {
        return;
    }
    //<1>获取下载的文件的路径
    NSString * string = imageStr;
    //<2>如果下载的文件路径中存在中文 不能转换成NSURL 所以必须转码
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //<3>将字符串网址转化成NSURL
    NSURL * url = [NSURL URLWithString:string];
    //<4>封装成请求对象
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    //<5>创建下载管理者对象
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //参数是监控进度的变化 也就是KVO
    NSProgress * tempProgress = nil;
    //<6>创建下载任务
    /*
     1、请求对象的指针
     2、下载进度的对象指针
     3、下载的文件的存放的路径
     */
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:&tempProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSData * data = [NSData dataWithContentsOfURL:targetPath];
        [data writeToFile:fileName1 atomically:YES];
        
        if (data)
        {
            if (Success) {
                Success(data);
            }
        }
        else
        {
            NSError * error =  nil;
            if (Failed) {
                Failed(error);
            }
            
        }
        return targetPath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@",error.description);
    }];
    //<8>开始下载
    [task resume];
    
}
-(void)downLoadImage:(NSString * )filePath success:(void(^)(id response))success failed:(void(^)(NSError*error))failed
{
    NSArray * pathArray = [filePath componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName1]) {
        return;
    }
    
    //<1>获取下载的文件的路径
    NSString * string = filePath;
    //<2>如果下载的文件路径中存在中文 不能转换成NSURL 所以必须转码
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //<3>将字符串网址转化成NSURL
    NSURL * url = [NSURL URLWithString:string];
    //<4>封装成请求对象
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    //<5>创建下载管理者对象
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //参数是监控进度的变化 也就是KVO
    NSProgress * tempProgress = nil;
    //<6>创建下载任务
    /*
     1、请求对象的指针
     2、下载进度的对象指针
     3、下载的文件的存放的路径
     */
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:&tempProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSData * data = [NSData dataWithContentsOfURL:targetPath];
        [data writeToFile:fileName1 atomically:YES];
        
        if (data)
        {
            if (success) {
                success(data);
            }
        }
        else
        {
            NSError * error =  nil;
            if (failed) {
                failed(error);
            }
            
        }
        return targetPath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@",error.description);
    }];
    //<8>开始下载
    [task resume];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == videoProgress&&[keyPath isEqualToString:@"fractionCompleted"]) {
        NSLog(@"%.2f%%",videoProgress.fractionCompleted*100);
    }
}
@end
