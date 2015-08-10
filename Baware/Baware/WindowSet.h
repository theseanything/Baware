//
//  WindowSet.h
//  Baware
//
//  Created by Sean Rankine on 10/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#ifndef __Baware__WindowSet__
#define __Baware__WindowSet__

#include <stdio.h>

class WindowSet{
private:
    const float **sensorData;
    int lengthData;
    int windowSize, overlap, numOfWindows, numOfFeatures;
    
    float **windows;
    
public:
    WindowSet(const float** sensorData, const int lengthData, const int windowSize, const int overlap);
    ~WindowSet();
    int getNumOfWindows();
    int getNumOfFeatures();
    float** getWindows();
    
};

#endif /* defined(__Baware__WindowSet__) */
