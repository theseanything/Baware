//
//  RecordingItem.m
//  Baware 2
//
//  Created by Sean Rankine on 04/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "RecordingItem.h"

@implementation RecordingItem

-(id)init{
    if (self = [super init])
    {
        self.accData = malloc(sizeof(double*)*1000);
        for (int i = 0; i < 1000; i++) {
            self.accData[i] = malloc(sizeof(double)*3);
            for (int n = 0; n < 3; n++) { self.accData[i][n] = 0; }
        }
        
        self.gyrData = malloc(sizeof(double*)*1000);
        for (int i = 0; i < 1000; i++) {
            self.gyrData[i] = malloc(sizeof(double)*3);
            for(int n = 0; n < 3; n++) { self.gyrData[i][n] = 0; }
        }
    }
    return self;
}

@end
