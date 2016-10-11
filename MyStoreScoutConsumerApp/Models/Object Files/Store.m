//
//  Store.m
//
//  Created by C205  on 11/10/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "Store.h"
#import "Racks.h"
#import "StoreImages.h"


NSString *const kStoreId = @"id";
NSString *const kStoreIsDeleted = @"is_deleted";
NSString *const kStoreStoreName = @"store_name";
NSString *const kStoreContactNo = @"contact_no";
NSString *const kStoreModified = @"modified";
NSString *const kStoreLongitude = @"longitude";
NSString *const kStoreWidth = @"width";
NSString *const kStorePositionY = @"position_y";
NSString *const kStoreLatitude = @"latitude";
NSString *const kStoreStoreAddress = @"store_address";
NSString *const kStoreStartTime = @"start_time";
NSString *const kStoreRacks = @"racks";
NSString *const kStoreHeight = @"height";
NSString *const kStoreEndTime = @"end_time";
NSString *const kStoreIsTestdata = @"is_testdata";
NSString *const kStoreCreated = @"created";
NSString *const kStoreStoreImages = @"store_images";
NSString *const kStoreRetailUserId = @"retail_user_id";
NSString *const kStorePositionX = @"position_x";


@interface Store ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Store

@synthesize storeIdentifier = _storeIdentifier;
@synthesize isDeleted = _isDeleted;
@synthesize storeName = _storeName;
@synthesize contactNo = _contactNo;
@synthesize modified = _modified;
@synthesize longitude = _longitude;
@synthesize width = _width;
@synthesize positionY = _positionY;
@synthesize latitude = _latitude;
@synthesize storeAddress = _storeAddress;
@synthesize startTime = _startTime;
@synthesize racks = _racks;
@synthesize height = _height;
@synthesize endTime = _endTime;
@synthesize isTestdata = _isTestdata;
@synthesize created = _created;
@synthesize storeImages = _storeImages;
@synthesize retailUserId = _retailUserId;
@synthesize positionX = _positionX;


+ (Store *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Store *instance = [[Store alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.storeIdentifier = [self objectOrNilForKey:kStoreId fromDictionary:dict];
            self.isDeleted = [self objectOrNilForKey:kStoreIsDeleted fromDictionary:dict];
            self.storeName = [self objectOrNilForKey:kStoreStoreName fromDictionary:dict];
            self.contactNo = [self objectOrNilForKey:kStoreContactNo fromDictionary:dict];
            self.modified = [self objectOrNilForKey:kStoreModified fromDictionary:dict];
            self.longitude = [self objectOrNilForKey:kStoreLongitude fromDictionary:dict];
            self.width = [self objectOrNilForKey:kStoreWidth fromDictionary:dict];
            self.positionY = [self objectOrNilForKey:kStorePositionY fromDictionary:dict];
            self.latitude = [self objectOrNilForKey:kStoreLatitude fromDictionary:dict];
            self.storeAddress = [self objectOrNilForKey:kStoreStoreAddress fromDictionary:dict];
            self.startTime = [self objectOrNilForKey:kStoreStartTime fromDictionary:dict];
    NSObject *receivedRacks = [dict objectForKey:kStoreRacks];
    NSMutableArray *parsedRacks = [NSMutableArray array];
    if ([receivedRacks isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedRacks) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedRacks addObject:[Racks modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedRacks isKindOfClass:[NSDictionary class]]) {
       [parsedRacks addObject:[Racks modelObjectWithDictionary:(NSDictionary *)receivedRacks]];
    }

    self.racks = [NSArray arrayWithArray:parsedRacks];
            self.height = [self objectOrNilForKey:kStoreHeight fromDictionary:dict];
            self.endTime = [self objectOrNilForKey:kStoreEndTime fromDictionary:dict];
            self.isTestdata = [self objectOrNilForKey:kStoreIsTestdata fromDictionary:dict];
            self.created = [self objectOrNilForKey:kStoreCreated fromDictionary:dict];
    NSObject *receivedStoreImages = [dict objectForKey:kStoreStoreImages];
    NSMutableArray *parsedStoreImages = [NSMutableArray array];
    if ([receivedStoreImages isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedStoreImages) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedStoreImages addObject:[StoreImages modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedStoreImages isKindOfClass:[NSDictionary class]]) {
       [parsedStoreImages addObject:[StoreImages modelObjectWithDictionary:(NSDictionary *)receivedStoreImages]];
    }

    self.storeImages = [NSArray arrayWithArray:parsedStoreImages];
            self.retailUserId = [self objectOrNilForKey:kStoreRetailUserId fromDictionary:dict];
            self.positionX = [self objectOrNilForKey:kStorePositionX fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.storeIdentifier forKey:kStoreId];
    [mutableDict setValue:self.isDeleted forKey:kStoreIsDeleted];
    [mutableDict setValue:self.storeName forKey:kStoreStoreName];
    [mutableDict setValue:self.contactNo forKey:kStoreContactNo];
    [mutableDict setValue:self.modified forKey:kStoreModified];
    [mutableDict setValue:self.longitude forKey:kStoreLongitude];
    [mutableDict setValue:self.width forKey:kStoreWidth];
    [mutableDict setValue:self.positionY forKey:kStorePositionY];
    [mutableDict setValue:self.latitude forKey:kStoreLatitude];
    [mutableDict setValue:self.storeAddress forKey:kStoreStoreAddress];
    [mutableDict setValue:self.startTime forKey:kStoreStartTime];
NSMutableArray *tempArrayForRacks = [NSMutableArray array];
    for (NSObject *subArrayObject in self.racks) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForRacks addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForRacks addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForRacks] forKey:@"kStoreRacks"];
    [mutableDict setValue:self.height forKey:kStoreHeight];
    [mutableDict setValue:self.endTime forKey:kStoreEndTime];
    [mutableDict setValue:self.isTestdata forKey:kStoreIsTestdata];
    [mutableDict setValue:self.created forKey:kStoreCreated];
NSMutableArray *tempArrayForStoreImages = [NSMutableArray array];
    for (NSObject *subArrayObject in self.storeImages) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForStoreImages addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForStoreImages addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForStoreImages] forKey:@"kStoreStoreImages"];
    [mutableDict setValue:self.retailUserId forKey:kStoreRetailUserId];
    [mutableDict setValue:self.positionX forKey:kStorePositionX];

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

    self.storeIdentifier = [aDecoder decodeObjectForKey:kStoreId];
    self.isDeleted = [aDecoder decodeObjectForKey:kStoreIsDeleted];
    self.storeName = [aDecoder decodeObjectForKey:kStoreStoreName];
    self.contactNo = [aDecoder decodeObjectForKey:kStoreContactNo];
    self.modified = [aDecoder decodeObjectForKey:kStoreModified];
    self.longitude = [aDecoder decodeObjectForKey:kStoreLongitude];
    self.width = [aDecoder decodeObjectForKey:kStoreWidth];
    self.positionY = [aDecoder decodeObjectForKey:kStorePositionY];
    self.latitude = [aDecoder decodeObjectForKey:kStoreLatitude];
    self.storeAddress = [aDecoder decodeObjectForKey:kStoreStoreAddress];
    self.startTime = [aDecoder decodeObjectForKey:kStoreStartTime];
    self.racks = [aDecoder decodeObjectForKey:kStoreRacks];
    self.height = [aDecoder decodeObjectForKey:kStoreHeight];
    self.endTime = [aDecoder decodeObjectForKey:kStoreEndTime];
    self.isTestdata = [aDecoder decodeObjectForKey:kStoreIsTestdata];
    self.created = [aDecoder decodeObjectForKey:kStoreCreated];
    self.storeImages = [aDecoder decodeObjectForKey:kStoreStoreImages];
    self.retailUserId = [aDecoder decodeObjectForKey:kStoreRetailUserId];
    self.positionX = [aDecoder decodeObjectForKey:kStorePositionX];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_storeIdentifier forKey:kStoreId];
    [aCoder encodeObject:_isDeleted forKey:kStoreIsDeleted];
    [aCoder encodeObject:_storeName forKey:kStoreStoreName];
    [aCoder encodeObject:_contactNo forKey:kStoreContactNo];
    [aCoder encodeObject:_modified forKey:kStoreModified];
    [aCoder encodeObject:_longitude forKey:kStoreLongitude];
    [aCoder encodeObject:_width forKey:kStoreWidth];
    [aCoder encodeObject:_positionY forKey:kStorePositionY];
    [aCoder encodeObject:_latitude forKey:kStoreLatitude];
    [aCoder encodeObject:_storeAddress forKey:kStoreStoreAddress];
    [aCoder encodeObject:_startTime forKey:kStoreStartTime];
    [aCoder encodeObject:_racks forKey:kStoreRacks];
    [aCoder encodeObject:_height forKey:kStoreHeight];
    [aCoder encodeObject:_endTime forKey:kStoreEndTime];
    [aCoder encodeObject:_isTestdata forKey:kStoreIsTestdata];
    [aCoder encodeObject:_created forKey:kStoreCreated];
    [aCoder encodeObject:_storeImages forKey:kStoreStoreImages];
    [aCoder encodeObject:_retailUserId forKey:kStoreRetailUserId];
    [aCoder encodeObject:_positionX forKey:kStorePositionX];
}


@end
