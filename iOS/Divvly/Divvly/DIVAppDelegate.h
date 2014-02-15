//
//  DIVAppDelegate.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/14/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIVVenmoIntegration.h"
@interface DIVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) DIVVenmoIntegration *venmo;

@end
