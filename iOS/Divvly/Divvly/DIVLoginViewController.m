//
//  DIVLoginViewController.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import "DIVLoginViewController.h"
#import "DIVAppDelegate.h"
#import "DIVCameraViewController.h"

@interface DIVLoginViewController ()

@end

@implementation DIVLoginViewController

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
    
    //self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:46.0f green:64.0f blue:83.0f alpha:1.0];
    //[self.navigationController.navigationBar setBackgroundColor: [UIColor colorWithRed:46.0f green:64.0f blue:83.0f alpha:1.0]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:35.0f/255.0f green:164.0f/255.0f blue:85.0f/255.0f alpha:1.0]];
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self login];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)login{
    //Checks if user logged in previouly
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    
    _webView.scrollView.scrollEnabled = NO;
    //if (![prefs objectForKey:@"token"] || [[prefs objectForKey:@"token"] isEqualToString:@""]){
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"login" ofType:@"html"]isDirectory:NO]]];
        _webView.delegate = self;
    //}
    /*
    else{
        DIVAppDelegate *delegate = (DIVAppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate.venmo setUserToken:[prefs objectForKey:@"token"]];
        
        [self performSegueWithIdentifier:@"loggedIn" sender:self];
    }
    */
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:
                      @"document.body.innerHTML"];
    if(html.length < 40){
        _token = html;
        DIVAppDelegate *delegate = (DIVAppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate.venmo setUserToken:_token];
        [self performSegueWithIdentifier:@"loggedIn" sender:self];
    }
}

@end
