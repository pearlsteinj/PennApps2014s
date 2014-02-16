//
//  DIVTipTaxViewController.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import "DIVTipTaxViewController.h"
#import "DIVVenmoChargeViewController.h"

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
    
    
    totalAll = 0;
    for (NSMutableDictionary *dict in _final){
        totalAll += [dict[@"cost"] floatValue];
    }
    
    _totalCost.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%f", totalAll]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:Nil action:@selector(resignFirstResponder)];
    [self.view addGestureRecognizer:tap];
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

        [self mergeRecords:entry andPerson:dict];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _final.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UIImageView *img = (UIImageView*)[cell viewWithTag:7];
    [img setImage:[_final objectAtIndex:indexPath.row][@"image"]];
    img.clipsToBounds = YES;
    img.layer.cornerRadius = 23.0f;
    img.backgroundColor = [UIColor clearColor];
    
    UILabel *name = (UILabel *)[cell viewWithTag:2];
    name.text = [_final objectAtIndex:indexPath.row][@"name"];
    [name setFont:[UIFont fontWithName:@"Open-Sans" size:35.0f]];

    UILabel *cost = (UILabel *)[cell viewWithTag:3];
    cost.text = [[_final objectAtIndex:indexPath.row][@"cost"] stringValue];
    [cost setFont:[UIFont fontWithName:@"Open-Sans" size:35.0f]];

return cell;

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string{
    
    textView.text = [textView.text stringByAppendingString:string];
    
    NSMutableString *totalString = [NSMutableString stringWithString:_totalCost.text];
    [totalString replaceOccurrencesOfString:@"$"
                                              withString:@""
                                                 options:0
                                                   range:NSMakeRange(0, totalString.length)];
    
    NSMutableString *taxString = [NSMutableString stringWithString:_taxCost.text];
    [taxString replaceOccurrencesOfString:@"$"
                                 withString:@""
                                    options:0
                                      range:NSMakeRange(0, taxString.length)];
    
    NSMutableString *extraString = [NSMutableString stringWithString:_extrasCost.text];
    [extraString replaceOccurrencesOfString:@"$"
                                 withString:@""
                                    options:0
                                      range:NSMakeRange(0, extraString.length)];
    
    NSMutableString *tipString = [NSMutableString stringWithString:_tipCost.text];
    [tipString replaceOccurrencesOfString:@"$"
                                 withString:@""
                                    options:0
                                      range:NSMakeRange(0, tipString.length)];
    
    
    float total = [totalString floatValue];
    float tax = [taxString floatValue];
    float extra = [extraString floatValue];
    float tip = [tipString floatValue];
    float additions = tax + extra + tip;
    [self updateCells:additions];
    total = total + tax + extra + tip;
    
    _totalCost.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%.2f", total]];
    
    return NO;
    
}
-(void)updateCells:(float)additions{
    int num = [_tableView numberOfRowsInSection:0];
    float cell_additional = additions/num;
    for(NSMutableDictionary *entry in _final){
        NSNumber *num2 = entry[@"cost"];
        NSNumber *new = [NSNumber numberWithFloat:([num2 floatValue]+cell_additional)];
        [entry setObject:new forKey:@"cost"];
    }
    [_tableView reloadData];
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DIVVenmoChargeViewController *dest = (DIVVenmoChargeViewController*)segue.destinationViewController;
    dest.toCharge = _final;
}
@end
