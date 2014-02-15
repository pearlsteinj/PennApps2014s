//
//  DIVOCR.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
@interface DIVOCR : NSObject <ASIHTTPRequestDelegate>
-(void)processImage:(UIImage*)image;
@end
