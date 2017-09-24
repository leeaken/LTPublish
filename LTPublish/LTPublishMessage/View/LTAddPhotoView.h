//
//  LTAddPhotoView.h
//  LTPublishMessage
//
//  添加图片
//  Created by aken on 17/4/13.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

// 最大图片选择数
static NSInteger const maximumNumberOfAddPhotoViewSelection = 9;

// 一行有多少张图
static NSInteger const maximumNumberOfAddPhotoViewRow = 4;

// 编移
static NSInteger const marginXOfAddPhotoView = 10;

// 元素编移
static NSInteger const marginXOfAddPhotoViewItem = 5;

// 添加图片按钮的标志
static NSInteger const addFlagOfAddPhotoView = 99999;

@protocol LTAddPhotoViewDelegate <NSObject>

- (void)didLTAddPhotoViewStartToPickImage;

- (void)didLTAddPhotoViewFinishPickingAssetsLayoutHeight:(CGFloat)height;

- (void)didLTAddPhotoViewSelectImageToPreViewAt:(NSInteger)index images:(NSArray*)images;

@end

@interface LTAddPhotoView : UIView

@property (nonatomic, weak) id<LTAddPhotoViewDelegate>  delegate;

// 图片数组
@property (nonatomic, strong) NSArray*  photoArray;

// 相册中选择中的图片数组
@property (nonatomic, strong) NSMutableArray* selectedALAssetUrl;


+ (CGFloat)photoViewItemWidth;

+ (CGFloat)photoViewDefaultHeight;

@end
