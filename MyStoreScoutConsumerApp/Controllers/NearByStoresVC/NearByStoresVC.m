//
//  NearByStoresVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "NearByStoresVC.h"
#import "Store.h"
#import "StoreInfoVC.h"

@interface NearByStoresVC ()
{
    double latitude;
    double lontitude;
    BOOL isFirstTime;
    NSArray *arrStores;
    NSArray *arrTempStores;
    CLLocationCoordinate2D coordinates;
}
@end

@implementation NearByStoresVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isFirstTime = YES;
    
    [self setLayout];
    [self configureMap];
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getAllStores];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
    
}

- (void)applyMapViewMemoryFix
{    
    switch (_mapView.mapType)
    {
        case MKMapTypeHybrid:
        {
            _mapView.mapType = MKMapTypeStandard;
        }
        break;
            
        case MKMapTypeStandard:
        {
            _mapView.mapType = MKMapTypeHybrid;
        }
        break;
            
        default:
            break;
    }
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
//    [_mapView removeFromSuperview];
    _mapView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - WS Call

- (void)getAllStores
{
    if([[NetworkAvailability instance] isReachable])
    {
        [SVProgressHUD showWithStatus:GetAllStoresMsg];
        
        long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
        
        [[WebServiceConnector alloc]init:URL_GetAllStores
                          withParameters:@{
                                           @"user_id":[NSString stringWithFormat:@"%ld",user_id]
                                           }
                              withObject:self
                            withSelector:@selector(DisplayResults:)
                          forServiceType:@"JSON"
                          showDisplayMsg:GetAllStoresMsg];
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
            arrStores = [sender responseArray];
            
            arrTempStores = [arrStores copy];
            
            [_tblSearchResults reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //This code will run in the main thread:
                CGRect frame = _tblSearchResults.frame;
                frame.size.height = _tblSearchResults.contentSize.height;
                _tblSearchResults.frame = frame;
            });

            
            for (int i = 0; i<arrTempStores.count; i++)
            {
                Store *objStore = [arrTempStores objectAtIndex:i];
                
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                [annotation setCoordinate:CLLocationCoordinate2DMake([objStore.latitude floatValue], [objStore.longitude floatValue])];
                [annotation setTitle:objStore.storeName];
                [annotation setSubtitle:objStore.storeAddress];
                [self.mapView addAnnotation:annotation];
            }
            
            MKMapRect zoomRect = MKMapRectNull;
            
            for (id <MKAnnotation> annotation in _mapView.annotations)
            {
                MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
            
            [_mapView setVisibleMapRect:zoomRect animated:YES];
        }
        else
        {
            [AZNotification showNotificationWithTitle:[[sender responseDict] valueForKey:@"message"]
                                           controller:self
                                     notificationType:AZNotificationTypeError];
        }
    }
}

#pragma mark - Setting Layout

- (void)setLayout
{
    [self removeUISearchBarBackgroundInViewHierarchy:self.searchBar];
    self.searchBar.backgroundColor = [UIColor clearColor];
    
    _tblSearchResults.layer.cornerRadius = 10.0f;
    _tblSearchResults.clipsToBounds = YES;
}

- (void) removeUISearchBarBackgroundInViewHierarchy:(UIView *)view
{
    for (UIView *subview in [view subviews])
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
        else
        {
            [self removeUISearchBarBackgroundInViewHierarchy:subview];
        }
    }
}

- (void)closeKeyBoard
{
    [self.view endEditing:YES];
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _tblSearchResults.hidden = searchText.length > 0 ? NO : YES;
    
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"storeName CONTAINS[c] %@", searchText];//CONTAINS[c]
    arrTempStores = [arrStores filteredArrayUsingPredicate:pred];
    [_tblSearchResults reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //This code will run in the main thread:
        CGRect frame = _tblSearchResults.frame;
        frame.size.height = _tblSearchResults.contentSize.height;
        _tblSearchResults.frame = frame;
        
    });
    //Store *objStore = [arrTempStores objectAtIndex:indexPath.row];
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[BaseVC sharedInstance] getRowsforTable:tableView
                                           forArray:(NSMutableArray *)arrTempStores
                                    withPlaceHolder:@"No Result Found"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tblSearchResults.hidden = YES;
    
    _searchBar.text = NULL;
    
    [_searchBar resignFirstResponder];

    Store *objStore = [arrTempStores objectAtIndex:indexPath.row];
    
    _mapView.centerCoordinate = CLLocationCoordinate2DMake([objStore.latitude floatValue], [objStore.longitude floatValue]);
    
    for (id <MKAnnotation> annotation in _mapView.annotations)
    {
        
        if ([objStore.latitude floatValue] == [annotation coordinate].latitude && [objStore.longitude floatValue] == [annotation coordinate].longitude)
        {
            [_mapView selectAnnotation:annotation animated:YES];
            break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    Store *objStore = [arrTempStores objectAtIndex:indexPath.row];

    cell.textLabel.text = objStore.storeName;
    
    return cell;
}

#pragma mark - Map Configuration and Methods

- (void)configureMap
{
    if ([CLLocationManager locationServicesEnabled])
    {
        if (self.locationManager == nil)
        {
            if (_beaconRegion == nil)
            {
                self.locationManager = [[CLLocationManager alloc] init];
                self.locationManager.delegate = self;
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                self.locationManager.distanceFilter = kCLDistanceFilterNone;
                [self.locationManager requestAlwaysAuthorization];
                
                NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"8DE29DD6-B667-4A51-B91F-48038B3F5278"];
                
                _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                   identifier:@"com.MyStoreScoutConsumerApp"];
                
                [self.locationManager startMonitoringForRegion:_beaconRegion];
                [self.locationManager startRangingBeaconsInRegion:_beaconRegion];
            }
        }
    }

    [self.locationManager startUpdatingLocation];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, 3000, 3000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    for (UIView *subview in _searchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(closeKeyBoard)];
                [done setTintColor:[UIColor blackColor]];
                
                UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
                doneToolbar.barStyle = UIBarStyleDefault;
                doneToolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:nil], done];
                [doneToolbar sizeToFit];
                textField.inputAccessoryView = doneToolbar;
                break;
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 2)
    {
//        CLBeacon *beaconA = [beacons objectAtIndex:0];
//        CLBeacon *beaconB = [beacons objectAtIndex:1];
//        CLBeacon *beaconC = [beacons objectAtIndex:2];
        // caclculate each beacon distance from current location and through which get current location and start navigating
    }
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

    if (isFirstTime)
    {
        self.mapView.centerCoordinate = annotation.coordinate;//self.mapView.userLocation.location.coordinate;
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
        
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    isFirstTime = NO;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"%f %f",[view.annotation coordinate].latitude, [view.annotation coordinate].longitude);
    for (int i = 0; i<arrStores.count; i++)
    {
        Store *objStore = [arrStores objectAtIndex:i];
        
        if ([objStore.latitude floatValue] == [view.annotation coordinate].latitude && [objStore.longitude floatValue] == [view.annotation coordinate].longitude)
        {
            StoreInfoVC *storeInfoVC = STORYBOARD_ID(@"idStoreInfoVC");
            
            storeInfoVC.objStore = objStore;
            
            [self.navigationController pushViewController:storeInfoVC animated:YES];
            
            break;
        }
    }
}

#pragma mark - Button Click Events

- (IBAction)btnMenuClicked:(id)sender
{
    [self.view endEditing:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
