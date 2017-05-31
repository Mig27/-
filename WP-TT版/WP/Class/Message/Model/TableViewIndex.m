//
//  TableViewIndex.m
//  tableViewIndex
//
//  Created by Spyer on 15/2/2.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "TableViewIndex.h"
//#import "IndexModel.h"
#import "pinyin.h"
#import "LinkManModel.h"
#import "WPPhoneBookContactDetailModel.h"
#import "WPGetFriendListResult.h"
#import "WPFriendListModel.h"
#import "WPSeeOrNotModel.h"

@implementation TableViewIndex

+ (NSMutableArray *)archive:(NSArray *)arr
{
    NSMutableArray *stringsToSort = [[NSMutableArray alloc]initWithArray:arr];
    //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringsToSort count];i++){
        LinkManListModel *model = stringsToSort[i];
        model.chineseString = [[ChineseString alloc]init];
        model.chineseString.string = model.user_name;
        
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
        
        WPFriendListModel *model = chineseStringsArray[i];
        
        for (int j = 0; j < letters.count; j++) {
            NSLog(@"%@",model.chineseString.pinYin);
            if (!model.chineseString.pinYin.length) {
                break;
            }
            if ([[model.chineseString.pinYin substringToIndex:1] isEqualToString:letters[j]]) {
                
                [datas[j] insertObject:model atIndex:0];
            }
            
        }
        
        for (int k = 0; k < numbers.count; k++) {
            if (!model.chineseString.pinYin.length) {
                break;
            }
            if ([[model.chineseString.pinYin substringToIndex:1] isEqualToString:numbers[k]]) {
                
                [datas[26] insertObject:model atIndex:0];
            }
        }
        
    }
//    for (int i = 0; i < chineseStringsArray.count; i++) {
//        LinkManListModel *model = chineseStringsArray[i];
//        for (int j = 0; j < letters.count; j++) {
//            if (model.chineseString.pinYin.length) {
//                if ([[model.chineseString.pinYin substringToIndex:1] isEqualToString:letters[j]]) {
//                    
//                    [datas[j] insertObject:model atIndex:0];
//                }
//            }
//            else
//            {
//            }
//        }
//        for (int k = 0; k < numbers.count; k++) {
//            if (model.chineseString.pinYin.length) {
//                if ([[model.chineseString.pinYin substringToIndex:1] isEqualToString:numbers[k]]) {
//                    
//                    [datas[26] insertObject:model atIndex:0];
//                }
//            }
//            else
//            {
//            
//            }
//        }
//    }
    return datas;
}

+ (NSMutableArray *)transferSee:(NSArray *)arr
{
    NSMutableArray *stringsToSort = [[NSMutableArray alloc]initWithArray:arr];
    
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringsToSort count];i++){
        
        WPSeeOrNotModel *model = stringsToSort[i];
        
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
        WPSeeOrNotModel *model = chineseStringsArray[i];
        for (int j = 0; j < letters.count; j++) {
            if (!model.chineseString.pinYin.length) {
                break;
            }
            if ([[model.chineseString.pinYin substringToIndex:1] isEqualToString:letters[j]]) {
                [datas[j] insertObject:model atIndex:0];
            }
        }
        for (int k = 0; k < numbers.count; k++) {
            if (!model.chineseString.pinYin.length) {
                break;
            }
            if ([[model.chineseString.pinYin substringToIndex:1] isEqualToString:numbers[k]]) {
                [datas[26] insertObject:model atIndex:0];
            }
        }
    }
    return datas;
}



+ (NSMutableArray *)transfer:(NSArray *)arr
{
    NSMutableArray *stringsToSort = [[NSMutableArray alloc]initWithArray:arr];

    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringsToSort count];i++){
        
        WPFriendListModel *model = stringsToSort[i];
        
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
        
        WPFriendListModel *model = chineseStringsArray[i];
        
        for (int j = 0; j < letters.count; j++) {
            NSLog(@"%@",model.chineseString.pinYin);
            if (!model.chineseString.pinYin.length) {
                break;
            }
            if ([[model.chineseString.pinYin substringToIndex:1] isEqualToString:letters[j]]) {
                
                [datas[j] insertObject:model atIndex:0];
            }
            
        }
        
        for (int k = 0; k < numbers.count; k++) {
            if (!model.chineseString.pinYin.length) {
                break;
            }
            if ([[model.chineseString.pinYin substringToIndex:1] isEqualToString:numbers[k]]) {
                
                [datas[26] insertObject:model atIndex:0];
            }
        }
        
    }
    
    return datas;
}


@end
