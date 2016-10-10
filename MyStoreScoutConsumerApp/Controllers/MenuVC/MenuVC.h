//
//  MenuVC.h
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 08/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *vwImageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UITableView *tblMenu;

@end
