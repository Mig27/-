//
//  SPRecSubview.m
//  WP
//
//  Created by CBCCBC on 15/10/27.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "SPRecSubview.h"
#import "SPTitleItem.h"
#import "SPItemPreview3.h"
#import "SPItemPreview4.h"
#import "SPButton.h"
#import "SPItemView.h"

@implementation SPRecSubview
{
    CGFloat welfareHeight;
    CGFloat requireHeight;
}
- (id)initWithTop:(CGFloat)top title:(NSString *)title Model:(WPRecEditModel *)model{
    self = [super init];
    if (self) {
        self.backgroundColor = RGB(235, 235, 235);
//        self.backgroundColor = [UIColor redColor];
        
        SPTitleItem *item = [[SPTitleItem alloc]initWithTop:0 title:title];
        [self addSubview:item];
        
        SPItemPreview3 *position = [[SPItemPreview3 alloc]initWithTop:item.bottom title:@"招聘职位:" content:model.jobPositon];
        [self addSubview:position];
        
        SPItemPreview3 *industry = [[SPItemPreview3 alloc]initWithTop:position.bottom title:@"行       业:" content:model.jobIndustry];
        [self addSubview:industry];
        
        SPItemPreview3 *wage = [[SPItemPreview3 alloc]initWithTop:industry.bottom title:@"工资待遇:" content:model.salary];
        [self addSubview:wage];
//        NSLog(@"%@",NSStringFromCGRect(wage.frame));
        UIView *welfareView = [[UIView alloc]initWithFrame:CGRectMake(0, wage.bottom+6, SCREEN_WIDTH, 31+60)];
        welfareView.backgroundColor = [UIColor whiteColor];
        [self addSubview:welfareView];
        
        NSArray *welfareArr = [model.epRange componentsSeparatedByString:@"/"];
        if (welfareArr.count == 1&&[welfareArr[0] isEqualToString:@""]) {
            welfareView.height = -6;
        }else{
            SPTitleItem *item1 = [[SPTitleItem alloc]initWithTop:0 title:@"企业福利"];
            [welfareView addSubview:item1];
            if (welfareArr.count <= 3) {
                welfareView.height = 32+30;
            }
            if (welfareArr.count>3&&welfareArr.count<=6) {
                welfareView.height = 32+60;
            }
            
            for (int i = 0; i < welfareArr.count; i++) {
                int col = i/3;
                int row = i%3;
//                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(row*SCREEN_WIDTH/3, col*30+item1.bottom, SCREEN_WIDTH/3, 30)];
//                label.text = welfareArr[i];
//                label.font = GetFont(15);
//                label.textAlignment = NSTextAlignmentCenter;
//                [welfareView addSubview:label];
                NSString *imageName = [self returnSPButtonImageName:welfareArr[i]];
                SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(row*SCREEN_WIDTH/3, col*30+item1.bottom, SCREEN_WIDTH/3, 30) title:welfareArr[i] ImageName:imageName Target:self Action:nil];
                button.contentAlignment = SPButtonContentAlignmentLeft;
                [welfareView addSubview:button];
            }
            UILabel *label1= [[UILabel alloc]initWithFrame:CGRectMake(0, welfareView.bottom+10, SCREEN_WIDTH, 6)];
            label1.backgroundColor = [UIColor whiteColor];
            [self addSubview:label1];
        }
        welfareHeight = welfareView.height;

        SPItemPreview3 *works = [[SPItemPreview3 alloc]initWithTop:welfareView.bottom+6 title:@"学       历:" content:model.workTime];
        [self addSubview:works];
        
        SPItemPreview3 *education = [[SPItemPreview3 alloc]initWithTop:works.bottom title:@"学       历:" content:model.education];
        [self addSubview:education];
        
        SPItemPreview3 *sex = [[SPItemPreview3 alloc]initWithTop:education.bottom title:@"性       别:" content:model.sex];
        [self addSubview:sex];
        
        SPItemPreview3 *age = [[SPItemPreview3 alloc]initWithTop:sex.bottom title:@"年       龄:" content:model.age];
        [self addSubview:age];
        
        SPItemPreview3 *numbers = [[SPItemPreview3 alloc]initWithTop:age.bottom title:@"招聘人数:" content:model.invitenumbe];
        [self addSubview:numbers];

        NSString *address = [NSString stringWithFormat:@"%@%@",model.workAddress,model.workAdS];
        SPItemPreview3 *workAddress = [[SPItemPreview3 alloc]initWithTop:numbers.bottom title:@"工作地点:" content:address];
        [self addSubview:workAddress];
        
        UILabel *label2= [[UILabel alloc]initWithFrame:CGRectMake(0, workAddress.bottom, SCREEN_WIDTH, 16)];
        label2.backgroundColor = [UIColor whiteColor];
        [self addSubview:label2];
        
        SPItemPreview4 *name = [[SPItemPreview4 alloc]initWithTop:label2.bottom+6 title:@"联系人:" content:model.industry];
        [self addSubview:name];
        
        SPItemPreview4 *phone = [[SPItemPreview4 alloc]initWithTop:name.bottom title:@"联系方式:" content:model.Tel];
        [self addSubview:phone];
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, phone.bottom+6, SCREEN_WIDTH, 60)];
        view2.backgroundColor = [UIColor whiteColor];
        [self addSubview:view2];
        
        SPTitleItem *item2 = [[SPTitleItem alloc]initWithTop:0 title:@"任职要求"];
        [view2 addSubview:item2];
        
//        NSString *str = @"春在田畴，松软的泥土散发着清新湿润的气息，冬憩后醒来的麦苗儿精神焕发，展现出一派蓬勃盎然的生机；渠水欢唱，如母爱的乳汁，与土地和麦苗的血液水乳交融。春在河畔，碧波清荡，鱼虾畅游，蛙鼓抑扬弄喉嗓，柳丝婆娑舞倩影，阳光水波交相辉映，洒落捧捧金和银。春在天空，燕语呢喃，蝴蝶翩跹，风筝高飞，浓浓春意弥漫洁白的云朵间，甜脆笑声穿梭浩淼九天。春在果园，红杏流火，桃花漫霞，梨树飞雪，蜂蝶追逐喧嚷，酝酿生活的甘甜和芬芳";
        NSString *str = model.Require;
        CGSize size = [str getSizeWithFont:[UIFont systemFontOfSize:15] Width:SCREEN_WIDTH-20];
        UILabel *duty = [[UILabel alloc]initWithFrame:CGRectMake(10, item2.bottom, SCREEN_WIDTH-20, size.height)];
        duty.text = str;
        duty.font = GetFont(15);
        duty.numberOfLines = 0;
        [view2 addSubview:duty];
        
        view2.height = size.height+32+16;
        requireHeight = view2.height;
        
//        NSLog(@"#####初始化时的高度###%f#####%f",welfareHeight,requireHeight);
//        
//        NSLog(@"======任职要求的FRAME======%@",NSStringFromCGRect(view2.frame));
        
        self.frame = CGRectMake(0, top, SCREEN_WIDTH, view2.bottom+6);
//        NSLog(@"%@",NSStringFromCGRect(self.frame));
    }
    return self;
}

+ (CGFloat)returnHeight:(WPRecEditModel *)model{
    CGFloat welfareHeight = 0;
    CGFloat requireHeight = 0;
    NSArray *welfareArr = [model.epRange componentsSeparatedByString:@"/"];
    if (welfareArr.count == 1&&[welfareArr[0] isEqualToString:@""]) {
        welfareHeight = -6;
    }else{
        if (welfareArr.count<=3) {
            welfareHeight = 32+30;
        }
        if (welfareArr.count>3&&welfareArr.count<=6) {
            welfareHeight = 32+60;
        }
    }
    CGSize size = [model.Require getSizeWithFont:[UIFont systemFontOfSize:15] Width:SCREEN_WIDTH-20];
    requireHeight = size.height+32+16;
//    NSLog(@"########返回时的高度###%f#####%f",welfareHeight,requireHeight);
    CGFloat height = 122+welfareHeight+6+32*6+16+6+43*2+6+requireHeight;
//    NSLog(@"**************返回的子视图的高度**************%f",height);
    return height;
}

- (NSString *)returnSPButtonImageName:(NSString *)title{
    NSString *imageName = @"NULL";
    if ([title isEqualToString:@"包吃包住"]) {
        imageName = @"baochibaozhu";
    }
    if ([title isEqualToString:@"五险一金"]) {
        imageName = @"wuxianyijin";
    }
    if ([title isEqualToString:@"周末双休"]) {
        imageName = @"zhoumoshuangxiu";
    }
    if ([title isEqualToString:@"交通补助"]) {
        imageName = @"jiaotongbuzhu";
    }
    if ([title isEqualToString:@"加班补助"]) {
        imageName = @"jiabanbuzhu";
    }
    if ([title isEqualToString:@"年底双薪"]) {
        imageName = @"niandishuangxin";
    }
    return imageName;
}

@end
