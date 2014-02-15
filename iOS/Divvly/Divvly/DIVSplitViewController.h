//
//  DIVSplitViewController.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIVSplitViewController : UIViewController
@property (nonatomic,retain) NSString *textToParse;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,retain) NSMutableArray *entries;
@property (nonatomic,retain) NSString *restaurant_name;

@end
