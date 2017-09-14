//
//  YDTestSoundEffectViewController.m
//  AKMediaUBox
//
//  Created by Aka on 2017/9/14.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import "YDTestSoundEffectViewController.h"
#import <AudioToolbox/AudioToolbox.h>

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


/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
}

/**
 *  播放音效文件
 *
 *  @param name 音频文件名称
 */

-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
