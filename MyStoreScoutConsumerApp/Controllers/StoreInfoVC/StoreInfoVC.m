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
}
@end

@implementation StoreInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureMap];
    
    _lblTitle.text = _objStore.storeName;
    _lblAddress.text = _objStore.storeAddress;
    _lblContactNumber.text = _objStore.contactNo;
    _lblTimings.text = [NSString stringWithFormat:@"%@ - %@", _objStore.startTime, _objStore.endTime];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(contactNumberTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    [_lblContactNumber addGestureRecognizer:tapGesture];
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
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",latitude,lontitude,view.annotation.coordinate.latitude,view.annotation.coordinate.longitude]];

//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=21.1702,72.8311&daddr=23.0225,72.5714"]];
//    [[UIApplication sharedApplication] openURL:URL];
    
    NSString *url = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", latitude, lontitude,[_objStore.latitude floatValue],[_objStore.longitude floatValue]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}

@end
