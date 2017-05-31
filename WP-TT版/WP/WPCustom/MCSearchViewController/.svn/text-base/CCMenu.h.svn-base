
#import <UIKit/UIKit.h>
#import "IndustryModel.h"
#import "CCIndexPath.h"

@protocol CCMenuDelegate <NSObject>

-(void)CCMenuDelegate:(IndustryModel *)model;

- (void)CCMenuDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model;

@end

@interface CCMenu : UIView <UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id <CCMenuDelegate> delegate;
@property (assign, nonatomic) BOOL isArea;
@property (assign, nonatomic) BOOL isIndusty;   /**< 行业 */
@property (nonatomic, assign) BOOL isResume; /**< 是否是全职模块 */
@property (copy, nonatomic) void (^touchHide)();

/**
 *  通过给定的网络地址和参数格式进行网络请求
 *
 *  @param urlStr 请求地址
 *  @param params 上传参数
 */
-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params;

-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params selectedIndex:(CCIndexPath *)selectedIndexPath;

/**
 * 本地数据操作
 *
 *  @param arr 给定的数组数据
 */
-(void)setLocalData:(NSArray *)arr;

-(void)setLocalData:(NSArray *)arr selectedIndex:(NSInteger)selectedIndex;

/**
 *  移除视图
 */
-(void)remove;

@end


