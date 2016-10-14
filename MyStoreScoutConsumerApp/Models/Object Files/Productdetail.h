//
//  Productdetail.h
//
//  Created by C205  on 14/10/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Productdetail : NSObject <NSCoding>

@property (nonatomic, strong) NSString *productdetailIdentifier;
@property (nonatomic, strong) NSString *retailUserId;
@property (nonatomic, strong) NSString *rackId;
@property (nonatomic, strong) NSString *blockId;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *isDeleted;
@property (nonatomic, strong) NSString *modified;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *productName;

+ (Productdetail *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
