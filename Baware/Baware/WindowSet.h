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

@property cv::Mat features;
@property NSTimeInterval windowTimeInterval;

- (WindowSet*)init:(Recording*)recording windowSize:(int)windowSize percent_overlap:(int)percent_overlap;
- (WindowSet*)init:(RawData*)rawData;


@end
