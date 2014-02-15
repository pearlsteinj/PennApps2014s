//
//  DIVOCR.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import "DIVOCR.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#define APP_ID "Divvly App"
#define APP_SECRET "czfERkFZAMG8/ncRcdPfji/U"
#define SERVER "http://cloud.ocrsdk.com"

@implementation DIVOCR
-(void)processImage:(UIImage*)image{
    NSURL *initialURL = [NSURL URLWithString:@"http://cloud.ocrsdk.com/processImage?exportFormat=txt&language=english"];
    ASIFormDataRequest *initialRequest = [ASIFormDataRequest requestWithURL:initialURL];
    //NSString *user = @"Divvly App:czfERkFZAMG8/ncRcdPfji/U";
    [initialRequest setUsername:@APP_ID];
    [initialRequest setPassword:@APP_SECRET];
    NSData *png = UIImagePNGRepresentation(image);
    [initialRequest setData:png withFileName:@"image.png" andContentType:@"image/png" forKey:@"form"];
    initialRequest.delegate = self;
    [initialRequest startAsynchronous];

}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    NSLog(@"%@",responseString);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
}
@end
