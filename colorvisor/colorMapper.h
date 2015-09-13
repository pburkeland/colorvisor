//
//  colorMapper.h
//  colorvisor
//
//  Created by paul on 1/30/15.
//  Copyright (c) 2015 Paul Burkeland. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface colorMapper : NSObject {
    
    NSString *colorName;
    NSArray *colorInfo;
    NSDictionary * colorDictionary;
    NSString *dictionaryName;
}

@property NSString * colorName;
@property NSArray * colorInfo;

@property NSInteger arrayValue1;
@property NSInteger arrayValue2;
@property NSInteger arrayValue3;
@property NSDictionary * colorDictionary;

@property NSString *dictionaryName;


//main method to match to RGB
- (id)calculateNearestMatchToValueX:(int)valueX Y:(int)valueY valueZ:(int)valueZ;


//distance calculations
-(float)calculateDistanceBetweenArrayOne:(NSArray*)arrayOne andArrayTwo:(NSArray*) arrayTwo;
-(float)calculateDistanceBetweenX:(int)valueOne Y:(int)valueTwo Z:(int)valueThree fromAlpha:(int)valueAlpha Beta:(int)valueBeta Gamma:(int)valueGamma;


//conversion methods
-(id)rgbToXYZfrom:(NSArray*)rgbArray;
-(id)xyzToLabfrom:(NSArray*)xyzArray;



@end
