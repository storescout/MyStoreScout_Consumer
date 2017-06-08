//
//  StoreVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 10/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "StoreVC.h"
#import "Racks.h"
#import "MenuVC.h"

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)

@interface StoreVC ()
{
    BOOL isWalkingPath; // check if object is walking path
    BOOL isBeacon; // check if object is beacon

    UILabel *lblText;
    UIImageView *imgEntry;
    UIImageView *imgExit;
    CAShapeLayer *shapeLayer; // all the object initiator
}
@end

@implementation StoreVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lblTitle.text = _objStore.storeName;
    
    _imgBackground.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _imgBackground.layer.borderWidth = 3.0f;
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
//    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    
    [self.locationManager startUpdatingLocation];
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"fda50693-a4e2-4fb1-afcf-c6eb07647825"];
    
    CLBeaconRegion *region1 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                      major:10035
                                                                      minor:56498
                                                                 identifier:@"a"];
    region1.notifyOnEntry = YES;
    region1.notifyOnExit = YES;
    region1.notifyEntryStateOnDisplay = YES;
    
//    CLBeaconRegion *region2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
//                                                                      major:23
//                                                                      minor:22
//                                                                 identifier:@"ab"];
//    region2.notifyOnEntry = YES;
//    region2.notifyOnExit = YES;
//    region2.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startMonitoringForRegion:region1];
    [self.locationManager startRangingBeaconsInRegion:region1];
    
//    [self.locationManager startMonitoringForRegion:region2];
//    [self.locationManager startRangingBeaconsInRegion:region2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_objStore.racks.count > 0)
    {
        [SVProgressHUD showWithStatus:@"Loading Layout"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // TODO: Loading/Drawing Pre-Existing Layout
    
    if (_objStore.racks.count > 0)
    {
        isWalkingPath = NO;
        isBeacon = NO;
        
        [self drawLayoutForArray:[NSMutableArray arrayWithArray:_objStore.racks]];
            
        [SVProgressHUD dismiss];
    }
}

//static double calculateDistance(int txPower, double rssi) {
//    if (rssi == 0)
//    {
//        return -1.0; // if we cannot determine distance, return -1.
//    }
//    
//    double ratio = rssi*1.0/txPower;
//    
//    if (ratio < 1.0)
//    {
//        return pow(ratio,10);
//    }
//    else
//    {
//        double accuracy =  (0.89976)*pow(ratio,7.7095) + 0.111;
//        return accuracy;
//    }
//}

- (void)drawLayoutForArray:(NSMutableArray *)arrTemp
{
    for (int i = 0; i < arrTemp.count; i++)
    {
        Racks *rack = [arrTemp objectAtIndex:i];
        
        // converting values from square feet to pixels
        CGFloat X = [self convertSquareFeetToPixelsForHorizontalValue:[rack.positionX floatValue]];
        CGFloat Y = [self convertSquareFeetToPixelsForVerticalValue:[rack.positionY floatValue]];
        CGFloat width = [self convertSquareFeetToPixelsForHorizontalValue:[rack.rackWidth floatValue]];
        CGFloat height = [self convertSquareFeetToPixelsForVerticalValue:[rack.rackHeight floatValue]];
        
        if ([rack.rackType isEqualToString:@"6"] || [rack.rackType isEqualToString:@"7"])
        {
            if (X == 0.00)
            {
                Y = Y - HALF(ENTRY_EXIT_HEIGHT);
            }
            else if (Y == 0.00)
            {
                X = X - HALF(ENTRY_EXIT_WIDTH);
            }
            else if (X == _imgBackground.frame.size.width)
            {
                X = X - ENTRY_EXIT_WIDTH;
                Y = Y - HALF(ENTRY_EXIT_HEIGHT);
            }
            else if (Y == _imgBackground.frame.size.height)
            {
                X = X - HALF(ENTRY_EXIT_WIDTH);
                Y = Y - ENTRY_EXIT_HEIGHT;
            }
            
            width = ENTRY_EXIT_WIDTH;
            height = ENTRY_EXIT_HEIGHT;
            
            [rack.rackType isEqualToString:@"6"] ? [self addEntryPointForX:X
                                                                      andY:Y
                                                                  forWidth:width
                                                                 andHeight:height] : [self addExitPointForX:X
                                                                                                       andY:Y
                                                                                                   forWidth:width
                                                                                                  andHeight:height];
        }
        else
        {
            if ([rack.rackType isEqualToString:@"2"]) // check if rack is walking path
            {
                isWalkingPath = YES;
            }
            else if ([rack.rackType isEqualToString:@"4"])
            {
                isBeacon = YES;
            }
            if ([rack.rackType isEqualToString:@"8"])
            {
                X = X - HALF(width);
                Y = Y - HALF(height);
                width = width;
                height = height;
                
                lblText = [self initializeTextLayerWithSize:CGRectZero];
                lblText.frame = CGRectMake(X, Y, width, height);
                
                
                //                lblText.text = @"";
                
                lblText.accessibilityIdentifier = rack.storeText;
                
                NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[rack.storeText dataUsingEncoding:NSUnicodeStringEncoding]
                                                                               options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                    documentAttributes:nil
                                                                                 error:nil];
                lblText.attributedText = attrStr;
                //                [lblText sizeToFit];
                
            }
            else
            {
                shapeLayer = isBeacon ? [self initializeBeaconLayer] : [self initializeShapeLayerWithID:rack.rackType];
                
                
                X = X - HALF(width);
                Y = Y - HALF(height);
                width = width;
                height = height;
                
                shapeLayer.path = [self drawRackFromStartingX:X
                                                         andY:Y
                                                    withWidth:width
                                                    andHeight:height].CGPath;
                
                if (!isBeacon) // if it's not a beacon
                {
//                    numberOfRacks++;
//                    
//                    [self addPointsForX:X + HALF(width)
//                                   andY:Y + HALF(height)
//                           forRackWidth:width
//                              andHeight:height];
//                    
//                    [self addRoateButtonForX:X + HALF(width)
//                                        andY:Y + HALF(height)
//                                forRackWidth:width
//                                   andHeight:height];
                    
                    
                    
                    CGPathRef path = createPathRotatedAroundBoundingBoxCenter(shapeLayer.path, DEGREES_TO_RADIANS([rack.angle floatValue]));
                    shapeLayer.path  = path;
                    CGPathRelease(path);
                    
//                    [arrRacks addObject:shapeLayer];
//                    [arrTopPoints addObject:topPoint];
//                    [arrBottomPoints addObject:bottomPoint];
//                    [arrLeftPoints addObject:leftPoint];
//                    [arrRightPoints addObject:rightPoint];
//                    [arrRotateButtons addObject:btnRotate];
                }
                else
                {
//                    [arrBeacons addObject:shapeLayer];
                }
            }
        }
        isWalkingPath = NO;
        isBeacon = NO;
        
        [arrTemp removeObjectAtIndex:0];
        
        if (arrTemp.count != 0) {
            [self drawLayoutForArray:arrTemp];
        }
    }
}

static CGPathRef createPathRotatedAroundBoundingBoxCenter(CGPathRef path, CGFloat radians) // used to get path for rack at certain radians
{
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, center.x, center.y);
    transform = CGAffineTransformRotate(transform, radians);
    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
    return CGPathCreateCopyByTransformingPath(path, &transform);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGPoint)getCoordinateWithBeaconA:(CGPoint)a
                            beaconB:(CGPoint)b
                            beaconC:(CGPoint)c
                          distanceA:(CGFloat)dA
                          distanceB:(CGFloat)dB
                          distanceC:(CGFloat)dC
{
    CGFloat W, Z, x, y, y2;
    
    W = dA*dA - dB*dB - a.x*a.x - a.y*a.y + b.x*b.x + b.y*b.y;
    Z = dB*dB - dC*dC - b.x*b.x - b.y*b.y + c.x*c.x + c.y*c.y;
    
    x = (W*(c.y-b.y) - Z*(b.y-a.y)) / (2 * ((b.x-a.x)*(c.y-b.y) - (c.x-b.x)*(b.y-a.y)));
    y = (W - 2*x*(b.x-a.x)) / (2*(b.y-a.y));
    //y2 is a second measure of y to mitigate errors
    y2 = (Z - 2*x*(c.x-b.x)) / (2*(c.y-b.y));
    
    y = (y + y2) / 2;
    return CGPointMake(x, y);

//    float xa = a.x;
//    float ya = a.y;
//    float xb = b.x;
//    float yb = b.y;
//    float xc = c.x;
//    float yc = c.y;
//    float ra = dA;
//    float rb = dB;
//    float rc = dC;
//    
//    float S = (pow(xc, 2.) - pow(xb, 2.) + pow(yc, 2.) - pow(yb, 2.) + pow(rb, 2.) - pow(rc, 2.)) / 2.0;
//    float T = (pow(xa, 2.) - pow(xb, 2.) + pow(ya, 2.) - pow(yb, 2.) + pow(rb, 2.) - pow(ra, 2.)) / 2.0;
//    float y = ((T * (xb - xc)) - (S * (xb - xa))) / (((ya - yb) * (xb - xc)) - ((yc - yb) * (xb - xa)));
//    float x = ((y * (ya - yb)) - T) / (xb - xa);
//    
//    CGPoint point = CGPointMake(x, y);
//    return point;
}

#pragma mark - Initializations

- (CAShapeLayer *)initializeShapeLayerWithID:(NSString *)identifier // identifier defines rack type
{
    shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.15].CGColor;
    shapeLayer.strokeColor = isWalkingPath ? WALKING_PATH_STROKE_COLOR.CGColor : DEFAULT_STROKE_COLOR.CGColor;
    shapeLayer.lineWidth = 3.0;
    shapeLayer.zPosition = 1;
    [shapeLayer setName:identifier];
    [_imgBackground.layer insertSublayer:shapeLayer atIndex:1];
    return shapeLayer;
}

- (UILabel *)initializeTextLayerWithSize:(CGRect)rect
{
    UILabel *lblTextField = [[UILabel alloc] initWithFrame:CGRectZero];
    lblTextField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.15];

    lblTextField.accessibilityIdentifier = @"<b>Please</b>  Enter Your Text Here";
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[lblTextField.accessibilityIdentifier dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    lblTextField.attributedText = attrStr;
    
    lblTextField.textAlignment = NSTextAlignmentCenter;
    [lblTextField sizeToFit];
    lblTextField.userInteractionEnabled = YES;
    
    [_imgBackground addSubview:lblTextField];
    return lblTextField;
}

- (CAShapeLayer *)initializeBeaconLayer
{
    shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.fillColor = [UIColor blueColor].CGColor;
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.lineWidth = 3.0f;
    shapeLayer.zPosition = 2;
    [shapeLayer setName:@"4"]; // "4" defines rack type of beacon
    [_imgBackground.layer insertSublayer:shapeLayer atIndex:2];
    return shapeLayer;
}

- (UIBezierPath *)drawRackFromStartingX:(CGFloat)X
                                   andY:(CGFloat)Y
                              withWidth:(CGFloat)width
                              andHeight:(CGFloat)height
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(X, Y)]; // left top point of rack
    [path addLineToPoint:CGPointMake(X + width, Y)]; // right top point of rack
    [path addLineToPoint:CGPointMake(X + width, Y + height)]; // right bottom point of rack
    [path addLineToPoint:CGPointMake(X, Y + height)]; // left bottom point of rack
    [path closePath]; // closing rectangle/path
    
    if (isWalkingPath) // creating pattern if it is walking path, also adding middle line
    {
        const CGFloat dashPattern[] = {2,6,4,2}; // you can make pattern here
        [path setLineDash:dashPattern count:4 phase:3];
        shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:7], nil];
        shapeLayer.lineDashPhase = 3.0f;
        shapeLayer.fillColor = [UIColor colorWithRed:255/255.0 green:183/255.0 blue:184/255.0 alpha:1.0].CGColor;
        
        if (height > width)
        {
            [path moveToPoint:CGPointMake(X + HALF(width), Y)]; // middle top point of rack
            [path addLineToPoint:CGPointMake(X + HALF(width), Y + height)]; // middle bottom point of rack
        }
        else
        {
            [path moveToPoint:CGPointMake(X, Y + HALF(height))]; // middle left point of rack
            [path addLineToPoint:CGPointMake(X + width, Y + HALF(height))]; // middle right point of rack
        }
    }
    
    return path;
}

#pragma mark -  Adding Entry Point to Store

- (void)addEntryPointForX:(CGFloat)X
                     andY:(CGFloat)Y
                 forWidth:(CGFloat)width
                andHeight:(CGFloat)height
{
    imgEntry = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, width, height)];
    [imgEntry setImage:[UIImage imageNamed:@"Entry"]];
    [_imgBackground addSubview:imgEntry];
}

#pragma mark -  Adding Exit Point to Store

- (void)addExitPointForX:(CGFloat)X
                    andY:(CGFloat)Y
                forWidth:(CGFloat)width
               andHeight:(CGFloat)height
{
    imgExit = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, width, height)];
    [imgExit setImage:[UIImage imageNamed:@"Exit"]];
    [_imgBackground addSubview:imgExit];
}

#pragma mark - Unit Converters

- (CGFloat)convertSquareFeetToPixelsForHorizontalValue:(CGFloat)value
{
    return (_imgBackground.frame.size.width * value)/[_objStore.width floatValue];
}

- (CGFloat)convertSquareFeetToPixelsForVerticalValue:(CGFloat)value
{
    return (_imgBackground.frame.size.height * value)/[_objStore.height floatValue];
}

#pragma mark - Button Click Events

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnShoppingListClicked:(id)sender
{
    [DefaultsValues setIntegerValueToUserDefaults:1 ForKey:KEY_SELECTED_MENU];
    
    MenuVC *menuVC = (MenuVC *)self.mm_drawerController.leftDrawerViewController;
    [menuVC.tblMenu reloadData];
    
    [self.navigationController pushViewController:STORYBOARD_ID(@"idShoppingListVC") animated:YES];
}


- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    NSLog(@"Entered %@", region);
    UILocalNotification *ln = [[UILocalNotification alloc] init];
    ln.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    ln.alertTitle = @"You have entered in region.";
    ln.alertBody = [NSString stringWithFormat:@"Hooray!!"];
    ln.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:ln];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion*)region
{
    UILocalNotification *ln = [[UILocalNotification alloc] init];
    ln.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    ln.alertTitle = @"You have exited from region.";
    ln.alertBody = [NSString stringWithFormat:@"Bye Bye!!"];
    ln.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:ln];

    //    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    //    //[self.locationManager stopRangingBeaconsInRegion:beaconRegion];
    //
    //    if ([Utility isApplicationStateInactiveORBackground])
    //    {
    //        if ([Function getCustomObjectFromUserDefaults_ForKey:@"Beacons"])
    //        {
    //            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //
    //            arrayBeacons = [Function getCustomObjectFromUserDefaults_ForKey:@"Beacons"];
    //
    //
    //            NSString *stringUUID = @"";
    //            for (int i = 0 ; i < arrayBeacons.count; i++)
    //            {
    //                if ([[[arrayBeacons objectAtIndex:i] valueForKey:@"uuid"] isEqualToString:beaconRegion.proximityUUID.UUIDString] && [[[arrayBeacons objectAtIndex:i] valueForKey:@"major"] isEqualToString:[NSString stringWithFormat:@"%@",beaconRegion.major]] && [[[arrayBeacons objectAtIndex:i] valueForKey:@"minor"] isEqualToString:[NSString stringWithFormat:@"%@",beaconRegion.minor]])
    //                {
    //                    stringUUID = [[arrayBeacons objectAtIndex:i] valueForKey:@"uuid"];
    //                    localNotification.alertBody = [[arrayBeacons objectAtIndex:i] valueForKey:@"exit_text"];
    //                    break;
    //                }
    //            }
    //
    //            localNotification.alertTitle = @"myTourisma";
    //            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    //            localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //            localNotification.soundName = UILocalNotificationDefaultSoundName;
    //            localNotification.applicationIconBadgeNumber= [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    //            localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Exit", @"NotificationType",stringUUID, @"beaconUUID", nil];
    //
    //            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    //        }
    //
    //        for (int i = 0 ; i < arraySentNotifications.count; i++)
    //        {
    //            if ([[arraySentNotifications objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@ %@ %@",beaconRegion.proximityUUID.UUIDString,[NSString stringWithFormat:@"%@",beaconRegion.major],[NSString stringWithFormat:@"%@",beaconRegion.minor]]])
    //            {
    //                [arraySentNotifications removeObject:[NSString stringWithFormat:@"%@ %@ %@",beaconRegion.proximityUUID.UUIDString,[NSString stringWithFormat:@"%@",beaconRegion.major],[NSString stringWithFormat:@"%@",beaconRegion.minor]]];
    //                [Function setCustomObjectToUserDefaults:arraySentNotifications ForKey:BeaconsNotificationArray];
    //            }
    //        }
    //    }
    //    else
    //    {
    //        if ([Function getCustomObjectFromUserDefaults_ForKey:@"Beacons"])
    //        {
    //            arrayBeacons = [Function getCustomObjectFromUserDefaults_ForKey:@"Beacons"];
    //
    //            for (int i = 0 ; i < arrayBeacons.count; i++)
    //            {
    //                if ([[[arrayBeacons objectAtIndex:i] valueForKey:@"uuid"] isEqualToString:beaconRegion.proximityUUID.UUIDString] && [[[arrayBeacons objectAtIndex:i] valueForKey:@"major"] isEqualToString:[NSString stringWithFormat:@"%@",beaconRegion.major]] && [[[arrayBeacons objectAtIndex:i] valueForKey:@"minor"] isEqualToString:[NSString stringWithFormat:@"%@",beaconRegion.minor]])
    //                {
    //                    [labelCustomText setText:[[arrayBeacons objectAtIndex:i] valueForKey:@"exit_text"]];
    //                    [buttonCustomNotification setTag:3];
    //                    [self displayCustomNotification];
    //                    //[Global displayTost:[[arrayBeacons objectAtIndex:i] valueForKey:@"exit_text"]];
    //                    break;
    //                }
    //            }
    //
    //            for (int i = 0 ; i < arraySentNotifications.count; i++)
    //            {
    //                if ([[arraySentNotifications objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@ %@ %@",beaconRegion.proximityUUID.UUIDString,[NSString stringWithFormat:@"%@",beaconRegion.major],[NSString stringWithFormat:@"%@",beaconRegion.minor]]])
    //                {
    //                    [arraySentNotifications removeObject:[NSString stringWithFormat:@"%@ %@ %@",beaconRegion.proximityUUID.UUIDString,[NSString stringWithFormat:@"%@",beaconRegion.major],[NSString stringWithFormat:@"%@",beaconRegion.minor]]];
    //                    [Function setCustomObjectToUserDefaults:arraySentNotifications ForKey:BeaconsNotificationArray];
    //                }
    //            }
    //        }
    //    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}

double getDistance(int rssi, int txPower) {
    /*
     * RSSI = TxPower - 10 * n * lg(d)
     * n = 2 (in free space)
     *
     * d = 10 ^ ((TxPower - RSSI) / (10 * n))
     */
    
    return pow(10, ((double) txPower - rssi) / (10 * 2));
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
//    NSLog(@"%@", beacons);
    
    if (beacons.count > 0)
    {
        CLBeacon *foundBeacon;
        
        for (int i = 0; i < beacons.count; i++)
        {
            foundBeacon = [beacons objectAtIndex:i];
            
            switch (foundBeacon.proximity)
            {
                case CLProximityImmediate:
                    NSLog(@"found Intermediate %f", foundBeacon.accuracy);
                    _lblDistance.text = [NSString stringWithFormat:@"found Intermediate %f", foundBeacon.accuracy];
                    break;
                    
                case CLProximityFar:
                    NSLog(@"found Far %f", foundBeacon.accuracy);
                    _lblDistance.text = [NSString stringWithFormat:@"found Far %f", foundBeacon.accuracy];
                    break;
                    
                case CLProximityNear:
                    NSLog(@"found Near %f", foundBeacon.accuracy);
                    _lblDistance.text = [NSString stringWithFormat:@"found Near %f", foundBeacon.accuracy];
                    break;
                    
                case CLProximityUnknown:
                    NSLog(@"found Unknown %f", foundBeacon.accuracy);
                    _lblDistance.text = [NSString stringWithFormat:@"found Unknown %f", foundBeacon.accuracy];
                    break;
                    
                default:
                    break;
            }
            
            if ([foundBeacon proximity] == CLProximityNear || [foundBeacon proximity] == CLProximityImmediate || [foundBeacon proximity] == CLProximityFar)
            {
//                UILocalNotification *ln = [[UILocalNotification alloc] init];
//                ln.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//                ln.alertTitle = @"You have entered in region.";
//                ln.alertBody = [NSString stringWithFormat:@"Distance -> %.2f meters", foundBeacon.accuracy];
//                ln.timeZone = [NSTimeZone defaultTimeZone];
//                [[UIApplication sharedApplication] scheduleLocalNotification:ln];
            }
        }
        
    }
//        if ([foundBeacon proximity] == CLProximityNear || [foundBeacon proximity] == CLProximityImmediate || [foundBeacon proximity] == CLProximityFar)
    //    {
    //        float intRange = 0;
    //
    //        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //
    //        if ([Function getCustomObjectFromUserDefaults_ForKey:@"Beacons"])
    //        {
    //            arrayBeacons = [Function getCustomObjectFromUserDefaults_ForKey:@"Beacons"];
    //        }
    //
    //        NSString *stringUUID = @"";
    //        NSString *stringMajor = @"";
    //        NSString *stringMinor = @"";
    //
    //        for (int i = 0 ; i < arrayBeacons.count; i++)
    //        {
    //            if ([[[arrayBeacons objectAtIndex:i] valueForKey:@"uuid"] isEqualToString:foundBeacon.proximityUUID.UUIDString] && [[[arrayBeacons objectAtIndex:i] valueForKey:@"major"] isEqualToString:[NSString stringWithFormat:@"%@",foundBeacon.major]] && [[[arrayBeacons objectAtIndex:i] valueForKey:@"minor"] isEqualToString:[NSString stringWithFormat:@"%@",foundBeacon.minor]])
    //            {
    //                stringUUID = [[arrayBeacons objectAtIndex:i] valueForKey:@"uuid"];
    //                stringMajor = [[arrayBeacons objectAtIndex:i] valueForKey:@"major"];
    //                stringMinor = [[arrayBeacons objectAtIndex:i] valueForKey:@"minor"];
    //                intRange = [[[arrayBeacons objectAtIndex:i] valueForKey:@"range"] floatValue];
    //
    //                NSString *stringClose = [[arrayBeacons objectAtIndex:i] valueForKey:@"is_close_approach"];
    //                if ([stringClose isEqualToString:@"1"])
    //                {
    //                    localNotification.alertBody = [[arrayBeacons objectAtIndex:i] valueForKey:@"nearby_text"];
    //                    localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Near", @"NotificationType",stringUUID, @"beaconUUID",stringMajor, @"beaconMajor",stringMinor, @"beaconMinor", nil];
    //                    [buttonCustomNotification setTag:2];
    //                }
    //                else
    //                {
    //                    localNotification.alertBody = [[arrayBeacons objectAtIndex:i] valueForKey:@"entry_text"];
    //                    localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Enter", @"NotificationType",stringUUID, @"beaconUUID",stringMajor, @"beaconMajor",stringMinor, @"beaconMinor", nil];
    //                    [buttonCustomNotification setTag:1];
    //                }
    //
    //                break;
    //            }
    //        }
    //
    //        localNotification.alertTitle = @"myTourisma";
    //        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    //        localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //        localNotification.soundName = UILocalNotificationDefaultSoundName;
    //        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    //
    //
    //        float intAbsRange = foundBeacon.accuracy;
    //        intAbsRange = fabsf(intAbsRange);
    //        //NSLog(@"abs range = %f",intAbsRange);
    //
    //        if (intAbsRange <= intRange)
    //        {
    //            //Notification sent or not
    //            if ([Function getCustomObjectFromUserDefaults_ForKey:BeaconsNotificationArray])
    //            {
    //                arraySentNotifications = [Function getCustomObjectFromUserDefaults_ForKey:BeaconsNotificationArray];
    //            }
    //
    //            if (arraySentNotifications.count > 0)
    //            {
    //                int intAlreadyGenerated = 0;
    //                for (int i = 0 ; i < arraySentNotifications.count; i++)
    //                {
    //                    if ([[arraySentNotifications objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@ %@ %@",stringUUID,stringMajor,stringMinor]])
    //                    {
    //                        intAlreadyGenerated = 1;
    //                    }
    //                }
    //
    //                if (intAlreadyGenerated == 1)
    //                {}
    //                else
    //                {
    //                    if ([Utility isApplicationStateInactiveORBackground])
    //                    {
    //                        [arraySentNotifications addObject:[NSString stringWithFormat:@"%@ %@ %@",stringUUID,stringMajor,stringMinor]];
    //                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    //                        [Function setCustomObjectToUserDefaults:arraySentNotifications ForKey:BeaconsNotificationArray];
    //                    }
    //                    else
    //                    {
    //                        [arraySentNotifications addObject:[NSString stringWithFormat:@"%@ %@ %@",stringUUID,stringMajor,stringMinor]];//localNotification.alertBody
    //                        [Function setCustomObjectToUserDefaults:arraySentNotifications ForKey:BeaconsNotificationArray];
    //                        boolOpenBeaconPage = YES;
    //                        [labelCustomText setText:localNotification.alertBody];
    //                        [buttonCustomNotification setTitle:stringUUID forState:UIControlStateNormal];
    //                        //[buttonCustomNotification setTag:2];
    //                        [self displayCustomNotification];
    //                    }
    //                }
    //            }
    //            else
    //            {
    //                if ([Utility isApplicationStateInactiveORBackground])
    //                {
    //                    [arraySentNotifications addObject:[NSString stringWithFormat:@"%@ %@ %@",stringUUID,stringMajor,stringMinor]];
    //                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    //                    [Function setCustomObjectToUserDefaults:arraySentNotifications ForKey:BeaconsNotificationArray];
    //                }
    //                else
    //                {
    //                    [arraySentNotifications addObject:[NSString stringWithFormat:@"%@ %@ %@",stringUUID,stringMajor,stringMinor]];
    //                    [Function setCustomObjectToUserDefaults:arraySentNotifications ForKey:BeaconsNotificationArray];
    //
    //                    boolOpenBeaconPage = YES;
    //                    [labelCustomText setText:localNotification.alertBody];
    //                    [buttonCustomNotification setTitle:stringUUID forState:UIControlStateNormal];
    //                    //[buttonCustomNotification setTag:2];
    //                    [self displayCustomNotification];
    //                }
    //            }
    //        }
    //        else
    //        {
    //            /*for (int i = 0 ; i < arrayBeacons.count; i++)
    //             {
    //             if ([[[arrayBeacons objectAtIndex:i] valueForKey:@"uuid"] isEqualToString:foundBeacon.proximityUUID.UUIDString])
    //             {
    //             //manage beacons notification in array
    //             if ([arraySentNotifications containsObject:[[arrayBeacons objectAtIndex:i] valueForKey:@"nearby_text"]])
    //             {
    //             [arraySentNotifications removeObject:[[arrayBeacons objectAtIndex:i] valueForKey:@"nearby_text"]];
    //             [Function setCustomObjectToUserDefaults:arraySentNotifications ForKey:BeaconsNotificationArray];
    //             }
    //             }
    //             }*/
    //        }
    //    }
    //    else if ([foundBeacon proximity] == CLProximityImmediate)
    //    {}
    //    else if ([foundBeacon proximity] == CLProximityFar)
    //    {}
    //    else if ([foundBeacon proximity] == CLProximityUnknown)
    //    {
    //        /*for (int i = 0 ; i < arrayBeacons.count; i++)
    //         {
    //         if ([[[arrayBeacons objectAtIndex:i] valueForKey:@"uuid"] isEqualToString:foundBeacon.proximityUUID.UUIDString])
    //         {
    //         //manage beacons notification in array
    //         if ([arraySentNotifications containsObject:[NSString stringWithFormat:@"%@ %@ %@",[[arrayBeacons objectAtIndex:i] valueForKey:@"uuid"],[[arrayBeacons objectAtIndex:i] valueForKey:@"major"],[[arrayBeacons objectAtIndex:i] valueForKey:@"minor"]]])
    //         {
    //         [arraySentNotifications removeObject:[NSString stringWithFormat:@"%@ %@ %@",[[arrayBeacons objectAtIndex:i] valueForKey:@"uuid"],[[arrayBeacons objectAtIndex:i] valueForKey:@"major"],[[arrayBeacons objectAtIndex:i] valueForKey:@"minor"]]];
    //         [Function setCustomObjectToUserDefaults:arraySentNotifications ForKey:BeaconsNotificationArray];
    //         }
    //         }
    //         }*/
    //    }
        
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside)
    {
    }
    else if(state == CLRegionStateOutside)
    {
    }
    else
    {
        return;
    }
}


@end
