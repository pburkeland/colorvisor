//
//  ViewController.m
//  colorvisor
//
//  Created by paul on 1/30/15.
//  Copyright (c) 2015 Paul Burkeland. All rights reserved.
//

#import "ViewController.h"
#import "colorMapper.h"
#import "cameraController.h"
#import "SettingsViewController.h"
//#import "settingsController.h"

@import ImageIO;
@import CoreMedia;
@import AVFoundation;


@interface ViewController ()


@end

@implementation ViewController

@synthesize previewColor;
@synthesize matchColor;
@synthesize colorLabel;
@synthesize redLabel, greenLabel, blueLabel;
@synthesize redPreviewLabel, greenPreviewLabel, bluePreviewLabel;
//@synthesize horizontalSliderValue, verticalSliderValue;
@synthesize cameraFeed;
@synthesize colorMatcher;

@synthesize displayHSV;
@synthesize libraryLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //adjust the 2nd UISlider to be vertical
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI_2);
    verticalSlider.transform = trans;
    
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crosshair1.png"]];
    [overlayImageView setFrame:CGRectMake(135, 145, 50, 50)];
    [[self view] addSubview:overlayImageView];
    
    
    
    // ---- TEMP MOVED --- TESTING TESTING TESTING -- MOVED TO VIEWDIDLOAD
    
     colorMatcher = [[colorMapper alloc] init];
     //now we read in the settings, if statement for HSL vs RGB mode
     
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults stringForKey:@"currentLibrary"] == nil){
        [defaults setObject:[NSString stringWithFormat:@"colorRGB_SherwinWilliams"] forKey:@"currentLibrary"];
    }
    
     [colorMatcher setDictionaryName:[defaults stringForKey:@"currentLibrary"]];
     NSLog(@"String is set to %@",[defaults stringForKey:@"currentLibrary"]);
     
     //now set the color dictionary
     [colorMatcher setColorDictionary: [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:colorMatcher.dictionaryName ofType:@"plist"]]];
     
    // ----- END OF MOVE ----- END OF MOVE ----- END OF MOVE ----
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    
    // HERE WE ARE GONNA WANT TO TAKE CARE OF THE RELOADS OF THE DICTIONARY AFTER CHANGING SETTINGS
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     [colorMatcher setDictionaryName:[defaults stringForKey:@"currentLibrary"]];
     NSLog(@"String is set to %@",[defaults stringForKey:@"currentLibrary"]);
     
     //now set the color dictionary
     [colorMatcher setColorDictionary: [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:colorMatcher.dictionaryName ofType:@"plist"]]];
    
}


//View about to be added to the window (called each time it appears)
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
// ---- TEMP MOVED --- TESTING TESTING TESTING -- MOVED TO VIEWDIDLOAD
/*
    colorMatcher = [[colorMapper alloc] init];
    //now we read in the settings, if statement for HSL vs RGB mode

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [colorMatcher setDictionaryName:[defaults stringForKey:@"currentLibrary"]];
    NSLog(@"String is set to %@",[defaults stringForKey:@"currentLibrary"]);
    
    //now set the color dictionary
    [colorMatcher setColorDictionary: [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:colorMatcher.dictionaryName ofType:@"plist"]]];
*/
// ----- END OF MOVE ----- END OF MOVE ----- END OF MOVE ----
    
    
    
    
    //----------------- BEGIN MOVE ------------------- MOVE TO SETTINGS ---------
    // USE A PREFERENCES VALUE TO STORE THE NAME AND UPDATE IT IN SETTINGS WHEN CHANGED
    
    
    if ([colorMatcher.dictionaryName isEqualToString:@"colorRGB_Crayola120"]){
        [self.libraryLabel setText: @"Crayola Colors"];
    }
    if ([colorMatcher.dictionaryName isEqualToString:@"colorRGB_colorvisor125"]){
        [self.libraryLabel setText: @"colorvisor Library"];
    }
    if ([colorMatcher.dictionaryName isEqualToString:@"colorRGB_PantoneCoated"]){
        [self.libraryLabel setText: @"Pantone Colors"];
    }
    if ([colorMatcher.dictionaryName isEqualToString:@"colorRGB_SherwinWilliams"]){
        [self.libraryLabel setText: @"Sherwin Williams"];
    }
    // ---------------- END OF MOVE ------------------- MOVE TO SETTINGS ------
    
    //[self.libraryLabel setText:colorMatcher.dictionaryName];
    
    //start the camera feed
    [self.cameraFeed initializeCamera];

}




- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    // DO WE REALLY WANT TO DO THIS?
    // IT MIGHT BE WHY THE CAMERA ACTS WEIRD WHEN IT COMES BACK FROM SLEEPING
    cameraFeed.vImagePreview = nil;
    
    
}


- (IBAction)onClickGetRGB:(id)sender{
    
    
    // HERE IS WHERE WE WILL DECIDE WHICH PATH TO TAKE - CIE OR RGB
    

    NSArray * matchingColor = [colorMatcher calculateNearestMatchToValueX:[self.cameraFeed.imageData[0] integerValue] Y:[self.cameraFeed.imageData[1] integerValue] valueZ:[self.cameraFeed.imageData[2] integerValue]];
    
    
    
    
    
    
    
    NSInteger match1 = [matchingColor[2] integerValue];
    NSInteger match2 = [matchingColor[3] integerValue];
    NSInteger match3 = [matchingColor[4] integerValue];
    
//    NSLog(@"Current R: %li G: %li B: %li A: %f", (long)match1, (long)match2, (long)match3, 1.0);
//    NSLog(@"Color match complete! Here's the info: %@",matchingColor);
    

    // --- FORMAT THE BELOW FOR CIE OR RGB
    
    //UPDATE LABELS
    [colorLabel setText: matchingColor[0]];
    [redLabel setText:[NSString stringWithFormat:@" R: %li",(long)match1]];
    [greenLabel setText:[NSString stringWithFormat:@" G: %li",(long)match2]];
    [blueLabel setText:[NSString stringWithFormat:@" B: %li",(long)match3]];
    
    [redPreviewLabel setText:[NSString stringWithFormat:@"  R: %li",(long)cameraFeed.redPreview]];
    [greenPreviewLabel setText:[NSString stringWithFormat:@"  G: %li",(long)cameraFeed.greenPreview]];
    [bluePreviewLabel setText:[NSString stringWithFormat:@"  B: %li",(long)cameraFeed.bluePreview]];

    UIColor *mcolor = [UIColor colorWithRed:(match1/255.0) green:(match2/255.0) blue:(match3/255.0) alpha:1.0];

    self.previewColor.backgroundColor = [cameraFeed previewColorSwatch];
    self.matchColor.backgroundColor = mcolor;

    
    /* --- This is our test for passing it as an array ----

    NSArray *testArray = @[[NSNumber numberWithInt:[self.cameraFeed.imageData[0] integerValue]], [NSNumber numberWithInt:[self.cameraFeed.imageData[1] integerValue]], [NSNumber numberWithInt:[self.cameraFeed.imageData[2] integerValue]]];
                           
                           NSArray *testArray2 = @[[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], [NSNumber numberWithInt:2]];
    
    float testDist = [colorMatcher calculateDistanceBetweenArrayOne:testArray2 andArrayTwo:testArray];
    NSLog(@"Distance is calculated to be %f", testDist);

     -----------------------------------------------------*/

}

- (IBAction)displaySettingsView{
    SettingsViewController *second= [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self presentViewController: second animated:YES completion:nil];
}

@end
