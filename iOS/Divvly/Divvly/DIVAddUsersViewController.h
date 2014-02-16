//
//  DIVAddUsersViewController.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIVAddUsersViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSMutableArray *friendsArray;
@property (strong,nonatomic) NSMutableArray *finalFriendsArray;
@property (nonatomic,retain) NSMutableArray *selectedFriends;

- (IBAction)refresh:(id)sender;
@end
