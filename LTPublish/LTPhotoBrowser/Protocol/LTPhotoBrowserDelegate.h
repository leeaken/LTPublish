//
//  LTPhotoBrowserDelegate.h
//  LTPublishMessage
//
//  Created by aken on 2017/7/19.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTPhotoBrowser;

@protocol LTPhotoBrowserDelegate <NSObject>

@optional

- (void)photoBrowser:(LTPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(LTPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index;

@end
