//
//  DIVVenmoChargeViewController.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/16/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import "DIVVenmoChargeViewController.h"
#import "DIVAppDelegate.h"
#import "DIVVenmoIntegration.h"
#import <QuartzCore/QuartzCore.h>

@interface DIVVenmoChargeViewController ()

@end

@implementation DIVVenmoChargeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _toCharge.count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    cell = [_collectionPay dequeueReusableCellWithReuseIdentifier:@"coll" forIndexPath:indexPath];
    UIImageView *img = (UIImageView*)[cell viewWithTag:4];
    img.image = [[_toCharge objectAtIndex:indexPath.row] objectForKey:@"image"];
    img.clipsToBounds = YES;
    img.layer.cornerRadius = 34.0f;
    
    img.backgroundColor = [UIColor clearColor];
    img.layer.borderColor = [UIColor clearColor].CGColor;
    img.layer.borderWidth =0;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)viewDidLoad
{
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self startCharging];
}
-(void)startCharging{
    DIVAppDelegate *delegate = (DIVAppDelegate*)[[UIApplication sharedApplication]delegate];
    DIVVenmoIntegration *venmo =  delegate.venmo;
    for(NSDictionary *dict in _toCharge){
        if(![dict[@"venmo_id"]isEqualToString:venmo.userData[@"data"][@"user"][@"id"]]){
            NSNumber *payID;
            [venmo chargeID:dict[@"venmo_id"] amount:dict[@"cost"] note:@"Temporary" payID:&payID];
            [_payIDs addObject:payID];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
