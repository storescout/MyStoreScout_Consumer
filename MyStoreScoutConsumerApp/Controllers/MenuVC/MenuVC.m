//
//  MenuVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 08/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "MenuVC.h"

@interface MenuVC ()
{
    UINavigationController *navigation;
}
@end

@implementation MenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)navigateToViewController:(UIViewController *)viewController
{
    navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    navigation.navigationBar.hidden = YES;
    
    if ([navigation respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigation.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [APP_CONTEXT.drawerController setCenterViewController:navigation
                               withCloseAnimation:YES
                                       completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [DefaultsValues setIntegerValueToUserDefaults:(int)indexPath.row ForKey:KEY_SELECTED_MENU];
    [tableView reloadData];
    [self navigateToViewController:[self.storyboard instantiateViewControllerWithIdentifier:indexPath.row == 0 ? @"idStoresVC" : @"idShoppingListVC"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = indexPath.row == [DefaultsValues getIntegerValueFromUserDefaults_ForKey:KEY_SELECTED_MENU] ? rgb(0, 0, 0, 0.3) : [UIColor clearColor];
    cell.textLabel.text = indexPath.row == 0 ? @"Home" : @"Shopping List";
    
    return cell;
}

@end
