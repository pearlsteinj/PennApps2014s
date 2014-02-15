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

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self login];

}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)login{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"login" ofType:@"html"]isDirectory:NO]]];
    _webView.delegate = self;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:
                      @"document.body.innerHTML"];
    if(html.length < 40){
        _token = html;
        [self performSegueWithIdentifier:@"loggedIn" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DIVAppDelegate *delegate = (DIVAppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate.venmo setUserToken:_token];
}
@end
