//
//  ShoppingList.m
//
//  Created by C205  on 14/10/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "ShoppingList.h"
#import "Productdetail.h"


NSString *const kShoppingListProductId = @"product_id";
NSString *const kShoppingListId = @"id";
NSString *const kShoppingListIsBought = @"is_bought";
NSString *const kShoppingListCreated = @"created";
NSString *const kShoppingListUserId = @"user_id";
NSString *const kShoppingListModified = @"modified";
NSString *const kShoppingListIsDeleted = @"is_deleted";
NSString *const kShoppingListProductdetail = @"productdetail";


@interface ShoppingList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ShoppingList

@synthesize productId = _productId;
@synthesize shoppingListIdentifier = _shoppingListIdentifier;
@synthesize isBought = _isBought;
@synthesize created = _created;
@synthesize userId = _userId;
@synthesize modified = _modified;
@synthesize isDeleted = _isDeleted;
@synthesize productdetail = _productdetail;


+ (ShoppingList *)modelObjectWithDictionary:(NSDictionary *)dict
{
    ShoppingList *instance = [[ShoppingList alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.productId = [self objectOrNilForKey:kShoppingListProductId fromDictionary:dict];
            self.shoppingListIdentifier = [self objectOrNilForKey:kShoppingListId fromDictionary:dict];
            self.isBought = [self objectOrNilForKey:kShoppingListIsBought fromDictionary:dict];
            self.created = [self objectOrNilForKey:kShoppingListCreated fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kShoppingListUserId fromDictionary:dict];
            self.modified = [self objectOrNilForKey:kShoppingListModified fromDictionary:dict];
            self.isDeleted = [self objectOrNilForKey:kShoppingListIsDeleted fromDictionary:dict];
    NSObject *receivedProductdetail = [dict objectForKey:kShoppingListProductdetail];
    NSMutableArray *parsedProductdetail = [NSMutableArray array];
    if ([receivedProductdetail isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedProductdetail) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedProductdetail addObject:[Productdetail modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedProductdetail isKindOfClass:[NSDictionary class]]) {
       [parsedProductdetail addObject:[Productdetail modelObjectWithDictionary:(NSDictionary *)receivedProductdetail]];
    }

    self.productdetail = [NSArray arrayWithArray:parsedProductdetail];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.productId forKey:kShoppingListProductId];
    [mutableDict setValue:self.shoppingListIdentifier forKey:kShoppingListId];
    [mutableDict setValue:self.isBought forKey:kShoppingListIsBought];
    [mutableDict setValue:self.created forKey:kShoppingListCreated];
    [mutableDict setValue:self.userId forKey:kShoppingListUserId];
    [mutableDict setValue:self.modified forKey:kShoppingListModified];
    [mutableDict setValue:self.isDeleted forKey:kShoppingListIsDeleted];
NSMutableArray *tempArrayForProductdetail = [NSMutableArray array];
    for (NSObject *subArrayObject in self.productdetail) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForProductdetail addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForProductdetail addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForProductdetail] forKey:@"kShoppingListProductdetail"];

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

    self.productId = [aDecoder decodeObjectForKey:kShoppingListProductId];
    self.shoppingListIdentifier = [aDecoder decodeObjectForKey:kShoppingListId];
    self.isBought = [aDecoder decodeObjectForKey:kShoppingListIsBought];
    self.created = [aDecoder decodeObjectForKey:kShoppingListCreated];
    self.userId = [aDecoder decodeObjectForKey:kShoppingListUserId];
    self.modified = [aDecoder decodeObjectForKey:kShoppingListModified];
    self.isDeleted = [aDecoder decodeObjectForKey:kShoppingListIsDeleted];
    self.productdetail = [aDecoder decodeObjectForKey:kShoppingListProductdetail];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_productId forKey:kShoppingListProductId];
    [aCoder encodeObject:_shoppingListIdentifier forKey:kShoppingListId];
    [aCoder encodeObject:_isBought forKey:kShoppingListIsBought];
    [aCoder encodeObject:_created forKey:kShoppingListCreated];
    [aCoder encodeObject:_userId forKey:kShoppingListUserId];
    [aCoder encodeObject:_modified forKey:kShoppingListModified];
    [aCoder encodeObject:_isDeleted forKey:kShoppingListIsDeleted];
    [aCoder encodeObject:_productdetail forKey:kShoppingListProductdetail];
}


@end
