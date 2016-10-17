//
//  ViewController.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 04/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "ViewController.h"
#import "NearByStoresVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
       [self setLayout];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _txtusername.text = NULL;
    _txtPassword.text = NULL;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Setting Layout

- (void)setLayout
{
    [[BaseVC sharedInstance] addLeftPaddingForTextFields:@[_txtusername, _txtPassword]];
    
    [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtusername
                                             withPlaceHolder:@"Username"];
    
    [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtPassword
                                             withPlaceHolder:@"Password"];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    textField == _txtusername ? [_txtPassword becomeFirstResponder] : [textField resignFirstResponder];
    return YES;
}

- (void)textFieldTextDidChanged:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    UIAlertAction *btnReset = alertController.actions.firstObject;
    
    if (alertController)
    {
        btnReset.enabled = [sender.text isValid] ? [sender.text isValidEmail] ? YES : NO : NO;
    }
}

#pragma mark - Button Click Events

- (IBAction)btnLoginClicked:(id)sender
{
    [self.view endEditing:YES];
    
    if ([_txtusername.text isValid] && [_txtPassword.text isValid])
    {
        if([[NetworkAvailability instance] isReachable])
        {
            NSString *strDeviceToken = [DefaultsValues getStringValueFromUserDefaults_ForKey:KEY_DEVICE_TOKEN];
            
            [SVProgressHUD showWithStatus:LoginMsg];
            
            [[WebServiceConnector alloc]init:URL_Login
                              withParameters:@{
                                               @"username":_txtusername.text,
                                               @"password":_txtPassword.text,
                                               @"role_id":@"1",
                                               @"is_testdata":@"1",
                                               @"device_token":strDeviceToken.length > 0 ? strDeviceToken : @"",
                                               }
                                  withObject:self
                                withSelector:@selector(DisplayResults:)
                              forServiceType:@"JSON"
                              showDisplayMsg:LoginMsg];
        }
        else
        {
            [AZNotification showNotificationWithTitle:NETWORK_ERR
                                           controller:self
                                     notificationType:AZNotificationTypeError];
        }
    }
    else
    {
        [AZNotification showNotificationWithTitle:@"Please fill all mandatory fields"
                                       controller:self
                                 notificationType:AZNotificationTypeError];
    }
}

- (void)DisplayResults:(id)sender
{
    [SVProgressHUD dismiss];
    
    if ([sender responseCode] != 100)
    {
        [AZNotification showNotificationWithTitle:[sender responseError]
                                       controller:self
                                 notificationType:AZNotificationTypeError];
    }
    else
    {
        if (STATUS([[sender responseDict] valueForKey:@"status"]))
        {
            User *objUser = [[sender responseArray] objectAtIndex:0];
            [DefaultsValues setIntegerValueToUserDefaults:objUser.userIdentifier ForKey:KEY_USER_ID];
            [DefaultsValues setCustomObjToUserDefaults:objUser ForKey:KEY_USER];
            [self.navigationController pushViewController:STORYBOARD_ID(@"idStoresVC") animated:YES];
        }
        else
        {
            [AZNotification showNotificationWithTitle:[[sender responseDict] valueForKey:@"message"]
                                           controller:self
                                     notificationType:AZNotificationTypeError];
        }
    }
}

- (IBAction)btnForgotPasswordClicked:(id)sender
{
    [self.view endEditing:YES];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                             message:@"Please enter your email address to reset your password"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        [textField addTarget:self
                      action:@selector(textFieldTextDidChanged:)
            forControlEvents:UIControlEventEditingChanged];

        [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:textField
                                                 withPlaceHolder:@"Enter your email address here"];

        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.tintColor = rgb(85, 85, 85, 1.0);
    }];
    
    UIAlertAction *btnReset = [UIAlertAction actionWithTitle:@"RESET"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
    {
        dispatch_async(dispatch_get_main_queue(),^
        {
            [self.view endEditing:YES];
        });
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^
        {
            NSString *strEmail = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
            [self resetPasswordForEmailID:strEmail];
        });
    }];
    
    UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){}];
    btnReset.enabled = NO;
    [alertController addAction:btnReset];
    [alertController addAction:btnCancel];
    
    dispatch_async(dispatch_get_main_queue(),^
    {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)resetPasswordForEmailID:(NSString *)strEmail
{
    dispatch_async(dispatch_get_main_queue(),^
    {
       if([[NetworkAvailability instance] isReachable])
       {
           [SVProgressHUD showWithStatus:ForgotPasswordMsg];
           
           [[WebServiceConnector alloc]init:URL_ForgotPassword
                             withParameters:@{
                                              @"email_id":strEmail,
                                              @"role_id":@"1",
                                              @"is_testdata":@"1"
                                              }
                                 withObject:self
                               withSelector:@selector(DisplayMessage:)
                             forServiceType:@"JSON"
                             showDisplayMsg:ForgotPasswordMsg];
       }
       else
       {
           [AZNotification showNotificationWithTitle:NETWORK_ERR
                                          controller:self
                                    notificationType:AZNotificationTypeError];
       }
    });
}

- (void)DisplayMessage:(id)sender
{
    [SVProgressHUD dismiss];
    if ([sender responseCode] != 100)
    {
        [AZNotification showNotificationWithTitle:[sender responseError]
                                       controller:self
                                 notificationType:AZNotificationTypeError];
    }
    else
    {
        BOOL isSucceed = STATUS([[sender responseDict] valueForKey:@"status"]);
        
        [AZNotification showNotificationWithTitle:[[sender responseDict] valueForKey:@"message"]
                                       controller:self
                                 notificationType:isSucceed ? AZNotificationTypeSuccess : AZNotificationTypeError];
    }
}

- (IBAction)btnSignUpClicked:(id)sender
{
    [self.view endEditing:YES];

    [self.navigationController pushViewController:STORYBOARD_ID(@"idRegisterVC") animated:YES];
}

@end
