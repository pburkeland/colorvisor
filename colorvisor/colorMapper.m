//
//  colorMapper.m
//  colorvisor
//
//  Created by paul on 1/30/15.
//  Copyright (c) 2015 Paul Burkeland. All rights reserved.
//

#import "colorMapper.h"

@implementation colorMapper

@synthesize colorName;
@synthesize colorInfo;
@synthesize colorDictionary;
@synthesize dictionaryName;


NSInteger arrayValue1;
NSInteger arrayValue2;
NSInteger arrayValue3;


-(float)calculateDistanceBetweenArrayOne:(NSArray*)arrayOne andArrayTwo:(NSArray*) arrayTwo{
    
    float totalDistance;
    //verify that both arrays are same length
    if ( arrayOne.count != arrayTwo.count ){
     
        NSLog(@"ERROR: array one has %lu items and array two has %lu items.", (unsigned long)arrayOne.count, (unsigned long)arrayTwo.count);
        
    }else if ( arrayOne.count ==  arrayTwo.count ){
        NSLog(@"arrays have equal numbers, both being %lu", (unsigned long)arrayOne.count);
        
        float totalDist = 0.0;
        
        for (int i = 0; i < [arrayOne count]; i++){
        
            float tmpDist = powf((abs([[arrayOne objectAtIndex:i] integerValue] - [[arrayTwo objectAtIndex:i] integerValue])), 2.0);
        
            totalDist = tmpDist + totalDist;
        
        }
        
        totalDistance = sqrt(totalDist);
        
    }else{
        NSLog(@"I did NOT expect this.");
    }
    

    return totalDistance;
}



-(float)calculateDistanceBetweenX:(int)valueOne Y:(int)valueTwo Z:(int)valueThree fromAlpha:(int)valueAlpha Beta:(int)valueBeta Gamma:(int)valueGamma{
    
    //this will be a more universal calculator for comparing, maybe make a version for arrays instead of xyz
    float distanceX = pow((abs(valueOne - valueAlpha)),2);
    float distanceY = pow((abs(valueTwo - valueBeta)),2);
    float distanceZ = pow((abs(valueThree - valueGamma)),2);
    
    //do math here
    float distance = sqrt(distanceX + distanceY + distanceZ);
    
    return distance;
}



- (id)calculateNearestMatchToValueX:(int)valueX Y:(int)valueY valueZ:(int)valueZ{

    //set to a high number so that any match will generate a new latestDistance value to compare against
    float latestDistance = 1000;

    //iterate through keys in dictionary
    for (id key in self.colorDictionary) {
        //NSLog(@"Listing key %@", key);

        NSArray *array = [colorDictionary objectForKey:key];
            //--        NSLog(@"array = %@", array);
    
        colorName = key;
    
        //grab the values from the key
        arrayValue1 = [array[0] integerValue];
        arrayValue2 = [array[1] integerValue];
        arrayValue3 = [array[2] integerValue];
        
    float colorDistance = [self calculateDistanceBetweenX:valueX Y:valueY Z:valueZ fromAlpha: arrayValue1 Beta:arrayValue2 Gamma:arrayValue3];
  

    //now we compare to previous matches
//       NSLog(@"color distance is %f and latest distance is %f", colorDistance, latestDistance);
    if (colorDistance < latestDistance) {
        
        NSArray * latestColorInfo = @[colorName, [NSNumber numberWithFloat:colorDistance], [NSNumber numberWithInt:arrayValue1], [NSNumber numberWithInt:arrayValue2], [NSNumber numberWithInt:arrayValue3]];

//        NSLog(@"Latest match is %@ with a distance of %@", latestColorInfo[0], latestColorInfo[1]);
        latestDistance = colorDistance;
        //set the colorInfo array to be our latest winning array
        colorInfo = latestColorInfo;
        }
    }
    return colorInfo;
}


-(id)rgbToXYZfrom:(NSArray*)rgbArray{
    
    float var_R = ( [[rgbArray objectAtIndex:0] floatValue] / 255 );        //R from 0 to 255
    float var_G = ( [[rgbArray objectAtIndex:1] floatValue] / 255 );        //G from 0 to 255
    float var_B = ( [[rgbArray objectAtIndex:2] floatValue] / 255 );        //B from 0 to 255
    
    //    NSLog(@"rgbArray reading in vars %f %f %f", var_R, var_G, var_B);
    
    if ( var_R > 0.04045 ){
        var_R = (powf((( var_R + 0.055 ) / 1.055 ), 2.4));
    }else{
        var_R = var_R / 12.92;
    }
    
    if ( var_G > 0.04045 ){
        var_G = (powf((( var_G + 0.055 ) / 1.055 ),2.4));
    }else{
        var_G = var_G / 12.92;
    }
    if ( var_B > 0.04045 ){
        var_B = (powf((( var_B + 0.055 ) / 1.055 ),2.4));
    }else{
        var_B = var_B / 12.92;
    }
    
    var_R = var_R * 100;
    var_G = var_G * 100;
    var_B = var_B * 100;
    
    //Observer. = 2°, Illuminant = D65
    float X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
    float Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
    float Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;
    
    //NSLog(@" Converted values are %f %f %f", X,Y,Z);
    
    NSArray * convertedRGB = [NSArray arrayWithObjects:[NSNumber numberWithFloat:X], [NSNumber numberWithFloat:Y], [NSNumber numberWithFloat:Z], nil];
    
    return convertedRGB;
}

-(id)xyzToLabfrom:(NSArray*)xyzArray{
    
    float ref_X =  95.047;
    float ref_Y = 100.000;
    float ref_Z = 108.883;
    
    float var_X = ([xyzArray[0] floatValue] / ref_X);        //ref_X =  95.047   Observer= 2°, Illuminant= D65
    float var_Y = ([xyzArray[1] floatValue] / ref_Y);          //ref_Y = 100.000
    float var_Z = ([xyzArray[2] floatValue] / ref_Z);         //ref_Z = 108.883
    
    if ( var_X > 0.008856 ){
        var_X = powf(var_X ,( 1.00/3.00 ));
    }else{
        var_X = ( 7.787 * var_X ) + ( 16.00 / 116.00 );
    }
    
    if ( var_Y > 0.008856 ){
        var_Y = powf(var_Y, ( 1.00/3.00 ));
    }else{
        var_Y = ( 7.787 * var_Y ) + ( 16.00 / 116.00 );
    }
    
    if ( var_Z > 0.008856 ){
        var_Z = powf(var_Z ,( 1.00/3.00 ));
    }else{
        var_Z = ( 7.787 * var_Z ) + ( 16.00 / 116.00 );
    }
    
    float L = ( 116.0 * var_Y ) - 16.0;
    float a = 500.0 * ( var_X - var_Y );
    float b = 200.0 * ( var_Y - var_Z );
    
    //    NSLog(@"and converted XYZ to Lab values of %f %f %f", L, a, b);
    
    NSArray * convertedXYZ = [NSArray arrayWithObjects:[NSNumber numberWithFloat:L], [NSNumber numberWithFloat:a], [NSNumber numberWithFloat:b], nil];
    
    return convertedXYZ;
}


@end
