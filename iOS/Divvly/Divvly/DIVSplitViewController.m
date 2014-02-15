//
//  DIVSplitViewController.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import "DIVSplitViewController.h"
#import "stdio.h"
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _entries = [[NSMutableArray alloc]init];
    [self parseString];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
