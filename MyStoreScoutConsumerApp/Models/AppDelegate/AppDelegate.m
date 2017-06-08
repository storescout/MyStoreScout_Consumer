//
//  AppDelegate.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 04/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "AppDelegate.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if(!error)
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];
             }
         }];
    }
    else if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"8.0"))
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
//    else
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setRootViewControllerForUserLoggedIn:[DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID] == 0 ? NO : YES];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    [DefaultsValues setStringValueToUserDefaults:token ForKey:KEY_DEVICE_TOKEN];
}

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center
      willPresentNotification:(UNNotification *)notification
        withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {}
    else
    {
//        NSString *stringNotificationType = [NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"NotificationType"]];
//        self.stringUUIDOfNotification = [NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"beaconUUID"]];
//        self.stringMajor = [NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"beaconMajor"]];
//        self.stringMinor = [NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"beaconMinor"]];
        //NSLog(@"uuid = %@",self.stringUUIDOfNotification);
        
//        if ([stringNotificationType isEqualToString:@"Enter"])
//        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
//        }
//        else if ([stringNotificationType isEqualToString:@"Near"])
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
//        }
//        else if ([stringNotificationType isEqualToString:@"Exit"])
//        {
//            //[[NSNotificationCenter defaultCenter] postNotificationName:OpenBeaconsDetail object:nil];
//        }
    }
    
    
    /*
     if ([notification.alertBody containsString:@"exit"])
     {}
     else
     {
     //UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"beaconUUID"]] message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     //[alert1 show];
     
     //send notification and open beacons screen
     self.stringUUIDOfNotification = [NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"beaconUUID"]];
     
     [[NSNotificationCenter defaultCenter] postNotificationName:OpenBeaconsDetail object:nil];
     }
     
     //app state
     UIApplicationState state = [application applicationState];
     if (state == UIApplicationStateActive)
     {
     //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"yyyy" message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     //[alert show];
     
     //Generate custom notification and on its click manage further process
     
     }
     */
    
}


- (void)setRootViewControllerForUserLoggedIn:(BOOL)isLoggedin
{
//    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier: isLoggedin ? @"idStoreVC" : @"ViewController"];
//    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
//    navController.navigationBar.hidden = YES;
//    
//    if ([navController respondsToSelector:@selector(interactivePopGestureRecognizer)])
//    {
//        navController.interactivePopGestureRecognizer.enabled = NO;
//    }
//    
//    self.window.rootViewController = navController;
    
    [DefaultsValues setIntegerValueToUserDefaults:0 ForKey:KEY_SELECTED_MENU];
    
    UIViewController *leftMenuVC = [[UIStoryboard storyboardWithName:[NSString stringWithFormat:@"Main"] bundle:NULL] instantiateViewControllerWithIdentifier:@"idMenuVC"];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:[NSString stringWithFormat:@"Main"] bundle:NULL] instantiateViewControllerWithIdentifier: isLoggedin ? @"idStoresVC" : @"ViewController"]];
    
    navigationController.navigationBar.hidden = YES;
    
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    _drawerController= [[MMDrawerController alloc] initWithCenterViewController:navigationController
                                                      leftDrawerViewController:leftMenuVC];
    [self.drawerController setMaximumLeftDrawerWidth: SCREEN_WIDTH * 0.75];
    [self.drawerController setShowsShadow:NO];
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.window setRootViewController:_drawerController];
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if(state == CLRegionStateInside)
    {
        notification.alertBody = [NSString stringWithFormat:@"You are inside region %@", region.identifier];
    }
    else if(state == CLRegionStateOutside)
    {
        notification.alertBody = [NSString stringWithFormat:@"You are outside region %@", region.identifier];
    }
    else
    {
        return;
    }
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    UILocalNotification *ln = [[UILocalNotification alloc] init];
//    ln.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//    ln.alertTitle = @"hjfdbv";
//    ln.alertBody = @"mncbds csdchjsd c";
//    ln.timeZone = [NSTimeZone defaultTimeZone];
//    [[UIApplication sharedApplication] scheduleLocalNotification:ln];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
