//
//  LTSelectedView.m
//  LTPublishMessage
//
//  Created by aken on 17/5/9.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import "LTSelectedView.h"
#import "LTPublishCommon.h"

@interface LTSelectedView()

@property (nonatomic, strong) UIImageView *rightArrowImageView;
@property (nonatomic, strong) UIButton    *hightLightedButton;

@end

@implementation LTSelectedView

- (id)initWithFrame:(CGRect)frame  {
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        
        [self addViewConstraints];
    }
    
    return self;
    
}

- (void)setupUI {
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightArrowImageView];
    [self addSubview:self.hightLightedButton];

}

- (void)addViewConstraints {

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(7, 13));
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-25);
        make.centerY.equalTo(self);
    }];

    [self.hightLightedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];

}


#pragma mark - Public

#pragma mark - Private

- (UIImage*)createImageWithColor:(UIColor*)color {
    
    CGRect rect=CGRectMake(0.0f,0.0f,[UIScreen mainScreen].bounds.size.width,44);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    
    return theImage;
    
}

- (void)buttonClick:(id)sender {
    
    if (self.delegate  && [self.delegate respondsToSelector:@selector(selectedViewDidTouchAt:)]) {
        
        [self.delegate selectedViewDidTouchAt:self.tag];
    }
}

#pragma mark - Getters and Setters

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.tintColor = [UIColor greenColor];
    }
    
    return _imageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
    }
    
    return _titleLabel;
}

- (UIImageView *)rightArrowImageView {
    
    if (!_rightArrowImageView) {
        _rightArrowImageView = [[UIImageView alloc] init];
        _rightArrowImageView.image = [UIImage imageNamed:@"rightArrow"];
    }
    
    return _rightArrowImageView;
}

- (UIButton *)hightLightedButton {
    
    if (!_hightLightedButton) {
        
        _hightLightedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hightLightedButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image = [self createImageWithColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.18]];
        
        [_hightLightedButton setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    
    return _hightLightedButton;
}

@end
