//
//  PlcLobbyViewController.m
//  PLLiveCourse
//
//  Created by TaoZeyu on 16/8/2.
//  Copyright © 2016年 com.pili-engineering. All rights reserved.
//

#import "PlcLobbyViewController.h"

@interface PlcLobbyViewController ()

@end

@implementation PlcLobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"大厅";
        [label sizeToFit];
        label;
    });
}

@end
