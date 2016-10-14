//
//  Productdetail.m
//
//  Created by C205  on 14/10/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "Productdetail.h"


NSString *const kProductdetailId = @"id";
NSString *const kProductdetailRetailUserId = @"retail_user_id";
NSString *const kProductdetailRackId = @"rack_id";
NSString *const kProductdetailBlockId = @"block_id";
NSString *const kProductdetailCreated = @"created";
NSString *const kProductdetailIsDeleted = @"is_deleted";
NSString *const kProductdetailModified = @"modified";
NSString *const kProductdetailStoreId = @"store_id";
NSString *const kProductdetailProductName = @"product_name";


@interface Productdetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Productdetail

@synthesize productdetailIdentifier = _productdetailIdentifier;
@synthesize retailUserId = _retailUserId;
@synthesize rackId = _rackId;
@synthesize blockId = _blockId;
@synthesize created = _created;
@synthesize isDeleted = _isDeleted;
@synthesize modified = _modified;
@synthesize storeId = _storeId;
@synthesize productName = _productName;


+ (Productdetail *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Productdetail *instance = [[Productdetail alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.productdetailIdentifier = [self objectOrNilForKey:kProductdetailId fromDictionary:dict];
            self.retailUserId = [self objectOrNilForKey:kProductdetailRetailUserId fromDictionary:dict];
            self.rackId = [self objectOrNilForKey:kProductdetailRackId fromDictionary:dict];
            self.blockId = [self objectOrNilForKey:kProductdetailBlockId fromDictionary:dict];
            self.created = [self objectOrNilForKey:kProductdetailCreated fromDictionary:dict];
            self.isDeleted = [self objectOrNilForKey:kProductdetailIsDeleted fromDictionary:dict];
            self.modified = [self objectOrNilForKey:kProductdetailModified fromDictionary:dict];
            self.storeId = [self objectOrNilForKey:kProductdetailStoreId fromDictionary:dict];
            self.productName = [self objectOrNilForKey:kProductdetailProductName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.productdetailIdentifier forKey:kProductdetailId];
    [mutableDict setValue:self.retailUserId forKey:kProductdetailRetailUserId];
    [mutableDict setValue:self.rackId forKey:kProductdetailRackId];
    [mutableDict setValue:self.blockId forKey:kProductdetailBlockId];
    [mutableDict setValue:self.created forKey:kProductdetailCreated];
    [mutableDict setValue:self.isDeleted forKey:kProductdetailIsDeleted];
    [mutableDict setValue:self.modified forKey:kProductdetailModified];
    [mutableDict setValue:self.storeId forKey:kProductdetailStoreId];
    [mutableDict setValue:self.productName forKey:kProductdetailProductName];

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

    self.productdetailIdentifier = [aDecoder decodeObjectForKey:kProductdetailId];
    self.retailUserId = [aDecoder decodeObjectForKey:kProductdetailRetailUserId];
    self.rackId = [aDecoder decodeObjectForKey:kProductdetailRackId];
    self.blockId = [aDecoder decodeObjectForKey:kProductdetailBlockId];
    self.created = [aDecoder decodeObjectForKey:kProductdetailCreated];
    self.isDeleted = [aDecoder decodeObjectForKey:kProductdetailIsDeleted];
    self.modified = [aDecoder decodeObjectForKey:kProductdetailModified];
    self.storeId = [aDecoder decodeObjectForKey:kProductdetailStoreId];
    self.productName = [aDecoder decodeObjectForKey:kProductdetailProductName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_productdetailIdentifier forKey:kProductdetailId];
    [aCoder encodeObject:_retailUserId forKey:kProductdetailRetailUserId];
    [aCoder encodeObject:_rackId forKey:kProductdetailRackId];
    [aCoder encodeObject:_blockId forKey:kProductdetailBlockId];
    [aCoder encodeObject:_created forKey:kProductdetailCreated];
    [aCoder encodeObject:_isDeleted forKey:kProductdetailIsDeleted];
    [aCoder encodeObject:_modified forKey:kProductdetailModified];
    [aCoder encodeObject:_storeId forKey:kProductdetailStoreId];
    [aCoder encodeObject:_productName forKey:kProductdetailProductName];
}


@end
