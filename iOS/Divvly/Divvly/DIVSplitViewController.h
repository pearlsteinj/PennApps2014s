//
//  DIVSplitViewController.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIVSplitViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>{
    bool editing_row;
    bool finalized_row;
}
@property (nonatomic,retain) NSString *textToParse;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,retain) NSMutableArray *entries;
@property (nonatomic,retain) NSString *restaurant_name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *friendsArray;
@property (nonatomic,retain) NSMutableDictionary *cellsAndImages;

//UILabels
@property (strong, nonatomic) IBOutlet UILabel *price_label;
@property (strong, nonatomic) IBOutlet UILabel *name_labe;

@end
