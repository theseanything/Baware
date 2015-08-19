//
//  RawData.m
//  Baware
//
//  Created by Sean Rankine on 07/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "RawData.h"

@implementation RawData

- (RawData*)init:(int)bufferSize
{
    self = [super init];
    if (self)
    {
        self.accDataArray = malloc(sizeof(float*)*3);
        for (int i = 0; i < 3; i++)
        {
            self.accDataArray[i] = malloc(sizeof(float)*bufferSize);
            for (int n = 0; n < bufferSize; n++) { self.accDataArray[i][n] = 0; }
        }
        self.gyrDataArray = malloc(sizeof(float*)*3);
        for (int i = 0; i < 3; i++)
        {
            self.gyrDataArray[i] = malloc(sizeof(float)*bufferSize);
            for(int n = 0; n < bufferSize; n++) { self.gyrDataArray[i][n] = 0; }
        }
        self.size = bufferSize;
    }
    return self;
}

-(RawData*)subData:(int)start period:(int)period{
    RawData* subData = [[RawData alloc] init:period];
    subData.accDataArray = self.accDataArray;
    subData.gyrDataArray = self.gyrDataArray;
    subData.accDataArray[0] = self.accDataArray[0]+start;
    subData.accDataArray[1] = self.accDataArray[1]+start;
    subData.accDataArray[2] = self.accDataArray[2]+start;
    subData.gyrDataArray[0] = self.gyrDataArray[0]+start;
    subData.gyrDataArray[1] = self.gyrDataArray[1]+start;
    subData.gyrDataArray[2] = self.gyrDataArray[2]+start;
    
    return subData;
}

@end
