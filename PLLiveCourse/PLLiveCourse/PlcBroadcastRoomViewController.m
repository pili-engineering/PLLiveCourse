//
//  PlcBroadcastRoomViewController.m
//  PLLiveCourse
//
//  Created by TaoZeyu on 16/8/2.
//  Copyright © 2016年 com.pili-engineering. All rights reserved.
//

#import "PlcBroadcastRoomViewController.h"

#import <PLCameraStreamingKit/PLCameraStreamingKit.h>

@interface PlcBroadcastRoomViewController ()
@property (nonatomic, strong) PLCameraStreamingSession *cameraStreamingSession;
@end

@implementation PlcBroadcastRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"直播房间";
        [label sizeToFit];
        label;
    });
    
    self.cameraStreamingSession = [self _generateCameraStreamingSession];
}

- (PLCameraStreamingSession *)_generateCameraStreamingSession
{
    // 视频采集配置，对应的是摄像头。
    PLVideoCaptureConfiguration *videoCaptureConfiguration;
    // 视频推流配置，对应的是推流出去的画面。
    PLVideoStreamingConfiguration *videoStreamingConfiguration;
    // 音频采集配置，对应的是麦克风。
    PLAudioCaptureConfiguration *audioCaptureConfiguration;
    // 音频推流配置，对应的是推流出去的声音。
    PLAudioStreamingConfiguration *audioSreamingConfiguration;
    // 摄像头采集方向
    AVCaptureVideoOrientation captureOrientation;
    
    videoCaptureConfiguration =
    [[PLVideoCaptureConfiguration alloc] initWithVideoFrameRate:30
                                                  sessionPreset:AVCaptureSessionPresetMedium
                                       previewMirrorFrontFacing:YES
                                        previewMirrorRearFacing:NO
                                        streamMirrorFrontFacing:NO
                                         streamMirrorRearFacing:NO
                                                 cameraPosition:AVCaptureDevicePositionFront//前置摄像头
                                               videoOrientation:AVCaptureVideoOrientationPortrait];
    
    audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
    
    // videoSize 指推流出去后的视频分辨率，建议与摄像头的采集分辨率设置得一样。
    CGSize videoSize = CGSizeMake(480 , 640);
    
    videoStreamingConfiguration =
    [[PLVideoStreamingConfiguration alloc] initWithVideoSize:videoSize
                                expectedSourceVideoFrameRate:30
                                    videoMaxKeyframeInterval:90
                                         averageVideoBitRate:512 * 1024
                                           videoProfileLevel:AVVideoProfileLevelH264Baseline31];
    
    // 让摄像头的采集方向与设备的实际方向一致。
    // 这样才能保证，主播把手机横放时，播出去的画面方向依然是“正”的。
    audioSreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (deviceOrientation == UIDeviceOrientationPortrait ||
        deviceOrientation == UIDeviceOrientationPortraitUpsideDown ||
        deviceOrientation == UIDeviceOrientationLandscapeLeft ||
        deviceOrientation == UIDeviceOrientationLandscapeRight) {
        captureOrientation = (AVCaptureVideoOrientation) deviceOrientation;
    } else {
        captureOrientation = AVCaptureVideoOrientationPortrait;
    }
    
    PLStream *stream = nil;
    
    return [[PLCameraStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration
                                                     audioCaptureConfiguration:audioCaptureConfiguration
                                                   videoStreamingConfiguration:videoStreamingConfiguration
                                                   audioStreamingConfiguration:audioSreamingConfiguration
                                                                        stream:stream
                                                              videoOrientation:captureOrientation];
}

@end
