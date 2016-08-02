//
//  PlcLobbyViewController.m
//  PLLiveCourse
//
//  Created by TaoZeyu on 16/8/2.
//  Copyright © 2016年 com.pili-engineering. All rights reserved.
//

#import "PlcLobbyViewController.h"
#import "PlcRoomInfo.h"
#import "PlcBroadcastRoomViewController.h"

#define kTableViewCellIdentifier @"kTableViewCellIdentifier"

@interface PlcLobbyViewController () <UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<PlcRoomInfo *> *roomInfos;
@end

@implementation PlcLobbyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.roomInfos = [[NSMutableArray<PlcRoomInfo *> alloc] init];
    
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    
    [self.roomInfos addObject:({
        PlcRoomInfo *roomInfo = [[PlcRoomInfo alloc] init];
        roomInfo.roomName = @"大家快来看我的直播！";
        roomInfo.playableURL = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
        roomInfo;
    })];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roomInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    PlcRoomInfo *roomInfo = [self.roomInfos objectAtIndex:indexPath.row];
    cell.textLabel.text = roomInfo.roomName;
    return cell;
}

@end
