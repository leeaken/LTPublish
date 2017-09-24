//
//  LTPhoto.m
//  LTPublishMessage
//
//  Created by aken on 17/5/12.
//  Copyright © 2017年 LTPublishMessage. All rights reserved.
//

#import "LTPhoto.h"

@implementation LTPhoto

+ (LTPhoto *)photoWithImage:(UIImage *)image {
    
    return [[LTPhoto alloc] initWithImage:image];
}

+ (LTPhoto *)photoWithUrl:(NSString *)url {
    
    return [[LTPhoto alloc] initWithURL:url];
}

- (instancetype)initWithImage:(UIImage *)image {
    
    self = [super init];
    
    if (self) {
        
        self.image = image;
    }
    
    return self;
}

- (instancetype)initWithURL:(NSString *)url {
    
    self = [super init];
    
    if (self) {
        
        self.photoUrl = url;
    }
    
    return self;
}

@end
