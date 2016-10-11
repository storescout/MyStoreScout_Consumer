//
//  ShoppingListVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "ShoppingListVC.h"
#import "ShoppingListCell.h"

@interface ShoppingListVC ()

@end

@implementation ShoppingListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.00001 * NSEC_PER_SEC), dispatch_get_main_queue(),^
    {
        _vwAddItem.layer.cornerRadius = 10.0f;
        _vwAddItem.clipsToBounds = YES;
        
        [[BaseVC sharedInstance] addBottomLineToTextFields:@[_txtAddItem]];
        
        [[BaseVC sharedInstance] addCustomPlaceHolderToTextField:_txtAddItem
                                                 withPlaceHolder:@"Add item name"];
    });
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [_vwAddItemContainer addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Tap Gesture Handling Method

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (!CGRectContainsRect(_vwAddItem.frame, CGRectMake([sender locationInView:self.view].x, [sender locationInView:self.view].y, 1, 1)))
    {
        [UIView transitionWithView:_vwAddItemContainer
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _vwAddItemContainer.hidden = !_vwAddItemContainer.hidden;
                        }
                        completion:^(BOOL finished) {
                            [self.view endEditing:YES];
                            _txtAddItem.enabled = NO;
                        }];
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    NSLog(@"Deleted row.");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_vwPopUp.hidden)
    {
        [UIView transitionWithView:_vwPopUp
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _vwPopUp.hidden = YES;
                        }
                        completion:NULL];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : rgb(242, 242, 242, 1.0);
    
    [cell.btnIsChecked setImage:[UIImage imageNamed:indexPath.row % 2 == 0 ? @"IMG_UNCHECKED" : @"IMG_CHECKED"] forState:UIControlStateNormal];
    
    cell.btnIsChecked.tag = indexPath.row;
    
    [cell.btnIsChecked addTarget:self
                          action:@selector(handleCheckBoxTap:)
                forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Check Box Handling Events

- (IBAction)handleCheckBoxTap:(UIButton *)sender
{
    NSLog(@"I have pressed button at index %ld",(long)[sender tag]);
    
    [sender setImage:[UIImage imageNamed:@"IMG_CHECKED"] forState:UIControlStateNormal];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!_vwPopUp.hidden)
    {
        [UIView transitionWithView:_vwPopUp
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _vwPopUp.hidden = YES;
                        }
                        completion:NULL];
    }
}

#pragma mark - Button Click Events

- (IBAction)btnOptionsClicked:(id)sender
{
    [UIView transitionWithView:_vwPopUp
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        _vwPopUp.hidden = !_vwPopUp.hidden;
                    }
                    completion:NULL];
}

- (IBAction)btnBackClicked:(id)sender
{
    if (!_vwPopUp.hidden)
    {
        [UIView transitionWithView:_vwPopUp
                          duration:0.1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _vwPopUp.hidden = YES;
                        }
                        completion:^(BOOL finished){
                            [self.view endEditing:YES];
                            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }];
    }
    else
    {
        [self.view endEditing:YES];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

- (IBAction)btnAddItemClicked:(id)sender
{
    if (!_vwPopUp.hidden)
    {
        [UIView transitionWithView:_vwPopUp
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            _vwPopUp.hidden = YES;
                        }
                        completion:NULL];
    }
    [UIView transitionWithView:_vwAddItemContainer
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        _vwAddItemContainer.hidden = !_vwAddItemContainer.hidden;
                        _txtAddItem.enabled = !_txtAddItem.enabled;
                    }
                    completion:nil];
}

- (IBAction)btnSelectClicked:(id)sender
{
    //[self.navigationController pushViewController:STORYBOARD_ID(@"idStoreInfoVC") animated:YES];
}

- (IBAction)btnDeleteAllClicked:(id)sender
{
}

- (IBAction)btnSaveClicked:(id)sender
{
}

- (IBAction)btnCancelClicked:(id)sender
{
    [UIView transitionWithView:_vwAddItemContainer
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        _vwAddItemContainer.hidden = !_vwAddItemContainer.hidden;
                    }
                    completion:^(BOOL finished) {
                        
                        [self.view endEditing:YES];
                        
                        _txtAddItem.enabled = NO;
                    }];
}

@end
