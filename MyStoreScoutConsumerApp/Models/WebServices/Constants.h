//
//  constants.h
//  acloud
//
//  Created by iMac on 15/06/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NetworkAvailability.h"

@interface Constants : NSObject
{
    
}

/* ============================================================================ */
#pragma mark - Web Service Requests
#define Server_URL    "http://54.70.249.239/MyStoreScoutWS/MobileAppService.php?Service="

#define Image_Path "http://54.70.249.239/img/"

#define SERVER "http://54.70.249.239/"


#define URL_Login [NSString stringWithFormat:@"%sLogin",Server_URL]

#define URL_ForgotPassword [NSString stringWithFormat:@"%sForgotPassword",Server_URL]

#define URL_Registration [NSString stringWithFormat:@"%sRegister",Server_URL]

#define URL_GetAllStores [NSString stringWithFormat:@"%sGetAllStores",Server_URL]

#define URL_AddStore [NSString stringWithFormat:@"%sAddStore",Server_URL]

#define URL_SaveElements [NSString stringWithFormat:@"%sSaveElements",Server_URL]

/* ============================================================================ */
#pragma mark - Class,Json Key and Message

#define WebserviceDialogMsg @"Processing"

#define LoginClass @"User"
#define LoginEntity @""
#define LoginKey @"data"
#define LoginMsg [NSString stringWithFormat:@"%@ Your Login",WebserviceDialogMsg]

#define ForgotPasswordClass @""
#define ForgotPasswordEntity @""
#define ForgotPasswordKey @""
#define ForgotPasswordMsg [NSString stringWithFormat:@"%@ for Password",WebserviceDialogMsg]

#define RegistrationClass @"User"
#define RegistrationEntity @""
#define RegistrationKey @"data"
#define RegistrationMsg [NSString stringWithFormat:@"%@ for Registration",WebserviceDialogMsg]

#define GetAllStoresClass @"Store"
#define GetAllStoresEntity @""
#define GetAllStoresKey @"data"
#define GetAllStoresMsg [NSString stringWithFormat:@"Loading Stores"]

#define AddStoreClass @"Store"
#define AddStoreEntity @""
#define AddStoreKey @"data"
#define AddStoreMsg [NSString stringWithFormat:@"Generating Store"]

#define SaveElementsClass @""
#define SaveElementsEntity @""
#define SaveElementsKey @""
#define SaveElementsMsg [NSString stringWithFormat:@"Saving"]

#define WSRegisterKeyMessage @"message"
#define WSRegisterKeyStatus @"status"


/* ============================================================================ */
#pragma mark - General Constants
#define APP_DELEGATE  (AppDelegate*)[[UIApplication sharedApplication] delegate]

#define isService( key ) \
[requestURL isEqualToString: key ]

#define ARRAY(key, ...) [NSMutableArray arrayWithObjects:key,##__VA_ARGS__]

#define ShowNetworkIndicator(XXX) [UIApplication sharedApplication].networkActivityIndicatorVisible = XXX;

#define CurrentTimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

@end
