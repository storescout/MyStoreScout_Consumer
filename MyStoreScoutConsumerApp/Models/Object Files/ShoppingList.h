//
//  ShoppingList.h
//
//  Created by C205  on 14/10/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ShoppingList : NSObject <NSCoding>

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *shoppingListIdentifier;
@property (nonatomic, strong) NSString *isBought;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *modified;
@property (nonatomic, strong) NSString *isDeleted;
@property (nonatomic, strong) NSArray *productdetail;

+ (ShoppingList *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
