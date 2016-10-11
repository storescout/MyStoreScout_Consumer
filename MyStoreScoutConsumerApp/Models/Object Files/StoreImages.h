//
//  StoreImages.h
//
//  Created by C205  on 11/10/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface StoreImages : NSObject <NSCoding>

@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *storeImagesIdentifier;
@property (nonatomic, strong) NSString *retailUserId;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSString *modified;

+ (StoreImages *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
