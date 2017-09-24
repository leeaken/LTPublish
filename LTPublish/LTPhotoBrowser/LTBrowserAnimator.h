//
//  LTBrowserAnimator.h
//  LTPublishMessage
//
//  图片动画管理
//  Created by aken on 17/5/14.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LTBrowserAnimator : NSObject<UIViewControllerTransitioningDelegate>

// 初始化图片管理
+ (instancetype)animatorWithPhotos:(NSArray<UIImageView *> *)photos;

@property (nonatomic) NSInteger selectedIndex;

// 转场当前显示的图像视图
@property (nonatomic, weak) UIImageView *fromImageView;

@end
