//
//  Data.h
//
//  Created by NC2-36  on 27/10/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Offers : NSObject <NSCoding>

@property (nonatomic, assign) id flyerFrom;
@property (nonatomic, assign) id flyerTo;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, assign) id flyerName;
@property (nonatomic, strong) NSString *flyerImg;
@property (nonatomic, strong) NSString *flyerDescription;

+ (Offers *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
