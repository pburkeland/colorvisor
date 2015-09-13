//
//SettingsViewController.h
//  colorvisor
//
//  Created by paul on 2/13/15.
//  Copyright (c) 2015 Paul Burkeland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController: UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UIView *settingsView;
    IBOutlet UIButton *backToMain;
    IBOutlet UIButton *resetButton;
    float sliderValue;
    IBOutlet UISwitch *displayRGB;
//    IBOutlet UIPickerView *picker;
    IBOutlet UILabel * fpslabel;
    IBOutlet UISlider * fpsSlider;
    float fpsValue;
}


@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property BOOL enableCIE;
@property float fpsValue;
@property IBOutlet UISlider * fpsSlider;
@property IBOutlet UILabel *fpslabel;


-(IBAction)onBackButtonClick:(id)sender;
-(IBAction)toggleRGBHSV:(id)sender;
-(IBAction)resetButton:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;

@end
