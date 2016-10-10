//
//  StoreInfoVC.m
//  MyStoreScoutConsumerApp
//
//  Created by C205 on 08/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "StoreInfoVC.h"

@interface StoreInfoVC ()

@end

@implementation StoreInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

#pragma mark - Button Click Events

- (IBAction)btnBackClicked:(id)sender
{
    
}

- (IBAction)btnEnterClicked:(id)sender
{
    [self.navigationController pushViewController:STORYBOARD_ID(@"idStoreVC") animated:YES];
}

- (IBAction)btnDirectionsClicked:(id)sender
{
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",latitude,lontitude,view.annotation.coordinate.latitude,view.annotation.coordinate.longitude]];

//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=21.1702,72.8311&daddr=23.0225,72.5714"]];
//    [[UIApplication sharedApplication] openURL:URL];
    
    NSString *url = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=21.1702,72.8311&daddr=23.0225,72.5714"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}

@end
