//
//  DIVAddUsersViewController.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import "DIVAddUsersViewController.h"
#import "DIVAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@interface DIVAddUsersViewController ()

@end

@implementation DIVAddUsersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSMutableArray *newArray = [NSMutableArray array];
    
    if (![searchText isEqualToString:@""]){
        for (NSMutableDictionary *i in _friendsArray){
            if ([[i objectForKey:@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0){
                [newArray addObject:i];
            }
        }
        _finalFriendsArray = newArray;
    }
    else{
        _finalFriendsArray = _friendsArray;
    }
    
    [_collectionView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _selectedFriends = [[NSMutableArray alloc]init];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];
    self.navigationItem.title = @"Add People";
    [[UINavigationBar appearance]setTintColor:[UIColor colorWithRed:52 green:73 blue:94 alpha:1]];
    [_activityIndicator startAnimating];
    _activityIndicator.hidesWhenStopped = YES;
    [self performSelector:@selector(stopTimer) withObject:nil afterDelay:3.0];
}
-(void)stopTimer{
    [_activityIndicator stopAnimating];
    DIVAppDelegate *delegate = (DIVAppDelegate*)[[UIApplication sharedApplication]delegate];
    _friendsArray = delegate.venmo.friendData;
    _finalFriendsArray = _friendsArray;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _finalFriendsArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
        cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"person" forIndexPath:indexPath];
        UIImageView *img = (UIImageView*)[cell viewWithTag:1];
        img.image = [[_finalFriendsArray objectAtIndex:indexPath.row] objectForKey:@"image"];
        img.clipsToBounds = YES;
        img.layer.cornerRadius = 34.0f;
        
        img.backgroundColor = [UIColor clearColor];
        
        cell.backgroundColor = [UIColor clearColor];
    
        UILabel *name = (UILabel*)[cell viewWithTag:2];
        //[name setFont:[UIFont fontWithName:@"Open-Sans" size:5]];
        NSString *person_name = [[_finalFriendsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        NSString *first = [[person_name componentsSeparatedByString:@" "]firstObject];
        [name setText:first];

       return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    if(![_selectedFriends containsObject:[_finalFriendsArray objectAtIndex:indexPath.row]]){
        [cell setRestorationIdentifier:@"selected"];
        UIImageView *img = (UIImageView*)[cell viewWithTag:1];
        [img.layer setBorderColor: [[UIColor greenColor] CGColor]];
        
        [img.layer setBorderWidth: 4.0];
        
        [_selectedFriends addObject:[_finalFriendsArray objectAtIndex:indexPath.row]];
        [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
    }
    else{
        [cell setRestorationIdentifier:@"person"];
        UIImageView *img = (UIImageView*)[cell viewWithTag:1];
        [img.layer setBorderWidth: 0];
        [_selectedFriends removeObject:[_finalFriendsArray objectAtIndex:indexPath.row]];
        [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
    }
    NSLog(@"%@",_selectedFriends);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refresh:(id)sender {
    [_collectionView reloadData];
}
@end
