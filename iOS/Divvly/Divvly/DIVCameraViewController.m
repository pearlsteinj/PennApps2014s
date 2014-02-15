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
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "DIVSplitViewController.h"

@interface DIVCameraViewController ()

@end

@implementation DIVCameraViewController


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller

                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   
                                                   UINavigationControllerDelegate>) delegate {
    
    
    if (([UIImagePickerController isSourceTypeAvailable:
          
          UIImagePickerControllerSourceTypeCamera] == NO)
        
        || (delegate == nil)
        
        || (controller == nil))
        
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    
    // movie capture, if both are available:
    
    
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    
    // trimming movies. To instead show the controls, use YES.
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentModalViewController: cameraUI animated: YES];
    
    return YES;
    
}

- (IBAction) showCameraUI {
    
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
    
}



- (void) imagePickerController: (UIImagePickerController *) picker

 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        
        == kCFCompareEqualTo) {
        
        
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        
        
        if (editedImage) {
            
            imageToSave = editedImage;
            
        } else {
            
            imageToSave = originalImage;
            
        }
        
        UIImage *src_img = imageToSave;
        
        CGColorSpaceRef d_colorSpace = CGColorSpaceCreateDeviceRGB();
        size_t d_bytesPerRow = src_img.size.width * 4;
        unsigned char * imgData = (unsigned char*)malloc(src_img.size.height*d_bytesPerRow);
        CGContextRef context =  CGBitmapContextCreate(imgData, src_img.size.width,
                                                      src_img.size.height,
                                                      8, d_bytesPerRow,
                                                      d_colorSpace,
                                                      kCGImageAlphaNoneSkipFirst);
        
        UIGraphicsPushContext(context);
        // These next two lines 'flip' the drawing so it doesn't appear upside-down.
        CGContextTranslateCTM(context, 0.0, src_img.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        // Use UIImage's drawInRect: instead of the CGContextDrawImage function, otherwise you'll have issues when the source image is in portrait orientation.
        [src_img drawInRect:CGRectMake(0.0, 0.0, src_img.size.width, src_img.size.height)];
        UIGraphicsPopContext();
        
        
        // After we've processed the raw data, turn it back into a UIImage instance.
        CGImageRef new_img = CGBitmapContextCreateImage(context);
        UIImage * convertedImage = [[UIImage alloc] initWithCGImage:
                                    new_img];
        
        CGImageRelease(new_img);
        CGContextRelease(context);
        CGColorSpaceRelease(d_colorSpace);
        free(imgData);
        
        _image = convertedImage;
        Tesseract *tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
        //[tesseract setVariableValue:@"1234567890" forKey:@"tessedit_char_whitelist"];
        [tesseract setImage:_image];
        [tesseract recognize];
        
        _text = [tesseract recognizedText];
        [self performSegueWithIdentifier:@"imageParsed" sender:self];
        
    }
    
    [picker dismissModalViewControllerAnimated: YES];
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DIVSplitViewController *view =  (DIVSplitViewController*)segue.destinationViewController;
    view.textToParse = _text;
}
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
    
    [self startCameraControllerFromViewController:self usingDelegate:self];
    
 
    
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
