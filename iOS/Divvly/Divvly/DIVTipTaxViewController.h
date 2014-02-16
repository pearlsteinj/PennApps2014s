//
//  DIVTipTaxViewController.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIVTipTaxViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *entries;
@property (nonatomic,retain) NSMutableDictionary *cellsToMatch;
@property (nonatomic,retain) NSMutableArray *final;
@end
