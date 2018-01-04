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
//CGLine's Constant
#define MT_EPS      1e-4
#define MT_MIN(A,B)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __a : __b; })
#define MT_MAX(A,B)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __b : __a; })
#define MT_ABS(A)	({ __typeof__(A) __a = (A); __a < 0 ? -__a : __a; })


#define Server_URL    "http://54.70.249.239/MyStoreScoutWS/MobileAppService.php?Service="

#define Image_Path "http://54.70.249.239/img/"

#define SERVER "http://54.70.249.239/"


#define URL_Login [NSString stringWithFormat:@"%sLogin",Server_URL]

#define URL_ForgotPassword [NSString stringWithFormat:@"%sForgotPassword",Server_URL]

#define URL_Registration [NSString stringWithFormat:@"%sRegister",Server_URL]

#define URL_GetAllStores [NSString stringWithFormat:@"%sGetAllStores",Server_URL]

#define URL_AddStore [NSString stringWithFormat:@"%sAddStore",Server_URL]

#define URL_SaveElements [NSString stringWithFormat:@"%sSaveElements",Server_URL]

#define URL_GetAllProducts [NSString stringWithFormat:@"%sGetAllProducts",Server_URL]

#define URL_GetSearchResultsForText [NSString stringWithFormat:@"%sGetSearchResultsForText",Server_URL]

#define URL_EditProfile [NSString stringWithFormat:@"%sEditProfile",Server_URL]

#define URL_GetShoppingList [NSString stringWithFormat:@"%sGetShoppingList",Server_URL]

#define URL_AddProductInShoppingList [NSString stringWithFormat:@"%sAddProductInShoppingList",Server_URL]

#define URL_CheckShoppingListProductAsBought [NSString stringWithFormat:@"%sCheckShoppingListProductAsBought",Server_URL]

#define URL_DeleteProductFromShoppingList [NSString stringWithFormat:@"%sDeleteProductFromShoppingList",Server_URL]

#define URL_CheckAllShoppingListProductsAsBought [NSString stringWithFormat:@"%sCheckAllShoppingListProductsAsBought",Server_URL]

#define URL_DeleteAllProductsFromShoppingList [NSString stringWithFormat:@"%sDeleteAllProductsFromShoppingList",Server_URL]

//Edited By: Anjali Jariwala
#define URL_CheckOutCount [NSString stringWithFormat:@"%sCheckoutCount",Server_URL]

#define URL_GetAllOffers [NSString stringWithFormat:@"%sgetStorewiseOffer",Server_URL]

//Updated By :

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

#define GetAllProductsClass @"Products"
#define GetAllProductsEntity @""
#define GetAllProductsKey @"data"
#define GetAllProductsMsg [NSString stringWithFormat:@"Loading Products"]

#define GetShoppingListClass @"ShoppingList"
#define GetShoppingListEntity @""
#define GetShoppingListKey @"data"
#define GetShoppingListMsg [NSString stringWithFormat:@"Loading Shopping List"]

#define CheckShoppingListProductAsBoughtClass @"ShoppingList"
#define CheckShoppingListProductAsBoughtEntity @""
#define CheckShoppingListProductAsBoughtKey @"data"
#define CheckShoppingListProductAsBoughtMsg [NSString stringWithFormat:@"Loading Shopping List"]

#define CheckAllShoppingListProductsAsBoughtClass @"ShoppingList"
#define CheckAllShoppingListProductsAsBoughtEntity @""
#define CheckAllShoppingListProductsAsBoughtKey @"data"
#define CheckAllShoppingListProductsAsBoughtMsg [NSString stringWithFormat:@"Loading Shopping List"]

#define DeleteProductFromShoppingListClass @"ShoppingList"
#define DeleteProductFromShoppingListEntity @""
#define DeleteProductFromShoppingListKey @"data"
#define DeleteProductFromShoppingListMsg [NSString stringWithFormat:@"Loading Shopping List"]

#define DeleteAllProductsFromShoppingListClass @"ShoppingList"
#define DeleteAllProductsFromShoppingListEntity @""
#define DeleteAllProductsFromShoppingListKey @"data"
#define DeleteAllProductsFromShoppingListMsg [NSString stringWithFormat:@"Loading Shopping List"]

#define SearchProductsClass @"Products"
#define SearchProductsEntity @""
#define SearchProductsKey @"data"
#define SearchProductsMsg [NSString stringWithFormat:@"Loading Products"]

#define AddProductInShoppingListClass @"ShoppingList"
#define AddProductInShoppingListEntity @""
#define AddProductInShoppingListKey @"data"
#define AddProductInShoppingListMsg [NSString stringWithFormat:@"Loading Products"]

#define AddStoreClass @"Store"
#define AddStoreEntity @""
#define AddStoreKey @"data"
#define AddStoreMsg [NSString stringWithFormat:@"Generating Store"]

#define EditProfileClass @"User"
#define EditProfileEntity @""
#define EditProfileKey @"data"
#define EditProfileMsg [NSString stringWithFormat:@"Updating Profile"]

#define SaveElementsClass @""
#define SaveElementsEntity @""
#define SaveElementsKey @""
#define SaveElementsMsg [NSString stringWithFormat:@"Saving"]

#define WSRegisterKeyMessage @"message"
#define WSRegisterKeyStatus @"status"

//Edited By: Anjali Jariwala
#define GetAllOffersClass @"Store"
#define GetAllOffersEntity @""
#define GetAllOffersKey @"data"
#define GetAllOffersMsg [NSString stringWithFormat:@"Loading Offers"]

#define isTestData @"1"
#define role_id @"0"


/* ============================================================================ */
#pragma mark - General Constants
#define APP_DELEGATE  (AppDelegate*)[[UIApplication sharedApplication] delegate]

#define isService( key ) \
[requestURL isEqualToString: key ]

#define ARRAY(key, ...) [NSMutableArray arrayWithObjects:key,##__VA_ARGS__]

#define ShowNetworkIndicator(XXX) [UIApplication sharedApplication].networkActivityIndicatorVisible = XXX;

#define CurrentTimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

@end
