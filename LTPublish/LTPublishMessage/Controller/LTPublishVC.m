//
//  LTPublishVC.m
//  LTPublishMessage
//
//  Created by aken on 17/4/13.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import "LTPublishVC.h"
#import "LTTextView.h"
#import "LTAddPhotoView.h"
#import "LTPublishCommon.h"
#import "LTSelectedView.h"
#import "LTPublishViewModel.h"

#import "LTPhotoBrowser.h"
#import "LTPhoto.h"
#import "UIImage+Tint.h"

@interface LTPublishVC ()<LTAddPhotoViewDelegate,LTPhotoBrowserDelegate>

@property (nonatomic, strong) LTTextView *textView;
@property (nonatomic, strong) LTAddPhotoView *photoView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *tmpPhotos;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineTopForTopView;
@property (nonatomic, strong) UIView *lineBottomForTopView;

@property (nonatomic, strong) NSString *selectedItem;

@property (nonatomic, strong) LTPublishViewModel *viewModel;
@property (nonatomic, assign) BOOL isPickImage;

@property (nonatomic, strong) NSMutableArray *fileUrls;

@end

@implementation LTPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self addViewConstraints];
    
    [self bindViewModel];
}


- (void)setupUI {
    
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor colorWithRed:.97f green:.97f blue:.97f alpha:1.0f];
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.textView];
    [self.topView addSubview:self.photoView];
    [self.topView addSubview:self.lineTopForTopView];
    [self.topView addSubview:self.lineBottomForTopView];

}

- (void)addViewConstraints {
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.top.equalTo(self.topView.mas_top).offset(10);
        make.height.equalTo(@(90));
    }];
    
    __block NSInteger height = [LTAddPhotoView photoViewDefaultHeight];
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.height.equalTo(@(height));
    }];

    [self.lineTopForTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.right.equalTo(self.topView.mas_right).offset(0);
        make.top.equalTo(self.photoView.mas_bottom).offset(10);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(self.topView.mas_bottom).offset(-5);
    }];

}

- (void)bindViewModel {
    
    RAC(self.viewModel,contentText) = self.textView.rac_textSignal;
    RAC(self.viewModel,pickImage) = [RACObserve(self, self.isPickImage)  map:^id(id value) {
        
        return @([value boolValue]);
    }];

}


#pragma mark - LTAddPhotoViewDelegate

- (void)didLTAddPhotoViewStartToPickImage {
    
}

- (void)didLTAddPhotoViewFinishPickingAssetsLayoutHeight:(CGFloat)height {
    
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    NSLog(@"height:%f",height);
    
    if (self.photoView.photoArray.count > 0) {
        
        self.isPickImage = YES;
        
    }else {
        
        self.isPickImage = NO;
    }
    
}

- (void)didLTAddPhotoViewSelectImageToPreViewAt:(NSInteger)index images:(NSArray *)images {
    
    
    [self.tmpPhotos removeAllObjects];
    
    [self.photos removeAllObjects];
    
    self.tmpPhotos = [NSMutableArray arrayWithArray:images];
    
    for (UIImage *image in images) {
        
        [self.photos addObject:[LTPhoto photoWithImage:image]];
    }
    
   
    
    LTPhotoBrowser *brower = [[LTPhotoBrowser alloc] initWithPhotos:self.photos];
    brower.delegate = self;
    brower.displayActionButton = YES;
    brower.currentPhotoIndex = index;
    [self.navigationController pushViewController:brower animated:YES];
}

#pragma mark -  MWPhotoBrowserDelegate

- (void)photoBrowser:(LTPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    
    
    if (index < self.photos.count) {
        
        [self.photos removeObjectAtIndex:index];
        [self.tmpPhotos removeObjectAtIndex:index];
        [self.photoView.selectedALAssetUrl removeObjectAtIndex:index];
            
        if (self.photos.count == 0) {
         
            self.isPickImage = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [photoBrowser reloadDataWithArray:self.photos];
    }
    
}

- (void)photoBrowser:(LTPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index {
    
    self.photoView.photoArray = self.tmpPhotos;
}


#pragma mark - Getters

- (LTTextView *)textView {
    
    if (!_textView) {
        _textView = [[LTTextView alloc] init];
        _textView.placeHolder = @"这一刻的想法...";
        _textView.placeHolderTextColor = [UIColor lightGrayColor];
    }
    
    return _textView;
}

- (LTAddPhotoView *)photoView {
    
    if (!_photoView) {
        _photoView = [[LTAddPhotoView alloc] init];
        _photoView.delegate = self;
    }
    
    return _photoView;
}

- (NSMutableArray *)photos {
    
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    
    return _photos;
}

- (NSMutableArray *)tmpPhotos {
    
    if (!_tmpPhotos) {
        _tmpPhotos = [NSMutableArray array];
    }
    
    return _tmpPhotos;
}

- (UIView *)topView {
    
    if (!_topView) {
        
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    
    return _topView;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    
    return _bottomView;
}

- (UIView *)lineTopForTopView {
    
    if (!_lineTopForTopView) {
     
        _lineTopForTopView = [[UIView alloc] init];
        _lineTopForTopView.backgroundColor = [UIColor colorWithRed:.9f green:.9f blue:.9f alpha:1.0f];
        
    }
    
    return _lineTopForTopView;
}

- (UIView *)lineBottomForTopView {
    
    if (!_lineBottomForTopView) {
        
        _lineBottomForTopView = [[UIView alloc] init];
        _lineBottomForTopView.backgroundColor = [UIColor colorWithRed:.9f green:.9f blue:.9f alpha:1.0f];
        
    }
    
    return _lineBottomForTopView;
}

- (LTPublishViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[LTPublishViewModel alloc] init];
    }
    
    return _viewModel;
}


- (NSMutableArray *)fileUrls {
    
    if (!_fileUrls) {
        
        _fileUrls = [NSMutableArray array];
    }
    
    return _fileUrls;
}

@end
