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
#import <ImageIO/CGImageProperties.h>
#import "DIVOCR.h"
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
    captureOutput = [[AVCaptureVideoDataOutput alloc] init];
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
    
    session.sessionPreset = AVCaptureSessionPresetMedium;
    //NSError *error = nil;
    //if (!input) {
    // Handle the error appropriately.
    //  NSLog(@"ERROR: trying to open camera: %@", error);
    //}
    
    //[session addInput:input];
    
    //stillImageOutput is a global variable in .h file: "AVCaptureStillImageOutput *stillImageOutput;"
    
    /*
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    */
    [session startRunning];
    
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    //NSLog(@"imageFromSampleBuffer: called");
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    //NSLog(@"captureOutput: didOutputSampleBufferFromConnection");
    
    // Create a UIImage from the sample buffer data
    self.image = [self imageFromSampleBuffer:sampleBuffer];
    
    //< Add your code here that uses the image >
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

    //NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
    //UIImage *image = [[UIImage alloc] initWithData:imageData];
     
    
    UIImage *temp = [UIImage imageWithCGImage:_image.CGImage
                        scale:_image.scale orientation: UIImageOrientationUpMirrored];
    _image  = temp;
    [session stopRunning];
    [_overlay setImage:_image];
    DIVOCR *ocr = [[DIVOCR alloc]init];
    [ocr processImage:temp];

    
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
