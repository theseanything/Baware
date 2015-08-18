//
//  SVM.m
//  Baware
//
//  Created by Sean Rankine on 09/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "Classifier.h"
#include <iostream>

using namespace cv;
using namespace cv::ml;


@implementation Classifier

-(Classifier*)init{
    self = [super init];
    if (self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *docs = [paths objectAtIndex:0];
        //NSString *filePath = [docs stringByAppendingPathComponent:@"trainData.csv"];
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath = [mainBundle pathForResource: @"trainData" ofType: @"csv"];
        
        NSMutableArray *colA = [NSMutableArray array];
        NSMutableArray *colB = [NSMutableArray array];
        NSMutableArray *colC = [NSMutableArray array];
        NSMutableArray *colD = [NSMutableArray array];
        NSMutableArray *colE = [NSMutableArray array];
        NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray* rows = [fileContents componentsSeparatedByString:@"\n"];
        for (NSString *row in rows){
            NSArray* columns = [row componentsSeparatedByString:@","];
            [colA addObject:columns[0]];
            [colB addObject:columns[1]];
            [colC addObject:columns[2]];
            [colD addObject:columns[3]];
            [colE addObject:columns[4]];
        }
        
        
        int rrows = (int)[colA count];
        int ccols = 4;
        
        float trainingData[rrows-1][ccols];
        int labels[rrows];

        
        for (int i = 0; i < rrows-1; ++i) {
            trainingData[i][0] = [[colB objectAtIndex:i+1] floatValue];
            trainingData[i][1] = [[colC objectAtIndex:i+1] floatValue];
            trainingData[i][2] = [[colD objectAtIndex:i+1] floatValue];
            trainingData[i][3] = [[colE objectAtIndex:i+1] floatValue];
            if ([[colA objectAtIndex:i+1]  isEqual: @"brushing"]) {
                labels[i] = 1;
            }
            else{
                labels[i] = -1;
            }
        }
        
        /*for(int i=0; i<rrows-1; i++)    //This loops on the rows.
        {
            for(int j=0; j<4; j++) //This loops on the columns
            {
                std::cout << trainingData[i][j]  << "  ";
            }
            std::cout << std::endl;
        }*/
        
        //float trainingData[4][2] = { {501, 10}, {255, 10}, {501, 255}, {10, 501} };
        Mat trainingDataMat(rrows-1, ccols, CV_32FC1, trainingData);
        Mat labelsMat(rrows-1, 1, CV_32SC1, labels);
        
        std::cout << "T = "<< std::endl << " "  << trainingDataMat << std::endl << std::endl;
        std::cout << "L = "<< std::endl << " "  << labelsMat << std::endl << std::endl;

        // Train the SVM
        self.svm = SVM::create();
        self.svm->setType(SVM::C_SVC);
        self.svm->setKernel(SVM::LINEAR);
        self.svm->setTermCriteria(TermCriteria(TermCriteria::MAX_ITER, 100, 1e-6));
        
        Ptr<TrainData> trainingDataAuto =  cv::ml::TrainData::create(trainingDataMat, ROW_SAMPLE, labelsMat);
        
        self.svm->trainAuto(trainingDataAuto);

        //self.svm->train(trainingDataMat, ROW_SAMPLE, labelsMat);
        
        NSString *savePath = [docs stringByAppendingPathComponent:@"savue_model.xml"];

        
        self.svm->StatModel::save([savePath UTF8String]);
        
        //self.svm = StatModel::load<SVM>("svm_model.xml");
        
    }
    
    return self;
    
}

-(std::vector<float>)classify:(WindowSet *)windowSet{
    Mat query = windowSet.features;
    
    std::cout << "Q = "<< std::endl << " "  << query << std::endl << std::endl;
    
    Mat result;
    
    self.svm->predict(query, result);
    
    std::cout << "R = "<< std::endl << " "  << result << std::endl << std::endl;
    
    std::vector<float> array;
    array.assign((float*)result.datastart, (float*)result.dataend);

    return array;
}

@end

/*int Classifier::classify(WindowSet *windowSet){
    Mat query(windowSet->getNumOfWindows(), windowSet->getNumOfFeatures(), CV_32FC1, windowSet->getWindows());
    
    Mat result;
    
    svm->predict(query, result);
    
    return 0;
}*/