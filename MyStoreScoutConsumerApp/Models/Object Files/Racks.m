//
//  Racks.m
//
//  Created by C205  on 11/10/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "Racks.h"


NSString *const kRacksId = @"id";
NSString *const kRacksIsDeleted = @"is_deleted";
NSString *const kRacksModified = @"modified";
NSString *const kRacksPositionY = @"position_y";
NSString *const kRacksRackHeight = @"rack_height";
NSString *const kRacksCreated = @"created";
NSString *const kRacksRackWidth = @"rack_width";
NSString *const kRacksIsTestdata = @"is_testdata";
NSString *const kRacksRetailUserId = @"retail_user_id";
NSString *const kRacksPositionX = @"position_x";
NSString *const kRacksStoreId = @"store_id";
NSString *const kRacksRackType = @"rack_type";


@interface Racks ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Racks

@synthesize racksIdentifier = _racksIdentifier;
@synthesize isDeleted = _isDeleted;
@synthesize modified = _modified;
@synthesize positionY = _positionY;
@synthesize rackHeight = _rackHeight;
@synthesize created = _created;
@synthesize rackWidth = _rackWidth;
@synthesize isTestdata = _isTestdata;
@synthesize retailUserId = _retailUserId;
@synthesize positionX = _positionX;
@synthesize storeId = _storeId;
@synthesize rackType = _rackType;


+ (Racks *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Racks *instance = [[Racks alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.racksIdentifier = [self objectOrNilForKey:kRacksId fromDictionary:dict];
            self.isDeleted = [self objectOrNilForKey:kRacksIsDeleted fromDictionary:dict];
            self.modified = [self objectOrNilForKey:kRacksModified fromDictionary:dict];
            self.positionY = [self objectOrNilForKey:kRacksPositionY fromDictionary:dict];
            self.rackHeight = [self objectOrNilForKey:kRacksRackHeight fromDictionary:dict];
            self.created = [self objectOrNilForKey:kRacksCreated fromDictionary:dict];
            self.rackWidth = [self objectOrNilForKey:kRacksRackWidth fromDictionary:dict];
            self.isTestdata = [self objectOrNilForKey:kRacksIsTestdata fromDictionary:dict];
            self.retailUserId = [self objectOrNilForKey:kRacksRetailUserId fromDictionary:dict];
            self.positionX = [self objectOrNilForKey:kRacksPositionX fromDictionary:dict];
            self.storeId = [self objectOrNilForKey:kRacksStoreId fromDictionary:dict];
            self.rackType = [self objectOrNilForKey:kRacksRackType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.racksIdentifier forKey:kRacksId];
    [mutableDict setValue:self.isDeleted forKey:kRacksIsDeleted];
    [mutableDict setValue:self.modified forKey:kRacksModified];
    [mutableDict setValue:self.positionY forKey:kRacksPositionY];
    [mutableDict setValue:self.rackHeight forKey:kRacksRackHeight];
    [mutableDict setValue:self.created forKey:kRacksCreated];
    [mutableDict setValue:self.rackWidth forKey:kRacksRackWidth];
    [mutableDict setValue:self.isTestdata forKey:kRacksIsTestdata];
    [mutableDict setValue:self.retailUserId forKey:kRacksRetailUserId];
    [mutableDict setValue:self.positionX forKey:kRacksPositionX];
    [mutableDict setValue:self.storeId forKey:kRacksStoreId];
    [mutableDict setValue:self.rackType forKey:kRacksRackType];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.racksIdentifier = [aDecoder decodeObjectForKey:kRacksId];
    self.isDeleted = [aDecoder decodeObjectForKey:kRacksIsDeleted];
    self.modified = [aDecoder decodeObjectForKey:kRacksModified];
    self.positionY = [aDecoder decodeObjectForKey:kRacksPositionY];
    self.rackHeight = [aDecoder decodeObjectForKey:kRacksRackHeight];
    self.created = [aDecoder decodeObjectForKey:kRacksCreated];
    self.rackWidth = [aDecoder decodeObjectForKey:kRacksRackWidth];
    self.isTestdata = [aDecoder decodeObjectForKey:kRacksIsTestdata];
    self.retailUserId = [aDecoder decodeObjectForKey:kRacksRetailUserId];
    self.positionX = [aDecoder decodeObjectForKey:kRacksPositionX];
    self.storeId = [aDecoder decodeObjectForKey:kRacksStoreId];
    self.rackType = [aDecoder decodeObjectForKey:kRacksRackType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_racksIdentifier forKey:kRacksId];
    [aCoder encodeObject:_isDeleted forKey:kRacksIsDeleted];
    [aCoder encodeObject:_modified forKey:kRacksModified];
    [aCoder encodeObject:_positionY forKey:kRacksPositionY];
    [aCoder encodeObject:_rackHeight forKey:kRacksRackHeight];
    [aCoder encodeObject:_created forKey:kRacksCreated];
    [aCoder encodeObject:_rackWidth forKey:kRacksRackWidth];
    [aCoder encodeObject:_isTestdata forKey:kRacksIsTestdata];
    [aCoder encodeObject:_retailUserId forKey:kRacksRetailUserId];
    [aCoder encodeObject:_positionX forKey:kRacksPositionX];
    [aCoder encodeObject:_storeId forKey:kRacksStoreId];
    [aCoder encodeObject:_rackType forKey:kRacksRackType];
}


@end