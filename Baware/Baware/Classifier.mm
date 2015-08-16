//
//  SVM.m
//  Baware
//
//  Created by Sean Rankine on 09/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "Classifier.h"

using namespace cv;
using namespace cv::ml;


@implementation Classifier

-(Classifier*)init{
    self = [super init];
    if (self)
    {
        Ptr<cv::ml::SVM> svm = StatModel::load<SVM>("svm_model.xml");
        
    }
    
    return self;
    
}

-(NSMutableSet*)classify:(WindowSet *)windowSet{
    //
    return nil;
}

@end

/*int Classifier::classify(WindowSet *windowSet){
    Mat query(windowSet->getNumOfWindows(), windowSet->getNumOfFeatures(), CV_32FC1, windowSet->getWindows());
    
    Mat result;
    
    svm->predict(query, result);
    
    return 0;
}*/