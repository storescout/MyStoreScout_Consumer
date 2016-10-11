//
//  StoreVC.h
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 10/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"

@interface StoreVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (nonatomic, strong) Store *objStore;

- (IBAction)btnBackClicked:(id)sender;

@end
