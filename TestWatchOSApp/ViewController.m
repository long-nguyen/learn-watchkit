//
//  ViewController.m
//  TestWatchOSApp
//
//  Created by Company on 2019/09/21.
//  Copyright © 2019 Active User Co.,LTD. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "DBHelper.h"
#import "FCLocationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNumber *didWatchStart = [DataManager.sharedManager getPref:@"firstStartClock"];
    NSLog(@"started : %@", didWatchStart);
    NSArray *allData = [[DBHelper sharedManager] getAllData];
    NSLog(@"Num of items: %d", allData.count);
    //Always call this in the app first, not the watch. make the watch inherit this permission.
    [[FCLocationManager sharedManager] startUpdatingLocation];
}


@end
