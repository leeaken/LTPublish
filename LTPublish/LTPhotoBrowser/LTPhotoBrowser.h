//
//  LTPhotoBrowser.h
//  LTPublishMessage
//
//  图片预览入口
//  Created by aken on 17/5/11.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTPhotoBrowserDelegate.h"

@class LTPhotoBrowser,LTPhoto;

@interface LTPhotoBrowser : UIViewController

/*!
 @property
 @brief 是否显示导航栏上的item
 */
@property (nonatomic) BOOL displayActionButton;

/*!
 @property
 @brief 是否显示分布栏
 */
@property (nonatomic) BOOL displayPageControl;

/*!
 @property
 @brief 图片显示下标
 */
@property (nonatomic, assign) NSInteger currentPhotoIndex;


/*!
 @property
 @brief 隐藏状态栏
 */
@property (nonatomic) BOOL forceHideStatusBar;

/*!
 @property
 @brief 代理
 */
@property (nonatomic, weak) id<LTPhotoBrowserDelegate> delegate;

/*!
 @method
 @brief 初始化图片预览，没有动画消失特效，一般用于图片预览编辑
 @param photosArray 图片数组
 */
- (instancetype)initWithPhotos:(NSArray<LTPhoto*> *)imageViews;

/**
 @method
 @brief 初始化图片预览,附带图片显示和消失动画,一般用于图片预览

 @param imageViews 图片数组
 @param fromViews 源显示图片数组
 @return 返回图片预览实例
 */
- (instancetype)initWithPhotos:(NSArray<LTPhoto*> *)imageViews
            fromViews:(NSArray<UIImageView *> *)fromViews;


- (instancetype)initWithURLs:(NSArray<LTPhoto*> *)urls
                     fromViews:(NSArray<UIImageView *> *)fromViews;


- (void)reloadDataWithArray:(NSArray*)array;

@end
