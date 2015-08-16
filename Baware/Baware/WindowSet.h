//
//  WindowSet.h
//  Baware
//
//  Created by Sean Rankine on 10/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recording.h"
#include "opencv2/opencv.hpp"

@interface WindowSet : NSObject

@property float **sensorData;
@property int lengthData;
@property int windowSize, overlap, numOfWindows, numOfFeatures;
@property float **windows;
@property cv::Mat features;

- (WindowSet*)init:(Recording*)recording windowSize:(int)windowSize overlap:(int)overlap;


@end
