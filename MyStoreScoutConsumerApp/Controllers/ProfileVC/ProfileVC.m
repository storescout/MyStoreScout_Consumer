//
//  ProfileVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "ProfileVC.h"

@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.00001 * NSEC_PER_SEC), dispatch_get_main_queue(),^
    {
        _imgProfilePicture.layer.cornerRadius = _imgProfilePicture.frame.size.width / 2;
        _imgProfilePicture.clipsToBounds = YES;
        
        _vwImageContainer.layer.cornerRadius = _vwImageContainer.frame.size.width / 2;
        _vwImageContainer.clipsToBounds = YES;
        _vwImageContainer.layer.borderWidth = 2.0f;
        _vwImageContainer.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [[BaseVC sharedInstance] addBottomLineToTextFields:@[_txtUserName, _txtEmailAddress, _txtMobileNumber, _txtOldPassword, _txtNewPassword, _txtConfirmPassword]];
    });
    
    [self integrateNextButtonToolBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [_txtOldPassword becomeFirstResponder];
}

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

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
