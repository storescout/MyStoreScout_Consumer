//
//  NearByStoresVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "NearByStoresVC.h"

@interface NearByStoresVC ()
{
    BOOL isFirstTime;
    double latitude;
    double lontitude;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Setting Layout

- (void)setLayout
{
    [self removeUISearchBarBackgroundInViewHierarchy:self.searchBar];
    self.searchBar.backgroundColor = [UIColor clearColor];
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

#pragma mark - Map Configuration and Methods

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
        self.mapView.centerCoordinate = location.coordinate;//self.mapView.userLocation.location.coordinate;
        isFirstTime = NO;
    }
}

#pragma mark - Button Click Events

- (IBAction)btnMenuClicked:(id)sender
{
    [self.view endEditing:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
