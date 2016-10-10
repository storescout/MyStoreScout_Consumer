//
//  SQLDataAdapter.m
//  NIPLiOSFramework
//
//  Created by Prerna on 8/17/15.
//  Copyright (c) 2015 Prerna. All rights reserved.
//

#import "SQLDataAdapter.h"
#import "SQLDataHelper.h"

#define tblpoints @"points"
#define tbllines @"lines"
#define tblrectangles @"rectangles"
#define tbllabels @"labels"


SQLDataAdapter *data_adapter;
@implementation SQLDataAdapter

+(SQLDataAdapter*)sharedInstance
{
    @synchronized(self)
    {
        if(data_adapter == nil)
            data_adapter = [[super allocWithZone:NULL] init] ;
    }
    return data_adapter;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


-(void)copyDatabase
{
    [SQLDataHelper copyDatabaseIfNeeded];
}

#pragma mark - Insert event

-(void)insertPoints:(NSDictionary *)dict
{
    [SQLDataHelper ExecuteInsert:tblpoints withParameters:dict];
}

-(void)insertLines:(NSDictionary *)dict
{
    [SQLDataHelper ExecuteInsert:tbllines withParameters:dict];
}

-(void)insertRectangles:(NSDictionary *)dict
{
    [SQLDataHelper ExecuteInsert:tblrectangles withParameters:dict];
}

-(void)insertLabels:(NSDictionary *)dict
{
    [SQLDataHelper ExecuteInsert:tbllabels withParameters:dict];
}

#pragma mark - Update event

-(void)updatePoints:(NSDictionary *)dict withCondition:(NSDictionary *)condition
{
    [SQLDataHelper ExecuteUpdate:tblpoints withParameters:dict forCondition:condition];
}

-(void)updateLines:(NSDictionary *)dict withCondition:(NSDictionary *)condition
{
    [SQLDataHelper ExecuteUpdate:tbllines withParameters:dict forCondition:condition];
}

-(void)updateRectangles:(NSDictionary *)dict withCondition:(NSDictionary *)condition
{
    [SQLDataHelper ExecuteUpdate:tblrectangles withParameters:dict forCondition:condition];
}

-(void)updateLabels:(NSDictionary *)dict withCondition:(NSDictionary *)condition
{
    [SQLDataHelper ExecuteUpdate:tbllabels withParameters:dict forCondition:condition];
}

#pragma mark - Delete event

-(void)deletePoints:(NSDictionary *)condition
{
    [SQLDataHelper ExecuteDelete:tblpoints forCondition:condition];
}

-(void)deleteLines:(NSDictionary *)condition
{
    [SQLDataHelper ExecuteDelete:tbllines forCondition:condition];
}

-(void)deleteRectangles:(NSDictionary *)condition
{
    [SQLDataHelper ExecuteDelete:tblrectangles forCondition:condition];
}

-(void)deleteLabels:(NSDictionary *)condition
{
    [SQLDataHelper ExecuteDelete:tbllabels forCondition:condition];
}

#pragma mark - Select event

-(NSMutableArray *)selectAvailableFloors
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT DISTINCT floor_name FROM %@",tbllines]]];
}

-(NSMutableArray *)selectAllPoints
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@",tblpoints]]];
}

-(NSMutableArray *)selectAllLines
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@",tbllines]]];
}

-(NSMutableArray *)selectAllRectangles
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@",tblrectangles]]];
}

-(NSMutableArray *)selectAllLabels
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@",tbllabels]]];
}

#pragma mark - Select with Condition event

-(NSMutableArray *)selectPointsByFloorName:(NSString *)condition
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@ where floor_name='%@'",tblpoints,condition]]];
}

-(NSMutableArray *)selectLinesByFloorName:(NSString *)condition
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@ where floor_name='%@'",tbllines,condition]]];
}

-(NSMutableArray *)selectRectanglesByFloorName:(NSString *)condition
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@ where floor_name='%@'",tblrectangles,condition]]];
}

-(NSMutableArray *)selectLabelsByFloorName:(NSString *)condition
{
    NSMutableArray *allRestaurant = [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@ where floor_name='%@'",tbllabels,condition]]];
    return allRestaurant;
}

-(NSMutableArray *)selectPointsByPointName:(NSString *)condition1 AndFloorName:(NSString *)condition2
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@ where point_name='%@' AND floor_name='%@'",tblpoints,condition1,condition2]]];
}

-(NSMutableArray *)selectLinesByLineName:(NSString *)condition1 AndFloorName:(NSString *)condition2
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@ where line_name='%@' AND floor_name='%@'",tbllines,condition1,condition2]]];
}

-(NSMutableArray *)selectRectanglesByRectangleName:(NSString *)condition1 AndFloorName:(NSString *)condition2
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@ where rectangle_name='%@' AND floor_name='%@'",tblrectangles,condition1,condition2]]];
}

-(NSMutableArray *)selectLabelsByLabelName:(NSString *)condition1 AndFloorName:(NSString *)condition2
{
    return [SQLDataHelper parseSql:[SQLDataHelper ExecuteReader:[NSString stringWithFormat:@"SELECT * FROM %@ where label_name='%@' AND floor_name='%@'",tbllabels,condition1,condition2]]];
}

@end
