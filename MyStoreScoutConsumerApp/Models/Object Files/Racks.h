//
//  Racks.h
//
//  Created by   on 21/11/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Racks : NSObject <NSCoding>

@property (nonatomic, strong) NSString *racksIdentifier;
@property (nonatomic, strong) NSString *isDeleted;
@property (nonatomic, strong) NSString *modified;
@property (nonatomic, strong) NSString *angle;
@property (nonatomic, strong) NSString *positionY;
@property (nonatomic, strong) NSString *rackHeight;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *rackWidth;
@property (nonatomic, strong) NSString *isTestdata;
@property (nonatomic, strong) NSString *retailUserId;
@property (nonatomic, strong) NSString *positionX;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *rackType;
@property (nonatomic, strong) NSString *storeText;

+ (Racks *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
