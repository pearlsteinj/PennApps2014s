//
//  DIVCameraViewController.h
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DIVCameraViewController : UIViewController{
    AVCaptureSession *session;
    AVCaptureDevice *device;
    AVCaptureDeviceInput *input;
    AVCaptureVideoDataOutput *captureOutput;
    AVCaptureVideoPreviewLayer *layer;
    AVCaptureStillImageOutput *stillImageOutput;
}

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (strong, nonatomic) IBOutlet UIImageView *overlay;
@property (strong,nonatomic) UIImage *image;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSMutableArray *selectedFriends;
@end
