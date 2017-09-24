//
//  LTAddPhotoView.m
//  LTPublishMessage
//
//  Created by aken on 17/4/13.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import "LTAddPhotoView.h"
#import "LTAddPhotoCell.h"

#import "LTPublishCommon.h"
#import "QBImagePicker.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface LTAddPhotoView()<UICollectionViewDelegate, UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray* selectedALAssetImage;
@property (nonatomic, assign) CGFloat itemWidth;
@end

@implementation LTAddPhotoView

- (id)initWithFrame:(CGRect)frame  {
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        
        [self addViewConstraints];
    }
    
    return self;
    
}

- (id)init {
    
    self=[super init];
    
    if (self) {
        
        [self setupUI];
        
        [self addViewConstraints];
    }
    
    return self;
    
}

- (void)setupUI {
    
    self.itemWidth = [self.class photoViewItemWidth];
    [self addSubview:self.collectionView];

}

- (void)addViewConstraints {

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);

    }];
    
}

#pragma mark - Public


- (void)setPhotoArray:(NSArray *)photoArray {
    
    if (_photoArray == photoArray) {
        return;
    }
    
    self.hidden = NO;
    
    _photoArray = [NSMutableArray arrayWithArray:photoArray];
    
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.collectionView reloadData];

    });
    
    // 只要图片数组发生变化，都将监听其view的高度
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLTAddPhotoViewFinishPickingAssetsLayoutHeight:)]) {
        
        CGFloat height = 0;
        
        // +1 是因为有一个添加图片的button
        NSInteger count = self.photoArray.count + 1;
        
        NSInteger page = (count + maximumNumberOfAddPhotoViewRow - 1) / maximumNumberOfAddPhotoViewRow;

        NSInteger maxPage = (maximumNumberOfAddPhotoViewSelection + maximumNumberOfAddPhotoViewRow - 1 ) / maximumNumberOfAddPhotoViewRow;
        
        if (page == maxPage && self.photoArray.count == maximumNumberOfAddPhotoViewSelection) {
            
            height = page * self.itemWidth + marginXOfAddPhotoView + page * marginXOfAddPhotoView;
            
        }else {
            
            if (page > 0) {//1
                
                height = page * self.itemWidth + page * marginXOfAddPhotoView + page * marginXOfAddPhotoViewItem;
                
            }else {
                
                height = (page + 1) * self.itemWidth + marginXOfAddPhotoView;
            }
        }
        
        [self.delegate didLTAddPhotoViewFinishPickingAssetsLayoutHeight:height];
    }
}


+ (CGFloat)photoViewItemWidth {
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - marginXOfAddPhotoView * 5)/maximumNumberOfAddPhotoViewRow;
    return width;
}

+ (CGFloat)photoViewDefaultHeight {
    
    return [[self class] photoViewItemWidth] + 10;
}

#pragma mark - Private


- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    NSArray *picChooseList = @[@"拍照",@"从手机相册中选择"];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:nil otherButtonTitles:picChooseList[0],picChooseList[1],nil];
    [sheet showInView:[[UIApplication sharedApplication] keyWindow]];

    if(self.delegate && [self.delegate respondsToSelector:@selector(didLTAddPhotoViewStartToPickImage)]) {
        [self.delegate didLTAddPhotoViewStartToPickImage];
    }
        
}

- (UIViewController *)viewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    return nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger number = self.photoArray.count + 1;

    return MIN(number, maximumNumberOfAddPhotoViewSelection);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LTAddPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTAddPhotoCell" forIndexPath:indexPath];

    if (indexPath.item == [self.photoArray count]) {
        //添加图片的Button 超过了maxPhotoNumer 就不显示添加按钮了
        cell.imageView.image = nil;
        cell.imageView.image = [UIImage imageNamed:@"add_plus"];
        cell.imageView.tag = addFlagOfAddPhotoView;
        
    }else{
        
        cell.imageView.tag = 0;
        id thePhoto = self.photoArray[indexPath.item];
        
        if ([thePhoto isKindOfClass:[NSString class]] &&
            [thePhoto length] > 0) {
//            [cell configureChatPhotoCell:PhotoSelectStateNone thumbImgUrl:[NSURL URLWithString:thePhoto]];
        }else if([thePhoto isKindOfClass:[UIImage class]]){
            cell.imageView.image = thePhoto;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.itemWidth, self.itemWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(marginXOfAddPhotoViewItem, 0, -marginXOfAddPhotoViewItem, 0);
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    // 点击添加按钮
    if (indexPath.item == [self.photoArray count]) {
        
        [self didSelectItemAtIndexPath:indexPath];
        
    }else {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLTAddPhotoViewSelectImageToPreViewAt:images:)]) {
                  
            [self.delegate didLTAddPhotoViewSelectImageToPreViewAt:indexPath.row images:self.photoArray];
        }
        
    }
    
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"设备没有摄像机");
            return;
        }
        
//        [self isAuthorizedCameraStatus];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [self.viewController presentViewController:imagePicker animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        
//        if([self.dependVC isAuthorizedPhotoLibraryStatus]) {
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.maximumNumberOfSelection = maximumNumberOfAddPhotoViewSelection;
            [imagePickerController.selectedAssets addObjectsFromArray:self.selectedALAssetUrl];
            imagePickerController.showsNumberOfSelectedAssets = YES;
            [self.viewController.navigationController presentViewController:imagePickerController animated:YES completion:nil];
//        }
    } else {
        
//        return;
    }
    
    
}

#pragma mark - UIImagePickerController(相机) Delegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage  * chosedImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self.selectedALAssetImage addObject:chosedImage];
    self.photoArray = self.selectedALAssetImage;
    [picker dismissViewControllerAnimated:YES  completion:nil];
}

#pragma mark - QBImagePickerController Delegate

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {

    [self.selectedALAssetUrl removeAllObjects];
    [self.selectedALAssetImage removeAllObjects];

  
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    @weakify(self);
    for (PHAsset *asset in assets) {
        
        [self.selectedALAssetUrl addObject:asset];
        
        dispatch_group_async(group, queue, ^{

            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                
                    @strongify(self);
                    UIImage *image = [UIImage imageWithData:imageData];
                    [self.selectedALAssetImage addObject:image];
                
            }];
         });
    }


    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{

        @strongify(self);
        self.photoArray = self.selectedALAssetImage;
    });

    
    [imagePickerController dismissViewControllerAnimated:YES  completion:nil];
}

#pragma mark - Getters and Setters

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
  
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        [_collectionView setScrollEnabled:NO];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView registerClass:[LTAddPhotoCell class] forCellWithReuseIdentifier:@"LTAddPhotoCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    
    return _layout;
}

- (NSMutableArray *)selectedALAssetUrl {
    
    if (!_selectedALAssetUrl) {
        _selectedALAssetUrl = [NSMutableArray array];
    }
    
    return _selectedALAssetUrl;
}

- (NSMutableArray *)selectedALAssetImage {
    
    if (!_selectedALAssetImage) {
        _selectedALAssetImage = [NSMutableArray array];
    }
    
    return _selectedALAssetImage;
}

@end
