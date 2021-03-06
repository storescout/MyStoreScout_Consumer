//
//  RegisterVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 06/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()
{
    BOOL isImageSet;
    UIImagePickerController *imagePickerController;
    NSString *strBase64;
}
@end

@implementation RegisterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    strBase64 = @"";
    
    [self setLayout];
    [self integrateNextButtonToolBar];
    [self tapGestureInitialize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Setting Layout

- (void)setLayout
{
    if (SCREEN_HEIGHT > 568)
    {
        _txtUsername.font = THEME_FONT(18);
        _txtEmailAddress.font = THEME_FONT(18);
        _txtMobileNumber.font = THEME_FONT(18);
        _txtPassword.font = THEME_FONT(18);
        _btnSignUp.titleLabel.font = THEME_FONT(19);
    }
    
    [[BaseVC sharedInstance] addBottomLineToTextFields:@[_txtUsername, _txtEmailAddress, _txtMobileNumber, _txtPassword]];
    
    [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtUsername
                                             withPlaceHolder:@"User Name"];
    [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtEmailAddress
                                             withPlaceHolder:@"Email ID"];
    [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtMobileNumber
                                             withPlaceHolder:@"Mobile Number"];
    [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtPassword
                                             withPlaceHolder:@"Password"];
    
    _imgProfilePicture.layer.cornerRadius = 10.0f;
    _imgProfilePicture.clipsToBounds = YES;
}

- (void)integrateNextButtonToolBar
{
    UIToolbar *nextButtonToolBar = [[UIToolbar alloc] init];
    [nextButtonToolBar sizeToFit];
    
    UIBarButtonItem *btnFlexBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil];
    
    UIBarButtonItem *btnNext = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(nextClicked)];
    
    [btnNext setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]
                          forState:UIControlStateNormal];
    
    [nextButtonToolBar setItems:[NSArray arrayWithObjects:btnFlexBar, btnNext, nil]];
    _txtMobileNumber.inputAccessoryView = nextButtonToolBar;
}

- (void)nextClicked
{
    [_txtPassword becomeFirstResponder];
}

#pragma mark - Gesture Handling Methods

- (void)tapGestureInitialize
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [_imgProfilePicture addGestureRecognizer:tapGesture];
}

- (void)tapGesture:(id)sender
{
    BOOL isDefaultImage = isImageSet ? NO : YES;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select your option"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:isDefaultImage ? nil : @"Remove Photo"
                                                    otherButtonTitles:@"Take Photo", @"Choose from Gallery", nil];
    actionSheet.tag = isDefaultImage ?  0 : 1;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ((buttonIndex == 0 && actionSheet.tag == 0) || (buttonIndex == 1 && actionSheet.tag == 1))
    {
        [self.view endEditing:YES];
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePickerController= [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NULL
                                                            message:@"Camera is not available"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        }
    }
    else if ((buttonIndex == 1 && actionSheet.tag == 0) || (buttonIndex == 2 && actionSheet.tag == 1))
    {
        [self.view endEditing:YES];
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if(buttonIndex == 0)
    {
        isImageSet = NO;
        [UIView transitionWithView:_imgProfilePicture
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [_imgProfilePicture setImage:DEFAULT_PROFILE_IMAGE];
                        } completion:nil];

    }
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)dict
{
    isImageSet = YES;
    
    if ([dict objectForKey:UIImagePickerControllerOriginalImage])
    {
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *compressedImage = [[BaseVC sharedInstance] compressImage:image];
        UIImage *finalImage = [[BaseVC sharedInstance] fixOrientation:compressedImage];
        [picker dismissViewControllerAnimated:YES
                                   completion:^{
                                       [UIView transitionWithView:_imgProfilePicture
                                                         duration:0.4
                                                          options:UIViewAnimationOptionTransitionFlipFromLeft
                                                       animations:^{
                                                           _imgProfilePicture.image = finalImage;
                                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^
                                                                          {
                                                                              strBase64 = [[BaseVC sharedInstance] encodeToBase64String:_imgProfilePicture.image];
                                                                          });
                                                       } completion:nil];
                                   }];
    }
    else if ([dict objectForKey:UIImagePickerControllerEditedImage])
    {
        UIImage *image = [dict objectForKey:UIImagePickerControllerEditedImage];
        UIImage *compressedImage = [[BaseVC sharedInstance] compressImage:image];
        UIImage *finalImage = [[BaseVC sharedInstance] fixOrientation:compressedImage];
        [picker dismissViewControllerAnimated:YES
                                   completion:^{
                                       [UIView transitionWithView:_imgProfilePicture
                                                         duration:0.4
                                                          options:UIViewAnimationOptionTransitionFlipFromLeft
                                                       animations:^{
                                                           _imgProfilePicture.image = finalImage;
                                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^
                                                                          {
                                                                              strBase64 = [[BaseVC sharedInstance] encodeToBase64String:_imgProfilePicture.image];
                                                                          });
                                                       } completion:nil];
                                   }];
    }
    
//    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtUsername)
    {
        [_txtEmailAddress becomeFirstResponder];
    }
    else if (textField == _txtEmailAddress)
    {
        [_txtMobileNumber becomeFirstResponder];
    }
    else if (textField == _txtMobileNumber)
    {
        [_txtPassword becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Button Click Events

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSignUpClicked:(id)sender
{
    [self.view endEditing:YES];
    
    if ([_txtUsername.text isValid] && [_txtEmailAddress.text isValid] && [_txtMobileNumber.text isValid] && [_txtPassword.text isValid])
    {
        
        NSRange whiteSpaceRange = [_txtUsername.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        if (whiteSpaceRange.location != NSNotFound) {
            [AZNotification showNotificationWithTitle:@"Please enter username without whitespace"
                                           controller:self
                                     notificationType:AZNotificationTypeError];
            return;
        }
        
        if ([_txtEmailAddress.text isValidEmail])
        {
            if (_txtMobileNumber.text.length > 6 && _txtMobileNumber.text.length < 16)
            {
                if ([_txtPassword.text isValidPassword])
                {
                    if([[NetworkAvailability instance] isReachable])
                    {
                        NSString *strDeviceToken = [DefaultsValues getStringValueFromUserDefaults_ForKey:KEY_DEVICE_TOKEN];
                        NSString *strDeviceUDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                        
                        [SVProgressHUD showWithStatus:RegistrationMsg];
                        [self.view setUserInteractionEnabled:NO];
                        [[WebServiceConnector alloc]init:URL_Registration
                                          withParameters:@{
                                                           @"firstname":_txtUsername.text,
                                                           @"lastname":_txtUsername.text,
                                                           @"username":_txtUsername.text,
                                                           @"role_id":role_id,
                                                           @"password":_txtPassword.text,
                                                           @"email_id":_txtEmailAddress.text,
                                                           @"phone_no":_txtMobileNumber.text,
                                                           @"profile_image":isImageSet ? strBase64 : @"",
                                                           @"device_token":strDeviceToken.length > 0 ? strDeviceToken : @"",
                                                           @"device_udid":strDeviceUDID,
                                                           @"device_make":@"iOS",
                                                           @"is_testdata":isTestData
                                                           }
                                              withObject:self
                                            withSelector:@selector(DisplayResults:)
                                          forServiceType:@"JSON"
                                          showDisplayMsg:RegistrationMsg];
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
                    [[BaseVC sharedInstance] addAlertBoxWithText:@"Please provide valid password.\nUse minimum 8 and maximum 16 characters with at least 1 Alphabet, 1 Number and 1 Special Character."
                                                            toVC:self];
                    return;
                }
            }
            else
            {
                [AZNotification showNotificationWithTitle:@"Phone number should be at least 7-15 digits"
                                               controller:self
                                         notificationType:AZNotificationTypeError];
                return;
            }
        }
        else
        {
            [AZNotification showNotificationWithTitle:@"Please enter valid email address"
                                           controller:self
                                     notificationType:AZNotificationTypeError];
            return;
        }
    }
    else
    {
        //[_txtUsername.text isValid] && [_txtEmailAddress.text isValid] && [_txtMobileNumber.text isValid] && [_txtPassword.text isValid]
        if (![_txtUsername.text isValid]) {
            [AZNotification showNotificationWithTitle:@"Please enter username"
                                           controller:self
                                     notificationType:AZNotificationTypeError];
            return;
        }
        
        if (![_txtEmailAddress.text isValid]) {
            [AZNotification showNotificationWithTitle:@"Please enter email id"
                                           controller:self
                                     notificationType:AZNotificationTypeError];
            return;
        }
        
        if (![_txtMobileNumber.text isValid]) {
            [AZNotification showNotificationWithTitle:@"Please enter mobile number"
                                           controller:self
                                     notificationType:AZNotificationTypeError];
            return;
        }
        
        if (![_txtPassword.text isValid]) {
            [AZNotification showNotificationWithTitle:@"Please enter password"
                                           controller:self
                                     notificationType:AZNotificationTypeError];
            return;
        }
        
    }
}

- (void)DisplayResults:(id)sender
{
    [self.view setUserInteractionEnabled:YES];
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
            [AZNotification showNotificationWithTitle:[[sender responseDict] valueForKey:@"message"] controller:self notificationType:AZNotificationTypeError];
        }
    }
}

@end
