//
//  UISelectMenu.m
//  WP
//
//  Created by 沈亮亮 on 15/10/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "UISelectMenu.h"
#import "MacroDefinition.h"
#import "WPHttpTool.h"
#import "SelectModel.h"
#import "IndustryModel.h"

#import "SelectTableViewCell.h"
#import "WPShareModel.h"

@interface UISelectMenu ()

@property (strong, nonatomic) NSArray *firstArr;
@property (strong, nonatomic) NSArray *secondArr;
@property (strong, nonatomic) UITableView *firstTableView;
@property (strong, nonatomic) UITableView *secondTableView;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (copy, nonatomic) NSString *urlStr;
@property (assign, nonatomic) NSInteger orignalHeight;

@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *area;

@property (assign, nonatomic) BOOL isLocal;

@end

@implementation UISelectMenu

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        _orignalHeight = self.size.height;
        _isLocal = NO;
    }
    return self;
}

-(void)remove
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.firstTableView.height = 0;
        self.secondTableView.height = 0;
        self.height = 0;
    }];
}

-(void)setLocalData:(NSArray *)arr
{
    _isLocal = YES;
    self.firstArr = [[NSArray alloc]initWithArray:arr];
    self.firstTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.secondTableView.frame = CGRectMake(self.width, 0, self.width/2, _orignalHeight);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.height = _orignalHeight;
        self.firstTableView.frame = CGRectMake(0, 0, self.width, arr.count*kHEIGHT(43));
        
    }];
    [self.firstTableView reloadData];
    
}

-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params
{
    _isLocal = NO;
    _province = @"";
    _city = @"";
    _area = @"";
    self.urlStr = urlStr;
    self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    self.firstTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.secondTableView.frame = CGRectMake(self.width, 0, self.width/2, _orignalHeight);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.height = _orignalHeight;
        self.firstTableView.frame = CGRectMake(0, 0, self.width, self.height);
        
    }];
    [self firstNetworkWithFatherId];
}

-(UITableView *)firstTableView
{
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-30) style:UITableViewStylePlain];
        _firstTableView.showsVerticalScrollIndicator = NO;
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        [self addSubview:_firstTableView];
    }
    return _firstTableView;
}

-(UITableView *)secondTableView
{
    if (!_secondTableView) {
        
        _secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.width, 0, self.width/2, self.height) style:UITableViewStylePlain];
        _secondTableView.showsVerticalScrollIndicator = NO;
        _secondTableView.backgroundColor = RGB(216, 216, 216);
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        [self addSubview:_secondTableView];
    }
    return _secondTableView;
}

-(NSArray *)firstArr
{
    if (!_firstArr) {
        _firstArr = [[NSArray alloc]init];
    }
    return _firstArr;
}

-(NSArray *)secondArr
{
    if (!_secondArr) {
        _secondArr = [[NSArray alloc]init];
    }
    return _secondArr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _firstTableView) {
        
        return self.firstArr.count;
    }else{
        return self.secondArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellId = @"cellId";
//    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        
//        cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    
//    cell.titleLabel.frame = CGRectMake(10, 0, _firstTableView.width-20, 60);
//    if (tableView == _firstTableView) {
////        NSLog(@"&&&&&&&%@",[self.firstArr[indexPath.row] industryName]);
//        cell.titleLabel.text = [self.firstArr[indexPath.row] industryName];
//    }else{
//        cell.backgroundColor = RGB(216, 216, 216);
//        cell.titleLabel.text = [self.secondArr[indexPath.row] industryName];
//    }
//    
//    return cell;
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
//    cell.textLabel.frame = CGRectMake(10, 0, _firstTableView.width-20, 60);
    cell.textLabel.font = kFONT(15);
    if (tableView == _firstTableView) {
        //        NSLog(@"&&&&&&&%@",[self.firstArr[indexPath.row] industryName]);
        cell.textLabel.text = [self.firstArr[indexPath.row] industryName];
    }else{
        cell.backgroundColor = RGB(216, 216, 216);
        cell.textLabel.text = [self.secondArr[indexPath.row] industryName];
    }
    
    return cell;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(43);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isLocal) {
        NSLog(@"%@",self.firstArr[indexPath.row]);
        if (self.delegate) {
            [self.delegate UISelectDelegate:self.firstArr[indexPath.row] selectMenu:self];
        }
    }else{
        if (tableView == _firstTableView) {
            NSString *is_alone = [_firstArr[indexPath.row] is_alone];
//            NSLog(@"******%@",is_alone);
            if ([is_alone isEqualToString:@"0"]) { //是直辖市
                [self.delegate UISelectDelegate:self.firstArr[indexPath.row] selectMenu:self];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.firstTableView.width = self.width/2;
                    self.secondTableView.left = self.width/2;
                }];
                [_firstTableView reloadData];
                [_firstTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                
                [self secondNetworkWithFatherId:[_firstArr[indexPath.row] industryID] row:indexPath];
            }
        }else{
            [self.delegate UISelectDelegate:self.secondArr[indexPath.row] selectMenu:self];
//            [self thirdNetworkWithFatherId:[_secondArr[indexPath.row] industryID] row:indexPath];
        }
    }
}

-(void)firstNetworkWithFatherId
{
    [WPHttpTool postWithURL:self.urlStr params:self.params success:^(id json) {
//        NSLog(@"######%@",json);
        SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
        self.firstArr =  model.list;
        [self.firstTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)secondNetworkWithFatherId:(NSString *)fatherId row:(NSIndexPath *)indexPath
{
    
    [self.params setValue:fatherId forKey:@"fatherid"];
    [WPHttpTool postWithURL:self.urlStr params:self.params success:^(id json) {
        SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
        _province = [_firstArr[indexPath.row] industryName];/**< 省 */
        self.secondArr = model.list;
        
        [self.secondTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)thirdNetworkWithFatherId:(NSString *)fatherId row:(NSIndexPath *)indexPath
{
    [self.params setValue:fatherId forKey:@"fatherid"];
    [WPHttpTool postWithURL:self.urlStr params:self.params success:^(id json) {
        SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
        if (model.list.count > 0) {/**< 市 */
            _city = [_secondArr[indexPath.row] industryName];
            self.firstArr = self.secondArr;
            self.secondArr = model.list;
            
            [self.firstTableView reloadData];
            [self.firstTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self.secondTableView reloadData];
        }else{/**< 区 */
            _area = [self.secondArr[indexPath.row] industryName];
            if (self.delegate) {
                [self remove];
                if (self.isArea) {
                    IndustryModel *model = _secondArr[indexPath.row];
                    model.industryName = [NSString stringWithFormat:@"%@%@%@",_province,_city,_area];
                    [self.delegate UISelectDelegate:model selectMenu:self];
                }else{
                    [self.delegate UISelectDelegate:_secondArr[indexPath.row] selectMenu:self];
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"111111111111111");
    if (self.touchHide) {
        self.touchHide();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
