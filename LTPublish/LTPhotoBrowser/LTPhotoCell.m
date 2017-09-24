//
//  LTPhotoCell.m
//  LTPublishMessage
//
//  Created by aken on 17/5/12.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import "LTPhotoCell.h"
#import "LTPhoto.h"

#import "FLAnimatedImageView+WebCache.h"
#import "DALabeledCircularProgressView.h"

const CGFloat PYPreviewPhotoMaxScale = 2;  // 预览图片时，图片最大放大倍数

@interface LTPhotoCell()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, assign) CGPoint photoCellAnchorPoint;
@property (nonatomic, assign) CGPoint scrollViewAnchorPoint;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) UIGestureRecognizerState state;

// 进度条
@property (nonatomic, strong) DALabeledCircularProgressView *progresView;

@end

@implementation LTPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {

        [self.contentView addSubview:self.contentScrollView];
        [self.contentScrollView addSubview:self.imgView];
        [self.contentScrollView addSubview:self.progresView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didImageClicked:)];
        [self addGestureRecognizer:singleTap];
   
        
        self.scale = 1.0;
    }
    
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = (self.contentScrollView.bounds.size.width > self.contentScrollView.contentSize.width)?
    (self.contentScrollView.bounds.size.width - self.contentScrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.contentScrollView.bounds.size.height > self.contentScrollView.contentSize.height)?
    (self.contentScrollView.bounds.size.height - self.contentScrollView.contentSize.height) * 0.5 : 0.0;
    self.imgView.center = CGPointMake(self.contentScrollView.contentSize.width * 0.5 + offsetX,
                                        self.contentScrollView.contentSize.height * 0.5 + offsetY);
}

- (void)setPhoto:(LTPhoto *)photo {
    
    _photo = photo;
    
    if ([photo.photoUrl isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:photo.photoUrl];
        [self.imgView sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
            CGFloat progress = 1.0 * receivedSize / expectedSize;
            self.progresView.hidden = NO;
            [self.progresView setProgress:progress animated:YES];

//            NSLog(@"progress:%f",progress);

        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            
            self.imgView.image = image;
            self.progresView.hidden = YES;
            
            [self updateImageFrame];

        }];
        

    }else {
        
        self.imgView.image = _photo.image;
        
        [self updateImageFrame];
    }
    
}

- (void)updateImageFrame {
    
    // 取出图片大小
    CGSize imageSize = self.imgView.image.size;
    
    if (imageSize.width > 0) {
        
        CGRect frame = self.imgView.frame;
        frame.size = CGSizeMake(self.frame.size.width, self.frame.size.width * imageSize.height / imageSize.width);
        self.imgView.frame = frame;
        
        // 设置scrollView的大小
        
        CGRect scrollFrame = self.contentScrollView.frame;
        frame.size = self.frame.size;
        self.contentScrollView.frame = scrollFrame;
    }
    
    
    [self.contentScrollView setContentSize:self.imgView.bounds.size];
    self.contentScrollView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    self.imgView.center = CGPointMake(self.contentScrollView.frame.size.width * 0.5,
                                      self.contentScrollView.frame.size.height * 0.5);
    
    
    
    
    // 刷新
    [self setNeedsLayout];
}

- (void)didImageClicked:(UITapGestureRecognizer *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewDidDismiss)]) {
        
        [self.delegate imageViewDidDismiss];
    }
   
}

#pragma mark - Getters

- (UIScrollView *)contentScrollView {
    
    if (!_contentScrollView) {
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.userInteractionEnabled  = YES;
        _contentScrollView.bouncesZoom = YES;
        
        float minimumScale = 1.0;
        _contentScrollView.maximumZoomScale = 6.0;
        _contentScrollView.minimumZoomScale = minimumScale;
        _contentScrollView.zoomScale = minimumScale;
    }
    
    return _contentScrollView;
}

- (FLAnimatedImageView *)imgView {
    
    if (!_imgView) {
        
        _imgView = [[FLAnimatedImageView alloc] init];
        _imgView.userInteractionEnabled = YES;
        
    }
    
    return _imgView;
}

- (DALabeledCircularProgressView *)progresView {
    
    if (!_progresView) {
        
        _progresView = [[DALabeledCircularProgressView alloc] init];
        _progresView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 25,
                                        [UIScreen mainScreen].bounds.size.height/2 - 25,
                                        50, 50);
        _progresView.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _progresView.hidden = YES;
    }
    
    return _progresView;
}

@end
