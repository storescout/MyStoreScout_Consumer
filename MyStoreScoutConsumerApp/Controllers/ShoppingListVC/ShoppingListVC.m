//
//  ShoppingListVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "ShoppingListVC.h"
#import "ShoppingListCell.h"
#import "Products.h"

@interface ShoppingListVC ()
{
    NSInteger isSelectAll;
    NSArray *arrProducts;
}
@end

@implementation ShoppingListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isSelectAll = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.00001 * NSEC_PER_SEC), dispatch_get_main_queue(),^
    {
        _vwAddItem.layer.cornerRadius = 10.0f;
        _vwAddItem.clipsToBounds = YES;
        
        [[BaseVC sharedInstance] addBottomLineToTextFields:@[_txtAddItem]];
        
        [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtAddItem
                                                 withPlaceHolder:@"Add item name"];
    });
    
    [self getAllProducts];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [_vwAddItemContainer addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - WS Call

- (void)getAllProducts
{
    if([[NetworkAvailability instance] isReachable])
    {
        long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
        
        [[WebServiceConnector alloc]init:URL_GetAllProducts
                          withParameters:@{
                                           @"user_id":[NSString stringWithFormat:@"%ld",user_id],
                                           @"role_id":@"1"
                                           }
                              withObject:self
                            withSelector:@selector(DisplayResults:)
                          forServiceType:@"JSON"
                          showDisplayMsg:GetAllProductsMsg];
    }
    else
    {
        [AZNotification showNotificationWithTitle:NETWORK_ERR
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
            arrProducts = [sender responseArray];
            
            [_tblShoppingList reloadData];

        }
    }
}

#pragma mark - Tap Gesture Handling Method

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (!CGRectContainsRect(_vwAddItem.frame, CGRectMake([sender locationInView:self.view].x, [sender locationInView:self.view].y, 1, 1)))
    {
        [UIView transitionWithView:_vwAddItemContainer
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _vwAddItemContainer.hidden = !_vwAddItemContainer.hidden;
                        }
                        completion:^(BOOL finished) {
                            [self.view endEditing:YES];
                            _txtAddItem.enabled = NO;
                        }];
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrProducts.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    NSLog(@"Deleted row.");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_vwPopUp.hidden)
    {
        [UIView transitionWithView:_vwPopUp
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _vwPopUp.hidden = YES;
                        }
                        completion:NULL];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Products *objProduct = [arrProducts objectAtIndex:indexPath.row];
    
    cell.lblItemName.text = objProduct.productName;
    
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : rgb(242, 242, 242, 1.0);
    
    if (isSelectAll == 0)
    {
        [cell.btnIsChecked setImage:[UIImage imageNamed:indexPath.row % 2 == 0 ? @"IMG_UNCHECKED" : @"IMG_CHECKED"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnIsChecked setImage:[UIImage imageNamed:isSelectAll == 2 ? @"IMG_UNCHECKED" : @"IMG_CHECKED"] forState:UIControlStateNormal];
    }
    
    cell.btnIsChecked.tag = indexPath.row;
    
    [cell.btnIsChecked addTarget:self
                          action:@selector(handleCheckBoxTap:)
                forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Check Box Handling Events

- (IBAction)handleCheckBoxTap:(UIButton *)sender
{
    _vwPopUp.hidden = YES;
    
    NSLog(@"I have pressed button at index %ld",(long)[sender tag]);
    
    [UIView transitionWithView:sender
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [sender setImage:[UIImage imageNamed:[[BaseVC sharedInstance] image:sender.imageView.image isEqualTo:[UIImage imageNamed:@"IMG_CHECKED"]] ? @"IMG_UNCHECKED" : @"IMG_CHECKED"] forState:UIControlStateNormal];
                    }
                    completion:nil];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!_vwPopUp.hidden)
    {
        [UIView transitionWithView:_vwPopUp
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _vwPopUp.hidden = YES;
                        }
                        completion:NULL];
    }
}

#pragma mark - Button Click Events

- (IBAction)btnOptionsClicked:(id)sender
{
    [UIView transitionWithView:_vwPopUp
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        _vwPopUp.hidden = !_vwPopUp.hidden;
                    }
                    completion:NULL];
}

- (IBAction)btnBackClicked:(id)sender
{
    if (!_vwPopUp.hidden)
    {
        [UIView transitionWithView:_vwPopUp
                          duration:0.1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _vwPopUp.hidden = YES;
                        }
                        completion:^(BOOL finished){
                            [self.view endEditing:YES];
                            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }];
    }
    else
    {
        [self.view endEditing:YES];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

- (IBAction)btnAddItemClicked:(id)sender
{
    if (!_vwPopUp.hidden)
    {
        [UIView transitionWithView:_vwPopUp
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _vwPopUp.hidden = YES;
                        }
                        completion:NULL];
    }
    [UIView transitionWithView:_vwAddItemContainer
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        _vwAddItemContainer.hidden = !_vwAddItemContainer.hidden;
                        _txtAddItem.enabled = !_txtAddItem.enabled;
                    }
                    completion:nil];
}

- (IBAction)btnSelectClicked:(id)sender
{
    isSelectAll = 1;
    
    _vwPopUp.hidden = YES;
    
    [UIView transitionWithView:_tblShoppingList
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^(void) {
                        [_tblShoppingList reloadData];
                    }
                    completion:^(BOOL finished){
                        isSelectAll = 0;
                    }];

    
    //[self.navigationController pushViewController:STORYBOARD_ID(@"idStoreInfoVC") animated:YES];
}

- (IBAction)btnDeleteAllClicked:(id)sender
{
    isSelectAll = 2;
    
    _vwPopUp.hidden = YES;
    
    [UIView transitionWithView:_tblShoppingList
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^(void) {
                        [_tblShoppingList reloadData];
                    }
                    completion:^(BOOL finished){
                        isSelectAll = 2;
                    }];
}

- (IBAction)btnSaveClicked:(id)sender
{
}

- (IBAction)btnCancelClicked:(id)sender
{
    [UIView transitionWithView:_vwAddItemContainer
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        _vwAddItemContainer.hidden = !_vwAddItemContainer.hidden;
                    }
                    completion:^(BOOL finished) {
                        
                        [self.view endEditing:YES];
                        
                        _txtAddItem.enabled = NO;
                    }];
}

@end
