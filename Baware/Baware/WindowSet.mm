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
        // extract accelerometer and gyrometer data from a saved recording object
        RawData *rawData = [recording getData];
        
        float **aData = rawData.accDataArray;
        float **gData = rawData.gyrDataArray;

        float *aX = aData[0];
        float *aY = aData[1];
        float *aZ = aData[2];
        float *gX = gData[0];
        float *gY = gData[1];
        float *gZ = gData[2];

        
        // convert the data into C++ vector arrays
        std::vector<float> VaX(aX, aX + rawData.size);
        std::vector<float> VaY(aY, aY + rawData.size);
        std::vector<float> VaZ(aZ, aZ + rawData.size);
        std::vector<float> VgX(gX, gX + rawData.size);
        std::vector<float> VgY(gY, gY + rawData.size);
        std::vector<float> VgZ(gZ, gZ + rawData.size);
        
        std::vector<float> VaM;
        std::vector<float> VgM;
        
        // create the singal magnitude vector time-series
        for(int i = 0; i < rawData.size; i++){
            VaM.push_back(sqrt((VaX[i]*VaX[i])+(VaY[i]*VaY[i])+(VaZ[i]*VaZ[i])));
            VgM.push_back(sqrt((VgX[i]*VgX[i])+(VgY[i]*VgY[i])+(VgZ[i]*VgZ[i])));
        }

        
        // check if overlap is valid and calculate number of measurements that overlap
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
        
        // calculate window size
        int numOfWindows = rawData.size/(windowSize-overlap);
        
        // create feature table
        self.features = cv::Mat(numOfWindows+1, 7, CV_32FC1, Scalar(0));
        
        
        //debug information - REMOVE
        NSLog(@"rawData.size = %d", rawData.size);
        NSLog(@"windowSize = %d", windowSize);
        NSLog(@"overlap = %d", overlap);
        NSLog(@"numberOfwindows = %d", numOfWindows);


        // calculate features
        int windowNum = 0;
        for (int i = 0; i < (rawData.size - windowSize); i = i + (windowSize-overlap)){
            self.features.at<float>(windowNum,0) = [self percentile:75 array:VaX start:i stop:i+windowSize];
            //self.features.at<float>(windowNum,1) = [self kurt:VaX start:i stop:i+windowSize];
            self.features.at<float>(windowNum,1) = [self stdev:VaY start:i stop:i+windowSize];
            self.features.at<float>(windowNum,2) = [self percentile:90 array:VaY start:i stop:i+windowSize];
            //self.features.at<float>(windowNum,4) = [self kurt:VaY start:i stop:i+windowSize];
            self.features.at<float>(windowNum,3) = [self absAvg:VaZ start:i stop:i+windowSize];
            self.features.at<float>(windowNum,4) = [self rms:VaZ start:i stop:i+windowSize];
            self.features.at<float>(windowNum,5) = [self stdev:VaM start:i stop:i+windowSize];
            self.features.at<float>(windowNum,6) = [self stdev:VgM start:i stop:i+windowSize];

            windowNum++;
        }
        
        self.windowTimeInterval = (windowSize-overlap)*32/1000;
 
    }
    return self;
}

// obselete initialiser - ignore
/*- (WindowSet*)init:(RawData*)rawData{
    self = [super init];
    if (self)
    {
    self.features = cv::Mat(1, 4, CV_32FC1, Scalar(0));
    
    std::vector<float> VaX(rawData.accDataArray[0], rawData.accDataArray[0]+rawData.size);
    std::vector<float> VaY(rawData.accDataArray[1], rawData.accDataArray[1]+rawData.size);
    std::vector<float> VaZ(rawData.accDataArray[2], rawData.accDataArray[2]+rawData.size);
    std::vector<float> VgX(rawData.gyrDataArray[0], rawData.gyrDataArray[0]+rawData.size);
    std::vector<float> VgY(rawData.gyrDataArray[1], rawData.gyrDataArray[1]+rawData.size);
    std::vector<float> VgZ(rawData.gyrDataArray[2], rawData.gyrDataArray[2]+rawData.size);
    
    self.features.at<float>(0,0) = [self percentile:25 array:VaX start:0 stop:rawData.size];
    //float aMperc50;
    //float gZabsAvg;;lm
    self.features.at<float>(0,1) = [self avg:VaX start:0 stop:rawData.size];
    //float aYzeroCrossings;
    self.features.at<float>(0,2) = [self percentile:25 array:VaZ start:0 stop:rawData.size];
    self.features.at<float>(0,3) = [self percentile:50 array:VaZ start:0 stop:rawData.size];
    }
    return self;
}*/

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

-(float)absAvg:(std::vector<float>)v start:(int)start stop:(int)stop{
    double return_value = 0.0;
    int n = stop - start;
    
    for ( int i = start; i < stop; i++)
    {
        return_value += abs(v[i]);
    }
    return ( return_value / n);
}

-(float)stdev:(std::vector<float>)v start:(int)start stop:(int)stop{

    float mean=0.0, sum_deviation=0.0;
    
    mean = [self avg:v start:start stop:stop];
    for(int i= start; i < stop;++i)
        sum_deviation+=(v[i]-mean)*(v[i]-mean);
    return sqrt(sum_deviation/(stop-start));
}

-(float)kurt:(std::vector<float>)v start:(int)start stop:(int)stop{
    float kurt = 0.0, top = 0.0, bottom = 0.0, mean = 0.0;
    
    int length = stop - start;
    
    mean = [self avg:v start:start stop:stop];
    
    for(int i= start; i < stop;++i)
        top += (v[i]-mean)*(v[i]-mean)*(v[i]-mean)*(v[i]-mean);
    
    top = top/length;
    
    for(int i= start; i < stop;++i)
        bottom += (v[i]-mean)*(v[i]-mean);
    
    bottom = bottom/length;
    
    bottom = bottom * bottom;
    
    kurt = top/bottom;
    
    return kurt;
}


-(float)rms:(std::vector<float>)v start:(int)start stop:(int)stop{
    double sumsquared = 0.0;
    int n = stop - start;
    
    for (int i = start; i < stop; i++)
    {
        sumsquared += v[i]*v[i];
    }
    
    return sqrt((double(1)/n)*(sumsquared));
}
@end
