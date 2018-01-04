//
//  StoreVC.h
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 10/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Store.h"
@import GoogleMobileAds;

@interface StoreVC : UIViewController <CLLocationManagerDelegate, UITextViewDelegate, GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIView *vwTopBar;
@property (weak, nonatomic) IBOutlet UIButton *btnShoppingList;
@property (strong, nonatomic) IBOutlet UIView *vwOfferMain;
@property (strong, nonatomic) IBOutlet UIImageView *imgProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) IBOutlet UILabel *lblOfferDescription;
@property (strong, nonatomic) IBOutlet UIView *vwSubOffer;
@property (strong, nonatomic) IBOutlet UIImageView *imgOfferRibbon;
@property (strong, nonatomic) IBOutlet UIView *vwBottom;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomProduct;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (nonatomic, readwrite) NSArray *arrShoppingList;
@property (nonatomic, strong) Store *objStore;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnShoppingListClicked:(id)sender;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

@end
