//
//  LTPublishViewModel.m
//  WodeTea
//
//  Created by aken on 2017/7/20.
//  Copyright © 2017年 WodeTea. All rights reserved.
//

#import "LTPublishViewModel.h"

@implementation LTPublishViewModel

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        [self initBind];
    }
    return self;
}


// 初始化绑定
- (void)initBind {
    
    id signals = @[RACObserve(self, contentText),RACObserve(self, pickImage)];
    
    _enableSubmitSignal = [[RACSignal combineLatest:signals reduce:^id(NSString *value,id isPick){
        
        return @(value.length > 0 || [isPick boolValue] == 1);
        
    }] distinctUntilChanged];
    
}


@end
