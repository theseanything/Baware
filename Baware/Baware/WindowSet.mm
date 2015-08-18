//
//  WindowSet.m
//  Baware
//
//  Created by Sean Rankine on 10/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "WindowSet.h"
#include <iterator>
#include <vector>
#include <algorithm>

using namespace cv;
using namespace cv::ml;


@implementation WindowSet

- (WindowSet*)init:(Recording*)recording windowSize:(int)windowSize percent_overlap:(int)percent_overlap
{
    self = [super init];
    if (self)
    {
        float **data = [recording getData];
        float *aX = data[0];
        float *aY = data[1];
        float *aZ = data[2];
        float *gX = data[3];
        float *gY = data[4];
        float *gZ = data[5];

        
        std::vector<float> VaX(aX, aX+1000);
        std::vector<float> VaY(aY, aY+1000);
        std::vector<float> VaZ(aZ, aZ+1000);
        std::vector<float> VgX(gX, gX+1000);
        std::vector<float> VgY(gY, gY+1000);
        std::vector<float> VgZ(gZ, gZ+1000);
        
        int overlap = 0;
        
        if (percent_overlap > 100 || percent_overlap < 0) {
            std::cout << "Error overlap not correctly specified - needs to be between 0 - 100\n Defaulted to 0\n" << std::endl;
            percent_overlap = 0;
        }
        else{
            if (percent_overlap == 100) {
                percent_overlap = 99;
            }
            overlap = windowSize * (percent_overlap/100);
        }
        
        
        int numOfWindows = 1000/(windowSize-overlap);
        
        self.features = cv::Mat(numOfWindows+1, 4, CV_32FC1, Scalar(0));


        int windowNum = 0;
        for (int i = 0; i < 1000; i += (windowSize-overlap)){
            self.features.at<float>(windowNum,0) = [self percentile:25 array:VaX start:i stop:i+windowSize];
            //float aMperc50;
            //float gZabsAvg;;lm
            self.features.at<float>(windowNum,1) = [self avg:VaX start:i stop:i+windowSize];
            //float aYzeroCrossings;
            self.features.at<float>(windowNum,2) = [self percentile:25 array:VaZ start:i stop:i+windowSize];
            self.features.at<float>(windowNum,3) = [self percentile:50 array:VaZ start:i stop:i+windowSize];
            windowNum++;
        }
        
        if (windowNum == numOfWindows) std::cout << "Correct windows size." << std::endl;
        
        self.features.at<float>(windowNum,0) = -0.772166667;
        self.features.at<float>(windowNum,1) = -0.94;
        self.features.at<float>(windowNum,2) = 0.235;
        self.features.at<float>(windowNum,3) = 0.61;
        
        self.windowTimeInterval = (windowSize-overlap)*32/1000;
 
    }
    return self;
}

-(float)percentile:(int)percent array:(std::vector<float>)input start:(int)start stop:(int)stop{
    std::vector<float>::const_iterator first = input.begin() + start;
    std::vector<float>::const_iterator last = input.begin() + stop;
    std::vector<float> array(first, last);
    
    std::nth_element(array.begin(), array.begin() + (percent*array.size())/100, array.end());
    return array[percent*array.size()/100];
}

-(float)avg:(std::vector<float>)v start:(int)start stop:(int)stop{
    double return_value = 0.0;
    int n = stop - start;
    
    for ( int i = start; i < stop; i++)
    {
        return_value += v[i];
    }
    return ( return_value / n);
}



@end
