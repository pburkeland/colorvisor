//
//  SettingsViewController.m
//  colorvisor
//
//  Created by paul on 2/13/15.
//  Copyright (c) 2015 Paul Burkeland. All rights reserved.
//

#import "SettingsViewController.h"
//#import "ViewController.h"
@import UIKit;

#import "cameraController.h"
#import "colorMapper.h"


@interface SettingsViewController()
{
    NSArray * _colorLibraryPickerData;
}


@end


@implementation SettingsViewController

@synthesize fpsSlider;
@synthesize fpslabel;
//@synthesize displayRGB;
@synthesize enableCIE;
//@synthesize backToMain;
@synthesize fpsValue;

- (IBAction)sliderValueChanged:(UISlider *)sender {
    fpsValue = sender.value;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat: fpsValue forKey:@"fps"];
    
    NSLog(@"defaults key says Slider float value is %f", [defaults floatForKey:@"fps"]);
    [fpslabel setText:[NSString stringWithFormat:@"%ld", (long)fpsValue ]];
    
    [defaults synchronize];
    NSLog(@"Data saved");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"In viewDidLoad");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    fpsValue =[defaults floatForKey:@"fps"];
//    NSLog(@"initial fps is set to %f", fpsValue);
    //this read correctly
    
    [fpslabel setText:[NSString stringWithFormat:@"%ld",(long)fpsValue]];
    [fpsSlider setValue:fpsValue animated:YES];
    
//    NSLog(@"slider is %@", fpsSlider);
//    NSLog(@"slider value is %f", fpsSlider.value);
    
    //now set up picker wheel data
    _colorLibraryPickerData = @[@"colorvisor 125-color", @"Crayola Colors", @"Pantone Colors - Coated", @"Sherwin Williams"];

    // Connect data
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
//    NSLog(@"Loading library defaults");

    NSInteger currentLibraryIndex;
    if ([[defaults stringForKey:@"currentLibrary"]  isEqual: @"colorRGB_colorvisor125"]){
        currentLibraryIndex = 0;
//        NSLog(@"it is set as 0");
    }else if ([[defaults stringForKey:@"currentLibrary"] isEqual: @"colorRGB_Crayola120"]){
        currentLibraryIndex = 1;
        //        NSLog(@"it says it is 1, or rather, not 0");
    }else if ([[defaults stringForKey:@"currentLibrary"] isEqual: @"colorRGB_PantoneCoated"]){
        currentLibraryIndex = 2;
//        NSLog(@"it says it is 1, or rather, not 0");
    }else if ([[defaults stringForKey:@"currentLibrary"] isEqual: @"colorRGB_SherwinWilliams"]){
        currentLibraryIndex = 3;
        //        NSLog(@"it says it is 1, or rather, not 0");
    }

    [self.picker selectRow:currentLibraryIndex inComponent:0 animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _colorLibraryPickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _colorLibraryPickerData[row];
}


-(IBAction)onBackButtonClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)toggleRGBHSV:(id)sender{
    NSLog(@"NOID VOID");
}

-(IBAction)resetButton:(id)sender{
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:@"enableCIE"];
    [defaults setFloat:10.0 forKey:@"fps"];
    
    [defaults synchronize];
    //NSLog(@"Data saved");
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSLog(@"Selected Row %ld", (long)row);
    
    
    // HERE WE WILL DO AN IF STATEMENT:
    // IF IT IS RGBMODE THEN DO THE FIRST SWITCH, IF IT IS CIEMODE THEN THE OTHER
    
    
    switch(row)
    {
        case 0:
            [defaults setObject:[NSString stringWithFormat:@"colorRGB_colorvisor125"] forKey:@"currentLibrary"];
            break;
        case 1:
            [defaults setObject:[NSString stringWithFormat:@"colorRGB_Crayola120"] forKey:@"currentLibrary"];
            break;
        case 2:
            [defaults setObject:[NSString stringWithFormat:@"colorRGB_PantoneCoated"] forKey:@"currentLibrary"];
            break;
        case 3:
            [defaults setObject:[NSString stringWithFormat:@"colorRGB_SherwinWilliams"] forKey:@"currentLibrary"];
            break;
    }
    
    [defaults synchronize];
}

@end
