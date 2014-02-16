//
//  DIVVenmoChargeViewController.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/16/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIVVenmoChargeViewController : UIViewController
@property (nonatomic,retain) NSMutableArray *toCharge;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionPay;
@property (nonatomic,retain) NSMutableArray *payIDs;
@property (nonatomic, retain) NSTimer * timer;
@end
