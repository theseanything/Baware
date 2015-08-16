//
//  RawData.m
//  Baware
//
//  Created by Sean Rankine on 07/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "RawData.h"

@implementation RawData

- (RawData*)init
{
    self = [super init];
    if (self)
    {
        self.accDataArray = malloc(sizeof(float*)*1000);
        for (int i = 0; i < 1000; i++)
        {
            self.accDataArray[i] = malloc(sizeof(float)*3);
            for (int n = 0; n < 3; n++) { self.accDataArray[i][n] = 0; }
        }
        self.gyrDataArray = malloc(sizeof(float*)*1000);
        for (int i = 0; i < 1000; i++)
        {
            self.gyrDataArray[i] = malloc(sizeof(float)*3);
            for(int n = 0; n < 3; n++) { self.gyrDataArray[i][n] = 0; }
        }
    }
    return self;
}

@end
