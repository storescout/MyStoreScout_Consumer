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

@interface StoreVC ()
{
    BOOL isWalkingPath; // check if object is walking path
    BOOL isBeacon; // check if object is beacon

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
    
//    CGPoint currentLocation = [self getCoordinateWithBeaconA:CGPointMake(50, 50)
//                                                     beaconB:CGPointMake(300, 200)
//                                                     beaconC:CGPointMake(50, 300)
//                                                   distanceA:150
//                                                   distanceB:250
//                                                   distanceC:100];
    
    CGPoint currentLocation = [self getCoordinateWithBeaconA:CGPointMake(50, 100)
                                                     beaconB:CGPointMake(100, 100)
                                                     beaconC:CGPointMake(150, 100)
                                                   distanceA:111.80
                                                   distanceB:100
                                                   distanceC:111.80];
    
    
    TRC_NRM(@"%f %f", currentLocation.x, currentLocation.y);
    
    // TODO: Loading/Drawing Pre-Existing Layout
    
    if (_objStore.racks.count > 0)
    {
        for (int i = 0; i < _objStore.racks.count; i++)
        {
            isWalkingPath = NO;
            isBeacon = NO;
            
            
            Racks *rack = [_objStore.racks objectAtIndex:i];
            
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
            
                if ([rack.rackType isEqualToString:@"2"])
                {
                    isWalkingPath = YES;
                }
                else if ([rack.rackType isEqualToString:@"4"])
                {
                    isBeacon = YES;
                }
                
                shapeLayer = isBeacon ? [self initializeBeaconLayer] : [self initializeShapeLayerWithID:rack.rackType];
                
                if (isBeacon)
                {
                    X = X - HALF(BEACON_WIDTH);
                    Y = Y - HALF(BEACON_HEIGHT);
                    width = BEACON_WIDTH;
                    height = BEACON_HEIGHT;
                }

                
                shapeLayer.path = [self drawRackFromStartingX:X
                                                         andY:Y
                                                    withWidth:width
                                                    andHeight:height].CGPath;
            }
        }
        [SVProgressHUD dismiss];
    }
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

@end
