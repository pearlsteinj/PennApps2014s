//
//  DIVAddUsersViewController.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import "DIVAddUsersViewController.h"
#import "DIVAppDelegate.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
     return _friendsArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"person" forIndexPath:indexPath];
   UIImageView *img = (UIImageView*)[cell viewWithTag:1];
    img.image = [[_friendsArray objectAtIndex:indexPath.row] objectForKey:@"image"];
    img.clipsToBounds = YES;
    img.layer.cornerRadius = 34.0f;
    
    img.backgroundColor = [UIColor clearColor];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *name = (UILabel*)[cell viewWithTag:2];
    //[name setFont:[UIFont fontWithName:@"Open-Sans" size:5]];
    NSString *person_name = [[_friendsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *first = [[person_name componentsSeparatedByString:@" "]firstObject];
    [name setText:first];
    
    return cell;
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
