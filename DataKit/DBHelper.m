//
//  DBHelper.m
//  WeatherAssistant
//
//  Created by Company on 7/20/16.
//  Copyright © 2016 ActiveUser. All rights reserved.
//


#import "DBHelper.h"
#import <FMDB/FMDB.h>
#import "SampleModel.h"

const int DB_VERSION = 1;

@interface DBHelper() {
    FMDatabase *_db;
    NSString *_dbPath;
}

@end

@implementation DBHelper

+ (DBHelper *)sharedManager{
    static DBHelper *_manager = nil;
    if (_manager == nil)
    {
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            _manager = [[DBHelper alloc] init];
        });
    }
    return _manager;
}

- (id) init {
    if (self = [super init]) {
        NSString *appGroupId = APP_GROUP;
        NSURL *appGroupDirectoryPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:appGroupId];
        NSURL *dataBaseURL = [appGroupDirectoryPath  URLByAppendingPathComponent:DB_NAME];
        _dbPath = [dataBaseURL path];
        
        //Check if DB is available
        BOOL avail;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        avail = [fileManager fileExistsAtPath:_dbPath];
        NSLog(@"DB path: %@", _dbPath);
        if (!avail) {
            //Fresh DB
            if ([self generateTable]) {
            } else {
                NSLog(@"Shit device");
            }
        }
    }
    return self;
}


- (BOOL)generateTable {
    FMDatabase *db ;
    @try {
        db = [FMDatabase databaseWithPath:_dbPath];
        [db open];
        BOOL result = [db executeUpdate:@"CREATE TABLE 'tb_sample' (`id` INTEGER Primary key AutoIncrement, `num` INTEGER, `des`	TEXT )"  withParameterDictionary:[NSDictionary dictionary]];
        NSLog(@"Table created resul? %d", result);
        [db setUserVersion: DB_VERSION];
        return true;
    } @catch (NSException *exception) {
    } @finally {
        if (db != nil ) {
            [db close];
        }
    }
    return false;
}

- (NSArray *)getAllData {
    NSMutableArray *allData = [[NSMutableArray alloc] init];
    FMDatabase *db ;
    @try {
        db = [FMDatabase databaseWithPath:_dbPath];
        [db open];
        FMResultSet *results = [db executeQuery:@"SELECT * FROM tb_sample ", nil];
        while([results next])
        {
            SampleModel *wc = [[SampleModel alloc] init];
            wc.Id = [results intForColumn:@"id"];
            wc.num = [results intForColumn:@"num"];
            wc.des = [results stringForColumn:@"des"];
            [allData addObject:wc];
        }
        [results close];
        
    } @catch (NSException *exception) {
    } @finally {
        if (db != nil ) {
            [db close];
        }
    }
    
    return allData;
}

-(BOOL)genData:(NSMutableArray *)data {
    FMDatabase *db;
    @try {
        db = [FMDatabase databaseWithPath:_dbPath];
        [db setShouldCacheStatements:NO];
        [db open];
        [db beginTransaction];
        for (SampleModel *md in data) {
            [db executeUpdate:@"INSERT INTO tb_sample (num, des) VALUES (?, ?);" withArgumentsInArray:@[@(md.num), md.des]];
        }
        [db commit];
    } @catch (NSException *exception) {
    } @finally {
        if (db != nil ) {
            [db close];
        }
    }
    
    return true;
}

- (BOOL)updateData:(SampleModel *)data {
    FMDatabase *db ;
    @try {
        db = [FMDatabase databaseWithPath:_dbPath];
        [db open];
        NSString *query = @"";
        query = [NSString stringWithFormat:@"UPDATE tb_sample SET num= '%d' WHERE id = '%d'", data.num, data.Id];
        BOOL res = [db executeUpdate:query];
        return res;
    } @catch (NSException *exception) {
    } @finally {
        if (db != nil ) {
            [db close];
        }
    }
    return false;
}


@end
