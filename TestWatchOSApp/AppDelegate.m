//
//  AppDelegate.m
//  TestWatchOSApp
//
//  Created by Company on 2019/09/21.
//  Copyright © 2019 Active User Co.,LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <WatchConnectivity/WatchConnectivity.h>


@interface AppDelegate () <WCSessionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Setup connection to watch app
    if (WCSession.isSupported) {
        WCSession.defaultSession.delegate = self;
        [WCSession.defaultSession activateSession];
    }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


#pragma mark Watch app

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    if ([message objectForKey:@"request"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"A message from watch"
                                                        message:@"something"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Say Hello",nil];
        [alert show];
        NSLog(@"message %@", [message objectForKey:@"request"]);
        replyHandler(@{@"test":@"message"});
    } else {
        replyHandler(@{});
    }
}

- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    
}

- (void)sessionDidBecomeInactive:(nonnull WCSession *)session {
    
}

- (void)sessionDidDeactivate:(nonnull WCSession *)session {
    
}

@end
