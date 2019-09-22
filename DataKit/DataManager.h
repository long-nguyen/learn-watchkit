//
//  DataManager.h
//  DataKit
//
//  Created by Company on 2019/09/22.
//  Copyright © 2019 Active User Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+(NSString *)appBuildVersion;
+(DataManager *)sharedManager;
-(id)getPref:(NSString *)key;
-(void)setPref:(NSString *)key :(id)value;
-(void)removePref:(NSString *)key;



@end

NS_ASSUME_NONNULL_END
