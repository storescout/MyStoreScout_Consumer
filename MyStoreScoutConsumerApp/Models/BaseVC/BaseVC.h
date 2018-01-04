//
//  BaseVC.h
//  MyStoreScout
//
//  Created by C205 on 12/09/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : NSObject

/* -------------------------- */

+ (instancetype)sharedInstance;

/* -------------------------- */


- (void)addAlertBoxWithText:(NSString *)message
                       toVC:(UIViewController *)VC;

- (void) addBottomLineToTextFields:(NSArray *)textFieldArray;

- (void)addCornerRadiusToViews:(NSArray *)views;

- (void)addCustomPlaceHolderToTextField:(UITextField *)textField
                        withPlaceHolder:(NSString *)placeHolder;

- (void)addLeftPaddingForTextFields:(NSArray *)textFields;

- (NSString *)encodeToBase64String:(UIImage *)image;

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;

- (NSInteger)getRowsforTable:(UITableView *)tableView
                    forArray:(NSMutableArray *)array
             withPlaceHolder: (NSString *)strPlaceHolder;

- (NSInteger)getRowsforCollection:(UICollectionView *)collectionView
                         forArray:(NSMutableArray *)array
                  withPlaceHolder: (NSString *)strPlaceHolder;

- (void)addRefreshControl:(UIRefreshControl *)refreshControl
                  toTable:(UITableView *)tableView
       withViewController:(UIViewController *)VC
              forSelector:(SEL)handlingMethod;

- (BOOL)image:(UIImage *)image1
    isEqualTo:(UIImage *)image2;

- (UIImage *)fixOrientation:(UIImage *)receivedImage;

- (UIImage *)compressImage:(UIImage *)image;

/* -------------------------- */
@property (nonatomic, readwrite) NSArray *arrGlobalBeacon;
@property (nonatomic, readwrite) NSString *strStoreName;
@end
