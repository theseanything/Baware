//
//  WindowSet.cpp
//  Baware
//
//  Created by Sean Rankine on 10/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#include "WindowSet.h"

//add consts

WindowSet::WindowSet(const float** _sensorData, const int _lengthData, const int _windowSize, const int _overlap){
    
    float featureSet [6];
    sensorData = _sensorData;
    lengthData = _lengthData;
    windowSize = _windowSize;
    overlap = _overlap;

    
    int windowNum = 0;
    for (int i = 0; i < lengthData; i += overlap){
        
        for (int n = 0 ; n < windowSize; n++) {
            
            
        }
        
        windows[windowNum] = featureSet;
        windowNum++;
    }
        
}

int WindowSet::getNumOfWindows(){
    return numOfWindows;
}

int WindowSet::getNumOfFeatures(){
    return numOfFeatures;
}

float** WindowSet::getWindows(){
    return windows;
}