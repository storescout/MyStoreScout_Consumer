//
//  DataHelper.m
//  SQLExample
//
//  Created by Prerna Gupta on 3/16/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "SQLDataHelper.h"
#import <sqlite3.h>

#define DBName @"GenieMobile.sqlite"

@implementation SQLDataHelper


#pragma mark - Sqlite DB
+ (void) copyDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    NSLog(@"%@",dbPath);
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success)
        {
        }
    }
}

+ (NSString *) getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:DBName];
}


+(int) ExecuteNonQuery : (NSString *) Query
{
    static sqlite3_stmt *addStmt = nil;
    static sqlite3 *database = nil;
    int success = 1;

    @try {
        if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK)
        {
            if(addStmt == nil)
            {
                const char *sql = NULL;
                sql = [Query UTF8String];
                if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
                {
                    //NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
                }
            }
            if(SQLITE_DONE != sqlite3_step(addStmt))
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        }
    }
    @catch (NSException *exception) {
        success = 0;
        NSLog(@" Error Performing Query-----%@",exception);
    }
    @finally {
        sqlite3_reset(addStmt);
        sqlite3_finalize(addStmt);
        addStmt = nil;
        sqlite3_close(database);
        return success;
    }
}

+(sqlite3_stmt *) ExecuteReader : (NSString *) Query
{
    static sqlite3_stmt *getStmt = nil;
    static sqlite3 *database = nil;

    @try {
        if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK)
        {
            const char *sql = NULL;
            sql = [Query UTF8String];

            if(sqlite3_prepare_v2(database, sql, -1, &getStmt, NULL) == SQLITE_OK){}
            else
            {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            }
        }
    }
    @catch (NSException *exception){
        NSLog(@"Error Performing Read Operation: %@",exception);
    }
    @finally
    {
        sqlite3_close(database);
    }
    return getStmt;
}

+(sqlite3_stmt *) ExecuteSelect: (NSString *) tblName
{
    return [self ExecuteSelect:tblName withColumns:nil withCondition:nil];
}

+(sqlite3_stmt *) ExecuteSelect: (NSString *) tblName withColumns:(NSArray *) arrColumns
{
    return [self ExecuteSelect:tblName withColumns:arrColumns withCondition:nil];
}

+(sqlite3_stmt *) ExecuteSelect: (NSString *) tblName withColumns:(NSArray *) arrColumns withCondition:(NSDictionary *) dictConditions
{
    NSString *Query = [NSString stringWithFormat:@"Select "];
    
    if(arrColumns == nil)
        Query = [Query stringByAppendingString:[NSString stringWithFormat:@" * "]];
    else
    {
        for(int i=0;i<(int)arrColumns.count;i++)
        {
            NSString *appendString;
            if(i!=(int)arrColumns.count - 1)
                appendString = [NSString stringWithFormat:@"%@,",[arrColumns objectAtIndex:i]];
            else
                appendString = [NSString stringWithFormat:@"%@",[arrColumns objectAtIndex:i]];
            Query = [Query stringByAppendingString:appendString];
        }
    }
    Query = [Query stringByAppendingString:[NSString stringWithFormat:@" from %@ ",tblName]];
    
    if(dictConditions != nil)
    {
        Query = [Query stringByAppendingString:@" Where "];
        
        int i = 0;
        for(id key in dictConditions)
        {
            NSString *appendString;
            if(i != (int)dictConditions.count - 1)
                appendString = [NSString stringWithFormat:@"%@ = '%@' and ",key,[dictConditions objectForKey:key]];
            else
                appendString = [NSString stringWithFormat:@"%@ = '%@'",key,[dictConditions objectForKey:key]];
            Query = [Query stringByAppendingString:appendString];
            i++;
        }
    }
    return [self ExecuteReader:Query];
}

+(int) ExecuteInsert: (NSString *) tblName withParameters:(NSDictionary *) dictParmeter
{
    NSArray *allKeys = [dictParmeter allKeys];
    NSArray *allValues = [dictParmeter allValues];
    NSString *Query = [NSString stringWithFormat:@"Insert Into %@ (",tblName];
    
    for(int i=0;i<(int)allKeys.count;i++)
    {
        NSString *appendString;
        if(i!=(int)allKeys.count - 1)
            appendString = [NSString stringWithFormat:@"%@,",[allKeys objectAtIndex:i]];
        else
            appendString = [NSString stringWithFormat:@"%@)",[allKeys objectAtIndex:i]];
        Query = [Query stringByAppendingString:appendString];
    }
    Query = [Query stringByAppendingString:[NSString stringWithFormat:@" values (" ]];
    
    for(int i=0;i<(int)allValues.count;i++)
    {
        NSString *appendString;
        if(i!=(int)allKeys.count - 1)
            appendString = [NSString stringWithFormat:@"'%@',",[allValues objectAtIndex:i]];
        else
            appendString = [NSString stringWithFormat:@"'%@')",[allValues objectAtIndex:i]];
        Query = [Query stringByAppendingString:appendString];
    }
    return [self ExecuteNonQuery:Query];
}

+(int) ExecuteUpdate: (NSString *) tblName withParameters:(NSDictionary *) dictionary forCondition: (NSDictionary *)condDictionary
{
    NSString *Query = [NSString stringWithFormat:@"Update %@ set ",tblName];
    int i = 0;
    for(id key in dictionary)
    {
        NSString *appendString;
        if(i != (int)dictionary.count - 1)
            appendString = [NSString stringWithFormat:@"%@ = '%@',",key,[dictionary objectForKey:key]];
        else
            appendString = [NSString stringWithFormat:@"%@ = '%@'",key,[dictionary objectForKey:key]];
        Query = [Query stringByAppendingString:appendString];
        i++;
    }
    if([condDictionary count] > 0)
    {
        Query = [Query stringByAppendingString:@" Where "];
        
        i = 0;
        for(id key in condDictionary)
        {
            NSString *appendString;
            if(i != (int)condDictionary.count - 1)
                appendString = [NSString stringWithFormat:@"%@ = '%@' and ",key,[condDictionary objectForKey:key]];
            else
                appendString = [NSString stringWithFormat:@"%@ = '%@'",key,[condDictionary objectForKey:key]];
            Query = [Query stringByAppendingString:appendString];
            i++;
        }
    }
   return [SQLDataHelper ExecuteNonQuery:Query];
}

+(int) ExecuteDelete: (NSString *) tblName forCondition:(NSDictionary *) condDictionary
{
    NSString *Query;
    
    if(condDictionary.count > 0)
    {
        Query = [NSString stringWithFormat:@"Delete from %@ Where  ",tblName];
        int i = 0;
        for(id key in condDictionary)
        {
            NSString *appendString;
            if(i != (int)condDictionary.count - 1)
                appendString = [NSString stringWithFormat:@"%@ = '%@' and ",key,[condDictionary objectForKey:key]];
            else
                appendString = [NSString stringWithFormat:@"%@ = '%@'",key,[condDictionary objectForKey:key]];
            Query = [Query stringByAppendingString:appendString];
            i++;
        }
    }
    else
    {
        Query = [NSString stringWithFormat:@"Delete from %@",tblName];
    }
    return [SQLDataHelper ExecuteNonQuery:Query];
}

+(NSMutableArray*)parseSql:(sqlite3_stmt*)statement
{
    NSMutableArray  *returnArray    =   [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        NSMutableArray *tempArray=[[NSMutableArray alloc] init];
        
        for (int i=0; i<(sqlite3_column_count(statement)); i++)
            [tempArray addObject:[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, i)]];
        
        [returnArray addObject:[[NSMutableArray alloc] initWithArray:tempArray copyItems:YES]];
    }
    return returnArray;
}

+(NSMutableArray*)parseColumnList:(sqlite3_stmt*)statement
{
    NSMutableArray  *columnArray    =   [[NSMutableArray alloc] init];
    while(sqlite3_step(statement) == SQLITE_ROW)
    {
        NSString *fieldName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        [columnArray addObject:fieldName];
    }
    return columnArray;
}

@end
