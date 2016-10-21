//
//  ShoppingListVC.h
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *vwPopUp;
@property (strong, nonatomic) IBOutlet UITableView *tblShoppingList;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnAddItem;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteAll;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITextField *txtAddItem;
@property (strong, nonatomic) IBOutlet UIView *vwAddItem;
@property (strong, nonatomic) IBOutlet UIView *vwAddItemContainer;
@property (strong, nonatomic) IBOutlet UITableView *tblResults;
@property (weak, nonatomic) IBOutlet UILabel *lblAddItem;

- (IBAction)btnOptionsClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnAddItemClicked:(id)sender;
- (IBAction)btnSelectClicked:(id)sender;
- (IBAction)btnDeleteAllClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;

@end
