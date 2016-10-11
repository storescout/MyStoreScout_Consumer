//
//  Store.h
//
//  Created by C205  on 11/10/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Store : NSObject <NSCoding>

@property (nonatomic, strong) NSString *storeIdentifier;
@property (nonatomic, strong) NSString *isDeleted;
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *contactNo;
@property (nonatomic, strong) NSString *modified;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *positionY;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *storeAddress;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSArray *racks;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *isTestdata;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSArray *storeImages;
@property (nonatomic, strong) NSString *retailUserId;
@property (nonatomic, strong) NSString *positionX;

+ (Store *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
