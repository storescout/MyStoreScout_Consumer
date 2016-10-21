//
//  ProfileVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "ProfileVC.h"

@interface ProfileVC ()
{
    BOOL isImageSet;
    UIImagePickerController *imagePickerController;
    NSString *strBase64;
    UIImage *tempImage;
}
@end

@implementation ProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    strBase64 = @"";
    
    tempImage = [UIImage imageNamed:@"IMG_DEFAULT_PROFILE"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.00001 * NSEC_PER_SEC), dispatch_get_main_queue(),^
    {
        _imgProfilePicture.layer.cornerRadius = _imgProfilePicture.frame.size.width / 2;
        _imgProfilePicture.clipsToBounds = YES;
        
        _vwImageContainer.layer.cornerRadius = _vwImageContainer.frame.size.width / 2;
        _vwImageContainer.clipsToBounds = YES;
        _vwImageContainer.layer.borderWidth = 2.0f;
        _vwImageContainer.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [[BaseVC sharedInstance] addBottomLineToTextFields:@[_txtUserName,
                                                             _txtEmailAddress,
                                                             _txtMobileNumber,
                                                             _txtOldPassword,
                                                             _txtNewPassword,
                                                             _txtConfirmPassword]];
        
        [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtUserName
                                                 withPlaceHolder:@"Enter User Name"];
        [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtEmailAddress
                                                 withPlaceHolder:@"Enter Email Address"];
        [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtMobileNumber
                                                 withPlaceHolder:@"Enter Mobile Number"];
        [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtOldPassword
                                                 withPlaceHolder:@"Enter Old Password"];
        [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtNewPassword
                                                 withPlaceHolder:@"Enter New Password"];
        [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtConfirmPassword
                                                 withPlaceHolder:@"Confirm Password"];
        
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _vwChangePasswordContainer.frame.origin.y + _vwChangePasswordContainer.frame.size.height);
        
        _vwOfScrollViewHeight.constant = _vwChangePasswordContainer.frame.origin.y + _vwChangePasswordContainer.frame.size.height;
        
        [self.view layoutIfNeeded];
        
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        [self.scrollView setScrollEnabled:NO];
    });
    [self tapGestureInitialize];
    [self integrateNextButtonToolBar];
    
    User *objUser = [DefaultsValues getCustomObjFromUserDefaults_ForKey:KEY_USER];

    _txtUserName.text = objUser.userName;
    _txtEmailAddress.text = objUser.email;
    _txtMobileNumber.text = objUser.contactNo;
    
    if (![objUser.profilePic isEqualToString:@"default.jpg"])
    {
        isImageSet = YES;
    }
    
    NSString *strImgPath = [NSString stringWithFormat:@"%sprofile/%@",Image_Path,objUser.profilePic];
    
    [_imgProfilePicture sd_setImageWithURL:[NSURL URLWithString:strImgPath]
                          placeholderImage:[UIImage imageNamed:@"IMG_DEFAULT_PROFILE"]];
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

- (void)tapGestureInitialize
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [_imgProfilePicture addGestureRecognizer:tapGesture];
}

- (void)tapGesture:(id)sender
{
    if(!_vwChangePasswordContainer.hidden)
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
        strBase64 = @"";
        [UIView transitionWithView:_vwImageContainer
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
        
        tempImage = finalImage;
        
        [picker dismissViewControllerAnimated:YES
                                   completion:^{
            [UIView transitionWithView:_vwImageContainer
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                _imgProfilePicture.image = finalImage;
                            } completion:nil];
        }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^
        {
            strBase64 = [[BaseVC sharedInstance] encodeToBase64String:finalImage];
        });

    }
    else if ([dict objectForKey:UIImagePickerControllerEditedImage])
    {
        UIImage *image = [dict objectForKey:UIImagePickerControllerEditedImage];
        UIImage *compressedImage = [[BaseVC sharedInstance] compressImage:image];
        UIImage *finalImage = [[BaseVC sharedInstance] fixOrientation:compressedImage];
        
        tempImage = finalImage;

        [picker dismissViewControllerAnimated:YES
                                   completion:^{
           [UIView transitionWithView:_vwImageContainer
                             duration:0.4
                              options:UIViewAnimationOptionTransitionFlipFromLeft
                           animations:^{
                               _imgProfilePicture.image = finalImage;
                           }
                           completion:nil];
                                   }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^
                       {
                           strBase64 = [[BaseVC sharedInstance] encodeToBase64String:finalImage];
                       });

    }
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - Tool Bar Configuration and Events

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
    [_txtOldPassword becomeFirstResponder];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtUserName)
    {
        [_txtEmailAddress becomeFirstResponder];
    }
    else if (textField == _txtEmailAddress)
    {
        [_txtMobileNumber becomeFirstResponder];
    }
    else if (textField == _txtMobileNumber)
    {
        [_txtOldPassword becomeFirstResponder];
    }
    else if (textField == _txtOldPassword)
    {
        [_txtNewPassword becomeFirstResponder];
    }
    else if (textField == _txtNewPassword)
    {
        [_txtConfirmPassword becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

#pragma mark - Button Click Events

- (IBAction)btnEditClicked:(id)sender
{
    [self.view endEditing:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    });
    
    [UIView transitionWithView:_vwChangePasswordContainer
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _vwChangePasswordContainer.hidden = !_vwChangePasswordContainer.hidden;
                            _txtUserName.enabled = !_txtUserName.enabled;
                            _txtEmailAddress.enabled = !_txtEmailAddress.enabled;
                            _txtMobileNumber.enabled = !_txtMobileNumber.enabled;
                            _scrollView.scrollEnabled = !_scrollView.scrollEnabled;
                        });
                    }
                    completion:nil];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.view endEditing:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)btnSaveClicked:(id)sender
{
    [self.view endEditing:YES];
    
    if ([_txtUserName.text isValid] && [_txtEmailAddress.text isValid] && [_txtMobileNumber.text isValid])
    {
        if ([_txtEmailAddress.text isValidEmail])
        {
            if (_txtMobileNumber.text.length == 7)
            {
                if (_txtOldPassword.text.length > 0 || _txtNewPassword.text.length > 0 || _txtConfirmPassword.text.length > 0)
                {
                    if ([_txtOldPassword.text isValid] && [_txtNewPassword.text isValid] && [_txtConfirmPassword.text isValid])
                    {
                        if ([_txtOldPassword.text isValidPassword] && [_txtNewPassword.text isValidPassword] && [_txtConfirmPassword.text isValidPassword])
                        {
                            if ([_txtNewPassword.text isEqualToString:_txtConfirmPassword.text])
                            {
                                // TODO: Calling WS
                                if([[NetworkAvailability instance] isReachable])
                                {
                                    long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
                                    
                                    [SVProgressHUD showWithStatus:EditProfileMsg];

                                    [[WebServiceConnector alloc]init:URL_EditProfile
                                                      withParameters:@{
                                                                       @"user_id":[NSString stringWithFormat:@"%ld", user_id],
                                                                       @"role_id":@"1",
                                                                       @"profile_pic":strBase64,
                                                                       @"username":_txtUserName.text,
                                                                       @"email":_txtEmailAddress.text,
                                                                       @"mobile_no":_txtMobileNumber.text,
                                                                       @"old_password":_txtOldPassword.text,
                                                                       @"new_password":_txtNewPassword.text
                                                                       }
                                                          withObject:self
                                                        withSelector:@selector(DisplayResults:)
                                                      forServiceType:@"JSON"
                                                      showDisplayMsg:EditProfileMsg];
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
                                [AZNotification showNotificationWithTitle:@"New passwords mismatched with each other"
                                                               controller:self
                                                         notificationType:AZNotificationTypeError];
                            }
                        }
                        else
                        {
                            [[BaseVC sharedInstance] addAlertBoxWithText:@"Please provide valid password.\nUse minimum 8 and maximum 16 characters with at least 1 Alphabet, 1 Number and 1 Special Character."
                                                                    toVC:self];
                        }
                    }
                    else
                    {
                        [AZNotification showNotificationWithTitle:@"Please fill all mandatory fields"
                                                       controller:self
                                                 notificationType:AZNotificationTypeError];
                    }
                }
                else
                {
                    if([[NetworkAvailability instance] isReachable])
                    {

                        long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
                        
                        [SVProgressHUD showWithStatus:EditProfileMsg];

                        [[WebServiceConnector alloc]init:URL_EditProfile
                                          withParameters:@{
                                                           @"user_id":[NSString stringWithFormat:@"%ld", user_id],
                                                           @"role_id":@"1",
                                                           @"profile_pic":strBase64,
                                                           @"username":_txtUserName.text,
                                                           @"email":_txtEmailAddress.text,
                                                           @"mobile_no":_txtMobileNumber.text,
                                                           @"old_password":_txtOldPassword.text,
                                                           @"new_password":_txtNewPassword.text
                                                           }
                                              withObject:self
                                            withSelector:@selector(DisplayResults:)
                                          forServiceType:@"JSON"
                                          showDisplayMsg:EditProfileMsg];
                    }
                    else
                    {
                        [AZNotification showNotificationWithTitle:NETWORK_ERR
                                                       controller:self
                                                 notificationType:AZNotificationTypeError];
                    }
                }
            }
            else
            {
                [AZNotification showNotificationWithTitle:@"Please provide valid contact number"
                                               controller:self
                                         notificationType:AZNotificationTypeError];
            }
        }
        else
        {
            [AZNotification showNotificationWithTitle:@"Please provide valid email address"
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
            [DefaultsValues setCustomObjToUserDefaults:objUser ForKey:KEY_USER];
            
            _txtUserName.text = objUser.userName;
            _txtEmailAddress.text = objUser.email;
            _txtMobileNumber.text = objUser.contactNo;
            
            if (![objUser.profilePic isEqualToString:@"default.jpg"])
            {
                isImageSet = YES;
            }
            
//            [SDWebImageManager.sharedManager.imageCache clearMemory];
//            [SDWebImageManager.sharedManager.imageCache clearDisk];
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            [imageCache clearMemory];
            [imageCache clearDisk];
            
            NSString *strImgPath = [NSString stringWithFormat:@"%sprofile/%@",Image_Path,objUser.profilePic];

            [_imgProfilePicture sd_setImageWithURL:[NSURL URLWithString:strImgPath]
                                  placeholderImage:tempImage
                                           options:SDWebImageRefreshCached];
            
            [AZNotification showNotificationWithTitle:@"Changes has been saved successfully"
                                           controller:self
                                     notificationType:AZNotificationTypeSuccess];
        }
        else
        {
            [AZNotification showNotificationWithTitle:[[sender responseDict] valueForKey:@"message"]
                                           controller:self
                                     notificationType:AZNotificationTypeError];
        }
    }
}

@end
