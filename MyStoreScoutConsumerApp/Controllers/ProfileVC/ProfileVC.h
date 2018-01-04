//
//  ProfileVC.h
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface ProfileVC : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePicture;
@property (weak, nonatomic) IBOutlet UIView *vwImageContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIView *vwChangePasswordContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vwOfScrollViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (strong, nonatomic) IBOutlet GADBannerView *bannerView;

- (IBAction)btnEditClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;

@end
