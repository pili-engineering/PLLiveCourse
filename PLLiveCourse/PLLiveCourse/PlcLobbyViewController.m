//
//  PlcLobbyViewController.m
//  PLLiveCourse
//
//  Created by TaoZeyu on 16/8/2.
//  Copyright © 2016年 com.pili-engineering. All rights reserved.
//

#import "PlcLobbyViewController.h"
#import "PlcBroadcastRoomViewController.h"

@interface PlcLobbyViewController ()

@end

@implementation PlcLobbyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"大厅";
        [label sizeToFit];
        label;
    });
    
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *button = [[UIBarButtonItem alloc] init];
        button.title = @"直播";
        button.target = self;
        button.action = @selector(_onPressedBeginBroadcastButton:);
        button;
    });
}

- (void)_onPressedBeginBroadcastButton:(id)sender
{
    PlcBroadcastRoomViewController *viewController = [[PlcBroadcastRoomViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
