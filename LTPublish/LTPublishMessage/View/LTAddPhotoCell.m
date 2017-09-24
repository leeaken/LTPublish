//
//  LTAddPhotoCell.m
//  LTPublishMessage
//
//  Created by aken on 17/4/13.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import "LTAddPhotoCell.h"
#import "LTPublishCommon.h"

@interface LTAddPhotoCell()


@end

@implementation LTAddPhotoCell

- (id)initWithFrame:(CGRect)frame  {
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        
        [self addViewConstraints];
    }
    
    return self;
    
}

- (void)setupUI {
    self.backgroundColor = [UIColor greenColor];
    self.imageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageView];
}

- (void)addViewConstraints {
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
}

#pragma mark - Getters and Setters

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
}

@end
