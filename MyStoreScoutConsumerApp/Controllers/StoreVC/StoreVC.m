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
#import <Popover/Popover-Swift.h>
#import "Products.h"
#import "ShoppingList.h"

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)
//#define NULL_NUMBER         INFINITY
//#define NULL_POINT          CGPointMake(NULL_NUMBER, NULL_NUMBER)
//#define RADIANS(degrees)    ((degrees * M_PI) / 180.0)

@interface StoreVC ()<CLLocationManagerDelegate, UIApplicationDelegate>
{
    BOOL isWalkingPath; // check if object is walking path
    BOOL isBeacon; // check if object is beacon

    NSArray *arrayBeacons;
    NSMutableArray *arrBeaconUUID;
    UILabel *lblText;
    UIImageView *imgEntry;
    UIImageView *imgExit;
    CAShapeLayer *shapeLayer;
    CAShapeLayer *pathLayer;
//    NSDictionary *destBeacon;
    UIBezierPath *UserPath;// all the object initiator
    UILabel *lblUserLocation;
    UIImageView *imgUserLocation;
    NSString *strNearestBeacon;
    CGFloat beaconWidth;
    NSInteger lineLength;
    CGFloat lastAccX;
    CGFloat lastAccY;
    CGPoint userLocation;
    CGFloat lastAccDistance;
    NSMutableArray *arrBeaconDetail;
    BOOL isEntryBeaconDetect;
    NSMutableArray *arrOffers;
    NSMutableArray *arrProductBeacon;
    NSMutableArray *arrAllRackPosition;
//    NSArray *arrShoppingList;
    NSMutableArray *arrShoppingListProducts;
    int CallDrawPathCount;
    NSString *strLineIntersectDirection;
    NSString *strBoughtProductId;
    BOOL areAdsRemoved;
}
typedef struct {
    CGPoint point1;
    CGPoint point2;
} CGLine;

typedef CGPoint CGDelta;

@property (strong, nonatomic) CLBeaconRegion *region1;
@property (strong, nonatomic) Popover *popover;
@property (strong, nonatomic) UIImageView *imgPopUp;
@end

@implementation StoreVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    CallDrawPathCount = 0;
    isEntryBeaconDetect = NO;
    _lblTitle.text = _objStore.storeName;
    lblUserLocation = [[UILabel alloc] init];
    imgUserLocation = [[UIImageView alloc] init];
    arrOffers = [[NSMutableArray alloc] init];
    arrProductBeacon = [[NSMutableArray alloc] init];
    arrAllRackPosition = [[NSMutableArray alloc] init];
    _arrShoppingList = [[NSArray alloc] init];
    arrShoppingListProducts = [[NSMutableArray alloc] init];
    [self getAllShoppingListItems];
    
    [self GetAllOffersStoreId:_objStore.storeIdentifier];
    [self.view addSubview:lblUserLocation];
    _imgBackground.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _imgBackground.layer.borderWidth = 3.0f;
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    
    [self.locationManager startUpdatingLocation];
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadAds];
   /*
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"fda50693-a4e2-4fb1-afcf-c6eb07647825"];
    
    CLBeaconRegion *region1 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                      major:10035
                                                                      minor:56498
                                                                 identifier:@"a"];
    region1.notifyOnEntry = YES;
    region1.notifyOnExit = YES;
    region1.notifyEntryStateOnDisplay = YES;
    
    CLBeaconRegion *region2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                      major:23
                                                                      minor:22
                                                                 identifier:@"ab"];
    region2.notifyOnEntry = YES;
    region2.notifyOnExit = YES;
    region2.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startMonitoringForRegion:region1];
    [self.locationManager startRangingBeaconsInRegion:region1];
    
    [self.locationManager startMonitoringForRegion:region2];
    [self.locationManager startRangingBeaconsInRegion:region2];
    */
    
    
    
    //Coded By: Anjali Jariwala
//    arrayBeacons = @[@{@"uuid":@"f7826da6-4fa2-4e98-8024-bc5b71e0893e",@"major" : @"22225", @"minor" : @"28689", @"entry_text" : @"GWNM"},
//                     @{@"uuid":@"f7826da6-4fa2-4e98-8024-bc5b71e0893e",@"major" : @"8938", @"minor" : @"30293", @"entry_text" : @"ca0h"},
//                     @{@"uuid":@"fda50693-a4e2-4fb1-afcf-c6eb07647825",@"major" : @"10035", @"minor" : @"56498", @"entry_text" : @"Narola"}];
    
    [self initiateBeaconsAndLocation];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_objStore.racks.count > 0)
    {
        
        [SVProgressHUD showWithStatus:@"Loading Layout"];
        
    }
    
    for (int i = 0; i < _arrShoppingList.count; i++) {
        ShoppingList *list = [_arrShoppingList objectAtIndex:i];
        UIButton *btnProduct = (UIButton *)[self.view viewWithTag:[list.productId integerValue]];
        if ([list.isBought isEqualToString:@"1"]) {
            [btnProduct setImage:[UIImage imageNamed:@"deactiveBeacon"] forState:UIControlStateNormal];
        }
        else
        {
            [btnProduct setImage:[UIImage imageNamed:@"activeBeacon"] forState:UIControlStateNormal];
        }
        
    }
    
    
//    [self getAllShoppingListItems];
//
//    [self GetAllOffersStoreId:_objStore.storeIdentifier];
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // TODO: Loading/Drawing Pre-Existing Layout
    
    if (_objStore.racks.count > 0)
    {
        isWalkingPath = NO;
        isBeacon = NO;
        
//        [self drawLayoutForArray:[NSMutableArray arrayWithArray:_objStore.racks]];
        
        [SVProgressHUD dismiss];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    isEntryBeaconDetect = NO;
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
                lblText.frame = CGRectMake(X, Y, [rack.rackWidth floatValue],[rack.rackHeight floatValue]/*width, height*/);
                
                
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
//                shapeLayer = isBeacon ? [self initializeBeaconLayer] : [self initializeShapeLayerWithID:rack.rackType];
                
                if (isBeacon) {
                    if ([arrShoppingListProducts containsObject:rack.Product_name]) {
                        
                        shapeLayer = [self initializeBeaconLayer:YES];
                    }
                    else
                    {
                        shapeLayer = [self initializeBeaconLayer:NO];
                    }
                }
                else
                {
                    shapeLayer = [self initializeShapeLayerWithID:rack.rackType];
                }
                
            
                
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
//                    shapeLayer.path = [self drawRackFromStartingX:X
//                                                             andY:Y
//                                                        withWidth:width
//                                                        andHeight:height].CGPath;
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
                    NSLog(@"Beacon");
                    beaconWidth = width;
                    shapeLayer.frame = CGRectMake(X, Y, width - 1, height + 3);
                    
                   
                    
                    UIButton *btnBeacon = [[UIButton alloc] init];
                    btnBeacon.frame = [_imgBackground convertRect:CGPathGetBoundingBox(shapeLayer.path) toView:self.view];
                    btnBeacon.tag = rack.Product_id.integerValue;
//                    [btnBeacon setBackgroundColor:[UIColor yellowColor]];
                    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                               initWithTarget:self
                                                               action:@selector(handleLongPress:)];
                    longPress.minimumPressDuration = 1.0;
                    longPress.accessibilityLabel = rack.Product_name;
                    [btnBeacon addGestureRecognizer:longPress];
                    
                    if ([arrShoppingListProducts containsObject:rack.Product_name]) {
                        
                        [btnBeacon setImage:[UIImage imageNamed:@"activeBeacon"] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        [btnBeacon setImage:[UIImage imageNamed:@"deactiveBeacon"] forState:UIControlStateNormal];
                    }
                    btnBeacon.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [btnBeacon addTarget:self action:@selector(btnBeaconAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:btnBeacon];
                }
            }
        }
        isWalkingPath = NO;
        isBeacon = NO;
        
        CGRect rect = CGRectMake(X, Y, width, height);
        [arrAllRackPosition addObject:[NSValue valueWithCGRect:rect]];
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

- (CAShapeLayer *)initializeBeaconLayer:(BOOL)isWishList
{
    shapeLayer = [[CAShapeLayer alloc] init];
    
//    if (isWishList) {
//        [shapeLayer setContents:(__bridge id)[UIImage imageNamed: @"activeBeacon"].CGImage];
//    }
//    else
//    {
//        [shapeLayer setContents:(__bridge id)[UIImage imageNamed: @"deactiveBeacon"].CGImage];
//    }
    
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3.0f;
    shapeLayer.zPosition = 2;
    [shapeLayer setName:@"4"]; // "4" defines rack type of beacon
    [_imgBackground.layer insertSublayer:shapeLayer atIndex:2];
   
//    [shapeLayer setNeedsDisplay];
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
- (IBAction)btnBeaconAction:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    
    NSString *strMsg = @"";
    if ([sender.imageView.image isEqual:[UIImage imageNamed:@"activeBeacon"]]) {
        strMsg = @"Are you sure you want to check product in your favourite list?";
    }
    else
    {
        strMsg = @"Are you sure you want to uncheck product in your favourite list?";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",_lblTitle.text] message:strMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSPredicate *Predicate =
        [NSPredicate predicateWithFormat:@"productId = %@", [NSString stringWithFormat:@"%ld",(long)sender.tag]];
        NSArray *arrFilter = [[NSArray alloc] init];
        arrFilter = [_arrShoppingList filteredArrayUsingPredicate:Predicate];
        
        if ([arrFilter count] > 0) {
            ShoppingList *objShoppingList = (ShoppingList *) arrFilter[0];
            if ([objShoppingList.isBought isEqualToString:@"0"]) {
                if([[NetworkAvailability instance] isReachable])
                {
                    long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
                    
                    [SVProgressHUD showWithStatus:CheckShoppingListProductAsBoughtMsg];
                    [self.view setUserInteractionEnabled:NO];
                    strBoughtProductId = objShoppingList.productId;
                    [[WebServiceConnector alloc]init:URL_CheckShoppingListProductAsBought
                                      withParameters:@{
                                                       @"user_id":[NSString stringWithFormat:@"%ld",user_id],
                                                       @"id":objShoppingList.shoppingListIdentifier,
                                                       @"is_bought": @"1"
                                                       }
                                          withObject:self
                                        withSelector:@selector(DisplayShoppingListResults:)
                                      forServiceType:@"JSON"
                                      showDisplayMsg:CheckShoppingListProductAsBoughtMsg];
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
                //            [AZNotification showNotificationWithTitle:AlreadyPurchase_ERR
                //                                           controller:self
                //                                     notificationType:AZNotificationTypeError];
                [SVProgressHUD showErrorWithStatus:AlreadyPurchase_ERR withViewController:self];
            }
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:IsBought_ERR withViewController:self];
            //        [AZNotification showNotificationWithTitle:IsBought_ERR
            //                                       controller:self
            //                                 notificationType:AZNotificationTypeError];
        }
        NSLog(@"Filtered Array : \n%@", arrFilter);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (IBAction)btnCloseAction:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        [_imgOfferRibbon setHidden:YES];
        [_vwOfferMain setHidden:YES];
//        _vwOfferMain.frame = CGRectMake(1000, _vwOfferMain.frame.origin.y, _vwOfferMain.frame.size.width, _vwOfferMain.frame.size.height);
    }];
}

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
    //                if ([[[arrayBeacons objectAtIndex:i] valueForKey:@"uuid"] isEqualToString:beaconRegion.proximityUUID.UUIDString] && [[[arrayBeacons objectAtIndex:i] valueFo
    
    
    
    
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
    NSLog(@"error: %@",[error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //hjbjbhjk
    NSLog(@"error: %@",[error localizedDescription]);
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


- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self.locationManager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region
//-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    NSLog(@"%@", beacons);
    
    
    if (beacons.count > 0) {
        
        CLBeacon *beacon = [beacons objectAtIndex:0];
        lastAccDistance = [beacon accuracy];
        NSLog(@"Distance : %f",[beacon accuracy]);
        if ([beacon proximity] == CLProximityNear || [beacon proximity] == CLProximityImmediate)
        {
            _lblDistance.text = [NSString stringWithFormat:@"%@ is %0.2fm away from your location",region.identifier, [beacon accuracy]];
            [self CalculateUserCurrentLocation:beacon beaconRegion:region distance:[beacon accuracy]];
        }
        else if([beacon proximity] == CLProximityFar)
        {
            NSLog(@"%@", [NSString stringWithFormat:@"%@ is %0.2fm away from your location",region.identifier, [beacon accuracy]]);
            if ([region.identifier isEqualToString:strNearestBeacon]) {
                _lblDistance.text = [NSString stringWithFormat:@"%@: %f",region.identifier, [beacon accuracy]];
                [self CalculateUserCurrentLocation:beacon beaconRegion:region distance:[beacon accuracy]];
            }
            
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    /*if(state == CLRegionStateInside)
    {
        [_popover dismiss];
        NSArray *filteredObj = [_objStore.racks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"beaconIdentifier == %@", region.identifier]];
        CGFloat X = [self convertSquareFeetToPixelsForHorizontalValue:[[filteredObj.firstObject valueForKey:@"positionX"] floatValue]];
        CGFloat Y = [self convertSquareFeetToPixelsForVerticalValue:[[filteredObj.firstObject valueForKey:@"positionY"] floatValue]];
        
        CGFloat width = [self convertSquareFeetToPixelsForHorizontalValue:[self convertSquareFeetToPixelsForVerticalValue:[[filteredObj.firstObject valueForKey:@"rackWidth"] floatValue]]];
            CGFloat height = [self convertSquareFeetToPixelsForVerticalValue:[self convertSquareFeetToPixelsForVerticalValue:[[filteredObj.firstObject valueForKey:@"rackHeight"] floatValue]]];
//        X = X - HALF(width);
//        Y = Y - HALF(height);
        
        _popover = [[Popover alloc] init];
        _popover.showBlackOverlay = NO ;
        
        UILabel *lblProductName = [[UILabel alloc] init];
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(X, Y - 3, 100, 55)];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 96, 46)];
        [img setImage:[UIImage imageNamed:@"BG_POPUP1"]];
        lblProductName.frame = CGRectMake(0.0, 0.0, 100, 50);
        vw.center = lblProductName.center;
        lblProductName.numberOfLines = 2;
        lblProductName.textAlignment = NSTextAlignmentCenter;
//        [lblProductName sizeToFit];
        [img addSubview:lblProductName];
        [vw addSubview:img];
        [img addSubview:lblProductName];
        if ([[filteredObj.firstObject valueForKey:@"beaconType"] isEqualToString:@"0"]) {
            lblProductName.text = @"Entry";
        }
        else if ([[filteredObj.firstObject valueForKey:@"beaconType"] isEqualToString:@"1"])
        {
            lblProductName.text = @"Exit";
        }
        else
        {
            lblProductName.text = [filteredObj.firstObject valueForKey:@"Product_name"];
        }
        
        lblProductName.textColor = [UIColor whiteColor];
        [lblProductName setFont:[UIFont boldSystemFontOfSize:12.0]];
        _popover.popoverType = UIPopoverArrowDirectionAny;
        _popover.animationIn = 0.1;
        _popover.animationOut = 0.2;
//        if (CGRectContainsRect(_imgBackground.frame, lblUserLocation.frame)) {
//            NSLog(@"User location displayed inside rect");
//        }
//        else
//        {
//            NSLog(@"User location displayed outside rect");
//            
//            if (Y < _imgBackground.frame.origin.y) {
//                // Upside
//                [_popover show:vw point:CGPointMake(X, _imgBackground.frame.origin.y - 5) inView:_imgBackground];
//            }
//            else if (X < _imgBackground.frame.origin.x)
//            {
//                //LeftSide
//                [_popover show:vw point:CGPointMake(5, Y) inView:_imgBackground];
//            }
//            else if (Y > _imgBackground.frame.origin.y + _imgBackground.frame.size.height)
//            {
//                //DownSide
//                [_popover show:vw point:CGPointMake(X, _imgBackground.frame.size.height - 55) inView:_imgBackground];
//            }
//            else if (X > _imgBackground.frame.origin.x + _imgBackground.frame.size.width)
//            {
//                //RightSide
//                [_popover show:vw point:CGPointMake(_imgBackground.frame.size.width - 100, Y) inView:_imgBackground];
//            }
//        }
        
        
        [_popover show:vw point:CGPointMake(X, Y) inView:_imgBackground];
        _popover.layer.zPosition = 1;
        
    }
    else if(state == CLRegionStateOutside)
    {
        [_popover dismiss];
    }
    else
    {
        return;
    }*/
}

#pragma mark --------- UserDefined Functions -----------------
-(void)initiateBeaconsAndLocation
{
    /*
     arrayBeacons = @[@{@"uuid":@"f7826da6-4fa2-4e98-8024-bc5b71e0893e",@"major" : @"22225", @"minor" : @"28689", @"entry_text" : @"GWNM"},
     @{@"uuid":@"f7826da6-4fa2-4e98-8024-bc5b71e0893e",@"major" : @"8938", @"minor" : @"30293", @"entry_text" : @"ca0h"},
     @{@"uuid":@"fda50693-a4e2-4fb1-afcf-c6eb07647825",@"major" : @"10035", @"minor" : @"56498", @"entry_text" : @"Narola"}];

     */
    
    //Get all floor map Beacons from service
    
    arrayBeacons = [_objStore.racks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"beaconIdentifier != nil"]];
    NSArray *arrTemp = [_objStore.racks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"beaconType = '2'"]];
    NSLog(@"Products: %@", arrTemp);
    if (arrProductBeacon.count == 0) {
        for (int i = 0; i < arrTemp.count; i++) {
            [arrProductBeacon addObject:[arrTemp[i] valueForKey:@"Product_id"]];
        }
    }
    
//    NSMutableArray *arrayBeaconsAdd = [[NSMutableArray alloc] init];
    arrBeaconDetail = [[NSMutableArray alloc] init];
    arrBeaconUUID = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayBeacons.count; i ++)
    {
        
//        if ([[[arrayBeacons objectAtIndex:i] valueForKey:@"beaconIdentifier"] isEqualToString:@"GWNM"]) {
//            destBeacon = [arrayBeacons objectAtIndex:i];
//        }
        
        NSString *strUUID = [NSString stringWithFormat:@"%@",[[arrayBeacons objectAtIndex:i] valueForKey:@"beaconUuid"]];
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:strUUID];
        [arrBeaconUUID addObject:[[NSUUID alloc] initWithUUIDString:strUUID]];
        //Get all Position of beacon
        NSString *x = [[arrayBeacons valueForKey:@"positionX"] objectAtIndex:i];
        NSString *y = [[arrayBeacons valueForKey:@"positionY"] objectAtIndex:i];
        NSString *width = [[arrayBeacons valueForKey:@"rackWidth"] objectAtIndex:i];
        NSString *height = [[arrayBeacons valueForKey:@"rackHeight"] objectAtIndex:i];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:x,@"x",y,@"y",width,@"width",height,@"height", nil];
        NSDictionary *dictTemp = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:dict] forKeys:[NSArray arrayWithObject:[[arrayBeacons objectAtIndex:i] valueForKey:@"beaconIdentifier"]]];
        [arrBeaconDetail addObject:dictTemp];
        
    }
//    arrBeacons = [arrayBeaconsAdd mutableCopy];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    
    //dynamic management for monitoring beacons
    for (int i = 0; i < arrayBeacons.count; i++)
    {
        int major = [[[arrayBeacons valueForKey:@"beaconMajor"] objectAtIndex:i] intValue];
        int minor = [[[arrayBeacons valueForKey:@"beaconMinor"] objectAtIndex:i] intValue];
        CLBeaconRegion *myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[arrBeaconUUID objectAtIndex:i] major:major minor:minor identifier:[arrayBeacons[i] valueForKey:@"beaconIdentifier"]];
        myBeaconRegion.notifyOnEntry = YES;
        myBeaconRegion.notifyOnExit = YES;
        myBeaconRegion.notifyEntryStateOnDisplay = YES;
        
        self.locationManager.delegate = self;
        [myBeaconRegion setNotifyEntryStateOnDisplay:YES];
        [self.locationManager startMonitoringForRegion:myBeaconRegion];
        [self.locationManager startRangingBeaconsInRegion:myBeaconRegion];
        
    }
    BaseVC *base = [BaseVC sharedInstance];
    base.arrGlobalBeacon = arrayBeacons;
    base.strStoreName = _lblTitle.text;
}



//Find Userlocation By getting position of nearest iBeacon
-(void)CalculateUserCurrentLocation:(CLBeacon *)nearestiBeacon beaconRegion:(CLBeaconRegion *)beaconRegion distance:(CGFloat)distance
{
    NSLog(@"Beacon : %@", nearestiBeacon);
    NSLog(@"Region : %@", beaconRegion);
    NSLog(@"Beacon Identifier : %@", beaconRegion.identifier);
   
    #warning : Get Nearest iBeacon rect position
    NSArray *filteredObj = [_objStore.racks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"beaconIdentifier == %@", beaconRegion.identifier]];
    if (filteredObj.count > 0) {
        NSArray *filteredOfferObj = [arrOffers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Product_id == %@", [filteredObj[0] valueForKey:@"Product_id"]]];
        if (filteredOfferObj.count > 0) {
            NSLog(@"%@", filteredOfferObj);
            if([arrProductBeacon containsObject:[filteredObj[0] valueForKey:@"Product_id"]])
            {
                NSInteger index = [arrProductBeacon indexOfObject:[filteredObj[0] valueForKey:@"Product_id"]];
                [arrProductBeacon replaceObjectAtIndex:index withObject:@"0"];
                [UIView animateWithDuration:0.3 animations:^{
                    [_vwOfferMain setHidden:NO];
                    [self.view bringSubviewToFront:_vwOfferMain];
                    [self setUIForOffers:filteredOfferObj[0]];
                }];
            }
        }
    }
   
    NSInteger index = [_objStore.racks indexOfObject:filteredObj.firstObject];
    NSDictionary *dictTemp = filteredObj[0];
    NSLog(@"%ld", (long)index);
    NSLog(@"FILTERED : %f", [[filteredObj[0] valueForKey:@"positionX"] floatValue]);
    
    CGFloat X = [self convertSquareFeetToPixelsForHorizontalValue:[[filteredObj.firstObject valueForKey:@"positionX"] floatValue]];
    CGFloat Y = [self convertSquareFeetToPixelsForVerticalValue:[[filteredObj.firstObject valueForKey:@"positionY"] floatValue]];
    
    CGFloat width = [self convertSquareFeetToPixelsForHorizontalValue:[self convertSquareFeetToPixelsForVerticalValue:[[filteredObj.firstObject valueForKey:@"rackWidth"] floatValue]]];
    CGFloat height = [self convertSquareFeetToPixelsForVerticalValue:[self convertSquareFeetToPixelsForVerticalValue:[[filteredObj.firstObject valueForKey:@"rackHeight"] floatValue]]];
    X = X - HALF(width);
    userLocation = CGPointMake(X, Y);
//    imgUserLocation = [[UIImageView alloc] init];
    lblUserLocation.frame = CGRectMake(X + ((width/2) - 2), Y + ((height/2) - 2) + (distance + (beaconWidth/2)), 10 , 20);
   
    [imgUserLocation setImage:[UIImage imageNamed:@"userlocationActive"]];
    if (![strNearestBeacon isEqualToString:beaconRegion.identifier]) {
    lblUserLocation.frame = CGRectMake(X + ((width/2) - 2), Y + ((height/2) - 2) + (distance), 10 , 10);
    }
//    lblUserLocation.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userlocationActive"]];
    imgUserLocation.frame = CGRectMake(X + ((width/2) - 2), Y + ((height/2) - 2) + (distance), 15, 20)/*lblUserLocation.frame*/;
    imgUserLocation.contentMode = UIViewContentModeScaleToFill;
//    imgUserLocation.backgroundColor = [UIColor blueColor];
    strNearestBeacon = beaconRegion.identifier;
    
    if (CGRectContainsRect(_imgBackground.frame, lblUserLocation.frame)) {
        NSLog(@"User location displayed inside rect");
    }
    else
    {
        NSLog(@"User location displayed outside rect");
        
        if (imgUserLocation.frame.origin.y < _imgBackground.frame.origin.y) {
            // Upside
            imgUserLocation.frame = CGRectMake(imgUserLocation.frame.origin.x, _imgBackground.frame.origin.y + 5, imgUserLocation.frame.size.width, imgUserLocation.frame.size.height);
        }
        else if (imgUserLocation.frame.origin.x < _imgBackground.frame.origin.x)
        {
            //LeftSide
            imgUserLocation.frame = CGRectMake(_imgBackground.frame.origin.x + 5 , _imgBackground.frame.origin.y, imgUserLocation.frame.size.width, imgUserLocation.frame.size.height);
        }
        else if (imgUserLocation.frame.origin.y > _imgBackground.frame.origin.y + _imgBackground.frame.size.height)
        {
            //DownSide
            imgUserLocation.frame = CGRectMake(imgUserLocation.frame.origin.x , (_imgBackground.frame.origin.y + _imgBackground.frame.size.height) - 5, imgUserLocation.frame.size.width, imgUserLocation.frame.size.height);
        }
        else if (imgUserLocation.frame.origin.x > _imgBackground.frame.origin.x + _imgBackground.frame.size.width)
        {
            //RightSide
            imgUserLocation.frame = CGRectMake((_imgBackground.frame.origin.x + _imgBackground.frame.size.width) - 5 , imgUserLocation.frame.origin.y, imgUserLocation.frame.size.width, imgUserLocation.frame.size.height);
        }
    }
    
    [self.view addSubview:lblUserLocation];
    [self.view addSubview:imgUserLocation];
    [imgUserLocation sendSubviewToBack: self.view];
    
    if (_vwOfferMain.isHidden == NO) {
        [imgUserLocation setHidden:YES];
    }
    else
    {
        [imgUserLocation setHidden:NO];
    }
    
    
    
    CGRect beaconRect = CGRectMake(X, Y, width, height);
    //Check for entry point beacon
    NSLog(@"%@", [dictTemp valueForKey:@"beaconType"]);
    
    if ([[dictTemp valueForKey:@"beaconType"] isEqualToString:@"0"] && !isEntryBeaconDetect && CGRectContainsRect(beaconRect, lblUserLocation.frame)) {
        //Entry Point Beacon detected, Update Server DB counter
        isEntryBeaconDetect = YES;
        [self UpdateChekoutOptionCounterStoreId:[dictTemp valueForKey:@"storeId"]];
    }
    
 /*#warning : Get Destination iBeacon rect position
    NSArray *destFilteredObj = [_objStore.racks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"beaconIdentifier == %@", @"ca0h"]];
    CGFloat destX = [self convertSquareFeetToPixelsForHorizontalValue:[[destFilteredObj.firstObject valueForKey:@"positionX"] floatValue]];
    CGFloat destY = [self convertSquareFeetToPixelsForVerticalValue:[[destFilteredObj.firstObject valueForKey:@"positionY"] floatValue]];
 
    [_locationManager startMonitoringForRegion:beaconRegion];
    if (CallDrawPathCount == 0) {
        CallDrawPathCount+=1;
        [self DrawPathWithCheckConditionLineStartPoint:CGPointMake(X + HALF(width) + distance, Y)  LineEndPoint:CGPointMake(destX, destY)];
    }*/
    
    
}

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
    [self.view setUserInteractionEnabled:YES];
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
            
            if ([[[sender responseDict] allKeys] containsObject:@"data"]) {
                _arrShoppingList = [sender responseArray];
                for (int i = 0; i<_arrShoppingList.count; i++) {
                    ShoppingList *objShoppingList = [_arrShoppingList objectAtIndex:i];
                    
                    Products *objProduct = [objShoppingList.productdetail objectAtIndex:0];
                    
                    if ([objShoppingList.isBought isEqualToString:@"0"]) {
                        [arrShoppingListProducts addObject:objProduct.productName];
                    }
                    else
                    {
                        [arrShoppingListProducts addObject:@""];
                    }
                    
                }
                if (_objStore.racks.count > 0)
                {
                    [self drawLayoutForArray:[NSMutableArray arrayWithArray:_objStore.racks]];
                    
                    [SVProgressHUD dismiss];
                }
                
            }
        }
        else
        {
            [AZNotification showNotificationWithTitle:[[sender responseDict] valueForKey:@"message"] controller:self notificationType:AZNotificationTypeError];
        }
    }
}

- (void)DisplayShoppingListResults:(id)sender
{
    [SVProgressHUD dismiss];
    [self.view setUserInteractionEnabled:YES];
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
            NSLog(@"%@", [sender responseArray]);
            
//            for (int i = 0; i < [[sender responseArray] count]; i++) {
//                ShoppingList *objShoppingList = [[sender responseArray] objectAtIndex:i];
//                if ([objShoppingList.isBought isEqualToString:@"1"]) {
//                     UIButton *btnProduct = (UIButton *)[self.view viewWithTag:[objShoppingList.productId integerValue]];
//                    [btnProduct setImage:[UIImage imageNamed: @"deactiveBeacon"] forState:UIControlStateNormal];
//                }
//                else
//                {
//                    UIButton *btnProduct = (UIButton *)[self.view viewWithTag:[objShoppingList.productId integerValue]];
//                    [btnProduct setImage:[UIImage imageNamed: @"activeBeacon"] forState:UIControlStateNormal];
//                }
//            }
            UIButton *btnProduct = (UIButton *)[self.view viewWithTag:[strBoughtProductId integerValue]];
//            [btnProduct setBackgroundColor:[UIColor redColor]];
//            UIImage *img = btnProduct.imageView.image;
            [btnProduct setImage:[UIImage imageNamed: @"deactiveBeacon"] forState:UIControlStateNormal];
            
//             UIImage *img1 = btnProduct.imageView.image;
//            [shapeLayer setContents:(__bridge id)[UIImage imageNamed: @"deactiveBeacon"].CGImage];
        }
        else
        {
            [AZNotification showNotificationWithTitle:[[sender responseDict] valueForKey:@"message"] controller:self notificationType:AZNotificationTypeError];
        }
    }
}


- (void)GetAllOffersStoreId:(NSString *)strStoreId
{
    if([[NetworkAvailability instance] isReachable])
    {
        [SVProgressHUD showWithStatus:GetAllOffersMsg];
       [self.view setUserInteractionEnabled:NO];
        
        [[WebServiceConnector alloc]init:URL_GetAllOffers
                          withParameters:@{
                                           @"store_id" : strStoreId,
                                           @"is_testdata":isTestData
                                           }
                              withObject:self
                            withSelector:@selector(DisplayAllOffersResults:)
                          forServiceType:@"JSON"
                          showDisplayMsg:GetAllOffersMsg];
        
//        NSMutableDictionary *dictPara = [[NSMutableDictionary alloc] init];
//        [dictPara setValue:strStoreId forKey:@"store_id"];
//        [dictPara setValue:@"1" forKey:@"is_testdata"];

    }
    else
    {
        [AZNotification showNotificationWithTitle:NETWORK_ERR
                                       controller:self
                                 notificationType:AZNotificationTypeError];
    }
}

- (void)DisplayAllOffersResults:(id)sender
{
    
    [self.view setUserInteractionEnabled:YES];
    NSLog(@"%@", [sender responseDict]);
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
            arrOffers = [[sender responseDict] valueForKey:@"data"];
            
        }
        else
        {
            [AZNotification showNotificationWithTitle:[[sender responseDict] valueForKey:@"message"] controller:self notificationType:AZNotificationTypeError];
        }
    }
}

-(void)setUIForOffers:(NSDictionary *)dictData
{
    _lblProductName.text = [arrOffers[0] valueForKey:@"Product_name"];
    
    if ([arrOffers[0] valueForKey:@"flyer_description"] == [NSNull null]) {
        _lblOfferDescription.text = @"";
    }
    else
    {
        _lblOfferDescription.text = [arrOffers[0] valueForKey:@"flyer_description"];
    }
    
    _lblOfferDescription.frame = CGRectMake(_lblOfferDescription.frame.origin.x, _lblOfferDescription.frame.origin.y,_vwSubOffer.frame.size.width - (2 * _lblOfferDescription.frame.origin.x) , _lblOfferDescription.frame.size.height);
//    [_lblOfferDescription sizeToFit];
    NSString *strPath = [NSString stringWithFormat:@"%s%@",SERVER,[arrOffers[0] valueForKey:@"flyer_img"]];
    
    if ([arrOffers[0] valueForKey:@"flyer_img"] == [NSNull null]) {
        [_imgProduct setImage:[UIImage imageNamed:@"Default_Image"]];
    }
    else
    {
        [_imgProduct sd_setImageWithURL:[NSURL URLWithString:strPath]
                       placeholderImage:[UIImage imageNamed:@"Default_Image"]];
    }
    
    [_imgOfferRibbon setHidden:NO];
}

- (void)getAllShoppingListItems
{
    if([[NetworkAvailability instance] isReachable])
    {
        long user_id = [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_USER_ID];
        [self.view setUserInteractionEnabled:NO];
        [SVProgressHUD showWithStatus:GetAllProductsMsg];
        [self.view setUserInteractionEnabled:NO];
        [[WebServiceConnector alloc]init:URL_GetShoppingList
                          withParameters:@{
                                           @"user_id":[NSString stringWithFormat:@"%ld",user_id],
                                           @"role_id":role_id
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

-(void)handleLongPress:(UILongPressGestureRecognizer*)recognizer
{
    NSLog(@"double oo");
    if (recognizer.state == UIGestureRecognizerStateBegan){
        [UIView animateWithDuration:2.0 animations:^{
            _vwBottom.frame = CGRectMake(0.0, SCREEN_HEIGHT - _vwBottom.frame.size.height, _vwBottom.frame.size.width, _vwBottom.frame.size.height);
            _lblBottomProduct.text = recognizer.accessibilityLabel;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:4.0 animations:^{
                _vwBottom.frame = CGRectMake(0.0, SCREEN_HEIGHT , _vwBottom.frame.size.width, _vwBottom.frame.size.height);
            } completion:nil];
        }];
        _lblBottomProduct.text = recognizer.accessibilityLabel;
    }
}

#pragma mark - GAD Ads functions
-(void)loadAds
{
    if (areAdsRemoved) {
        [_bannerView setHidden:YES];
        [self.view updateConstraintsIfNeeded];
    }
    else
    {
        
         [_bannerView setHidden:NO];
        _bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
        _bannerView.delegate = self;
        _bannerView.rootViewController = self;
        [_bannerView loadRequest:[GADRequest request]];
    }
    
}

/*- (BOOL)RectContainsLineRect:(CGRect)r StartPoint:(CGPoint)lineStart EndPoint:(CGPoint)lineEnd
{
    BOOL (^LineIntersectsLine)(CGPoint, CGPoint, CGPoint, CGPoint) = ^BOOL(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End)
    {
        CGFloat q =
        //Distance between the lines' starting rows times line2's horizontal length
        (line1Start.y - line2Start.y) * (line2End.x - line2Start.x)
        //Distance between the lines' starting columns times line2's vertical length
        - (line1Start.x - line2Start.x) * (line2End.y - line2Start.y);
        CGFloat d =
        //Line 1's horizontal length times line 2's vertical length
        (line1End.x - line1Start.x) * (line2End.y - line2Start.y)
        //Line 1's vertical length times line 2's horizontal length
        - (line1End.y - line1Start.y) * (line2End.x - line2Start.x);
        
        if( d == 0 )
            return NO;
        
        CGFloat r = q / d;
        
        q =
        //Distance between the lines' starting rows times line 1's horizontal length
        (line1Start.y - line2Start.y) * (line1End.x - line1Start.x)
        //Distance between the lines' starting columns times line 1's vertical length
        - (line1Start.x - line2Start.x) * (line1End.y - line1Start.y);
        
        CGFloat s = q / d;
        if( r < 0 || r > 1 || s < 0 || s > 1 )
            return NO;
        
        
        return YES;
    };
 
    /*Test whether the line intersects any of:
     *- the bottom edge of the rectangle
     *- the right edge of the rectangle
     *- the top edge of the rectangle
     *- the left edge of the rectangle
     *- the interior of the rectangle (both points inside)
     */
    
    /*if (LineIntersectsLine(lineStart, lineEnd, CGPointMake(r.origin.x, r.origin.y), CGPointMake(r.origin.x + r.size.width, r.origin.y))) {
        NSLog(@"the bottom edge of the rectangle");
        strLineIntersectDirection = @"BottomEdge";
    }
    else if (LineIntersectsLine(lineStart, lineEnd, CGPointMake(r.origin.x + r.size.width, r.origin.y), CGPointMake(r.origin.x + r.size.width, r.origin.y + r.size.height)))
    {
        NSLog(@"the right edge of the rectangle");
        strLineIntersectDirection = @"RightEdge";
    }
    else if (LineIntersectsLine(lineStart, lineEnd, CGPointMake(r.origin.x + r.size.width, r.origin.y + r.size.height), CGPointMake(r.origin.x, r.origin.y + r.size.height)))
    {
        NSLog(@"the top edge of the rectangle");
        strLineIntersectDirection = @"TopEdge";
    }
    else if (LineIntersectsLine(lineStart, lineEnd, CGPointMake(r.origin.x, r.origin.y + r.size.height), CGPointMake(r.origin.x, r.origin.y)))
    {
        NSLog(@"the left edge of the rectangle");
        strLineIntersectDirection = @"LeftEdge";
    }
    else if (CGRectContainsPoint(r, lineStart) && CGRectContainsPoint(r, lineEnd))
    {
        NSLog(@"the interior of the rectangle (both points inside)");
        strLineIntersectDirection = @"Inside";
    }
    
    return (LineIntersectsLine(lineStart, lineEnd, CGPointMake(r.origin.x, r.origin.y), CGPointMake(r.origin.x + r.size.width, r.origin.y)) ||
            LineIntersectsLine(lineStart, lineEnd, CGPointMake(r.origin.x + r.size.width, r.origin.y), CGPointMake(r.origin.x + r.size.width, r.origin.y + r.size.height)) ||
            LineIntersectsLine(lineStart, lineEnd, CGPointMake(r.origin.x + r.size.width, r.origin.y + r.size.height), CGPointMake(r.origin.x, r.origin.y + r.size.height)) ||
            LineIntersectsLine(lineStart, lineEnd, CGPointMake(r.origin.x, r.origin.y + r.size.height), CGPointMake(r.origin.x, r.origin.y)) ||
            (CGRectContainsPoint(r, lineStart) && CGRectContainsPoint(r, lineEnd)));
    
   
}

-(void)EndPathAtIntersectionPoint:(CGPoint)StartPoint EndPoint:(CGPoint)EndPoint
{
    [pathLayer removeFromSuperlayer];
    
    pathLayer = [[CAShapeLayer alloc] init];
    pathLayer.fillColor = [UIColor redColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    pathLayer.zPosition = 2;
    [pathLayer setName:@"4"]; // "4" defines rack type of beacon
    [_imgBackground.layer insertSublayer:pathLayer atIndex:2];
    
    
    UserPath = nil;
    [_imgBackground setNeedsDisplay];
    UserPath = [UIBezierPath bezierPath];
    
    [UserPath moveToPoint:StartPoint];
    [UserPath addLineToPoint:EndPoint]; // right top point of rack
    [UserPath closePath];
}



-(void)DrawPathWithCheckConditionLineStartPoint:(CGPoint)startPoint LineEndPoint:(CGPoint)endPoint
{
    BOOL isIntersect = false;
    
    for (int i = 0; i < arrAllRackPosition.count; i++) {
        
        if ([self RectContainsLineRect:[arrAllRackPosition[i] CGRectValue] StartPoint:startPoint EndPoint:endPoint]) {
            isIntersect = YES;
            NSLog(@"path intersect");
//            [pathLayer removeFromSuperlayer];
            
            //Check if line start point intersect reck
            //BottomEdge,RightEdge,TopEdge,LeftEdge,Inside
            
            if (/*[self RectContainsLineRect:[arrAllRackPosition[i] CGRectValue] StartPoint:startPoint EndPoint:startPoint]*//*[strLineIntersectDirection isEqualToString:@"Inside"]) {
                //Point inside Reck
                CGRect reckPosition = [arrAllRackPosition[i] CGRectValue];
                CGFloat lineEndPointX = startPoint.x;
                CGFloat lineEndPointY = reckPosition.origin.y + reckPosition.size.height + 5;
                
                [self DrawLineStartPoint:startPoint LineEndPoint:CGPointMake(lineEndPointX, lineEndPointY)];
                
                CGPoint LineStartPoint = CGPointMake(lineEndPointX, lineEndPointY);
                CGPoint LineEndPoint = CGPointMake(((reckPosition.origin.x + reckPosition.size.width) - startPoint.x), startPoint.y);
                [self DrawLineStartPoint:LineStartPoint LineEndPoint:LineEndPoint];
                
                LineStartPoint = LineEndPoint;
                LineEndPoint = endPoint;
                [self DrawLineStartPoint:LineStartPoint LineEndPoint:LineEndPoint];
                return;
            }
            else if ([strLineIntersectDirection isEqualToString:@"BottomEdge"])
            {
                
            }
            else if ([strLineIntersectDirection isEqualToString:@"RightEdge"])
            {
               
            }
            else if ([strLineIntersectDirection isEqualToString:@"TopEdge"])
            {
                
            }
            else if ([strLineIntersectDirection isEqualToString:@"LeftEdge"])
            {
                
            }
            
            //check rack point where line intersect
            CGLine line = CGLineMake(startPoint, endPoint);
            [self EndPathAtIntersectionPoint:startPoint EndPoint:CGLineIntersectsRectAtPoint([arrAllRackPosition[i] CGRectValue], line)];
            NSLog(@"%@", NSStringFromCGPoint(CGLineIntersectsRectAtPoint([arrAllRackPosition[i] CGRectValue], line)));
        }
        else
        {
            isIntersect = NO;
            NSLog(@"path not intersect");
        }
    }
    
    if (!isIntersect) {
        [self DrawLineStartPoint:startPoint LineEndPoint:endPoint];
    }
    
    
}

- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    for (int i = 0 ; i < count ; ++i)
    {
        CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ) / 255.0f;
        CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / alpha;
        CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / alpha;
        CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / alpha;
        byteIndex += bytesPerPixel;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}


-(void)DrawLineStartPoint:(CGPoint)startPoint LineEndPoint:(CGPoint)endPoint
{
    [pathLayer removeFromSuperlayer];
    
    pathLayer = [[CAShapeLayer alloc] init];
    pathLayer.fillColor = [UIColor redColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    pathLayer.zPosition = 2;
    [pathLayer setName:@"4"]; // "4" defines rack type of beacon
    [_imgBackground.layer insertSublayer:pathLayer atIndex:2];
    
    
    UserPath = nil;
    [_imgBackground setNeedsDisplay];
    UserPath = [UIBezierPath bezierPath];
    
    [UserPath moveToPoint:startPoint];
    [UserPath addLineToPoint:endPoint]; // right top point of rack
    [UserPath closePath];
    pathLayer.path = UserPath.CGPath;
}

#pragma mark - Lines [.C Functions]

CGLine CGLineMake(CGPoint point1, CGPoint point2)
{
    CGLine line;
    line.point1.x = point1.x;
    line.point1.y = point1.y;
    line.point2.x = point2.x;
    line.point2.y = point2.y;
    return line;
}

CGFloat CGPointDistance(CGPoint p1, CGPoint p2)
{
    CGFloat dx = p1.x - p2.x;
    CGFloat dy = p1.y - p2.y;
    CGFloat dist = sqrt(pow(dx, 2) + pow(dy, 2));
    return dist;
}

#pragma mark - Rectangles [.C Functions]

CGPoint CGRectTopLeftPoint(CGRect rect)
{
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
}

CGPoint CGRectTopRightPoint(CGRect rect)
{
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
}

CGPoint CGRectBottomLeftPoint(CGRect rect)
{
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
}

CGPoint CGRectBottomRightPoint(CGRect rect)
{
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

CGFloat CGLineLength(CGLine line)
{
    return CGPointDistance(line.point1, line.point2);
}
CGDelta CGDeltaMake(CGFloat deltaX, CGFloat deltaY)
{
    CGDelta delta;
    delta.x = deltaX;
    delta.y = deltaY;
    return delta;
}

CGDelta CGLineDelta(CGLine line)
{
    return CGDeltaMake(line.point2.x - line.point1.x, line.point2.y - line.point1.y);
}

CGLine CGLineScale(CGLine line, CGFloat scale)
{
    CGDelta lineDelta = CGLineDelta(line);
    CGFloat scaledDeltaX = lineDelta.x * scale;
    CGFloat scaledDeltaY = lineDelta.y * scale;
    return CGLineMake( CGPointMake(line.point1.x, line.point1.y), CGPointMake(line.point1.x + scaledDeltaX, line.point1.y + scaledDeltaY) );
}

CGPoint CGLinesIntersectAtPoint(CGLine line1, CGLine line2)
{
    CGFloat mua,mub;
    CGFloat denom,numera,numerb;
    
    double x1 = line1.point1.x;
    double y1 = line1.point1.y;
    double x2 = line1.point2.x;
    double y2 = line1.point2.y;
    double x3 = line2.point1.x;
    double y3 = line2.point1.y;
    double x4 = line2.point2.x;
    double y4 = line2.point2.y;
    
    denom  = (y4-y3) * (x2-x1) - (x4-x3) * (y2-y1);
    numera = (x4-x3) * (y1-y3) - (y4-y3) * (x1-x3);
    numerb = (x2-x1) * (y1-y3) - (y2-y1) * (x1-x3);
    
    // Are the lines coincident?
    if (MT_ABS(numera) < MT_EPS && MT_ABS(numerb) < MT_EPS && MT_ABS(denom) < MT_EPS) {
        return CGPointMake( (x1 + x2) / 2.0 , (y1 + y2) / 2.0);
    }
    
    // Are the line parallel
    if (MT_ABS(denom) < MT_EPS) {
        return CGPointZero //NULL_POINT;
    }
    
    // Is the intersection along the the segments
    mua = numera / denom;
    mub = numerb / denom;
    if (mua < 0 || mua > 1 || mub < 0 || mub > 1) {
        return CGPointZero //NULL_POINT;
    }
    return CGPointMake(x1 + mua * (x2 - x1), y1 + mua * (y2 - y1));
}

CGPoint CGLineIntersectsRectAtPoint(CGRect rect, CGLine line)
{
    CGLine top      = CGLineMake( CGPointMake( CGRectGetMinX(rect), CGRectGetMinY(rect) ), CGPointMake( CGRectGetMaxX(rect), CGRectGetMinY(rect) ) );
    CGLine right    = CGLineMake( CGPointMake( CGRectGetMaxX(rect), CGRectGetMinY(rect) ), CGPointMake( CGRectGetMaxX(rect), CGRectGetMaxY(rect) ) );
    CGLine bottom   = CGLineMake( CGPointMake( CGRectGetMinX(rect), CGRectGetMaxY(rect) ), CGPointMake( CGRectGetMaxX(rect), CGRectGetMaxY(rect) ) );
    CGLine left     = CGLineMake( CGPointMake( CGRectGetMinX(rect), CGRectGetMinY(rect) ), CGPointMake( CGRectGetMinX(rect), CGRectGetMaxY(rect) ) );
    
    // ensure the line extends beyond outside the rectangle
    CGFloat topLeftToBottomRight = CGPointDistance(CGRectTopLeftPoint(rect), CGRectBottomRightPoint(rect));
    CGFloat bottomLeftToTopRight = CGPointDistance(CGRectBottomLeftPoint(rect), CGRectTopRightPoint(rect));
    CGFloat maxDimension = MT_MAX(topLeftToBottomRight, bottomLeftToTopRight);
    CGFloat scaleFactor = maxDimension / MT_MIN(CGLineLength(line), maxDimension);
    CGLine extendedLine = CGLineScale(line, scaleFactor + 3);
    
    CGPoint points[4] = { CGLinesIntersectAtPoint(top, extendedLine), CGLinesIntersectAtPoint(right, extendedLine), CGLinesIntersectAtPoint(bottom, extendedLine), CGLinesIntersectAtPoint(left, extendedLine) };
    
    for (int i = 0; i < 4; i++) {
        CGPoint p = points[i];
        if (!CGPointEqualToPoint(p, CGPointZero/*NULL_POINT)) {
            return p;
        }
    }
    
    return CGPointZero /*NULL_POINT;
}*/

@end
