//
//  PlcLobbyViewController.m
//  PLLiveCourse
//
//  Created by TaoZeyu on 16/8/2.
//  Copyright © 2016年 com.pili-engineering. All rights reserved.
//

#import "PlcLobbyViewController.h"
#import "AppDelegate.h"
#import "PlcRoomInfo.h"
#import "PlcBroadcastRoomViewController.h"
#import "PlcPlayerViewController.h"

#define kTableViewCellIdentifier @"kTableViewCellIdentifier"

@interface PlcLobbyViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray<PlcRoomInfo *> *roomInfos;
@end

@implementation PlcLobbyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.roomInfos = [[NSMutableArray<PlcRoomInfo *> alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    
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
    
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *button = [[UIBarButtonItem alloc] init];
        button.title = @"刷新";
        button.target = self;
        button.action = @selector(_onPressedRefreshLobbyListButton:);
        button;
    });
    
    [self _refreshLobbyListWithComplete:nil];
}

- (void)_onPressedBeginBroadcastButton:(id)sender
{
    PlcBroadcastRoomViewController *viewController = [[PlcBroadcastRoomViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)_onPressedRefreshLobbyListButton:(UIBarButtonItem *)button
{
    button.enabled = NO;
    
    [self _refreshLobbyListWithComplete:^{
        button.enabled = YES;
    }];
}

- (void)_refreshLobbyListWithComplete:(void (^)())complete
{
    NSString *url = [NSString stringWithFormat:@"%@%@", kHost, @"/api/pilipili"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil || response == nil || data == nil) {
            NSLog(@"获取大厅列表失败... %@", error);
            return;
        }
        NSArray *rooms = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"---> %@", rooms);
        self.roomInfos = ({
            NSMutableArray<PlcRoomInfo *> *roomsInfos = [[NSMutableArray<PlcRoomInfo *> alloc] init];
            for (NSUInteger i = 0; i < rooms.count; i++) {
                NSDictionary *room = rooms[i];
            }
            roomsInfos;
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (complete) {
                complete();
            }
        });
    }];
    [task resume];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlcRoomInfo *roomInfo = [self.roomInfos objectAtIndex:indexPath.row];
    PlcPlayerViewController *viewController = [[PlcPlayerViewController alloc] initWithRoomInfo:roomInfo];
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
