//
//  DataHelper.h
//  SQLExample
//
//  Created by Prerna Gupta on 3/16/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SQLDataHelper : NSObject
{
    
}
+(int) ExecuteNonQuery : (NSString *) Query;
+(sqlite3_stmt *) ExecuteReader : (NSString *) Query;
+(int) ExecuteInsert: (NSString *) tblName withParameters:(NSDictionary *) dictParmeter;
+(int) ExecuteUpdate: (NSString *) tblName withParameters:(NSDictionary *) dictionary forCondition: (NSDictionary *)condDictionary;
+(int) ExecuteDelete: (NSString *) tblName forCondition:(NSDictionary *) condDictionary;

+(sqlite3_stmt *) ExecuteSelect: (NSString *) tblName;

+(sqlite3_stmt *) ExecuteSelect: (NSString *) tblName withColumns:(NSArray *) arrColumns;

+(sqlite3_stmt *) ExecuteSelect: (NSString *) tblName withColumns:(NSArray *) arrColumns withCondition:(NSDictionary *) dictConditions;

+ (void) copyDatabaseIfNeeded;
+ (NSString *) getDBPath ;

+(NSMutableArray*)parseColumnList:(sqlite3_stmt*)statement;
+(NSMutableArray*)parseSql:(sqlite3_stmt*)statement;
@end
