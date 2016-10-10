//
//  StoreImages.m
//
//  Created by C205  on 29/09/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "StoreImages.h"


NSString *const kStoreImagesStoreId = @"store_id";
NSString *const kStoreImagesId = @"id";
NSString *const kStoreImagesRetailUserId = @"retail_user_id";
NSString *const kStoreImagesCreated = @"created";
NSString *const kStoreImagesImgPath = @"img_path";
NSString *const kStoreImagesModified = @"modified";


@interface StoreImages ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation StoreImages

@synthesize storeId = _storeId;
@synthesize storeImagesIdentifier = _storeImagesIdentifier;
@synthesize retailUserId = _retailUserId;
@synthesize created = _created;
@synthesize imgPath = _imgPath;
@synthesize modified = _modified;


+ (StoreImages *)modelObjectWithDictionary:(NSDictionary *)dict
{
    StoreImages *instance = [[StoreImages alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.storeId = [self objectOrNilForKey:kStoreImagesStoreId fromDictionary:dict];
            self.storeImagesIdentifier = [self objectOrNilForKey:kStoreImagesId fromDictionary:dict];
            self.retailUserId = [self objectOrNilForKey:kStoreImagesRetailUserId fromDictionary:dict];
            self.created = [self objectOrNilForKey:kStoreImagesCreated fromDictionary:dict];
            self.imgPath = [self objectOrNilForKey:kStoreImagesImgPath fromDictionary:dict];
            self.modified = [self objectOrNilForKey:kStoreImagesModified fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.storeId forKey:kStoreImagesStoreId];
    [mutableDict setValue:self.storeImagesIdentifier forKey:kStoreImagesId];
    [mutableDict setValue:self.retailUserId forKey:kStoreImagesRetailUserId];
    [mutableDict setValue:self.created forKey:kStoreImagesCreated];
    [mutableDict setValue:self.imgPath forKey:kStoreImagesImgPath];
    [mutableDict setValue:self.modified forKey:kStoreImagesModified];

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

    self.storeId = [aDecoder decodeObjectForKey:kStoreImagesStoreId];
    self.storeImagesIdentifier = [aDecoder decodeObjectForKey:kStoreImagesId];
    self.retailUserId = [aDecoder decodeObjectForKey:kStoreImagesRetailUserId];
    self.created = [aDecoder decodeObjectForKey:kStoreImagesCreated];
    self.imgPath = [aDecoder decodeObjectForKey:kStoreImagesImgPath];
    self.modified = [aDecoder decodeObjectForKey:kStoreImagesModified];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_storeId forKey:kStoreImagesStoreId];
    [aCoder encodeObject:_storeImagesIdentifier forKey:kStoreImagesId];
    [aCoder encodeObject:_retailUserId forKey:kStoreImagesRetailUserId];
    [aCoder encodeObject:_created forKey:kStoreImagesCreated];
    [aCoder encodeObject:_imgPath forKey:kStoreImagesImgPath];
    [aCoder encodeObject:_modified forKey:kStoreImagesModified];
}


@end
