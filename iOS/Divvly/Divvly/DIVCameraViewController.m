//
//  DIVCameraViewController.m
//  Divvly
//
//  Created by Josh Pearlstein on 2/15/14.
//  Copyright (c) 2014 Peter and Josh Ventures. All rights reserved.
//

#import "DIVCameraViewController.h"
#import "DIVAppDelegate.h"
#import "DIVVenmoIntegration.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
@interface DIVCameraViewController ()

@end

@implementation DIVCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)startCameraSession
{
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if (!captureInput) {
        return;
    }
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    session = [[AVCaptureSession alloc] init];
    NSString* preset = 0;
    if (!preset) {
        preset = AVCaptureSessionPresetMedium;
    }
    session.sessionPreset = preset;
    if ([session canAddInput:captureInput]) {
        [session addInput:captureInput];
    }
    if ([session canAddOutput:captureOutput]) {
        [session addOutput:captureOutput];
    }
    
    if (!layer) {
        layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    }
    
    layer.frame = self.view.bounds;
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_cameraView.layer addSublayer: layer];
    _overlay = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"photo-capture.png"]];
    [_cameraView addSubview:_overlay];
    [session startRunning];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePicture)];
    [self.view addGestureRecognizer:recognizer];
    /*
    DIVAppDelegate *delegate = (DIVAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray *friends = delegate.venmo.friendData;*/

    
    [self startCameraSession];

}
-(void)takePicture{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                  completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         _image = image;
         //[_overlay setImage:_image];
         
         Tesseract *tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
         
         [tesseract setImage:_image];
         [tesseract recognize];
         
         NSLog(@"%@", [tesseract recognizedText]);
     }];
    
    [session stopRunning];


}
-(void)viewDidAppear:(BOOL)animated{
    
    //[super viewDidAppear:animated];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
