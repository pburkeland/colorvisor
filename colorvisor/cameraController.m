//
//  NSObject+cameraController.m
//  colorvisor
//
//  Created by paul on 2/6/15.
//  Copyright (c) 2015 Paul Burkeland. All rights reserved.
//

#import "cameraController.h"

@import AVFoundation;
@import ImageIO;
@import CoreMedia;

@implementation cameraController

@synthesize vImagePreview;
@synthesize imageData;
@synthesize redPreview, greenPreview, bluePreview;
@synthesize previewColorSwatch;
@synthesize minWhiteBalance, maxWhiteBalance;


@synthesize device;

@synthesize fpsValue;


-(void)initializeCamera{

//    NSLog(@"inside of initializeCamera");
    
    //----- SHOW LIVE CAMERA PREVIEW -----
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    CALayer *viewLayer = self.vImagePreview.layer;
    NSLog(@"viewLayer = %@", viewLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setFrame: self.vImagePreview.bounds];
    
    [self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    //this sets it so that the video fills the available area, no black lines on side as the default does
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [captureVideoPreviewLayer setBounds: captureVideoPreviewLayer.bounds];
    
//    NSLog(@"Bounds are %f and %f and %f and %f",captureVideoPreviewLayer.bounds.origin.x, captureVideoPreviewLayer.bounds.origin.y, captureVideoPreviewLayer.bounds.size.width, captureVideoPreviewLayer.bounds.size.height);

//    NSLog(@"Frames are %f and %f and %f and %f",captureVideoPreviewLayer.frame.origin.x, captureVideoPreviewLayer.frame.origin.y, captureVideoPreviewLayer.frame.size.width, captureVideoPreviewLayer.frame.size.height);
    
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //NEW
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
#define AVCaptureFocusModeManual     2
    NSError*    error = nil;
    if ([self.device lockForConfiguration:&error]) {
//        self.device.focusMode = 1;
        NSLog(@"Inside lock for configuration");
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeManual]) {
            
            NSLog(@"Device focus mode supported");
            //device.whiteBalanceMode =2;
            device.focusMode = 2;
//            self.device.whiteBalanceMode = 0;
//            [self.device setWhiteBalanceMode:0];
            // this is a value [0..1]
            
//            NSLog(@"Self white balance mode is set to %i", self.device.whiteBalanceMode);
        }
        
        
        if ([self.device isExposureModeSupported:2]){
            
            [self.device setExposureMode:2];
            NSLog(@"Exposure mode is set to %ld", self.device.exposureMode);
        }
        
        
        //TESTING NEW
       // NSLog(@"Inside of camera config");
            
        //float maxGain = self.device.maxWhiteBalanceGain;
        //NSLog(@"Max gain is %f", maxGain);
            
        if (self.device.lowLightBoostSupported) {
                self.device.automaticallyEnablesLowLightBoostWhenAvailable = YES;
                NSLog(@"LOW LIGHT BOOST SUPPORTED: setting automaticallyEnablesLowLightBoostWhenAvailable = NO");
            }
            
            // lock the gains
//            if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked]) {
//                self.device.whiteBalanceMode = AVCaptureWhiteBalanceModeLocked;
//                NSLog(@"setting AVCaptureWhiteBalanceModeLocked");
//            }

            if ([self.device isWhiteBalanceModeSupported:0]){
                //self.maxWhiteBalance = device.maxWhiteBalanceGain;
                
                
//                self.maxWhiteBalance = device.
                
                // set the gains
                AVCaptureWhiteBalanceGains gains;
                gains.redGain = 1.0;
                gains.greenGain = 1.0;
                gains.blueGain = 1.0;
                
                
                [self.device setWhiteBalanceMode:2];
                //[self.device setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:gains completionHandler:nil];
                NSLog(@"White balance mode is %ld", self.device.whiteBalanceMode);
                //NSLog(@"WHITE BALANCE SUPPORTED: Max white balance gain is %f", self.maxWhiteBalance);
            }
        
        
         [self.device unlockForConfiguration];
    }
    


    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    
    
    [session addInput:input];

    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    output.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    
    
    
//CONFIGURE Min/Max FRAMERATES
    int framerate = 10;
    if ([self.device respondsToSelector:@selector(setActiveVideoMinFrameDuration:)] &&
        [self.device respondsToSelector:@selector(setActiveVideoMaxFrameDuration:)]) {
//        NSLog(@"Inside of TESTING");
        NSError *error;
        [self.device lockForConfiguration:&error];
        if (error == nil) {
#if defined(__IPHONE_7_0)
            [self.device setActiveVideoMinFrameDuration:CMTimeMake(1, framerate)];
            [self.device setActiveVideoMaxFrameDuration:CMTimeMake(1, framerate)];
#endif
        }
        [self.device unlockForConfiguration];
    } else {
        
        
        NSLog(@"Couldn't set the normal way, going to wayback way");
        for (AVCaptureConnection *connection in output.connections)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            if ([connection respondsToSelector:@selector(setVideoMinFrameDuration:)])
                connection.videoMinFrameDuration = CMTimeMake(1, framerate);
            
            if ([connection respondsToSelector:@selector(setVideoMaxFrameDuration:)])
                connection.videoMaxFrameDuration = CMTimeMake(1, framerate);
#pragma clang diagnostic pop
 /*           if ([connection isVideoOrientationSupported])
            {
                NSLog(@"Setting video orientation to portrait");
                AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
                [connection setVideoOrientation:orientation];
            }
            
           // NSLog(@"Max video scale and crop factor is %f", connection.videoMaxScaleAndCropFactor);
 */
            
        }
    }
 
    for (AVCaptureConnection *connection in output.connections)
    {
    if ([connection isVideoOrientationSupported])
    {
//        NSLog(@"NUMBER 2 - Setting video orientation to portrait");
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
        [connection setVideoOrientation:orientation];
    }

    }
    
    
//    NSLog(@"Max gain is set to %f", self.device.maxWhiteBalanceGain);
    

//START SESSION
    [session startRunning];

    
    //draw a dot in the middle of our selector box so we can tell where we're reading from
    
//    UIView *myBox  = [[UIView alloc] initWithFrame:CGRectMake(164, 158, 2, 2)];
    UIView *myBox  = [[UIView alloc] initWithFrame:CGRectMake(158, 150, 2, 2)];

    myBox.backgroundColor = [UIColor lightGrayColor];
    [self.vImagePreview addSubview:myBox];
    
  //  NSLog(@"White balance max gain is %f ", device.maxWhiteBalanceGain);
    
    
    
    //reading in settings
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    fpsValue =[defaults floatForKey:@"fps"];
    
//    NSLog(@"Inside of cameraController setup, fps is set to %li", fpsValue);
    
}



- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
//    NSLog(@"inside captureOutput");
    
    UIImage *image = [self imageFromSampleBuffer: sampleBuffer];
    
//    self.imageData = [self getRGBAsFromImage:image atX:160 andY:160 count:1];
//    self.imageData = [self getRGBAsFromImage:image atX:160 andY:240 count:1];
    self.imageData = [self getRGBAsFromImage:image atX:180 andY:240 count:1];

    
//    self.imageData = [self getRGBAsFromImage:image atX:240 andY:170 count:1];

//LATEST WORKING WITHOUT PORTRAIT SET
//    self.imageData = [self getRGBAsFromImage:image atX:240 andY:180 count:1];

    
    //out of buonds
    //self.imageData = [self getRGBAsFromImage:image atX:360 andY:480 count:1];

    
//        NSLog(@"Image data is %@",self.imageData);
    
    
    self.redPreview = [self.imageData[0] integerValue];
    self.greenPreview = [self.imageData[1] integerValue];
    self.bluePreview = [self.imageData[2] integerValue];
    //    CGFloat alphaPreview = [self.imageData[3] floatValue];
    
    self.previewColorSwatch = [UIColor colorWithRed:(self.redPreview/255.0) green:(self.greenPreview/255.0) blue:(self.bluePreview/255.0) alpha:1.0];
    
    //sleep(1);
    
}


// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
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
    
    //NSLog(@"image from sample buffer has width of %zu and height of %zu", width, height);
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little |
                                                 kCGImageAlphaPremultipliedFirst);
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


- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
//    NSLog(@"imageref is %i wide and %i tall", width, height);
    
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    for (int i = 0 ; i < count ; ++i)
    {
        
        /*
         CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
         CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
         CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
         CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
         */
        
        
        CGFloat red   = (rawData[byteIndex]     * 1.0);
        CGFloat green = (rawData[byteIndex + 1] * 1.0);
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0);
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0);
        
        
        
        byteIndex += bytesPerPixel;
        
        [result addObject:[NSNumber numberWithFloat:red]];
        [result addObject:[NSNumber numberWithFloat:green]];
        [result addObject:[NSNumber numberWithFloat:blue]];
        [result addObject:[NSNumber numberWithFloat:alpha]];
        
        
        
        //UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        //[result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}


- (AVCaptureWhiteBalanceGains)normalizedGains:(AVCaptureWhiteBalanceGains) gains
{
    AVCaptureWhiteBalanceGains g = gains;
    
    g.redGain = MAX(1.0, g.redGain);
    g.greenGain = MAX(1.0, g.greenGain);
    g.blueGain = MAX(1.0, g.blueGain);
    
//    g.redGain = MIN(self.device.maxWhiteBalanceGain, g.redGain);
//    g.greenGain = MIN(self.device.maxWhiteBalanceGain, g.greenGain);
//    g.blueGain = MIN(self.device.maxWhiteBalanceGain, g.blueGain);
    
    return g;
}

// TESTING
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.vImagePreview];
    NSLog(@"Touch x : %f y : %f", touchPoint.x, touchPoint.y);
}


+(void)setFPSRate:(float)newRate{
    [self setFPSRate: newRate];
}


@end
