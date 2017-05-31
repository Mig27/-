//
//  inviteAndApplyCellController.m
//  WP
//
//  Created by CC on 16/9/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "inviteAndApplyCellController.h"

@interface inviteAndApplyCellController ()

@end

@implementation inviteAndApplyCellController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//修改了群的资料时在消息内容界面修改title
+(NSString*)getTitleFromString:(NSString*)titleString
{
    NSString * title = [NSString string];
    NSData * data = [titleString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (dictionary.count == 2) {
        NSString * note_type = dictionary[@"content"][@"note_type"];
        if ([note_type isEqualToString:@"10"]) {
            title = dictionary[@"content"][@"for_username"];
        }
        else
        {
          title = @"";
        }
    }
    else
    {
        NSString * note_type = dictionary[@"note_type"];
        if ([note_type isEqualToString:@"10"]) {
            title = dictionary[@"for_username"];
        }
        else
        {
            title = @"";
        }
    }
    return title;
}

+(NSString*)getTextFromString:(NSString*)textString
{
  
    NSString * backString = [NSString string];
    NSData * data = [textString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    if (dictionary.count == 2)
    {
        
        NSString * note_type = dictionary[@"content"][@"note_type"];
        switch (note_type.intValue) {
            case 0://申请
            {
                NSString * for_userid = dictionary[@"content"][@"for_userid"];
                if ([for_userid isEqualToString:kShareModel.userId]) {
                    backString  = @"你加入了群组";
                }
                else
                {
                    backString  = [NSString stringWithFormat:@"%@加入了群组",dictionary[@"content"][@"for_username"]];
                }
            }
                break;
            case 1://邀请
            {
                NSString * create_userid = dictionary[@"content"][@"create_userid"];
                if ([create_userid isEqualToString:kShareModel.userId]) {
                    backString  = [NSString stringWithFormat:@"你邀请%@加入群组",dictionary[@"content"][@"for_username"]];
                }
                else
                {
                    NSString * for_userid = dictionary[@"content"][@"for_userid"];
                    if ([for_userid isEqualToString:kShareModel.userId]) {
                        backString  = [NSString stringWithFormat:@"%@邀请你加入群组",dictionary[@"content"][@"create_username"]];
                    }
                    else
                    {
                        backString  = [NSString stringWithFormat:@"%@邀请%@加入群组",dictionary[@"content"][@"create_username"],dictionary[@"content"][@"for_username"]];
                        
                        NSString * nameStr = dictionary[@"content"][@"for_username"];
                        NSArray * nameArray = [nameStr componentsSeparatedByString:@","];
                        NSMutableArray * nameMuArr = [NSMutableArray array];
                        [nameMuArr addObjectsFromArray:nameArray];
                        for (int i = 0 ; i < nameArray.count; i++) {
                            NSString * string = nameArray[i];
                            if ([string isEqualToString:kShareModel.nick_name]) {
                                [nameMuArr replaceObjectAtIndex:i withObject:@"你"];
                            }
                        }
                        NSString * nameString = [nameMuArr componentsJoinedByString:@","];
                        backString = [NSString stringWithFormat:@"%@邀请%@加入群组",dictionary[@"content"][@"create_username"],nameString];
                    }
                }
            }
                break;
            case 2://退出
                
                break;
            case 3://移除
            {
                NSString * create_userid = dictionary[@"content"][@"create_userid"];
                if ([create_userid isEqualToString:kShareModel.userId]) {
                   backString  = @"";
                }
                else
                {
                    NSString * for_userid = dictionary[@"content"][@"for_userid"];
                    if ([for_userid isEqualToString:kShareModel.userId]) {
                        backString  = @"你已被移出群组";
                    }
                    else
                    {
                        backString  = [NSString stringWithFormat:@"%@已被移出群组",dictionary[@"content"][@"for_username"]];
                    }
                }
            }
                break;
                case 8:
            {
              backString = @"消息已发出,但被对方拒收了。";
            }
                break;
                case 9:
            {
              backString = @"你还不是对方的好友,添加对方为好友,成功后即可聊天\n";
            }
                break;
                case 10:
            {
                NSString * name = dictionary[@"content"][@"create_username"];
                if ([name isEqualToString:kShareModel.nick_name]) {
                    name = @"你";
                }
                backString = [NSString stringWithFormat:@"%@修改了群资料",name];
            }
                break;
            case 11:
            {
                backString = @"群创建成功!";
            }
                break;
            default:
                break;
        }
    }
    else
    {
        
        NSString * note_type = dictionary[@"note_type"];
        switch (note_type.intValue) {
            case 0://申请
            {
                NSString * for_userid = dictionary[@"for_userid"];
                if ([for_userid isEqualToString:kShareModel.userId]) {
                    backString  = @"你加入了群组";
                }
                else
                {
                    backString  = [NSString stringWithFormat:@"%@加入了群组",dictionary[@"for_username"]];
                }
            }
                break;
            case 1://邀请
            {
                NSString * create_userid = dictionary[@"create_userid"];
                if ([create_userid isEqualToString:kShareModel.userId]) {
                   backString  = [NSString stringWithFormat:@"你邀请%@加入群组",dictionary[@"for_username"]];
                }
                else
                {
                    NSString * for_userid = dictionary[@"for_userid"];
                    if ([for_userid isEqualToString:kShareModel.userId]) {
                        backString  = [NSString stringWithFormat:@"%@邀请你加入群组",dictionary[@"create_username"]];
                    }
                    else
                    {
                        backString  = [NSString stringWithFormat:@"%@邀请%@加入群组",dictionary[@"create_username"],dictionary[@"for_username"]];
                        
                        
                        
                        NSString * nameStr = dictionary[@"for_username"];
                        NSArray * nameArray = [nameStr componentsSeparatedByString:@","];
                        NSMutableArray * nameMuArr = [NSMutableArray array];
                        [nameMuArr addObjectsFromArray:nameArray];
                        for (int i = 0 ; i < nameArray.count; i++) {
                            NSString * string = nameArray[i];
                            if ([string isEqualToString:kShareModel.nick_name]) {
                                [nameMuArr replaceObjectAtIndex:i withObject:@"你"];
                            }
                        }
                        NSString * nameString = [nameMuArr componentsJoinedByString:@","];
                        backString = [NSString stringWithFormat:@"%@邀请%@加入群组",dictionary[@"create_username"],nameString];
                    }
                }
            }
                break;
            case 2://退出
                
                break;
            case 3://移除
            {
                NSString * create_userid = dictionary[@"create_userid"];
                if ([create_userid isEqualToString:kShareModel.userId]) {
                    backString  = @"";
                }
                else
                {
                    NSString * for_userid = dictionary[@"for_userid"];
                    if ([for_userid isEqualToString:kShareModel.userId]) {
                        backString  = @"你已被移出群组";
                    }
                    else
                    {
                        backString = [NSString stringWithFormat:@"%@已被移出群组",dictionary[@"content"][@"for_username"]];
                    }
                }
            }
                break;
                case 8:
            {
              backString = @"消息已发出,但被对方拒收了。";
            }
                break;
            case 9:
            {
                backString = @"你还不是对方的好友,添加对方为好友,成功后即可聊天\n";
            }
                break;
                case 10:
            {
                NSString * name =dictionary[@"create_username"];
                if ([name isEqualToString:kShareModel.nick_name]) {
                    name = @"你";
                }
                backString = [NSString stringWithFormat:@"%@修改了群资料",name];
            }
                break;
            case 11:
            {
                backString = @"群创建成功!";
            }
                break;
            default:
                break;
        }
    }
    return backString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
