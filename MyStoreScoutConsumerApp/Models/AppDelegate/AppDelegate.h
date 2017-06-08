//
//  AppDelegate.h
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 04/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MMDrawerController *drawerController;

@property (strong, nonatomic) UIImage *imgUserProfile;

@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)setRootViewControllerForUserLoggedIn:(BOOL)isLoggedin;

@end

