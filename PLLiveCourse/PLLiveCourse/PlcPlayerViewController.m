//
//  PlcPlayerViewController.m
//  PLLiveCourse
//
//  Created by TaoZeyu on 16/8/2.
//  Copyright © 2016年 com.pili-engineering. All rights reserved.
//

#import "PlcPlayerViewController.h"
#import "PlcRoomInfo.h"

#import <PLPlayerKit/PLPlayer.h>

@interface PlcPlayerViewController () <PLPlayerDelegate>
@property (nonatomic, strong) PlcRoomInfo *roomInfo;
@property (nonatomic, strong) PLPlayer *player;
@end

@implementation PlcPlayerViewController

- (instancetype)initWithRoomInfo:(PlcRoomInfo *)roomInfo
{
    if (self = [self init]) {
        _roomInfo = roomInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player = ({
        PLPlayer *player = [PLPlayer playerWithURL:[NSURL URLWithString:self.roomInfo.playableURL]
                                            option:[PLPlayerOption defaultOption]];
        player.delegate = self;
        // 允许播放器后台播放。
        player.backgroundPlayEnable = YES;
        // 设置 AVAudioSession 的 Category。
        // 特别注意：禁止在推流过程中修改 AVAudioSession 的 Category。
        // 由于观众房间是不会推流的，所以这里可以安心修改。
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        player;
    });
    
    UIView *playerView = self.player.playerView;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:playerView];
    
    // 开始播放
    [self.player play];
}

@end
