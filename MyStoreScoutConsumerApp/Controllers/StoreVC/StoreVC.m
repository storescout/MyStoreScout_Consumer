//
//  StoreVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 10/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "StoreVC.h"

@interface StoreVC ()

@end

@implementation StoreVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lblTitle.text = _objStore.storeName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Click Events

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
