//
//  YDTestSoundEffectViewController.m
//  AKMediaUBox
//
//  Created by Aka on 2017/9/14.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import "YDTestSoundEffectViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AkMgrService.h"

@interface YDTestSoundEffectViewController ()

@end

@implementation YDTestSoundEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"音效播放" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onSoundEffectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 100, 30);
}

- (void)onSoundEffectClick:(id)sender {
    [self playSoundEffect:@"9152.wav"];
}

//test may be remove 
-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    [SERVICE_MGR(AKSegmentAudioMgr) playSegmentAudioWithURl:fileUrl];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
