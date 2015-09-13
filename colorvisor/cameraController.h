//
//  cameraController.h
//  colorvisor
//
//  Created by paul on 2/6/15.
//  Copyright (c) 2015 Paul Burkeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface cameraController : UIView <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    IBOutlet UIView * vImagePreview;
}

@property(nonatomic, retain) IBOutlet UIView *vImagePreview;
@property(nonatomic, retain) NSArray* imageData;

@property NSInteger redPreview;
@property NSInteger greenPreview;
@property NSInteger bluePreview;
@property float minWhiteBalance;
@property float maxWhiteBalance;

@property UIColor *previewColorSwatch;

@property AVCaptureDevice *device;

@property NSInteger fpsValue;


-(void)initializeCamera;

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;

-(NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count;


- (AVCaptureWhiteBalanceGains)normalizedGains:(AVCaptureWhiteBalanceGains) gains;

+(void)setFPSRate:(float)newRate;

@end
