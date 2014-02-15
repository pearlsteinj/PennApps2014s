//
//  DIVVenmoIntegration.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/14/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#define FRIENDS_ENPOINT1() "https://api.venmo.com/v1/users/"
#define FRIENDS_ENPOINT2()  "/friends?access_token="
#import "DIVVenmoIntegration.h"
@implementation DIVVenmoIntegration

-(void)setUserToken:(NSString *)token{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    _token = token;
    [prefs setObject:_token forKey:@"token"];
    [prefs synchronize];
    
    [self loadUserData];
}
-(void)loadUserData{
    
    //Form the first request for the user data, everything but the friend list
    NSString *ME_ENDPOINT = @"https://api.venmo.com/v1/me?access_token=";
    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ME_ENDPOINT,_token]];
    _request1 = [NSURLRequest requestWithURL:url1];
    [NSURLConnection connectionWithRequest:_request1 delegate:self];

}
-(void)part2{
    //Pull all the friends
    NSString *user_id = _userData[@"data"][@"user"][@"id"];
    NSString *limit = @"&limit=1000";
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%s%@%s%@%@",FRIENDS_ENPOINT1(),user_id,FRIENDS_ENPOINT2(),_token,limit]];
    _request2 = [NSURLRequest requestWithURL:url2];
    [NSURLConnection connectionWithRequest:_request2 delegate:self];
}
-(void)pullPictures{
    _friendData = [[NSMutableArray alloc]init];
    for(id entry in _friendsResponse[@"data"]){
        NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
        NSString *name = entry[@"display_name"];
        NSString *venmo_id = entry[@"id"];
        NSURL *pic_url = entry[@"profile_picture_url"];
        [temp setObject:name forKey:@"name"];
        [temp setObject:venmo_id forKey:@"id"];
        [temp setObject:pic_url forKey:@"pic_url"];
        [_friendData addObject:temp];
    }
    //To be moved to a seperate thread
    for(id entry in _friendData){
        NSURL *imageURL = [NSURL URLWithString:entry[@"pic_url"]];
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:imageURL
                                                            options:0
                                                           progress:^(NSUInteger receivedSize, long long expectedSize)
         {
         }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 [entry setObject:image forKey:@"image"];
             }
         }];

    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if([connection originalRequest] == _request1){

        _responseUserData = [[NSMutableData alloc] init];
    }
    else if([connection originalRequest] == _request2){
        _responseFriendData = [[NSMutableData alloc]init];
    }
    else {
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if([connection originalRequest] == _request1){

        [_responseUserData appendData:data];
    }
    else if([connection originalRequest] == _request2){
        [_responseFriendData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed: %@",[error localizedDescription]);
}
     
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([connection originalRequest] == _request1){
        NSError *error;
        _userData = [NSJSONSerialization JSONObjectWithData:_responseUserData options:0 error:&error];
        [self part2];
    }
    else if([connection originalRequest] == _request2){
        NSError *error;
        _friendsResponse = [NSJSONSerialization JSONObjectWithData:_responseFriendData options:0 error:&error];
        [self pullPictures];
    }
}
@end
