//
//  DIVTipTaxViewController.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import "DIVTipTaxViewController.h"

@interface DIVTipTaxViewController ()

@end

@implementation DIVTipTaxViewController

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
    _final = [[NSMutableArray alloc]init];
    [self calcTotals];
    
    NSLog(@"%@",_final);
}
-(void)calcTotals{

    NSNumber *index = 0;
    for(id entry in _entries){
        NSMutableDictionary *dict;
        if(index ==0){
            dict = [_cellsToMatch objectForKey:@"0"];
        }
        else{
            dict = [_cellsToMatch objectForKey:[index stringValue]];
        }
        index = [NSNumber numberWithInt:([index intValue]+1)];
        NSLog(@"Merging %@ and %@",entry,dict);
        [self mergeRecords:entry andPerson:dict];
        
    }
}
-(void)mergeRecords:(NSMutableDictionary*)cell andPerson:(NSMutableDictionary*)person{
    NSNumber *price = cell[@"cost"];
    NSNumber *venmo_id = person[@"id"];
    NSString *name = person[@"name"];
    UIImage *image = person[@"image"];
    bool exists = false;
    int index;
    for(id records in _final){
        if(records[@"venmo_id"] == venmo_id){
            exists = true;
            index = [_final indexOfObject:records];
        }
    }
    
    if(exists) {
        NSNumber *currPrice = [_final objectAtIndex:index][@"cost"];
        NSNumber *new_price = [NSNumber numberWithFloat:([currPrice floatValue] + [price floatValue])];
        [[_final objectAtIndex:index] setObject:new_price forKey:@"cost"];
    }
    else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:price forKey:@"cost"];
        [dict setObject:venmo_id forKey:@"venmo_id"];
        [dict setObject:name forKey:@"name"];
        [dict setObject:image forKey:@"image"];
        [_final addObject:dict];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
