//
//  DIVVenmoIntegration.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/14/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIVVenmoIntegration : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

//Properties for Venmo Integration
@property (nonatomic,retain) NSString *token;
//Contains normal User related info
@property (nonatomic,retain) NSMutableDictionary *userData;
@property (nonatomic,retain) NSMutableDictionary *userDataCleaned;

//Contains 4 fields, {display_name, venmo id, NSURL to pic, UIImage of pic}
@property (nonatomic,retain) NSMutableArray *friendData;
//Img data
@property (nonatomic,retain) NSMutableDictionary *friendsResponse;
//Data Responses
@property (nonatomic,retain) NSMutableData *responseUserData;
@property (nonatomic,retain) NSMutableData *responseFriendData;
@property (nonatomic,retain) NSMutableData *img;
//Requests
@property (nonatomic,retain) NSURLRequest *request1;
@property (nonatomic,retain) NSURLRequest *request2;

//Possible Method Endpoints
-(void)setUserToken:(NSString *)token;
-(NSMutableDictionary *)chargeID:(NSString*)ID amount:(NSNumber*)amount note:(NSString *)note payID:(NSNumber**)paymentI;

@end
