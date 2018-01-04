//
//  Data.m
//
//  Created by NC2-36  on 27/10/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "Offers.h"


NSString *const kOffersFlyerFrom = @"flyer_from";
NSString *const kOffersFlyerTo = @"flyer_to";
NSString *const kOffersProductId = @"Product_id";
NSString *const kOffersFlyerName = @"flyer_name";
NSString *const kOffersFlyerImg = @"flyer_img";
NSString *const kOffersFlyerDescription = @"flyer_description";


@interface Offers ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Offers

@synthesize flyerFrom = _flyerFrom;
@synthesize flyerTo = _flyerTo;
@synthesize productId = _productId;
@synthesize flyerName = _flyerName;
@synthesize flyerImg = _flyerImg;
@synthesize flyerDescription = _flyerDescription;


+ (Offers *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Offers *instance = [[Offers alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.flyerFrom = [self objectOrNilForKey:kOffersFlyerFrom fromDictionary:dict];
            self.flyerTo = [self objectOrNilForKey:kOffersFlyerTo fromDictionary:dict];
            self.productId = [self objectOrNilForKey:kOffersProductId fromDictionary:dict];
            self.flyerName = [self objectOrNilForKey:kOffersFlyerName fromDictionary:dict];
            self.flyerImg = [self objectOrNilForKey:kOffersFlyerImg fromDictionary:dict];
            self.flyerDescription = [self objectOrNilForKey:kOffersFlyerDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.flyerFrom forKey:kOffersFlyerFrom];
    [mutableDict setValue:self.flyerTo forKey:kOffersFlyerTo];
    [mutableDict setValue:self.productId forKey:kOffersProductId];
    [mutableDict setValue:self.flyerName forKey:kOffersFlyerName];
    [mutableDict setValue:self.flyerImg forKey:kOffersFlyerImg];
    [mutableDict setValue:self.flyerDescription forKey:kOffersFlyerDescription];

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

    self.flyerFrom = [aDecoder decodeObjectForKey:kOffersFlyerFrom];
    self.flyerTo = [aDecoder decodeObjectForKey:kOffersFlyerTo];
    self.productId = [aDecoder decodeObjectForKey:kOffersProductId];
    self.flyerName = [aDecoder decodeObjectForKey:kOffersFlyerName];
    self.flyerImg = [aDecoder decodeObjectForKey:kOffersFlyerImg];
    self.flyerDescription = [aDecoder decodeObjectForKey:kOffersFlyerDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_flyerFrom forKey:kOffersFlyerFrom];
    [aCoder encodeObject:_flyerTo forKey:kOffersFlyerTo];
    [aCoder encodeObject:_productId forKey:kOffersProductId];
    [aCoder encodeObject:_flyerName forKey:kOffersFlyerName];
    [aCoder encodeObject:_flyerImg forKey:kOffersFlyerImg];
    [aCoder encodeObject:_flyerDescription forKey:kOffersFlyerDescription];
}


@end
