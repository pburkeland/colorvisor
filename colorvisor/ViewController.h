//
//  ViewController.h
//  colorvisor
//
//  Created by paul on 1/30/15.
//  Copyright (c) 2015 Paul Burkeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "cameraController.h"
#import "colorMapper.h"

@interface ViewController : UIViewController
{
    IBOutlet UIView *previewColor;
    IBOutlet UIView *matchColor;
    IBOutlet UILabel *colorLabel;
    IBOutlet UILabel *redLabel;
    IBOutlet UILabel *greenLabel;
    IBOutlet UILabel *blueLabel;
    IBOutlet UILabel *redPreviewLabel;
    IBOutlet UILabel *greenPreviewLabel;
    IBOutlet UILabel *bluePreviewLabel;
    IBOutlet UILabel *libraryLabel;
    IBOutlet UISlider *horizontalSlider;
    IBOutlet UISlider *verticalSlider;
    IBOutlet cameraController *cameraFeed;
    colorMapper *colorMatcher;
    
    BOOL displayHSV;
}

@property(nonatomic, retain) IBOutlet UIView *previewColor;
@property(nonatomic, retain) IBOutlet UIView *matchColor;
@property(nonatomic, retain) IBOutlet UILabel *colorLabel;
@property(nonatomic, retain) IBOutlet UILabel *redLabel;
@property(nonatomic, retain) IBOutlet UILabel *greenLabel;
@property(nonatomic, retain) IBOutlet UILabel *blueLabel;
@property(nonatomic, retain) IBOutlet UILabel *redPreviewLabel;
@property(nonatomic, retain) IBOutlet UILabel *greenPreviewLabel;
@property(nonatomic, retain) IBOutlet UILabel *bluePreviewLabel;
@property(nonatomic, retain) IBOutlet UILabel *libraryLabel;


@property cameraController * cameraFeed;
@property colorMapper * colorMatcher;

@property BOOL displayHSV;

-(IBAction)onClickGetRGB:(id)sender;

@end

