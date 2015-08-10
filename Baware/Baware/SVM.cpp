//
//  SVM.m
//  Baware
//
//  Created by Sean Rankine on 09/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#include "SVM.hpp"

using namespace cv;
using namespace cv::ml;

Classifier::Classifier(){
    trainingDataMat = new Mat(4, 2, CV_32FC1, trainingData);
    labelsMat = new Mat(4, 1, CV_32SC1, labels);
    svm = SVM::create();
    svm->setType(SVM::C_SVC);
    svm->setKernel(SVM::LINEAR);
    svm->setTermCriteria(TermCriteria(TermCriteria::MAX_ITER, 100, 1e-6));
}

Classifier::~Classifier(){
    //call other destructors
    delete trainingDataMat;
    delete labelsMat;
    delete svm;
    
}

int Classifier::classify(WindowSet *windowSet){
    Mat query(windowSet->getNumOfWindows(), windowSet->getNumOfFeatures(), CV_32FC1, windowSet->getWindows());
    
    Mat result;
    
    svm->predict(query, result);
    
    return 0;
}