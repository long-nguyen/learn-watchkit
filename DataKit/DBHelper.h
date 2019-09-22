//
//  DBHelper.h
//  WeatherAssistant
//
//  Created by Company on 7/20/16.
//  Copyright © 2016 ActiveUser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleModel.h"


#define CURRENT_LOCATION_ID @"-1"
#define DB_NAME  @"database.db"

@interface DBHelper : NSObject

+ (DBHelper *)sharedManager;

- (NSArray *)getAllData;
- (BOOL)genData:(NSMutableArray *)data;
- (BOOL)updateData:(SampleModel *)data;

@end
