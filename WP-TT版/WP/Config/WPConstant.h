//
//  WPConstant.h
//  WP
//
//  Created by Kokia on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>



// 创建简历界面
#define ItemViewHeight kHEIGHT(43)

// 照片高度 (去除间距，left：10， right：30)
#define PhotoHeight ((SCREEN_WIDTH - kHEIGHT(12) - kHEIGHT(6)*3 - 30)/4)

#define PhotoViewHeight (PhotoHeight + 20)


#define kColorCellSelectedBg    RGB(226, 226, 226)


// 图片 固定高度
#define kCellHeight ceil((kScreenWidth) * 3.0 / 4.0)