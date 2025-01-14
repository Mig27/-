//
//  GroupMemberTableViewIndex.m
//  WP
//
//  Created by 沈亮亮 on 16/4/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupMemberTableViewIndex.h"
#import "pinyin.h"
#import "GroupMemberModel.h"

@implementation GroupMemberTableViewIndex

+ (NSMutableArray *)archive:(NSArray *)arr
{
    NSMutableArray *stringsToSort = [[NSMutableArray alloc]initWithArray:arr];
    //    for (NSDictionary *dic in arr) {
    //
    //        LinkManListModel *model = [[LinkManListModel alloc]init];
    //        [model setValuesForKeysWithDictionary:dic];
    //        [stringsToSort addObject:model];
    //    }
    //
    ////    Step1输出
    //        NSLog(@"尚未排序的NSString数组:");
    //        for(int i=0;i<[stringsToSort count];i++){
    //            NSLog(@"%@",[stringsToSort objectAtIndex:i]);
    //        }
    
    //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringsToSort count];i++){
        
        GroupMemberListModel *model = stringsToSort[i];
        
        model.chineseString = [[ChineseString alloc]init];
        model.chineseString.string = model.nick_name;
        
        if(model.chineseString.string==nil){
            model.chineseString.string=@"";
        }
        
        if(![model.chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            
            for(int j=0;j<model.chineseString.string.length;j++){
                
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([model.chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                
            }
            model.chineseString.pinYin=pinYinResult;
        }else{
            model.chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:model];
    }
    
    NSArray *letters = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    NSArray *numbers = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    for (int i = 0; i < 27; i++) {
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [datas addObject:arr];
    }
    
    for (int i = 0; i < chineseStringsArray.count; i++) {
        
        GroupMemberListModel *model = chineseStringsArray[i];
        
        for (int j = 0; j < letters.count; j++) {
            
            if ([[model.chineseString.pinYin substringToIndex:1] isEqualToString:letters[j]]) {
                
                [datas[j] insertObject:model atIndex:0];
            }
            
        }
        
        for (int k = 0; k < numbers.count; k++) {
            
            if ([[model.chineseString.pinYin substringToIndex:1] isEqualToString:numbers[k]]) {
                
                [datas[26] insertObject:model atIndex:0];
            }
        }
        
    }
    
    return datas;
}


@end
