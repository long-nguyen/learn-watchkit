//
//  DataManager.m
//  DataKit
//
//  Created by Company on 2019/09/22.
//  Copyright © 2019 Active User Co.,LTD. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager


+ (DataManager *)sharedManager{
    static DataManager *_manager = nil;
    if (_manager == nil)
    {
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            _manager = [[DataManager alloc] init];
        });
    }
    return _manager;
}


+ (NSString *)appBuildVersion {
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    return build;
}

-(id)getPref:(NSString *)key {
    NSUserDefaults *defaults = [[NSUserDefaults alloc]initWithSuiteName:APP_GROUP];
    return [defaults objectForKey:key];
}

-(void)setPref:(NSString *)key :(id)value {
    NSUserDefaults *defaults = [[NSUserDefaults alloc]initWithSuiteName:APP_GROUP];
       [defaults setObject:value forKey:key];
}

-(void)removePref:(NSString *)key{
    NSUserDefaults *defaults = [[NSUserDefaults alloc]initWithSuiteName:APP_GROUP];
    [defaults removeObjectForKey:key];
}
@end
