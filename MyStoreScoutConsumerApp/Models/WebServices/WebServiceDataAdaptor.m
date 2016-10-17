//
//  WebHelper.m
//  SQLExample
//
//  Created by iMac on 17/03/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//
//[[FamousFoodWS alloc]initWithDictionary:allvalues];
//[[classname alloc]initWithDictionary:allvalues];
//[[[NSClassFromString(classname) alloc] init] initWithDictionary:allvalues]

#import "WebServiceDataAdaptor.h"
#import "Constants.h"

#import <objc/runtime.h>
#import "NSString+Extensions.h"

@implementation WebServiceDataAdaptor

@synthesize arrParsedData;

-(NSArray *)autoParse:(NSDictionary *) allValues forServiceName:(NSString *)requestURL
{
    arrParsedData = [NSArray new];
    if (isService(URL_Login))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:LoginClass
                                    forEntity:LoginEntity
                                  withJSONKey:LoginKey];
    }
    else if (isService(URL_ForgotPassword))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:ForgotPasswordClass
                                    forEntity:ForgotPasswordEntity
                                  withJSONKey:ForgotPasswordKey];
    }
    else if (isService(URL_Registration))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:RegistrationClass
                                    forEntity:RegistrationEntity
                                  withJSONKey:RegistrationKey];
    }
    else if (isService(URL_GetAllStores))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:GetAllStoresClass
                                    forEntity:GetAllStoresEntity
                                  withJSONKey:GetAllStoresKey];
    }
    else if (isService(URL_AddStore))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:AddStoreClass
                                    forEntity:AddStoreEntity
                                  withJSONKey:AddStoreKey];
    }
    else if (isService(URL_SaveElements))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:SaveElementsClass
                                    forEntity:SaveElementsEntity
                                  withJSONKey:SaveElementsKey];
    }
    else if (isService(URL_GetAllProducts))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:GetAllProductsClass
                                    forEntity:GetAllProductsEntity
                                  withJSONKey:GetAllProductsKey];
    }
    else if (isService(URL_EditProfile))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:EditProfileClass
                                    forEntity:EditProfileEntity
                                  withJSONKey:EditProfileKey];
    }
    else if (isService(URL_GetSearchResultsForText))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:SearchProductsClass
                                    forEntity:SearchProductsEntity
                                  withJSONKey:SearchProductsKey];
    }
    else if (isService(URL_GetShoppingList))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:GetShoppingListClass
                                    forEntity:GetShoppingListEntity
                                  withJSONKey:GetShoppingListKey];
    }
    else if (isService(URL_AddProductInShoppingList))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:AddProductInShoppingListClass
                                    forEntity:AddProductInShoppingListEntity
                                  withJSONKey:AddProductInShoppingListKey];
    }
    else if (isService(URL_CheckShoppingListProductAsBought))
    {
        arrParsedData = [self processJSONData:allValues
                                     forClass:CheckShoppingListProductAsBoughtClass
                                    forEntity:CheckShoppingListProductAsBoughtEntity
                                  withJSONKey:CheckShoppingListProductAsBoughtKey];
    }

    return arrParsedData;
}

-(NSArray *) processJSONData: (NSDictionary *)dict forClass:(NSString *)classname forEntity:(NSString *)entityname withJSONKey:(NSString *)json_Key
{
    
    if ([[dict objectForKey:json_Key] objectForKey:classname] != (id)[NSNull null])
    {
        NSMutableArray *arrProcessedData = [NSMutableArray array];
        //[CoreDataAdaptor deleteDataInCoreDB:entityname];
        for(int i =0;i<[[[dict objectForKey:json_Key] objectForKey:classname] count];i++)
        {
            NSMutableDictionary *allvalues = [[[[dict objectForKey:json_Key] objectForKey:classname] objectAtIndex:i] mutableCopy];
            id objClass = [[[NSClassFromString(classname) alloc] init] initWithDictionary:allvalues];
            [arrProcessedData addObject:objClass];
            
        }
        return arrProcessedData;
    }
    return nil;
}

-(NSDictionary *)processObjectForCoreData:(id)obj
{
    NSArray *aVoidArray =@[@"NSDate"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    for (int i = 0; i < count; i++)
    {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if (![aVoidArray containsObject: key] )
        {
            if ([obj valueForKey:key]!=nil)
            {
                [dict setObject:[obj valueForKey:key] forKey:key];
            }
        }
    }
    return dict;
}

@end
