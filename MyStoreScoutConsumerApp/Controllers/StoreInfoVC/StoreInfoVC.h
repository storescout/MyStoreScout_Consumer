//
//  StoreInfoVC.h
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 08/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Store.h"

@interface StoreInfoVC : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblContactNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTimings;
@property (weak, nonatomic) IBOutlet UIButton *btnEnter;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnDirections;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) Store *objStore;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnEnterClicked:(id)sender;
- (IBAction)btnDirectionsClicked:(id)sender;


@end
