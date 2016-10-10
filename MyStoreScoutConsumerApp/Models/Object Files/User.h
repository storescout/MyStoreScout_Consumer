//
//  User.h
//
//  Created by C205  on 29/09/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface User : NSObject <NSCoding>

@property (nonatomic, assign) double userIdentifier;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *modified;
@property (nonatomic, strong) NSString *contactNo;
@property (nonatomic, strong) NSString *deviceUdid;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) double deviceMake;
@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSString *forgetPassword;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, assign) double isTestdata;
@property (nonatomic, assign) double isDeleted;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) double roleId;
@property (nonatomic, assign) id verifyStr;

+ (User *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
