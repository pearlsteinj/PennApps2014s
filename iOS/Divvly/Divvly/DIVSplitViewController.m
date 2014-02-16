//
//  DIVSplitViewController.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import "DIVSplitViewController.h"
#import "stdio.h"
#import "DIVAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface DIVSplitViewController ()

@end

@implementation DIVSplitViewController

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
//    NSLog([_friendsArray description]);
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _entries = [[NSMutableArray alloc]init];
    [self parseString];
    _label.text = _restaurant_name;
}

-(void)parseString{
    NSMutableArray *lines = [[_textToParse componentsSeparatedByString:@"\n"]mutableCopy];
    _restaurant_name = [lines firstObject];
    NSLog(@"Restaurant Name: %@",_restaurant_name);
    for(id line in lines){
        NSMutableArray *tokens = [[line componentsSeparatedByString:@" "]mutableCopy];
        if([self isNumeric:tokens[0]] && [self isNumeric:[tokens lastObject]]){
            [self addLine:tokens];
        }
    }
}

-(void)addLine:(NSMutableArray*)line{
    NSNumber *amount = [NSNumber numberWithInt:[line[0] integerValue]];
    [line removeObjectAtIndex:0];
    NSNumber *cost = [NSNumber numberWithFloat:[[line lastObject] floatValue]];
    [line removeLastObject];
    NSString *description = [line componentsJoinedByString:@" "];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:amount forKey:@"amount"];
    [dict setObject:cost forKey:@"cost"];
    [dict setObject:description forKey:@"description"];
    [_entries addObject:dict];
}

-(BOOL)isNumeric:(NSString*)s
{
    NSScanner *sc = [NSScanner scannerWithString: s];
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;  }

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Entries";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _entries.count;
}

-(IBAction)addPeople:(id)sender{
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview] superview];
    if (!editing_row) {
        editing_row = true;
    }
    else{
        editing_row = false;
    }
    NSArray *temp = [[NSArray alloc]initWithObjects:[_tableView indexPathForCell:cell], nil];
    [_tableView reloadRowsAtIndexPaths:temp withRowAnimation:UITableViewRowAnimationLeft];

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *cell;
    if(!editing_row){
        static NSString *MyIdentifier = @"cell";
    
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
        }
    
        UIButton *btn = (UIButton*)[cell viewWithTag:0];
        UILabel *description = (UILabel*)[cell viewWithTag:1];
        UILabel *cost = (UILabel*)[cell viewWithTag:2];
    
        description.text = [[_entries objectAtIndex:[indexPath row]] objectForKey:@"description"];
        [description setFont:[UIFont systemFontOfSize:14]];
        description.backgroundColor = [UIColor clearColor];
        [cell addSubview:description];
    
        cost.text = [[[_entries objectAtIndex:[indexPath row]] objectForKey:@"cost"] stringValue];
        cost.textAlignment = UITextAlignmentRight;
        [cost setFont:[UIFont systemFontOfSize:14]];
        cost.backgroundColor = [UIColor clearColor];
        [cell addSubview:cost];
    }
    else {
        static NSString *MyIdentifier = @"search";
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        UISearchBar *bar = (UISearchBar*)[cell viewWithTag:5];
        bar.placeholder = @"HEllo";
    }
     
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _friendsArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"collCell" forIndexPath:indexPath];
    UIImageView *img = (UIImageView*)[cell viewWithTag:4];
    img.image = [[_friendsArray objectAtIndex:indexPath.row] objectForKey:@"image"];
    img.clipsToBounds = YES;
    img.layer.cornerRadius = 23.0f;
    img.backgroundColor = [UIColor clearColor];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected: %@",[_friendsArray objectAtIndex:indexPath.row][@"name"]);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
