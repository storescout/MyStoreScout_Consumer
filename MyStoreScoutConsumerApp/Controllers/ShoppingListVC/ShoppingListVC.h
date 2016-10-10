//
//  ShoppingListVC.h
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *vwPopUp;
@property (weak, nonatomic) IBOutlet UITableView *tblShoppingList;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnAddItem;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteAll;

- (IBAction)btnOptionsClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnAddItemClicked:(id)sender;
- (IBAction)btnSelectClicked:(id)sender;
- (IBAction)btnDeleteAllClicked:(id)sender;

@end
