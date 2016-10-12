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
    else
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setRootViewControllerForUserLoggedIn:[DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID] == 0 ? NO : YES];
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
