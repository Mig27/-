//
//  LocationViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/7/11.
//  Copyright (c) 2015年 WP. All rights reserved.
//  定位页面

#import "LocationViewController.h"
#import "MJRefresh.h"
#import "LocationCell.h"

@interface LocationViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    //为了实现搜索
    UISearchBar *_searchBar;
    
    //创建用于显示搜索界面的对象
    UISearchDisplayController *_searchDisplayController;
    
    //保存搜索界面的数组
    NSMutableArray *_searchResultArray;
}

@property (nonatomic, strong) NSMutableArray *names;
@property (nonatomic, strong) NSMutableArray *adress;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
//@property (nonatomic,weak) MJRefreshFooterView *footer;

@end

@implementation LocationViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _names = [NSMutableArray array];
    _adress = [NSMutableArray array];
    self.page = 1;
    self.mapView = [[MAMapView alloc] init];
    self.mapView.delegate = self;
    
    
    [AMapSearchServices sharedServices].apiKey = @"eb9761d4882a35c670410b580bfa2a50";
    
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //self.search = [[AMapSearchAPI alloc] initWithSearchKey:@"eb9761d4882a35c670410b580bfa2a50" Delegate:self];
//    self.search.delegate = self;
    [self searchPoiByCenterCoordinate];
    self.title = @"所在位置";
    [self createUI];
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate
{
    //AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    //request.searchType          = AMapSearchType_PlaceAround;
    
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    CGFloat latitude = [[user objectForKey:@"latitude"] floatValue];
    CGFloat longitude = [[user objectForKey:@"longitude"] floatValue];
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
//    request.location            = [AMapGeoPoint locationWithLatitude:31.882040 longitude:117.315978];
//    request.keywords            = @"餐饮";
    /* 按照距离排序. */
    request.sortrule            = 1;
    request.offset  = 20;
    request.page = self.page;
    request.requireExtension    = YES;
    
    /* 添加搜索结果过滤 */
//    AMapPlaceSearchFilter *filter = [[AMapPlaceSearchFilter alloc] init];
//    filter.costFilter = @[@"100", @"200"];
//    filter.requireFilter = AMapRequireNone;
//    request.searchFilter = filter;
//    
//    [self.search AMapPlaceSearch:request];  d
}

#pragma mark - AMapSearchDelegate

/* POI 搜索回调. */

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    for (AMapPOI *poi in response.pois) {
        NSLog(@"%@,%@",poi.name,poi.address);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"name"] = poi.name;
        dic[@"address"] = poi.address;
        [_names addObject:dic];
        //        [self.footer endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
    }
}

/*
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
{
    for (AMapPOI *poi in respons.pois) {
        NSLog(@"%@,%@",poi.name,poi.address);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"name"] = poi.name;
        dic[@"address"] = poi.address;
        [_names addObject:dic];
//        [self.footer endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
    }
    
}*/

//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    if (refreshView == self.footer) {
//        _page++;
//        [self searchPoiByCenterCoordinate];
//    }
//}

//- (void)dealloc{
//    [self.footer free];
//}

- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
//    _table1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _page1 = 1;
//        [weakSelf createData1];
//    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakSelf searchPoiByCenterCoordinate];
    }];

//    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//    footer.scrollView = self.tableView;
//    footer.delegate = self;
//    self.footer = footer;
    
    [_tableView reloadData];
//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//    _searchBar.delegate = self;
//    _searchBar.placeholder = @"搜索其他位置";
//    _searchBar.autocapitalizationType = UITextAutocorrectionTypeNo;
//    _searchBar.keyboardType = UIKeyboardTypeDefault;
//    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _tableView.tableHeaderView = _searchBar;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 37)];
    _searchBar.delegate =self;
    _searchBar.placeholder = @"搜索";
    _searchBar.tintColor = [UIColor lightGrayColor];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.backgroundColor = WPColor(235, 235, 235);
    for (UIView *view in _searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }

    _tableView.tableHeaderView = _searchBar;
    //系统UISearchDisPlayController中包含一个tableView
    //      可以用这tableView显示搜索后的数据
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    //要给_searchDisplayController提供搜索结果
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.searchResultsDataSource = self;
    
    //当搜索框文本改变时执行搜索
    _searchResultArray = [[NSMutableArray alloc] init];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != _tableView) {
        [_searchResultArray removeAllObjects];
        for (NSDictionary *dic in _names) {
            if ([dic[@"name"] rangeOfString:_searchBar.text].location != NSNotFound) {
                [_searchResultArray addObject:dic];
            } else {
                
            }
        }
        return _searchResultArray.count;
    }
    return _names.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellId = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
//    }
//    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
//    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    if (tableView != _tableView) {
        LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell == nil) {
            cell = [[LocationCell alloc] init];
        }
        cell.nameLabel.text = _searchResultArray[indexPath.row][@"name"];
        cell.locationLabel.text = _searchResultArray[indexPath.row][@"address"];
        return cell;
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] init];
            }
            cell.textLabel.text = @"始终不显示位置";
            cell.textLabel.textColor = RGBColor(90, 118, 172);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.text = nil;
            return cell;
        } else if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] init];
            }
            cell.textLabel.text = @"始终默认当前位置";
            cell.textLabel.textColor = RGBColor(90, 118, 172);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.text = nil;
            return cell;
        } else {
            LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            if (cell == nil) {
                cell = [[LocationCell alloc] init];
            }
            cell.nameLabel.text = _names[indexPath.row - 2][@"name"];
            cell.locationLabel.text = _names[indexPath.row - 2][@"address"];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView != _tableView) {
        [self.delegate sendBackLocationWith:_searchResultArray[indexPath.row][@"name"]];
    } else {
        if (indexPath.row == 0) {
            [self.delegate sendBackLocationWith:@"默认不显示"];
        } else if (indexPath.row == 1) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *adress = [user objectForKey:@"adress"];
            [self.delegate sendBackLocationWith:adress];
        } else {
            [self.delegate sendBackLocationWith:_names[indexPath.row - 2][@"name"]];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
