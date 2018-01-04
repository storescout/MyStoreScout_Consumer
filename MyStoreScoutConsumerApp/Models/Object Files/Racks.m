//
//  Racks.m
//
//  Created by   on 21/11/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "Racks.h"


NSString *const kRacksId = @"id";
NSString *const kRacksIsDeleted = @"is_deleted";
NSString *const kRacksModified = @"modified";
NSString *const kRacksAngle = @"angle";
NSString *const kRacksPositionY = @"position_y";
NSString *const kRacksRackHeight = @"rack_height";
NSString *const kRacksCreated = @"created";
NSString *const kRacksRackWidth = @"rack_width";
NSString *const kRacksIsTestdata = @"is_testdata";
NSString *const kRacksRetailUserId = @"retail_user_id";
NSString *const kRacksPositionX = @"position_x";
NSString *const kRacksStoreId = @"store_id";
NSString *const kRacksRackType = @"rack_type";
NSString *const kStoreStoreText = @"store_text";



//Added By : Anjali Jariwala
NSString *const kStoreBeaconUuid = @"beacon_uuid";
NSString *const kStoreBeaconMajor = @"beacon_major";
NSString *const kStoreBeaconMinor = @"beacon_minor";
NSString *const kStoreBeaconId = @"beacon_identifier";
NSString *const kStoreBeaconType = @"beacon_type";
NSString *const kStoreProductId = @"Product_id";
NSString *const kStoreProductName = @"Product_name";

@interface Racks ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Racks

@synthesize racksIdentifier = _racksIdentifier;
@synthesize isDeleted = _isDeleted;
@synthesize modified = _modified;
@synthesize angle = _angle;
@synthesize positionY = _positionY;
@synthesize rackHeight = _rackHeight;
@synthesize created = _created;
@synthesize rackWidth = _rackWidth;
@synthesize isTestdata = _isTestdata;
@synthesize retailUserId = _retailUserId;
@synthesize positionX = _positionX;
@synthesize storeId = _storeId;
@synthesize rackType = _rackType;
@synthesize storeText = _storeText;
//Added By: Anjali Jariwala
@synthesize beaconUuid = _beaconUuid;
@synthesize beaconMajor = _beaconMajor;
@synthesize beaconMinor = _beaconMinor;
@synthesize beaconIdentifier = _beaconIdentifier;
@synthesize beaconType = _beaconType;
@synthesize Product_id = _Product_id;
@synthesize Product_name = _Product_name;

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
        self.angle = [self objectOrNilForKey:kRacksAngle fromDictionary:dict];
        self.positionY = [self objectOrNilForKey:kRacksPositionY fromDictionary:dict];
        self.rackHeight = [self objectOrNilForKey:kRacksRackHeight fromDictionary:dict];
        self.created = [self objectOrNilForKey:kRacksCreated fromDictionary:dict];
        self.rackWidth = [self objectOrNilForKey:kRacksRackWidth fromDictionary:dict];
        self.isTestdata = [self objectOrNilForKey:kRacksIsTestdata fromDictionary:dict];
        self.retailUserId = [self objectOrNilForKey:kRacksRetailUserId fromDictionary:dict];
        self.positionX = [self objectOrNilForKey:kRacksPositionX fromDictionary:dict];
        self.storeId = [self objectOrNilForKey:kRacksStoreId fromDictionary:dict];
        self.rackType = [self objectOrNilForKey:kRacksRackType fromDictionary:dict];
        self.storeText = [self objectOrNilForKey:kStoreStoreText fromDictionary:dict];
        self.Product_id = [self objectOrNilForKey:kStoreProductId fromDictionary:dict];
        self.Product_name = [self objectOrNilForKey:kStoreProductName fromDictionary:dict];
        
        //Added By : Anjali Jariwala
        self.beaconUuid = [self objectOrNilForKey:kStoreBeaconUuid fromDictionary:dict];
        self.beaconMajor = [self objectOrNilForKey:kStoreBeaconMajor fromDictionary:dict];
        self.beaconMinor = [self objectOrNilForKey:kStoreBeaconMinor fromDictionary:dict];
        self.beaconIdentifier = [self objectOrNilForKey:kStoreBeaconId fromDictionary:dict];
        self.beaconType = [self objectOrNilForKey:kStoreBeaconType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.racksIdentifier forKey:kRacksId];
    [mutableDict setValue:self.isDeleted forKey:kRacksIsDeleted];
    [mutableDict setValue:self.modified forKey:kRacksModified];
    [mutableDict setValue:self.angle forKey:kRacksAngle];
    [mutableDict setValue:self.positionY forKey:kRacksPositionY];
    [mutableDict setValue:self.rackHeight forKey:kRacksRackHeight];
    [mutableDict setValue:self.created forKey:kRacksCreated];
    [mutableDict setValue:self.rackWidth forKey:kRacksRackWidth];
    [mutableDict setValue:self.isTestdata forKey:kRacksIsTestdata];
    [mutableDict setValue:self.retailUserId forKey:kRacksRetailUserId];
    [mutableDict setValue:self.positionX forKey:kRacksPositionX];
    [mutableDict setValue:self.storeId forKey:kRacksStoreId];
    [mutableDict setValue:self.rackType forKey:kRacksRackType];
    [mutableDict setValue:self.storeText forKey:kStoreStoreText];
    
    //Added By : Anjali Jariwala
    [mutableDict setValue:self.beaconUuid forKey:kStoreBeaconUuid];
    [mutableDict setValue:self.beaconMajor forKey:kStoreBeaconMajor];
    [mutableDict setValue:self.beaconMinor forKey:kStoreBeaconMinor];
    [mutableDict setValue:self.beaconIdentifier forKey:kStoreBeaconId];
    [mutableDict setValue:self.Product_id forKey:kStoreProductId];
    [mutableDict setValue:self.Product_name forKey:kStoreProductName];
    [mutableDict setValue:self.beaconType forKey:kStoreBeaconType];
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
    self.angle = [aDecoder decodeObjectForKey:kRacksAngle];
    self.positionY = [aDecoder decodeObjectForKey:kRacksPositionY];
    self.rackHeight = [aDecoder decodeObjectForKey:kRacksRackHeight];
    self.created = [aDecoder decodeObjectForKey:kRacksCreated];
    self.rackWidth = [aDecoder decodeObjectForKey:kRacksRackWidth];
    self.isTestdata = [aDecoder decodeObjectForKey:kRacksIsTestdata];
    self.retailUserId = [aDecoder decodeObjectForKey:kRacksRetailUserId];
    self.positionX = [aDecoder decodeObjectForKey:kRacksPositionX];
    self.storeId = [aDecoder decodeObjectForKey:kRacksStoreId];
    self.rackType = [aDecoder decodeObjectForKey:kRacksRackType];
    self.storeText = [aDecoder decodeObjectForKey:kStoreStoreText];
    
    
    //Added By : Anjali Jariwala
    self.beaconUuid = [aDecoder decodeObjectForKey:kStoreBeaconUuid];
    self.beaconMajor = [aDecoder decodeObjectForKey:kStoreBeaconMajor];
    self.beaconMinor = [aDecoder decodeObjectForKey:kStoreBeaconMinor];
    self.beaconIdentifier = [aDecoder decodeObjectForKey:kStoreBeaconId];
    self.Product_id = [aDecoder decodeObjectForKey:kStoreProductId];
    self.Product_name = [aDecoder decodeObjectForKey:kStoreProductName];
    self.beaconType = [aDecoder decodeObjectForKey:kStoreBeaconType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_racksIdentifier forKey:kRacksId];
    [aCoder encodeObject:_isDeleted forKey:kRacksIsDeleted];
    [aCoder encodeObject:_modified forKey:kRacksModified];
    [aCoder encodeObject:_angle forKey:kRacksAngle];
    [aCoder encodeObject:_positionY forKey:kRacksPositionY];
    [aCoder encodeObject:_rackHeight forKey:kRacksRackHeight];
    [aCoder encodeObject:_created forKey:kRacksCreated];
    [aCoder encodeObject:_rackWidth forKey:kRacksRackWidth];
    [aCoder encodeObject:_isTestdata forKey:kRacksIsTestdata];
    [aCoder encodeObject:_retailUserId forKey:kRacksRetailUserId];
    [aCoder encodeObject:_positionX forKey:kRacksPositionX];
    [aCoder encodeObject:_storeId forKey:kRacksStoreId];
    [aCoder encodeObject:_rackType forKey:kRacksRackType];
    [aCoder encodeObject:_storeText forKey:kStoreStoreText];
    
    //Added By : Anjali Jariwala
    [aCoder encodeObject:_beaconUuid forKey:kStoreBeaconUuid];
    [aCoder encodeObject:_beaconMajor forKey:kStoreBeaconMajor];
    [aCoder encodeObject:_beaconMinor forKey:kStoreBeaconMinor];
    [aCoder encodeObject:_beaconIdentifier forKey:kStoreBeaconId];
    [aCoder encodeObject:_Product_id forKey:kStoreProductId];
    [aCoder encodeObject:_Product_name forKey:kStoreProductName];
    [aCoder encodeObject:_beaconType forKey:kStoreBeaconType];
    
}


@end
