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
}
@end

@implementation ProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    strBase64 = @"";
    
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
    });
    [self tapGestureInitialize];
    [self integrateNextButtonToolBar];
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
            [self presentViewController:imagePickerController animated:YES completion:^{}];
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
        [SVProgressHUD showWithStatus:@"Please wait"];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void)
                       {
                           imagePickerController = [[UIImagePickerController alloc] init];
                           imagePickerController.delegate = self;
                           imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                           [self presentViewController:imagePickerController animated:YES completion:^
                            {
                                [SVProgressHUD dismiss];
                            }];
                       });
    }
    else if(buttonIndex == 0)
    {
        isImageSet = NO;
        [_imgProfilePicture setImage:DEFAULT_PROFILE_IMAGE];
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
        _imgProfilePicture.image = finalImage;
    }
    else if ([dict objectForKey:UIImagePickerControllerEditedImage])
    {
        UIImage *image = [dict objectForKey:UIImagePickerControllerEditedImage];
        UIImage *compressedImage = [[BaseVC sharedInstance] compressImage:image];
        UIImage *finalImage = [[BaseVC sharedInstance] fixOrientation:compressedImage];
        _imgProfilePicture.image = finalImage;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^
                   {
                       strBase64 = [[BaseVC sharedInstance] encodeToBase64String:_imgProfilePicture.image];
                   });
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

#pragma mark - Button Click Events

- (IBAction)btnEditClicked:(id)sender
{
    [self.view endEditing:YES];
    [UIView transitionWithView:self.view
                      duration:0.1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _vwChangePasswordContainer.hidden = !_vwChangePasswordContainer.hidden;
                        _txtUserName.enabled = !_txtUserName.enabled;
                        _txtEmailAddress.enabled = !_txtEmailAddress.enabled;
                        _txtMobileNumber.enabled = !_txtMobileNumber.enabled;
                    }
                    completion:NULL];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.view endEditing:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
