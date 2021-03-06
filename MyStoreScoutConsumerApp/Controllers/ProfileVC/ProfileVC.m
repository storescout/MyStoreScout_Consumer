//
//  ProfileVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "ProfileVC.h"

#define DEFAULT_IMAGE_NAME @"default.jpg"

@interface ProfileVC ()
{
    BOOL isImageSet;
    BOOL isImageChanged;
    
    NSString *strBase64;
    UIImage *tempImage, *mainImage;
    UIImagePickerController *imagePickerController;
    BOOL areAdsRemoved;
}
@end

@implementation ProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    strBase64 = @"";
    isImageChanged = NO;
    tempImage = [UIImage imageNamed:@"IMG_DEFAULT_PROFILE"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.00001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
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
        
        CGFloat heightScrollView = _vwChangePasswordContainer.frame.origin.y + _vwChangePasswordContainer.frame.size.height;
        
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, heightScrollView);
        
        _vwOfScrollViewHeight.constant = heightScrollView;
        
        [self.view layoutIfNeeded];
        
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        [self.scrollView setScrollEnabled:NO];
    });
    
    [self loadAds];
    [self tapGestureInitialize];
    [self integrateNextButtonToolBar];
    
    User *objUser = [DefaultsValues getCustomObjFromUserDefaults_ForKey:KEY_USER];

    _txtUserName.text = objUser.userName;
    _txtEmailAddress.text = objUser.email;
    _txtMobileNumber.text = objUser.contactNo;
    
    if (![objUser.profilePic isEqualToString:DEFAULT_IMAGE_NAME])
    {
        isImageSet = YES;
    }
    
    if (![objUser.profilePic isEqualToString:DEFAULT_IMAGE_NAME])
    {
        NSString *strImgPath = [NSString stringWithFormat:@"%sprofile/%@",Image_Path,objUser.profilePic];
        
        [_imgProfilePicture sd_setImageWithURL:[NSURL URLWithString:strImgPath]
                              placeholderImage:[UIImage imageNamed:@"IMG_DEFAULT_PROFILE"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         mainImage = image;
                                     }];
    }
    else
    {
        _imgProfilePicture.image = [UIImage imageNamed:@"IMG_DEFAULT_PROFILE"];
        mainImage = [UIImage imageNamed:@"IMG_DEFAULT_PROFILE"];
    }
    _imgProfilePicture.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleLightContent))
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tapGestureInitialize
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    
    [tapGesture addTarget:self
                   action:@selector(tapGesture:)];
    
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [_imgProfilePicture addGestureRecognizer:tapGesture];
}

- (void)tapGesture:(id)sender
{
    [self.view endEditing:YES];
    
    
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
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if(buttonIndex == 0)
    {
        isImageSet = NO;
        strBase64 = @"";
        isImageChanged = YES;
        
        [UIView transitionWithView:_vwImageContainer
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^ {
                            [_imgProfilePicture setImage:DEFAULT_PROFILE_IMAGE];
                        } completion:nil];

    }
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)dict
{
    isImageSet = YES;
    isImageChanged = YES;
    
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
       didShowViewController:(UIViewController *)viewController
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
                        dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if(!_vwChangePasswordContainer.hidden)
                            {
                                strBase64 = @"";
                                isImageChanged = NO;
                                if (mainImage != nil)
                                {
                                    if (![[BaseVC sharedInstance] image:_imgProfilePicture.image isEqualTo:mainImage])
                                    {
                                        [UIView transitionWithView:_vwImageContainer
                                                          duration:0.4
                                                           options:UIViewAnimationOptionTransitionFlipFromLeft
                                                        animations:^{
                                                                isImageSet = [[BaseVC sharedInstance] image:mainImage isEqualTo:[UIImage imageNamed:DEFAULT_IMAGE_NAME]] ? NO : YES;
                                                            _imgProfilePicture.image = mainImage;
                                                        } completion:nil];
                                    }
                                }
                            }
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
            if (_txtMobileNumber.text.length > 6 && _txtMobileNumber.text.length < 16)
            {
                if (_txtOldPassword.text.length > 0 || _txtNewPassword.text.length > 0 || _txtConfirmPassword.text.length > 0)
                {
                    if ([_txtOldPassword.text isValid] && [_txtNewPassword.text isValid] && [_txtConfirmPassword.text isValid])
                    {
                        if ([_txtOldPassword.text isValidPassword] && [_txtNewPassword.text isValidPassword] && [_txtConfirmPassword.text isValidPassword])
                        {
                            if ([_txtOldPassword.text isEqualToString:_txtNewPassword.text]) {
                                [AZNotification showNotificationWithTitle:@"Old and New password must be different"
                                                               controller:self
                                                         notificationType:AZNotificationTypeError];
                                return;
                            }
                            
                            if ([_txtNewPassword.text isEqualToString:_txtConfirmPassword.text])
                            {
                                // TODO: Calling WS
                                if([[NetworkAvailability instance] isReachable])
                                {
                                    long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
                                    
                                    [SVProgressHUD showWithStatus:EditProfileMsg];
                                    [self.view setUserInteractionEnabled:NO];
                                    [[WebServiceConnector alloc]init:URL_EditProfile
                                                      withParameters:@{
                                                                       @"user_id":[NSString stringWithFormat:@"%ld", user_id],
                                                                       @"role_id":role_id,
                                                                       @"profile_pic":strBase64,
                                                                       @"is_image_changed":isImageChanged ? @"1" : @"0",
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
                                [AZNotification showNotificationWithTitle:@"New and Confirm password must be same"
                                                               controller:self
                                                         notificationType:AZNotificationTypeError];
                            }
                        }
                        else
                        {
                            
//                            [[BaseVC sharedInstance] addAlertBoxWithText:@"Please provide valid password.\nUse minimum 8 and maximum 16 characters with at least 1 Alphabet, 1 Number and 1 Special Character."
//                                                                    toVC:self];
                            [[BaseVC sharedInstance] addAlertBoxWithText:@"Use minimum 8 and maximum 16 characters password with at least 1 Alphabet, 1 Number and 1 Special character."
                                                                    toVC:self];
                        }
                    }
                    else
                    {
                        if (_txtOldPassword.text.length == 0) {
                            
                            [[BaseVC sharedInstance] addAlertBoxWithText:@"Please enter old password."
                                                                    toVC:self];
                            
//                            [AZNotification showNotificationWithTitle:@"Please enter old password"
//                                                           controller:self
//                                                     notificationType:AZNotificationTypeError];
                            return;
                        }
                        
                        if (_txtNewPassword.text.length == 0) {
                            
                            [[BaseVC sharedInstance] addAlertBoxWithText:@"Please enter new password."
                                                                    toVC:self];
//                            [AZNotification showNotificationWithTitle:@"Please enter new password"
//                                                           controller:self
//                                                     notificationType:AZNotificationTypeError];
                            return;
                        }
                        
                        if (_txtConfirmPassword.text.length == 0) {
                            
                            [[BaseVC sharedInstance] addAlertBoxWithText:@"Please enter confirm password."
                                                                    toVC:self];
                            
//                            [AZNotification showNotificationWithTitle:@"Please enter confirm password"
//                                                           controller:self
//                                                     notificationType:AZNotificationTypeError];
                            return;
                        }
                        
                        
//                        [AZNotification showNotificationWithTitle:@"Please fill all mandatory fields"
//                                                       controller:self
//                                                 notificationType:AZNotificationTypeError];
                    }
                }
                else
                {
                    if([[NetworkAvailability instance] isReachable])
                    {

                        long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
                        
                        [SVProgressHUD showWithStatus:EditProfileMsg];
                        [self.view setUserInteractionEnabled:NO];
                        [[WebServiceConnector alloc]init:URL_EditProfile
                                          withParameters:@{
                                                           @"user_id":[NSString stringWithFormat:@"%ld", user_id],
                                                           @"role_id":role_id,
                                                           @"profile_pic":strBase64,
                                                           @"is_image_changed":isImageChanged ? @"1" : @"0",
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
        if ([_txtUserName.text isValid]) {
            [AZNotification showNotificationWithTitle:@"Please enter username"
                                           controller:self
                                     notificationType:AZNotificationTypeError];
            return;
        }
        
        if ([_txtEmailAddress.text isValid]) {
            [AZNotification showNotificationWithTitle:@"Please enter email id"
                                           controller:self
                                     notificationType:AZNotificationTypeError];
            return;
        }
        
        if ([_txtMobileNumber.text isValid]) {
            [AZNotification showNotificationWithTitle:@"Please enter mobile number"
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
    [self.view setUserInteractionEnabled:YES];
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
            
            if (![objUser.profilePic isEqualToString:DEFAULT_IMAGE_NAME])
            {
                isImageSet = YES;
            }
            
            if (isImageChanged) {
                
                mainImage = _imgProfilePicture.image;
                
                SDImageCache *imageCache = [SDImageCache sharedImageCache];
                [imageCache clearMemory];
                [imageCache clearDisk];
                
                if (![objUser.profilePic isEqualToString:DEFAULT_IMAGE_NAME]) {
                
                NSString *strImgPath = [NSString stringWithFormat:@"%sprofile/%@",Image_Path,objUser.profilePic];
                
                [_imgProfilePicture sd_setImageWithURL:[NSURL URLWithString:strImgPath]
                                      placeholderImage:tempImage
                                               options:SDWebImageRefreshCached];
                }
                else {
                    _imgProfilePicture.image = [UIImage imageNamed:@"IMG_DEFAULT_PROFILE"];
                }
            }
            
            [self btnEditClicked:nil];
            
            
            
            [AZNotification showNotificationWithTitle:@"Profile updated successfully"
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

#pragma mark - GAD Ads functions
-(void)loadAds
{
    if (areAdsRemoved) {
        _bottomSpace = 0;
        [self.view updateConstraintsIfNeeded];
    }
    else
    {
        _bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
        _bannerView.delegate = self;
        _bannerView.rootViewController = self;
        [_bannerView loadRequest:[GADRequest request]];
    }
    
}

@end
