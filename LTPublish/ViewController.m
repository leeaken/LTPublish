//
//  ViewController.m
//  LTPublish
//
//  Created by aken on 2017/9/23.
//  Copyright © 2017年 aken. All rights reserved.
//

#import "ViewController.h"
#import "LTPublishVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(id)sender {
    
    LTPublishVC *publishVC = [[LTPublishVC alloc] init];
    [self.navigationController pushViewController:publishVC animated:YES];
}

@end
