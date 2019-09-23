//
//  InterfaceController.m
//  TestWatchApp Extension
//
//  Created by Company on 2019/09/21.
//  Copyright © 2019 Active User Co.,LTD. All rights reserved.
//

#import "InterfaceController.h"
#import "SampleModel.h"
#import "InterfaceDetailViewController.h"
#import "DataManager.h"
#import "DBHelper.h"
#import "TTApiClient.h"
#import "FCLocationManager.h"
#import <WatchConnectivity/WatchConnectivity.h>

/*How to make watchos and ios share code?
 Actually iOS can share dynamic framework with TodayExtension, but with watchOS, that not possible.
 You'll need to add another framework for watchOS, then add shared code to that framework.
Help from: https://www.skoumal.com/en/own-dynamic-framework-for-ios-macos-watchos-and-tvos/

 
 */
@interface InterfaceController () <FCLocationManagerDelegate> {
    NSMutableArray *dataList;

}
@end

@implementation RowController


@end


@implementation InterfaceController


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    NSLog(@"------- Awake with context");
    // Configure interface objects here.
    //Giong viewdidload
    
    //Preference OK
    if (![DataManager.sharedManager getPref:@"firstStartClock"]) {
        [DataManager.sharedManager setPref:@"firstStartClock" :@YES];
        
        dataList = [NSMutableArray array];
        [dataList addObject:[[SampleModel alloc]initWithNum:0 :@"Flight 1"]];
        [dataList addObject:[[SampleModel alloc]initWithNum:0 :@"Flight 2"]];
        [dataList addObject:[[SampleModel alloc]initWithNum:0 :@"Flight 3"]];
        [dataList addObject:[[SampleModel alloc]initWithNum:0 :@"Flight 4"]];
        [dataList addObject:[[SampleModel alloc]initWithNum:0 :@"Flight 5"]];
        
        [DBHelper.sharedManager genData:dataList];
    }
    
    //Try testing API OK
    [[TTApiClient sharedClient] getWallsWithHandler:^(NSDictionary *resutl, NSError *error) {
    }];
    
    //Try location OK
    [[FCLocationManager sharedManager] setDelegate:self];
    
    
    //Try connect to app
    [self loadAppData];
    [NSNotificationCenter.defaultCenter addObserverForName:@"whatName" object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        
    }];
    
    [NSNotificationCenter.defaultCenter addObserverForName:@"whatName2" object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        
    }];
}

-(void)loadAppData {
    if (WCSession.isSupported) {
        //Try sending message to the phone
        [WCSession.defaultSession sendMessage:@{@"request":@"test"} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            //Code when got message
            NSLog(@"got message from iPHone %@", replyMessage);
        } errorHandler:^(NSError * _Nonnull error) {
           //Code when error
            NSLog(@"Error message from iPHone %@", error);
        }];
    }
}

-(void)reloadData {
    dataList = [[DBHelper.sharedManager getAllData] mutableCopy];

    [_tbView setNumberOfRows:dataList.count withRowType:@"rowIden"];
    for (int i = 0; i < dataList.count; i++) {
        SampleModel *data = dataList[i];
        RowController *rc = [_tbView rowControllerAtIndex:i];
        [rc.countLbl setText:[NSString stringWithFormat:@"%d", data.num]];
        [rc.titleLbl setText:data.des];
    }
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    NSLog(@"Row selected %d", rowIndex);
    //This method will be automatically called if no segue is added
    SampleModel *dt = dataList[rowIndex];
    [self presentControllerWithName:@"interfaceDetailVC" context:dt];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    //Giong viewWillAppear
    [super willActivate];
    NSLog(@"------- Will activate");
    
    [self reloadData];
}

-(void)didAppear {
    [super didAppear];
    //OnScreen
    NSLog(@"------- didappear");
    //Only use this when permission is enabled in app
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined) {
            // Request permission if necessary
        [[FCLocationManager sharedManager] startUpdatingLocation];
    } else {
        //Tell user to grant permission inside the app
        [self presentAlertControllerWithTitle:@"Location" message:@"Please open iOS app, pair with watch and enable location permission" preferredStyle:WKAlertControllerStyleAlert actions:@[[WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleDefault handler:^{
            
        }]]];
    }
}

-(void)willDisappear {
    [super willDisappear];
    //OffScreen
    NSLog(@"------- willDisappear");
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    //Giong viewDidDisappear
    [super didDeactivate];
    NSLog(@"------- DidDeactivate");
    [FCLocationManager.sharedManager stopUpdatingLocation];
}

#pragma mark location

-(void)didAcquireLocation:(CLLocation *)location {
    NSLog(@"Got location");
}

-(void)didFindLocationName:(NSString *)locationName :(CLLocation *)location {
    NSLog(@"Location name %@", locationName);
}

-(void)didFailToAcquireLocationWithErrorMsg:(NSString *)errorMsg {
    NSLog(@"Failed location %@", errorMsg);
}

@end



