//
//  DIVTipTaxViewController.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIVTipTaxViewController : UIViewController{
    float totalAll;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *entries;
@property (nonatomic,retain) NSMutableDictionary *cellsToMatch;
@property (strong, nonatomic) IBOutlet UITextView *totalCost;
@property (strong, nonatomic) IBOutlet UITextView *tipCost;
@property (strong, nonatomic) IBOutlet UITextView *extrasCost;
@property (strong, nonatomic) IBOutlet UITextView *taxCost;
@property (nonatomic,retain) NSMutableArray *final;
@end
