//
//  ViewController.m
//  AKMediaUBox
//
//  Created by Aka on 2017/9/6.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import "ViewController.h"
#import "YDTestSoundEffectViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    0
    [self testSoundEffect];

}


- (void)testSoundEffect {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"音效" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onSoundEffectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(0, 100, 100, 30);
    
}

- (void)onSoundEffectClick:(id)sender {
    [self.navigationController pushViewController:[YDTestSoundEffectViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
