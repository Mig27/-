//
//  RecentPersonController.m
//  WP
//
//  Created by CBCCBC on 16/1/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "RecentPersonController.h"
#import "RSFmdbTool.h"
#import "LinkmanCell.h"
#import "RSChatMessageModel.h"
#import "UIImageView+WebCache.h"
#import "YYAlertManager.h"
#import "ShareConnectPersonController.h"

@interface RecentPersonController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tableHeaderView;
@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation RecentPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    
//    self.title = @"分享给好友";
//    
//    [self tableView];
//    [self tableHeaderView];
//    [self getRecentPerson];
}

//- (NSMutableArray *)array{
//    if (!_array) {
//        _array = [[NSMutableArray alloc]init];
//    }
//    return _array;
//}
//
//- (NSArray *)shareArray{
//    if (!_shareArray) {
//        _shareArray = [[NSArray alloc]init];
//    }
//    return _shareArray;
//}
//
//- (UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.tableHeaderView = self.tableHeaderView;
//        _tableView.tableFooterView = [[UIView alloc]init];
//        [self.view addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.view);
//            make.top.equalTo(self.view).offset(64);
//        }];
//        
//        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
//        {
//            [_tableView setSeparatorInset:UIEdgeInsetsZero];
//        }
//        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
//        {
//            [_tableView setLayoutMargins:UIEdgeInsetsZero];
//        }
//    }
//    return _tableView;
//}
//
//- (UIView *)tableHeaderView{
//    if (!_tableHeaderView) {
//        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(50)+40)];
//        
//        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//        [_tableHeaderView addSubview:searchBar];
//        searchBar.delegate = self;
//        searchBar.placeholder = @"搜索";
//        searchBar.tintColor = [UIColor lightGrayColor];
//        searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//        searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        searchBar.keyboardType = UIKeyboardTypeDefault;
//        searchBar.backgroundColor = WPColor(235, 235, 235);
//        for (UIView* view in searchBar.subviews) {
//            // for before iOS7.0
//            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//                [view removeFromSuperview];
//                break;
//            }
//            // for later iOS7.0(include)
//            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//                [[view.subviews objectAtIndex:0] removeFromSuperview];
//                break;
//            }
//        }
//        
//        UIButton *addressBookView = [[UIButton alloc]initWithFrame:CGRectMake(0, searchBar.bottom, SCREEN_WIDTH, kHEIGHT(50))];
//        addressBookView.backgroundColor = [UIColor whiteColor];
//        [addressBookView setImage:[UIImage imageNamed:@"gray_background"] forState:UIControlStateHighlighted];
//        [addressBookView addTarget:self action:@selector(addressBookActions) forControlEvents:UIControlEventTouchUpInside];
//        [_tableHeaderView addSubview:addressBookView];
//        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(10), 0, 100, addressBookView.height)];
//        label.text = @"通讯录";
//        [addressBookView addSubview:label];
//        
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, addressBookView.height/2-7, 8, 14)];
//        imageView.image = [UIImage imageNamed:@"jinru"];
//        [addressBookView addSubview:imageView];
//        
//    }
//    return _tableHeaderView;
//}
//
//- (void)addressBookActions{
//    ShareConnectPersonController *shareConnectPerson = [[ShareConnectPersonController alloc]init];
//    shareConnectPerson.shareArray = self.shareArray;
//    [self.navigationController pushViewController:shareConnectPerson animated:YES];
//}
//
//- (void)getRecentPerson{
//    [self.array removeAllObjects];
//    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_modals WHERE login_ID = '%@'",kShareModel.userId];
//    NSArray *megArr = [RSFmdbTool queryData:querySql];
//    [self.array addObjectsFromArray:megArr];
//    [self.tableView reloadData];
//}
//
//- (void)backToFromViewController:(UIButton *)sender{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return kHEIGHT(50);
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.array.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellId = @"";
//    LinkmanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[LinkmanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    
//    RSChatMessageModel *model = self.array[indexPath.row];
//    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatarUrl]];
//    [cell.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
//    
//    cell.nameLabel.text = model.avatarName;
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    [YYAlertManager messages:self.shareArray action:^{
//        
//    }];
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    view.backgroundColor = [UIColor whiteColor];
//    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH, 30)];
//    label.text = @"最近聊天";
//    label.font = kFONT(12);
//    label.textColor= RGB(127, 127, 127);
//    [view addSubview:label];
//    
//    return view;
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
//    {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
//    {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

@end
