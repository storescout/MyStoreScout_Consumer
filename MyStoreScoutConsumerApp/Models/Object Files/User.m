//
//  User.m
//
//  Created by C205  on 29/09/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "User.h"


NSString *const kUserId = @"id";
NSString *const kUserEmail = @"email";
NSString *const kUserModified = @"modified";
NSString *const kUserContactNo = @"contact_no";
NSString *const kUserDeviceUdid = @"device_udid";
NSString *const kUserImageUrl = @"image_url";
NSString *const kUserDeviceMake = @"device_make";
NSString *const kUserProfilePic = @"profile_pic";
NSString *const kUserForgetPassword = @"forget_password";
NSString *const kUserPassword = @"password";
NSString *const kUserUserName = @"user_name";
NSString *const kUserFirstName = @"first_name";
NSString *const kUserDeviceToken = @"device_token";
NSString *const kUserCreated = @"created";
NSString *const kUserIsTestdata = @"is_testdata";
NSString *const kUserIsDeleted = @"is_deleted";
NSString *const kUserLastName = @"last_name";
NSString *const kUserRoleId = @"role_id";
NSString *const kUserVerifyStr = @"verify_str";


@interface User ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation User

@synthesize userIdentifier = _userIdentifier;
@synthesize email = _email;
@synthesize modified = _modified;
@synthesize contactNo = _contactNo;
@synthesize deviceUdid = _deviceUdid;
@synthesize imageUrl = _imageUrl;
@synthesize deviceMake = _deviceMake;
@synthesize profilePic = _profilePic;
@synthesize forgetPassword = _forgetPassword;
@synthesize password = _password;
@synthesize userName = _userName;
@synthesize firstName = _firstName;
@synthesize deviceToken = _deviceToken;
@synthesize created = _created;
@synthesize isTestdata = _isTestdata;
@synthesize isDeleted = _isDeleted;
@synthesize lastName = _lastName;
@synthesize roleId = _roleId;
@synthesize verifyStr = _verifyStr;


+ (User *)modelObjectWithDictionary:(NSDictionary *)dict
{
    User *instance = [[User alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.userIdentifier = [[self objectOrNilForKey:kUserId fromDictionary:dict] doubleValue];
            self.email = [self objectOrNilForKey:kUserEmail fromDictionary:dict];
            self.modified = [self objectOrNilForKey:kUserModified fromDictionary:dict];
            self.contactNo = [self objectOrNilForKey:kUserContactNo fromDictionary:dict];
            self.deviceUdid = [self objectOrNilForKey:kUserDeviceUdid fromDictionary:dict];
            self.imageUrl = [self objectOrNilForKey:kUserImageUrl fromDictionary:dict];
            self.deviceMake = [[self objectOrNilForKey:kUserDeviceMake fromDictionary:dict] doubleValue];
            self.profilePic = [self objectOrNilForKey:kUserProfilePic fromDictionary:dict];
            self.forgetPassword = [self objectOrNilForKey:kUserForgetPassword fromDictionary:dict];
            self.password = [self objectOrNilForKey:kUserPassword fromDictionary:dict];
            self.userName = [self objectOrNilForKey:kUserUserName fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:kUserFirstName fromDictionary:dict];
            self.deviceToken = [self objectOrNilForKey:kUserDeviceToken fromDictionary:dict];
            self.created = [self objectOrNilForKey:kUserCreated fromDictionary:dict];
            self.isTestdata = [[self objectOrNilForKey:kUserIsTestdata fromDictionary:dict] doubleValue];
            self.isDeleted = [[self objectOrNilForKey:kUserIsDeleted fromDictionary:dict] doubleValue];
            self.lastName = [self objectOrNilForKey:kUserLastName fromDictionary:dict];
            self.roleId = [[self objectOrNilForKey:kUserRoleId fromDictionary:dict] doubleValue];
            self.verifyStr = [self objectOrNilForKey:kUserVerifyStr fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userIdentifier] forKey:kUserId];
    [mutableDict setValue:self.email forKey:kUserEmail];
    [mutableDict setValue:self.modified forKey:kUserModified];
    [mutableDict setValue:self.contactNo forKey:kUserContactNo];
    [mutableDict setValue:self.deviceUdid forKey:kUserDeviceUdid];
    [mutableDict setValue:self.imageUrl forKey:kUserImageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.deviceMake] forKey:kUserDeviceMake];
    [mutableDict setValue:self.profilePic forKey:kUserProfilePic];
    [mutableDict setValue:self.forgetPassword forKey:kUserForgetPassword];
    [mutableDict setValue:self.password forKey:kUserPassword];
    [mutableDict setValue:self.userName forKey:kUserUserName];
    [mutableDict setValue:self.firstName forKey:kUserFirstName];
    [mutableDict setValue:self.deviceToken forKey:kUserDeviceToken];
    [mutableDict setValue:self.created forKey:kUserCreated];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isTestdata] forKey:kUserIsTestdata];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isDeleted] forKey:kUserIsDeleted];
    [mutableDict setValue:self.lastName forKey:kUserLastName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.roleId] forKey:kUserRoleId];
    [mutableDict setValue:self.verifyStr forKey:kUserVerifyStr];

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

    self.userIdentifier = [aDecoder decodeDoubleForKey:kUserId];
    self.email = [aDecoder decodeObjectForKey:kUserEmail];
    self.modified = [aDecoder decodeObjectForKey:kUserModified];
    self.contactNo = [aDecoder decodeObjectForKey:kUserContactNo];
    self.deviceUdid = [aDecoder decodeObjectForKey:kUserDeviceUdid];
    self.imageUrl = [aDecoder decodeObjectForKey:kUserImageUrl];
    self.deviceMake = [aDecoder decodeDoubleForKey:kUserDeviceMake];
    self.profilePic = [aDecoder decodeObjectForKey:kUserProfilePic];
    self.forgetPassword = [aDecoder decodeObjectForKey:kUserForgetPassword];
    self.password = [aDecoder decodeObjectForKey:kUserPassword];
    self.userName = [aDecoder decodeObjectForKey:kUserUserName];
    self.firstName = [aDecoder decodeObjectForKey:kUserFirstName];
    self.deviceToken = [aDecoder decodeObjectForKey:kUserDeviceToken];
    self.created = [aDecoder decodeObjectForKey:kUserCreated];
    self.isTestdata = [aDecoder decodeDoubleForKey:kUserIsTestdata];
    self.isDeleted = [aDecoder decodeDoubleForKey:kUserIsDeleted];
    self.lastName = [aDecoder decodeObjectForKey:kUserLastName];
    self.roleId = [aDecoder decodeDoubleForKey:kUserRoleId];
    self.verifyStr = [aDecoder decodeObjectForKey:kUserVerifyStr];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_userIdentifier forKey:kUserId];
    [aCoder encodeObject:_email forKey:kUserEmail];
    [aCoder encodeObject:_modified forKey:kUserModified];
    [aCoder encodeObject:_contactNo forKey:kUserContactNo];
    [aCoder encodeObject:_deviceUdid forKey:kUserDeviceUdid];
    [aCoder encodeObject:_imageUrl forKey:kUserImageUrl];
    [aCoder encodeDouble:_deviceMake forKey:kUserDeviceMake];
    [aCoder encodeObject:_profilePic forKey:kUserProfilePic];
    [aCoder encodeObject:_forgetPassword forKey:kUserForgetPassword];
    [aCoder encodeObject:_password forKey:kUserPassword];
    [aCoder encodeObject:_userName forKey:kUserUserName];
    [aCoder encodeObject:_firstName forKey:kUserFirstName];
    [aCoder encodeObject:_deviceToken forKey:kUserDeviceToken];
    [aCoder encodeObject:_created forKey:kUserCreated];
    [aCoder encodeDouble:_isTestdata forKey:kUserIsTestdata];
    [aCoder encodeDouble:_isDeleted forKey:kUserIsDeleted];
    [aCoder encodeObject:_lastName forKey:kUserLastName];
    [aCoder encodeDouble:_roleId forKey:kUserRoleId];
    [aCoder encodeObject:_verifyStr forKey:kUserVerifyStr];
}


@end
