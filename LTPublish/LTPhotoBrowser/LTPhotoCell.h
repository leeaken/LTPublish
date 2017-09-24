//
//  LTPhotoCell.h
//  LTPublishMessage
//
//  Created by aken on 17/5/12.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"

@class LTPhoto;

@protocol LTPhotoCellDelegate <NSObject>

- (void)imageViewDidDismiss;

@end

@interface LTPhotoCell : UICollectionViewCell

@property (nonatomic, strong) FLAnimatedImageView *imgView;

@property (nonatomic, strong) LTPhoto *photo;

@property (nonatomic, weak) id<LTPhotoCellDelegate> delegate;

@end
