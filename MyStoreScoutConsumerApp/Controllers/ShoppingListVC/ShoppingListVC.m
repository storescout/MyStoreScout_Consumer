//
//  ShoppingListVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 07/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "ShoppingListVC.h"

@interface ShoppingListVC ()

@end

@implementation ShoppingListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_vwPopUp.hidden)
    {
        [UIView transitionWithView:_vwPopUp
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _vwPopUp.hidden = YES;
                        }
                        completion:NULL];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : rgb(242, 242, 242, 1.0);
    
    return cell;
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!_vwPopUp.hidden)
    {
        [UIView transitionWithView:_vwPopUp
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
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
                       options:UIViewAnimationOptionTransitionCrossDissolve
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
                           options:UIViewAnimationOptionTransitionCrossDissolve
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
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _vwPopUp.hidden = YES;
                        }
                        completion:NULL];
    }
    [self.navigationController pushViewController:STORYBOARD_ID(@"idStoreInfoVC") animated:YES];
}

- (IBAction)btnSelectClicked:(id)sender
{
}

- (IBAction)btnDeleteAllClicked:(id)sender
{
}

@end
