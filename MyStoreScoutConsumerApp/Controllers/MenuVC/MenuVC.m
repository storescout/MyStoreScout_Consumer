//
//  MenuVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 08/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "MenuVC.h"

@interface MenuVC ()
{
    UINavigationController *navigation;
}
@end

@implementation MenuVC

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
    });
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [_imgProfilePicture addGestureRecognizer:tapGesture];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [_tblMenu reloadData];
    
    User *objUser = [DefaultsValues getCustomObjFromUserDefaults_ForKey:KEY_USER];
    
    _lblFullName.text = [NSString stringWithFormat:@"%@ %@",objUser.firstName, objUser.lastName];
    
    if (![objUser.profilePic isEqualToString:@"default.jpg"]) {
    
        NSString *strImgPath = [NSString stringWithFormat:@"%sprofile/%@",Image_Path,objUser.profilePic];
        
        [_imgProfilePicture sd_setImageWithURL:[NSURL URLWithString:strImgPath]
                              placeholderImage:[UIImage imageNamed:@"IMG_DEFAULT_PROFILE"]];
    }
    else{
        _imgProfilePicture.image = [UIImage imageNamed:@"IMG_DEFAULT_PROFILE"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Tap Gesture Event

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if ([DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_SELECTED_MENU] == -1)
    {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
    else
    {
        [DefaultsValues setIntegerValueToUserDefaults:-1 ForKey:KEY_SELECTED_MENU];
        [_tblMenu reloadData];
        [self navigateToViewController:STORYBOARD_ID(@"idProfileVC")];
    }
}

#pragma mark - Custom Events

- (void)navigateToViewController:(UIViewController *)viewController
{
    navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    navigation.navigationBar.hidden = YES;
    
    if ([navigation respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigation.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [APP_CONTEXT.drawerController setCenterViewController:navigation
                                        withCloseAnimation:YES
                                               completion:nil];
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_SELECTED_MENU] == indexPath.row)
    {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
    else
    {
        [DefaultsValues setIntegerValueToUserDefaults:(int)indexPath.row ForKey:KEY_SELECTED_MENU];
        
        [tableView reloadData];

        [self navigateToViewController:STORYBOARD_ID(indexPath.row == 0 ? @"idStoresVC" : @"idShoppingListVC")];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = indexPath.row == [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_SELECTED_MENU] ? rgb(0, 0, 0, 0.3) : [UIColor clearColor];
    cell.textLabel.text = indexPath.row == 0 ? @"Home" : @"Shopping List";
    
    return cell;
}

#pragma mark - Button Click Events

- (IBAction)btnLogOutClicked:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                   message:@"Are you sure you want to Logout?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                                          [DefaultsValues removeObjectForKey:KEY_USER_ID];
                                                          [DefaultsValues removeObjectForKey:KEY_USER];
                                                          [APP_CONTEXT setRootViewControllerForUserLoggedIn:NO];
                                                      }];
    
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
