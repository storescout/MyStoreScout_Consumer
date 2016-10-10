//
//  NSUserDefaults+SaveCustomObject.m
//  ObjMapper
//
//  Created by Roomorama on 28/6/13.
//  Copyright (c) 2013 Roomorama. All rights reserved.
//

#import "NSUserDefaults+SaveCustomObject.h"

@implementation NSUserDefaults (SaveCustomObject)

-(void)setCustomObject:(id)obj forKey:(NSString *)key {
    if ([obj respondsToSelector:@selector(encodeWithCoder:)] == NO) {
        TRC_NRM(@"Error save object to NSUserDefaults. Object must respond to encodeWithCoder: message");
        return;
    }
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

-(id)customObjectForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return obj;
}

@end
