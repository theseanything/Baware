//
//  WindowSet.h
//  Baware
//
//  Created by Sean Rankine on 10/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WindowSet.h"
#include "opencv2/opencv.hpp"



@interface Classifier : NSObject

@property cv::Ptr<cv::ml::SVM> svm;

-(Classifier*)init;

-(NSMutableSet*)classify:(WindowSet*) windowSet;

@end

