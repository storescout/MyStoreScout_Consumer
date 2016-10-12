//
//  Products.m
//
//  Created by C205  on 12/10/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "Products.h"


NSString *const kProductsId = @"id";
NSString *const kProductsRetailUserId = @"retail_user_id";
NSString *const kProductsRackId = @"rack_id";
NSString *const kProductsBlockId = @"block_id";
NSString *const kProductsCreated = @"created";
NSString *const kProductsIsDeleted = @"is_deleted";
NSString *const kProductsModified = @"modified";
NSString *const kProductsStoreId = @"store_id";
NSString *const kProductsProductName = @"product_name";


@interface Products ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Products

@synthesize productsIdentifier = _productsIdentifier;
@synthesize retailUserId = _retailUserId;
@synthesize rackId = _rackId;
@synthesize blockId = _blockId;
@synthesize created = _created;
@synthesize isDeleted = _isDeleted;
@synthesize modified = _modified;
@synthesize storeId = _storeId;
@synthesize productName = _productName;


+ (Products *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Products *instance = [[Products alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.productsIdentifier = [self objectOrNilForKey:kProductsId fromDictionary:dict];
            self.retailUserId = [self objectOrNilForKey:kProductsRetailUserId fromDictionary:dict];
            self.rackId = [self objectOrNilForKey:kProductsRackId fromDictionary:dict];
            self.blockId = [self objectOrNilForKey:kProductsBlockId fromDictionary:dict];
            self.created = [self objectOrNilForKey:kProductsCreated fromDictionary:dict];
            self.isDeleted = [self objectOrNilForKey:kProductsIsDeleted fromDictionary:dict];
            self.modified = [self objectOrNilForKey:kProductsModified fromDictionary:dict];
            self.storeId = [self objectOrNilForKey:kProductsStoreId fromDictionary:dict];
            self.productName = [self objectOrNilForKey:kProductsProductName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.productsIdentifier forKey:kProductsId];
    [mutableDict setValue:self.retailUserId forKey:kProductsRetailUserId];
    [mutableDict setValue:self.rackId forKey:kProductsRackId];
    [mutableDict setValue:self.blockId forKey:kProductsBlockId];
    [mutableDict setValue:self.created forKey:kProductsCreated];
    [mutableDict setValue:self.isDeleted forKey:kProductsIsDeleted];
    [mutableDict setValue:self.modified forKey:kProductsModified];
    [mutableDict setValue:self.storeId forKey:kProductsStoreId];
    [mutableDict setValue:self.productName forKey:kProductsProductName];

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

    self.productsIdentifier = [aDecoder decodeObjectForKey:kProductsId];
    self.retailUserId = [aDecoder decodeObjectForKey:kProductsRetailUserId];
    self.rackId = [aDecoder decodeObjectForKey:kProductsRackId];
    self.blockId = [aDecoder decodeObjectForKey:kProductsBlockId];
    self.created = [aDecoder decodeObjectForKey:kProductsCreated];
    self.isDeleted = [aDecoder decodeObjectForKey:kProductsIsDeleted];
    self.modified = [aDecoder decodeObjectForKey:kProductsModified];
    self.storeId = [aDecoder decodeObjectForKey:kProductsStoreId];
    self.productName = [aDecoder decodeObjectForKey:kProductsProductName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_productsIdentifier forKey:kProductsId];
    [aCoder encodeObject:_retailUserId forKey:kProductsRetailUserId];
    [aCoder encodeObject:_rackId forKey:kProductsRackId];
    [aCoder encodeObject:_blockId forKey:kProductsBlockId];
    [aCoder encodeObject:_created forKey:kProductsCreated];
    [aCoder encodeObject:_isDeleted forKey:kProductsIsDeleted];
    [aCoder encodeObject:_modified forKey:kProductsModified];
    [aCoder encodeObject:_storeId forKey:kProductsStoreId];
    [aCoder encodeObject:_productName forKey:kProductsProductName];
}


@end
