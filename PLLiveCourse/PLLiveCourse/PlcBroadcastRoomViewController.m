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
    
    [self.view addSubview:({
        UIView *preview = self.cameraStreamingSession.previewView;
        preview.frame = self.view.bounds;
        preview.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                   UIViewAutoresizingFlexibleHeight;
        preview;
    })];
    
    NSURL *cloudURL = [NSURL URLWithString:@"http://pili2-demo.qiniu.com/api/stream"];
    [self _generatePushURLWithCloudURL:cloudURL withComplete:^(NSURL *pushURL) {
        
    }];
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
    
    videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
    videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
    audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
    audioSreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
    
    AVCaptureVideoOrientation captureOrientation = AVCaptureVideoOrientationPortrait;

    PLStream *stream = nil;
    return [[PLCameraStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration
                                                     audioCaptureConfiguration:audioCaptureConfiguration
                                                   videoStreamingConfiguration:videoStreamingConfiguration
                                                   audioStreamingConfiguration:audioSreamingConfiguration
                                                                        stream:stream
                                                              videoOrientation:captureOrientation];
}

- (void)_generatePushURLWithCloudURL:(NSURL *)cloudURL withComplete:(void (^)(NSURL *pushURL))complete
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:cloudURL];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable responseError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = responseError;
            if (error != nil || response == nil || data == nil) {
                NSLog(@"获取推流 URL 失败");
                return;
            }
            
            NSURL *pushURL = [NSURL URLWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            if (complete) {
                complete(pushURL);
            }
        });
    }];
    [task resume];
}

@end
