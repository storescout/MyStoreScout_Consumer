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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (IBAction)btnBackClicked:(id)sender
{
}

- (IBAction)btnEnterClicked:(id)sender
{
    [self.navigationController pushViewController:STORYBOARD_ID(@"idStoreVC") animated:YES];
}

@end
