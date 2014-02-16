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
#import "DIVTipTaxViewController.h"
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
    _cellsAndImages = [[NSMutableDictionary alloc]init];

}

-(void)parseString{
    NSMutableArray *lines = [[_textToParse componentsSeparatedByString:@"\n"]mutableCopy];
    _restaurant_name = [lines firstObject];
    [_name_labe setText:_restaurant_name];
    [_name_labe setFont:[UIFont fontWithName:@"Open-Sans" size:40.0f]];
    for(id line in lines){
        NSMutableArray *tokens = [[line componentsSeparatedByString:@" "]mutableCopy];
        if([self isNumeric:tokens[0]] && [self isNumeric:[tokens lastObject]]){
            [self addLine:tokens];
        }
    }
    float totalCost = 0;
    for(id entry in _entries){
        totalCost += [entry[@"cost"] floatValue];
    }
    //[_price_label setTextColor:[UIColor greenColor]];
    [_price_label setFont:[UIFont fontWithName:@"Open-Sans" size:30.0f]];
    [_price_label setText:[NSString stringWithFormat:@"%.2f",totalCost]];
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
    return 1;
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
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableView *cell;
    if([_cellsAndImages objectForKey:str] != NULL){
        finalized_row = false;
        static NSString *MyIdentifier = @"final";
        
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        
        UIImageView *img = (UIImageView*)[cell viewWithTag:10];
        UILabel *description = (UILabel*)[cell viewWithTag:1];
        UILabel *cost = (UILabel*)[cell viewWithTag:2];
        
        description.text = [[_entries objectAtIndex:[indexPath row]] objectForKey:@"description"];
        [description setFont:[UIFont fontWithName:@"Open-Sans" size:20.0f]];
        [description setFont:[UIFont systemFontOfSize:14]];
        description.backgroundColor = [UIColor clearColor];
        [cell addSubview:description];
        
        cost.text = [[[_entries objectAtIndex:[indexPath row]] objectForKey:@"cost"] stringValue];
        [cost setFont:[UIFont fontWithName:@"Open-Sans" size:35.0f]];

        cost.textAlignment = UITextAlignmentRight;
        [cost setFont:[UIFont systemFontOfSize:14]];
        cost.backgroundColor = [UIColor clearColor];
        //[cost setTextColor:[UIColor greenColor]];
        [cell addSubview:cost];
        [img setImage:[_cellsAndImages objectForKey:str][@"image"]];
        img.clipsToBounds = YES;
        img.layer.cornerRadius = 23.0f;
        img.backgroundColor = [UIColor clearColor];
        
        UILabel *nameL = (UILabel*)[cell viewWithTag:15];
        [nameL setFont:[UIFont fontWithName:@"Open-Sans" size:10.0f]];
        [nameL setText:[_cellsAndImages objectForKey:str][@"name"]];
    }
    else if(!editing_row){
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
        [cost setFont:[UIFont fontWithName:@"Open-Sans" size:35.0f]];
        //[cost setTextColor:[UIColor greenColor]];
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



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    UITableViewCell *Tcell = (UITableViewCell*)[[[collectionView superview]superview]superview];
    UIImage *img = [_friendsArray objectAtIndex:indexPath.row][@"image"];
    [self updateCellatIndexPath:[_tableView indexPathForCell:Tcell] withImage:img andRecord:[_friendsArray objectAtIndex:indexPath.row]];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DIVTipTaxViewController *dest = (DIVTipTaxViewController*)segue.destinationViewController;
    dest.entries = _entries;
    dest.cellsToMatch = _cellsAndImages;
}
-(void)updateCellatIndexPath:(NSIndexPath*)indexPath withImage:(UIImage*)img andRecord:(id)record{
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [_cellsAndImages setObject:record forKey:str];
    editing_row = false;
    finalized_row = true;
    NSArray *temp = [[NSArray alloc]initWithObjects:indexPath, nil];
    [_tableView reloadRowsAtIndexPaths:temp withRowAnimation:UITableViewRowAnimationRight];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
