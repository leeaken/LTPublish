//
//  LTPhotoBrowser.m
//  LTPublishMessage
//
//  Created by aken on 17/5/11.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import "LTPhotoBrowser.h"
#import "LTPhotoCell.h"
#import "LTPhoto.h"
#import "LTBrowserAnimator.h"


NSString *const photoCellReuseIdentifier = @"LTPhotoCell";

@interface LTPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,LTPhotoCellDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger currentSelectedIndex;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation LTPhotoBrowser {
    
    LTBrowserAnimator *_animator;
    
    // Appearance
    BOOL _didSavePreviousStateOfNavBar;
    BOOL _previousNavBarHidden;
    BOOL _previousNavBarTranslucent;
    UIBarStyle _previousNavBarStyle;
    UIColor *_previousNavBarTintColor;
    UIColor *_previousNavBarBarTintColor;
    UIBarButtonItem *_previousViewControllerBackButton;
    UIImage *_previousNavigationBarBackgroundImageDefault;
    UIImage *_previousNavigationBarBackgroundImageLandscapePhone;
    
    //
    BOOL _viewIsActive;
    BOOL _isHidenStatus;
    
    NSTimer *_controlVisibilityTimer;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.displayActionButton = NO;
        self.displayPageControl = NO;
        self.forceHideStatusBar = NO;
    }
    
    return self;
}


- (instancetype)initWithPhotos:(NSArray<LTPhoto*> *)imageViews {
    
    self = [self init];
    
    if (self) {
        
        [self.photos addObjectsFromArray:imageViews];

    }
    
    return self;
}

- (instancetype)initWithPhotos:(NSArray<LTPhoto*> *)imageViews
                     fromViews:(NSArray<UIImageView *> *)fromViews {
    
    self = [self init];
    
    if (self) {
        
        [self.photos addObjectsFromArray:imageViews];
        
        _animator = [LTBrowserAnimator animatorWithPhotos:fromViews];
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = _animator;
        _isHidenStatus = NO;
    }
    
    return self;
}

- (instancetype)initWithURLs:(NSArray<LTPhoto*> *)urls
                   fromViews:(NSArray<UIImageView *> *)fromViews {
    
    self = [self init];
    
    if (self) {
        
        [self.photos addObjectsFromArray:urls];
        _animator = [LTBrowserAnimator animatorWithPhotos:fromViews];
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = _animator;
        _isHidenStatus = NO;
    }
    
    return self;
}


#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[LTPhotoCell class] forCellWithReuseIdentifier:photoCellReuseIdentifier];
    
    CGFloat lineSpacing = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).minimumLineSpacing;
    
    CGRect rect = self.collectionView.frame;
    rect.size.width += lineSpacing;
    self.collectionView.frame = rect;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, lineSpacing);
    
    [self.view addSubview:self.pageControl];
    self.collectionView.contentOffset = CGPointMake(self.currentSelectedIndex * self.collectionView.frame.size.width, 0);
    self.pageControl.currentPage = self.currentSelectedIndex;
    self.pageControl.hidden = !self.displayPageControl;
    
    if (self.navigationController) {
        
        [self updateNavigationTitle];
        
        if (self.displayActionButton) {
            
            UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(actionButtonPressed:)];
            self.navigationItem.rightBarButtonItem = actionButton;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (!_viewIsActive && [self.navigationController.viewControllers objectAtIndex:0] != self) {
        [self storePreviousNavBarAppearance];
    }
    
    [self setNavBarAppearance:animated];
    [self hideControlsAfterDelay];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    _viewIsActive = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ((self.navigationController.isBeingDismissed) ||
        ([self.navigationController.viewControllers objectAtIndex:0] != self && ![self.navigationController.viewControllers containsObject:self])) {
        
        _viewIsActive = NO;
        [self restorePreviousNavBarAppearance:animated];
        
    }
    

    [self.navigationController.navigationBar.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self setControlsHidden:NO animated:NO permanent:YES];
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        if ([self.delegate respondsToSelector:@selector(photoBrowser:didDismissAtPageIndex:)])
            [self.delegate photoBrowser:self didDismissAtPageIndex:self.currentSelectedIndex];
        
    }
    
}

#pragma mark - Public

- (void)reloadDataWithArray:(NSArray*)array {
    
    
    [self.photos removeAllObjects];
    [self.photos addObjectsFromArray:array];
    
    [self.collectionView reloadData];
    //
    if (self.currentSelectedIndex > 0) {
        
        self.currentSelectedIndex = self.currentSelectedIndex - 1;
    }
    self.collectionView.contentOffset = CGPointMake(self.currentSelectedIndex * self.collectionView.frame.size.width, 0);
    [self updateNavigationTitle];
    self.pageControl.currentPage = self.currentSelectedIndex;
    self.pageControl.numberOfPages = self.photos.count;
}

- (void)setCurrentPhotoIndex:(NSInteger)currentPhotoIndex {
    
    if (currentPhotoIndex < 0) {
        
        return;
        
    }else if(_currentPhotoIndex > self.photos.count){
        
        return;
    }
    
    _currentPhotoIndex = currentPhotoIndex;
    self.currentSelectedIndex = currentPhotoIndex;
    
    _animator.selectedIndex = currentPhotoIndex;
    
     if ([self isViewLoaded]) {
         
         self.collectionView.contentOffset = CGPointMake(self.currentSelectedIndex  * self.collectionView.frame.size.width, 0);
         [self updateNavigationTitle];
         
     }
    
}

#pragma mark - Private

// 设置导航
- (void)setNavBarAppearance:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = nil;
    navBar.shadowImage = nil;
    navBar.translucent = YES;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsCompact];
}

- (void)storePreviousNavBarAppearance {
    _didSavePreviousStateOfNavBar = YES;
    _previousNavBarBarTintColor = self.navigationController.navigationBar.barTintColor;
    _previousNavBarTranslucent = self.navigationController.navigationBar.translucent;
    _previousNavBarTintColor = self.navigationController.navigationBar.tintColor;
    _previousNavBarHidden = self.navigationController.navigationBarHidden;
    _previousNavBarStyle = self.navigationController.navigationBar.barStyle;
    _previousNavigationBarBackgroundImageDefault = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    _previousNavigationBarBackgroundImageLandscapePhone = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsCompact];
}

- (void)restorePreviousNavBarAppearance:(BOOL)animated {
    if (_didSavePreviousStateOfNavBar) {
        [self.navigationController setNavigationBarHidden:_previousNavBarHidden animated:animated];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        navBar.tintColor = _previousNavBarTintColor;
        navBar.translucent = _previousNavBarTranslucent;
        navBar.barTintColor = _previousNavBarBarTintColor;
        navBar.barStyle = _previousNavBarStyle;
        [navBar setBackgroundImage:_previousNavigationBarBackgroundImageDefault forBarMetrics:UIBarMetricsDefault];
        [navBar setBackgroundImage:_previousNavigationBarBackgroundImageLandscapePhone forBarMetrics:UIBarMetricsCompact];
    
        if (_previousViewControllerBackButton) {
            UIViewController *previousViewController = [self.navigationController topViewController];
            previousViewController.navigationItem.backBarButtonItem = _previousViewControllerBackButton;
            _previousViewControllerBackButton = nil;
        }
    }
}

- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated permanent:(BOOL)permanent {
    
    // 取消 timers
    [self cancelControlHiding];
    
    
    // 显示/隐藏 bars
    [UIView animateWithDuration:(animated ? 0.5 : 0.5) animations:^(void) {
        
        CGFloat alpha = hidden ? 0 : 1;
        [self.navigationController.navigationBar setAlpha:alpha];
        
        [self.navigationController setNavigationBarHidden:!alpha animated:animated];
        _isHidenStatus = !alpha;
        
    } completion:^(BOOL finished) {}];
    
    if (!permanent) {
        [self hideControlsAfterDelay];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)cancelControlHiding {
 
    if (_controlVisibilityTimer) {
        [_controlVisibilityTimer invalidate];
        _controlVisibilityTimer = nil;
    }
}

- (void)hideControlsAfterDelay {

    if (!_isHidenStatus) {
        [self cancelControlHiding];
        _controlVisibilityTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
    }
}

- (void)hideControls {

    [self setControlsHidden:YES animated:YES permanent:NO];
}

- (void)updateNavigationTitle {
    
    if (self.photos.count >= 1) {
        
        self.title = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)(self.currentSelectedIndex + 1), (unsigned long)self.photos.count];
        
    } else {
        
        self.title = nil;
    }
    
}

- (void)actionButtonPressed:(id)sender {
    
    if (self.photos.count > 0) {
        
        if ([self.delegate respondsToSelector:@selector(photoBrowser:actionButtonPressedForPhotoAtIndex:)]) {
            
            [self.delegate photoBrowser:self actionButtonPressedForPhotoAtIndex:self.currentSelectedIndex];
            
        }
    }
}

#pragma mark - Status Bar

- (BOOL)prefersStatusBarHidden {
    
    if(self.forceHideStatusBar) {
        return YES;
    }
    
    return _isHidenStatus;
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LTPhotoCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:photoCellReuseIdentifier forIndexPath:indexPath];
    
    LTPhoto *photo = self.photos[indexPath.row];
    
    
    cell.photo = photo;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemHeight = [UIScreen mainScreen].bounds.size.height;
    
    return CGSizeMake(collectionView.frame.size.width - ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).minimumLineSpacing, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}


#pragma mark - LTPhotoCellDelegate

- (void)imageViewDidDismiss {
    
    // 如果是push过来，则是编辑图片模式，可删除图片
    if (self.navigationController) {
        
        [self setControlsHidden:!self.navigationController.navigationBar.hidden animated:YES permanent:NO];
        
    }else { // 常规的图片预览
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0];
        
        LTPhotoCell *cell = (LTPhotoCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        UIImageView *tmpView = (UIImageView*)cell.imgView;
        
        _animator.fromImageView = tmpView;
        
        if(tmpView.image){
            _animator.fromImageView.frame = tmpView.frame;
        }else{
            _animator.fromImageView.frame = self.view.bounds;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}


#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 计算页数
    NSInteger page = self.collectionView.contentOffset.x / self.collectionView.frame.size.width + 0.5;
    // 避免数组越界
    self.pageControl.currentPage = page >= self.pageControl.numberOfPages ? self.pageControl.numberOfPages - 1 : page;
    
    self.currentSelectedIndex = page;
    _animator.selectedIndex = page;
    
    if (self.navigationController) {
        [self updateNavigationTitle];
    }

}

#pragma mark - Getters

- (NSMutableArray *)photos {
    
    if (!_photos) {
        
        _photos = [NSMutableArray array];
    }
    
    return _photos;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 30;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.userInteractionEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.photos.count;
        _pageControl.frame = CGRectMake(0,
                                        self.view.frame.size.height - 30 - 30,
                                        self.view.frame.size.width,
                                        30);
    }
    
    return _pageControl;
}

@end
