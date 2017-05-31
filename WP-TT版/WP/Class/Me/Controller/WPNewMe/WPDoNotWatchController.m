//
//  WPDoNotWatchController.m
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPDoNotWatchController.h"
#import "FriendListModel.h"
#import "FriendCell.h"
#import "WPBlackListController.h"
#import "PersonalInfoViewController.h"

#define kDoNotWatchCellReuse @"kDoNotWatchCellReuse"

@interface WPDoNotWatchController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,WPBlackListControllerDelegate>
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)NSMutableArray *friendArr;

@property (nonatomic ,assign)BOOL showRemoveFriendView;


@end

@implementation WPDoNotWatchController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestWithAction:self.action];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self requestWithAction:self.action];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.showRemoveFriendView == YES) {
        return self.friendArr.count+2;
    }else{
        return self.friendArr.count+1;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDoNotWatchCellReuse forIndexPath:indexPath];
    NSInteger number = indexPath.row - self.friendArr.count;
    if (number == 0) {
        cell.image = [UIImage imageNamed:@"commom_tianjia"];
        cell.name = @"";
    }else if(number == 1){
        cell.image = [UIImage imageNamed:@"commom_yichu"];
        cell.name = @"";
    }else{
        cell.model = self.friendArr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger number = indexPath.row - self.friendArr.count;
    if (number == 0) {
        WPBlackListController *blackVC = [[WPBlackListController alloc]init];
        NSLog(@"添加");
        blackVC.delegate = self;
        blackVC.pushViewData = self.friendArr;
        blackVC.title = @"选择联系人";
        blackVC.action = self.action;
        [self.navigationController pushViewController:blackVC animated:YES];
    }else if(number == 1){
        WPBlackListController *blackVC = [[WPBlackListController alloc]init];
        NSLog(@"移除");
        blackVC.title = @"移除好友";
        blackVC.pushViewData = self.friendArr;
        blackVC.action = self.action;
        blackVC.delegate = self;
        [self.navigationController pushViewController:blackVC animated:YES];
    }else{
       
        PersonalInfoViewController *person = [[PersonalInfoViewController alloc] init];
        person.friendID = [self.friendArr[indexPath.item] friend_id];
        person.newType = NewRelationshipTypeFriend;  //is_friend 全部都是好友，这个字段现在是不用的
        person.comeFromVc = @"黑名单";
        [self.navigationController pushViewController:person animated:YES];
    }
    
}

- (void)reloadData
{
    [self requestWithAction:self.action];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumInteritemSpacing = 18;
        layOut.minimumLineSpacing = 18;
        CGFloat width = (SCREEN_WIDTH-18*5)/4;
        CGRect rect = [@"刘德华" boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil];
        layOut.itemSize = CGSizeMake(width, width+8+rect.size.height);
//        layOut.headerReferenceSize = CGSizeMake(0, 18);
//        layOut.footerReferenceSize = CGSizeMake(0, 18);
        layOut.sectionInset = UIEdgeInsetsMake(18, 18, 18, 18);
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layOut];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[FriendCell class]  forCellWithReuseIdentifier:kDoNotWatchCellReuse];
    }
    return _collectionView;
}

- (void)requestWithAction:(NSString *)action
{
    [self.friendArr removeAllObjects];
    NSDictionary *params = @{@"action":action,@"user_id":kShareModel.userId,@"username":kShareModel.username,@"password":kShareModel.password};
    NSString *urlstr = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
    [WPHttpTool postWithURL:urlstr params:params success:^(id json) {
        FrienDListModel *model = [FrienDListModel mj_objectWithKeyValues:json];
        [self.friendArr removeAllObjects];
        [self.friendArr addObjectsFromArray: model.list];
        if (self.friendArr.count == 0 ||self.friendArr == nil) {
            self.showRemoveFriendView = NO;
        }else{
            self.showRemoveFriendView = YES;
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (NSMutableArray *)friendArr
{
    if (!_friendArr) {
        self.friendArr = [NSMutableArray array];
    }
    return _friendArr;
}

@end
