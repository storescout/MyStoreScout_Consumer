//
//  ViewController.h
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 04/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUnderlinedButton.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtusername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet UIUnderlinedButton *btnSignUp;

- (IBAction)btnLoginClicked:(id)sender;
- (IBAction)btnForgotPasswordClicked:(id)sender;
- (IBAction)btnSignUpClicked:(id)sender;

@end

