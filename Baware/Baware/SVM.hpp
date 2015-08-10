//
//  SVM.h
//  Baware
//
//  Created by Sean Rankine on 09/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#include <opencv2/opencv.hpp>
#include "WindowSet.h"

using namespace cv;
using namespace cv::ml;


class Classifier{
public:
    Classifier();
    ~Classifier();
    
    int classify(WindowSet* windowSet);
    
private:
    int labels[4] = {1, -1, -1, -1};
    float trainingData[4][2] = { {501, 10}, {255, 10}, {501, 255}, {10, 501} };
    
    Mat *trainingDataMat;
    Mat *labelsMat;
    Ptr<SVM> svm;
};
