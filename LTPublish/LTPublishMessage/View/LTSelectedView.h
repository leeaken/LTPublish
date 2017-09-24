//
//  LTSelectedView.h
//  LTPublishMessage
//
//  Created by aken on 17/5/9.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTSelectedViewDelegate <NSObject>

- (void)selectedViewDidTouchAt:(NSInteger)tag;

@end

@interface LTSelectedView : UIView

@property (nonatomic, weak) id<LTSelectedViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *descLabel;

@end
