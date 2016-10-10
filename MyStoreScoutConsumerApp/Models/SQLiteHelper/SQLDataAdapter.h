//
//  SQLDataAdapter.h
//  NIPLiOSFramework
//
//  Created by Prerna on 8/17/15.
//  Copyright (c) 2015 Prerna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLDataAdapter : NSObject

+(SQLDataAdapter*)sharedInstance;
-(void)copyDatabase;

-(void)insertPoints:(NSDictionary *)dict;
-(void)insertLines:(NSDictionary *)dict;
-(void)insertRectangles:(NSDictionary *)dict;
-(void)insertLabels:(NSDictionary *)dict;

-(void)updatePoints:(NSDictionary *)dict withCondition:(NSDictionary *)condition;
-(void)updateLines:(NSDictionary *)dict withCondition:(NSDictionary *)condition;
-(void)updateRectangles:(NSDictionary *)dict withCondition:(NSDictionary *)condition;
-(void)updateLabels:(NSDictionary *)dict withCondition:(NSDictionary *)condition;

-(void)deletePoints:(NSDictionary *)condition;
-(void)deleteLines:(NSDictionary *)condition;
-(void)deleteRectangles:(NSDictionary *)condition;
-(void)deleteLabels:(NSDictionary *)condition;

-(NSMutableArray *)selectAvailableFloors;
-(NSMutableArray *)selectAllPoints;
-(NSMutableArray *)selectAllLines;
-(NSMutableArray *)selectAllRectangles;
-(NSMutableArray *)selectAllLabels;

-(NSMutableArray *)selectPointsByFloorName:(NSString *)condition;
-(NSMutableArray *)selectLinesByFloorName:(NSString *)condition;
-(NSMutableArray *)selectRectanglesByFloorName:(NSString *)condition;
-(NSMutableArray *)selectLabelsByFloorName:(NSString *)condition;

-(NSMutableArray *)selectPointsByPointName:(NSString *)condition1 AndFloorName:(NSString *)condition2;
-(NSMutableArray *)selectLinesByLineName:(NSString *)condition1 AndFloorName:(NSString *)condition2;
-(NSMutableArray *)selectRectanglesByRectangleName:(NSString *)condition1 AndFloorName:(NSString *)condition2;
-(NSMutableArray *)selectLabelsByLabelName:(NSString *)condition1 AndFloorName:(NSString *)condition2;

@end
