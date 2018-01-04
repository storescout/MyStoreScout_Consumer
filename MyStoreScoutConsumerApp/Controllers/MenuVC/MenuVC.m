//
//  MenuVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 08/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "MenuVC.h"
#import <StoreKit/StoreKit.h>
#define kRemoveAdsProductIdentifier @"com.MyStoreScoutConsumerApp.RemoveAds"

@interface MenuVC ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    UINavigationController *navigation;
    BOOL *areAdsRemoved;
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
    
//    _lblFullName.text = [NSString stringWithFormat:@"%@ %@",objUser.firstName, objUser.lastName];
    _lblFullName.text = [NSString stringWithFormat:@"%@",objUser.userName];
    
    if (![objUser.profilePic isEqualToString:@"default.jpg"]) {
    
        NSString *strImgPath = [NSString stringWithFormat:@"%sprofile/%@",Image_Path,objUser.profilePic];
        
        [_imgProfilePicture sd_setImageWithURL:[NSURL URLWithString:strImgPath]
                              placeholderImage:[UIImage imageNamed:@"IMG_DEFAULT_PROFILE"]];
    }
    else{
        _imgProfilePicture.image = [UIImage imageNamed:@"IMG_DEFAULT_PROFILE"];
    }
    _imgProfilePicture.contentMode = UIViewContentModeScaleAspectFill;
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_SELECTED_MENU] == indexPath.row)
    {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
    else if (indexPath.row == 2)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove All Ads" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *RemoveAds = [UIAlertAction actionWithTitle:@"Remove Ads" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"User requests to remove ads");
            
            if([SKPaymentQueue canMakePayments]){
                NSLog(@"User can make payments");
                
                //If you have more than one in-app purchase, and would like
                //to have the user purchase a different product, simply define
                //another function and replace kRemoveAdsProductIdentifier with
                //the identifier for the other product
                
                SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
                productsRequest.delegate = self;
                [productsRequest start];
                
            }
            else{
                NSLog(@"User cannot make payments due to parental controls");
                //this is called the user cannot make payments, most likely due to parental controls
            }
        }];
        UIAlertAction *Restore = [UIAlertAction actionWithTitle:@"Restore" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //this is called when the user restores purchases, you should hook this up to a button
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        }];
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:RemoveAds];
        [alert addAction: Restore];
        [alert addAction:Cancel];
        [self presentViewController:alert animated:YES completion:nil];
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
    cell.textLabel.text = indexPath.row == 2 ? @"Remove Ads" : (indexPath.row == 0 ? @"Home" : @"Shopping List");
    
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

#pragma mark - In App Purchase Delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            //if you have more than one in-app purchase product,
            //you restore the correct product for the identifier.
            //For example, you could use
            //if(productID == kRemoveAdsProductIdentifier)
            //to get the product identifier for the
            //restored purchases, you can use
            //
            //NSString *productID = transaction.payment.productIdentifier;
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        //if you have multiple in app purchases in your app,
        //you can get the product identifier of this transaction
        //by using transaction.payment.productIdentifier
        //
        //then, check the identifier against the product IDs
        //that you have defined to check which product the user
        //just purchased
        
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

- (void)doRemoveAds{
    areAdsRemoved = YES;
//    _bannerView.hidden = YES;
    //    _tblHeightConstaint.constant = 75;
//    _tblStore.frame= CGRectMake(_tblStore.frame.origin.x, _tblStore.frame.origin.y, _tblStore.frame.size.width, [UIScreen mainScreen].bounds.size.height - 75);
//    _btnRemoveAds.enabled = NO;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    //use NSUserDefaults so that you can load whether or not they bought it
    //it would be better to use KeyChain access, or something more secure
    //to store the user data, because NSUserDefaults can be changed.
    //You're average downloader won't be able to change it very easily, but
    //it's still best to use something more secure than NSUserDefaults.
    //For the purpose of this tutorial, though, we're going to use NSUserDefaults
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
