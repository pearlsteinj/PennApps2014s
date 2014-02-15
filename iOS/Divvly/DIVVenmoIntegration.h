//
//  DIVVenmoIntegration.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/14/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIVVenmoIntegration : NSObject

//Properties for Venmo Integration
@property (nonatomic,retain) NSString *token;


//Possible Method Endpoints
-(BOOL)loginWithUser:(NSString*)user andPass:(NSString*)pass;

@end