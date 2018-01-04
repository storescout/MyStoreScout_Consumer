//
//  StoreInfoVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 08/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "StoreInfoVC.h"
#import "StoreVC.h"
#import "StoreImagesCell.h"
#import "StoreImages.h"

@interface StoreInfoVC ()
{
    double latitude;
    double lontitude;
    CLLocationCoordinate2D coordinates;
    BOOL isCounterUpdate;
}
@end


@implementation StoreInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureMap];
    isCounterUpdate = NO;
    _lblTitle.text = _objStore.storeName;
    _lblAddress.text = _objStore.storeAddress;
    _lblContactNumber.text = _objStore.contactNo;
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm a"];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"];
    NSString *strStartTime = [dateFormatter1 stringFromDate:[dateFormatter2 dateFromString:_objStore.startTime]];
    NSString *strEndTime = [dateFormatter1 stringFromDate:[dateFormatter2 dateFromString:_objStore.endTime]];
    
    _lblTimings.text = [NSString stringWithFormat:@"%@ - %@", strStartTime, strEndTime];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(contactNumberTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    [_lblContactNumber addGestureRecognizer:tapGesture];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.00001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
    {
        _heightOfAddress.constant = [self lineCountForLabel:_lblAddress] == 1 ? 24 : 34;
        [self.view layoutIfNeeded];
    });
}

- (void)contactNumberTapped:(UITapGestureRecognizer *)sender
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", _lblContactNumber.text]];
    [[UIApplication  sharedApplication] openURL:url];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (int)lineCountForLabel:(UILabel *)label
{
    
    CGRect sizeOfText = [label.text boundingRectWithSize:label.frame.size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName: label.font}
                                                   context:nil];
    return sizeOfText.size.height / label.font.pointSize;
}

- (void)configureMap
{
    
    if ([CLLocationManager locationServicesEnabled])
    {
        if (self.locationManager == nil)
        {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            [self.locationManager requestWhenInUseAuthorization];
        }
    }

    [self.locationManager startUpdatingLocation];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, 3000, 3000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:CLLocationCoordinate2DMake([_objStore.latitude floatValue], [_objStore.longitude floatValue])];
    [annotation setTitle:_objStore.storeName];
    [annotation setSubtitle:_objStore.storeAddress];
    [self.mapView addAnnotation:annotation];
    
    _mapView.centerCoordinate = annotation.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    coordinates.latitude=location.coordinate.latitude;
    coordinates.longitude=location.coordinate.longitude;
    latitude = location.coordinate.latitude;
    lontitude = location.coordinate.longitude;
    
    annotation.coordinate = coordinates;
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:lontitude];
    CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:[_objStore.latitude floatValue] longitude:[_objStore.longitude floatValue]];
    CLLocationDistance distance = [userLocation distanceFromLocation:storeLocation];
    NSLog(@"Distance: %f",distance);
    if (distance < 1 && !isCounterUpdate) {
        isCounterUpdate = YES;
        NSLog(@"Location matched");
        [self UpdateChekoutOptionCounterStoreId:_objStore.storeIdentifier];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
    
    if (!pinView)
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SFAnnotationIdentifier];
        UIImage *flagImage = [UIImage imageNamed:@"BLUE_ANNOTATION"];
        flagImage = [self imageWithImage:flagImage scaledToSize:CGSizeMake(30, 30)];
        annotationView.image = flagImage;
        return annotationView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UICollectionView Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)_objStore.storeImages.count);
    return [[BaseVC sharedInstance] getRowsforCollection:collectionView
                                                forArray:(NSMutableArray *)_objStore.storeImages
                                         withPlaceHolder:@"No Pictures Available"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imgView.layer.cornerRadius = 10.0f;
    cell.imgView.clipsToBounds = YES;
    
    StoreImages *objStoreImages = [_objStore.storeImages objectAtIndex:indexPath.row];
    
    NSString *strImgPath = [NSString stringWithFormat:@"%s%@",SERVER,objStoreImages.imgPath];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:strImgPath]
                    placeholderImage:[UIImage imageNamed:@"IMG_DEFAULT_PROFILE"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width/3) - 10, (collectionView.frame.size.width/3) - 10);
}

#pragma mark - Button Click Events

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEnterClicked:(id)sender
{
    StoreVC *storeVC = STORYBOARD_ID(@"idStoreVC");
    storeVC.objStore = _objStore;
    [self.navigationController pushViewController:storeVC animated:YES];
}

- (IBAction)btnDirectionsClicked:(id)sender
{
//    NSString *url = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", latitude, lontitude, [_objStore.latitude floatValue], [_objStore.longitude floatValue]];
     NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&travelmode=driving",latitude, lontitude, [_objStore.latitude floatValue],[_objStore.longitude floatValue]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}

#pragma mark ----------- User defined function -----------
- (void)UpdateChekoutOptionCounterStoreId:(NSString *)strStoreId
{
    if([[NetworkAvailability instance] isReachable])
    {
        //        [SVProgressHUD showWithStatus:GetAllStoresMsg];
        
        long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
        
        [[WebServiceConnector alloc]init:URL_CheckOutCount
                          withParameters:@{
                                           @"user_id":[NSString stringWithFormat:@"%ld",user_id],
                                           @"Store_id":strStoreId,
                                           @"is_testdata":isTestData,
                                           @"is_deletedata":@"0"
                                           }
                              withObject:self
                            withSelector:@selector(DisplayResults:)
                          forServiceType:@"JSON"
                          showDisplayMsg:@""];
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
            NSLog(@"%@", [[sender responseDict] valueForKey:@"message"]);
        }
        else
        {
            [AZNotification showNotificationWithTitle:[[sender responseDict] valueForKey:@"message"] controller:self notificationType:AZNotificationTypeError];
        }
    }
}
@end
