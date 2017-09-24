//
//  LTPhoto.h
//  LTPublishMessage
//
//  图片对象Model
//  Created by aken on 17/5/12.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTPhoto : NSObject

+ (LTPhoto *)photoWithImage:(UIImage *)image;

+ (LTPhoto *)photoWithUrl:(NSString *)url;

// 本地图片
@property (nonatomic, strong) UIImage *image;

// 服务器地址
@property (nonatomic, strong) NSString *photoUrl;

//
- (instancetype)initWithImage:(UIImage *)image;

- (instancetype)initWithURL:(NSString *)url;

@end
