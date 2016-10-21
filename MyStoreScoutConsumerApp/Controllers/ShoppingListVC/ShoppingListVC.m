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
#import "ShoppingList.h"

@interface ShoppingListVC ()
{
    NSArray *arrShoppingList;
    NSMutableArray *arrResults;
    UIRefreshControl *refreshControl;
    NSInteger productID;
}
@end

@implementation ShoppingListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    productID = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.00001 * NSEC_PER_SEC), dispatch_get_main_queue(),^
    {
        _vwAddItem.layer.cornerRadius = 10.0f;
        _vwAddItem.clipsToBounds = YES;
        
        [[BaseVC sharedInstance] addBottomLineToTextFields:@[_txtAddItem]];
        
        [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtAddItem
                                                 withPlaceHolder:@"Add item name"];
        
        if (SCREEN_HEIGHT > 568)
        {
            _lblAddItem.font = THEME_FONT(25);
            _txtAddItem.font = THEME_FONT(18);
            _btnSave.titleLabel.font = THEME_FONT(20);
            _btnCancel.titleLabel.font = THEME_FONT(20);
        }
    });
    
    [self getAllShoppingListItems];
    
    // Intializing refresh control for Pull-To-Refresh
    refreshControl = [[UIRefreshControl alloc] init];
    [[BaseVC sharedInstance] addRefreshControl:refreshControl
                                       toTable:_tblShoppingList
                            withViewController:self
                                   forSelector:@selector(getAllShoppingListItems)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [_vwAddItemContainer addGestureRecognizer:tapGesture];
    
    [_txtAddItem addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods

- (void)closeAddItemPopUp
{
    [UIView transitionWithView:_vwAddItemContainer
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        _vwAddItemContainer.hidden = !_vwAddItemContainer.hidden;
                    }
                    completion:^(BOOL finished) {
                        [self.view endEditing:YES];
                        _txtAddItem.text = NULL;
                        _txtAddItem.enabled = NO;
                        [arrResults removeAllObjects];
                        [_tblResults reloadData];
                        [_tblResults setHidden:YES];
                    }];
}

#pragma mark - WS Call

- (void)getAllShoppingListItems
{
    if([[NetworkAvailability instance] isReachable])
    {
        long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
        
        [SVProgressHUD showWithStatus:GetAllProductsMsg];
        
        [[WebServiceConnector alloc]init:URL_GetShoppingList
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
        [refreshControl endRefreshing];
        [AZNotification showNotificationWithTitle:NETWORK_ERR
                                       controller:self
                                 notificationType:AZNotificationTypeError];
    }
}

- (void)DisplayResults:(id)sender
{
    [SVProgressHUD dismiss];
    [refreshControl endRefreshing];

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
            arrShoppingList = [sender responseArray];
            
            [_tblShoppingList reloadData];
        }
    }
}

#pragma mark - Tap Gesture Handling Method

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (!CGRectContainsRect(_vwAddItem.frame, CGRectMake([sender locationInView:self.view].x, [sender locationInView:self.view].y, 1, 1)))
    {
        [self closeAddItemPopUp];
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (!_tblResults.hidden)
    {
        if (CGRectContainsPoint(_tblResults.bounds, [touch locationInView:_tblResults]))
            return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)sender
{
    productID = 0;
    
    _tblResults.hidden = sender.text.length > 0 ? NO : YES;
    
    if(sender.text.length > 0)
    {
        if([[NetworkAvailability instance] isReachable])
        {
            long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
            
            [[WebServiceConnector alloc]init:URL_GetSearchResultsForText
                              withParameters:@{
                                               @"user_id":[NSString stringWithFormat:@"%ld",user_id],
                                               @"role_id":@"1",
                                               @"search_text":sender.text
                                               }
                                  withObject:self
                                withSelector:@selector(DisplaySearchResults:)
                              forServiceType:@"JSON"
                              showDisplayMsg:SearchProductsMsg];
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
        [arrResults removeAllObjects];
        [_tblResults reloadData];
    }
}

- (void)DisplaySearchResults:(id)sender
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
            [arrResults removeAllObjects];
            arrResults = (NSMutableArray *)[sender responseArray];
            [_tblResults reloadData];
        }
    }
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblShoppingList)
    {
        return 44;
    }
    return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView == _tblShoppingList ?
    
    [[BaseVC sharedInstance] getRowsforTable:tableView
                                    forArray:(NSMutableArray *)arrShoppingList
                             withPlaceHolder:@"No Products Found"] :
    
    [[BaseVC sharedInstance] getRowsforTable:tableView
                                    forArray:arrResults
                             withPlaceHolder:@"No Result Found"];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return tableView == _tblShoppingList ? YES : NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                   message:@"Do you want to remove this product from shopping list?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *btnYes = [UIAlertAction actionWithTitle:@"Yes"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 ShoppingList *objShoppingList = [arrShoppingList objectAtIndex:indexPath.row];
                                 NSLog(@"%@",objShoppingList.shoppingListIdentifier);
                                 
                                 if([[NetworkAvailability instance] isReachable])
                                 {
                                     long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
                                     
                                     [SVProgressHUD showWithStatus:DeleteProductFromShoppingListMsg];
                                     
                                     [[WebServiceConnector alloc]init:URL_DeleteProductFromShoppingList
                                                       withParameters:@{
                                                                        @"user_id":[NSString stringWithFormat:@"%ld",user_id],
                                                                        @"id":objShoppingList.shoppingListIdentifier
                                                                        }
                                                           withObject:self
                                                         withSelector:@selector(DisplayResults:)
                                                       forServiceType:@"JSON"
                                                       showDisplayMsg:DeleteProductFromShoppingListMsg];
                                 }
                                 else
                                 {
                                     [AZNotification showNotificationWithTitle:NETWORK_ERR
                                                                    controller:self
                                                              notificationType:AZNotificationTypeError];
                                 }
                             }];
    
    UIAlertAction *btnNo = [UIAlertAction actionWithTitle:@"Cancel"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {}];
    
    [alert addAction:btnNo];
    [alert addAction:btnYes];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblShoppingList)
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
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        Products *objProduct = [arrResults objectAtIndex:indexPath.row];
        productID = [objProduct.productsIdentifier integerValue];
        _txtAddItem.text = cell.textLabel.text;
        
        [arrResults removeAllObjects];
        [_tblResults reloadData];
        [_tblResults setHidden:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblShoppingList)
    {
        ShoppingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        ShoppingList *objShoppingList = [arrShoppingList objectAtIndex:indexPath.row];
        
        Products *objProduct = [objShoppingList.productdetail objectAtIndex:0];
        
        cell.lblItemName.text = objProduct.productName;
        
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : rgb(242, 242, 242, 1.0);
        
        [cell.btnIsChecked setImage:[UIImage imageNamed:[objShoppingList.isBought boolValue] ? @"IMG_CHECKED" : @"IMG_UNCHECKED"] forState:UIControlStateNormal];
        
        cell.btnIsChecked.tag = indexPath.row;
        
        [cell.btnIsChecked addTarget:self
                              action:@selector(handleCheckBoxTap:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        Products *objProduct = [arrResults objectAtIndex:indexPath.row];
        cell.textLabel.text = objProduct.productName;

        return cell;
    }
}

#pragma mark - Check Box Handling Events

- (IBAction)handleCheckBoxTap:(UIButton *)sender
{
    _vwPopUp.hidden = YES;
    
    BOOL isBought = [[BaseVC sharedInstance] image:sender.imageView.image isEqualTo:[UIImage imageNamed:@"IMG_CHECKED"]];
    
    [UIView transitionWithView:sender
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [sender setImage:[UIImage imageNamed:isBought ? @"IMG_UNCHECKED" : @"IMG_CHECKED"] forState:UIControlStateNormal];
                    }
                    completion:nil];
    
    ShoppingList *objShoppingList = [arrShoppingList objectAtIndex:sender.tag];
    
    
    if([[NetworkAvailability instance] isReachable])
    {
        long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
        
        [SVProgressHUD showWithStatus:CheckShoppingListProductAsBoughtMsg];
        
        [[WebServiceConnector alloc]init:URL_CheckShoppingListProductAsBought
                          withParameters:@{
                                           @"user_id":[NSString stringWithFormat:@"%ld",user_id],
                                           @"id":objShoppingList.shoppingListIdentifier,
                                           @"is_bought":isBought ? @"0" : @"1"
                                           }
                              withObject:self
                            withSelector:@selector(DisplayResults:)
                          forServiceType:@"JSON"
                          showDisplayMsg:CheckShoppingListProductAsBoughtMsg];
    }
    else
    {
        [AZNotification showNotificationWithTitle:NETWORK_ERR
                                       controller:self
                                 notificationType:AZNotificationTypeError];
    }


    NSLog(@"%@",objShoppingList.shoppingListIdentifier);
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
    [UIView transitionWithView:_vwPopUp
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^(void) {
                        _vwPopUp.hidden = YES;
                    }
                    completion:^(BOOL finished){
                        if([[NetworkAvailability instance] isReachable])
                        {
                            long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
                            
                            [SVProgressHUD showWithStatus:CheckAllShoppingListProductsAsBoughtMsg];
                            
                            [[WebServiceConnector alloc]init:URL_CheckAllShoppingListProductsAsBought
                                              withParameters:@{
                                                               @"user_id":[NSString stringWithFormat:@"%ld",user_id],
                                                               }
                                                  withObject:self
                                                withSelector:@selector(DisplayResults:)
                                              forServiceType:@"JSON"
                                              showDisplayMsg:CheckAllShoppingListProductsAsBoughtMsg];
                        }
                        else
                        {
                            [AZNotification showNotificationWithTitle:NETWORK_ERR
                                                           controller:self
                                                     notificationType:AZNotificationTypeError];
                        }
                    }];
}

- (IBAction)btnDeleteAllClicked:(id)sender
{

//    isSelectAll = 2;
//    
//    _vwPopUp.hidden = YES;
//    
    [UIView transitionWithView:_vwPopUp
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^(void) {
                        _vwPopUp.hidden = YES;
                    }
                    completion:^(BOOL finished){
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                                       message:@"Are you sure you want to remove all items from shopping list?"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *btnYes = [UIAlertAction actionWithTitle:@"Yes"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * action)
                                                 {
                                                     if([[NetworkAvailability instance] isReachable])
                                                     {
                                                         long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
                                                         
                                                         [SVProgressHUD showWithStatus:DeleteAllProductsFromShoppingListMsg];
                                                         
                                                         [[WebServiceConnector alloc]init:URL_DeleteAllProductsFromShoppingList
                                                                           withParameters:@{
                                                                                            @"user_id":[NSString stringWithFormat:@"%ld",user_id],
                                                                                            }
                                                                               withObject:self
                                                                             withSelector:@selector(DisplayResults:)
                                                                           forServiceType:@"JSON"
                                                                           showDisplayMsg:DeleteAllProductsFromShoppingListMsg];
                                                     }
                                                     else
                                                     {
                                                         [AZNotification showNotificationWithTitle:NETWORK_ERR
                                                                                        controller:self
                                                                                  notificationType:AZNotificationTypeError];
                                                     }
                                                 }];
                        
                        UIAlertAction *btnNo = [UIAlertAction actionWithTitle:@"Cancel"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                        
                        [alert addAction:btnNo];
                        [alert addAction:btnYes];
                        [self presentViewController:alert animated:YES completion:nil];
                    }];
}

- (IBAction)btnSaveClicked:(id)sender
{
    if (productID == 0)
    {
        NSLog(@"not save");
        [AZNotification showNotificationWithTitle:@"Please select valid product"
                                       controller:self
                                 notificationType:AZNotificationTypeError];
    }
    else
    {
        if([[NetworkAvailability instance] isReachable])
        {
            long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
            
            [SVProgressHUD showWithStatus:AddProductInShoppingListMsg];
            
            [[WebServiceConnector alloc]init:URL_AddProductInShoppingList
                              withParameters:@{
                                               @"user_id":[NSString stringWithFormat:@"%ld",user_id],
                                               @"role_id":@"1",
                                               @"product_id":[NSString stringWithFormat:@"%ld",(long)productID]
                                               }
                                  withObject:self
                                withSelector:@selector(DisplayAddResults:)
                              forServiceType:@"JSON"
                              showDisplayMsg:AddProductInShoppingListMsg];
        }
        else
        {
            [AZNotification showNotificationWithTitle:NETWORK_ERR
                                           controller:self
                                     notificationType:AZNotificationTypeError];
        }
    }
    
    productID = 0;
}

- (void)DisplayAddResults:(id)sender
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
            _txtAddItem.text = NULL;
            [UIView transitionWithView:_vwAddItemContainer
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                _vwAddItemContainer.hidden = !_vwAddItemContainer.hidden;
                            }
                            completion:^(BOOL finished) {
                                
                                [self.view endEditing:YES];
                                
                                _txtAddItem.enabled = NO;
                                
                                arrShoppingList = [sender responseArray];
                                
                                [_tblShoppingList reloadData];

                            }];
        }
        else
        {
            [AZNotification showNotificationWithTitle:[[sender responseDict] valueForKey:@"message"]
                                           controller:self
                                     notificationType:AZNotificationTypeError];
        }
    }
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
