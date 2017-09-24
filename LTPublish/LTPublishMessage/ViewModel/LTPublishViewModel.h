//
//  LTPublishViewModel.h
//  WodeTea
//
//  Created by aken on 2017/7/20.
//  Copyright © 2017年 WodeTea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTPublishViewModel : NSObject


@property (nonatomic, strong) NSString *contentText;

@property (nonatomic, assign) BOOL pickImage;

@property (nonatomic, strong, readonly) RACSignal *enableSubmitSignal;


@end
