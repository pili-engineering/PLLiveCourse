//
//  PlcBroadcastRoomViewController.m
//  PLLiveCourse
//
//  Created by TaoZeyu on 16/8/2.
//  Copyright © 2016年 com.pili-engineering. All rights reserved.
//

#import "PlcBroadcastRoomViewController.h"

@interface PlcBroadcastRoomViewController ()

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
}

@end
