//
//  Recording.m
//  Baware
//
//  Created by Sean Rankine on 06/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "Recording.h"

@implementation Recording

@dynamic duration,  dateCreated, accCounter, gyrCounter, sensorData, events, analysed;

-(void)setData:(float **)accData gyrData:(float **)gyrData{
    self.sensorData = [[NSMutableArray alloc]initWithCapacity:1000];
    for (int i = 0; i < 1000; i++) {
        NSNumber *aX = [[NSNumber alloc] initWithDouble:accData[i][0]];
        NSNumber *aY = [[NSNumber alloc] initWithDouble:accData[i][1]];
        NSNumber *aZ = [[NSNumber alloc] initWithDouble:accData[i][2]];
        NSNumber *gX = [[NSNumber alloc] initWithDouble:gyrData[i][0]];
        NSNumber *gY = [[NSNumber alloc] initWithDouble:gyrData[i][1]];
        NSNumber *gZ = [[NSNumber alloc] initWithDouble:gyrData[i][2]];
        
        NSArray *dataInstance = [[NSArray alloc] initWithObjects:aX, aY, aZ, gX, gY, gZ, nil];
        [self.sensorData addObject:dataInstance];
    }
};

-(float**)getData{
    float** data = malloc(sizeof(float*)*6);
    for (int i = 0; i < 6; i++)
    {
        data[i] = malloc(sizeof(float)*1000);
        for (int n = 0; n < 1000; n++) {
            data[i][n] = [[[self.sensorData objectAtIndex:n] objectAtIndex:i] floatValue];
        }
    }
    return data;
};

-(float*)getAxis:(int) axisN{
    if (axisN > 6 || axisN <0) return nil;
    
    float* data = malloc(sizeof(float)*1000);
    for (int i = 0; i < 1000; i++)
    {
        data[i] = [[[self.sensorData objectAtIndex:i] objectAtIndex:axisN] floatValue];
    }
    return data;
};

@end

#pragma mark -

/*@implementation ArrayToDataTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSArray class];
}

- (id)transformedValue:(id)value {
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value {
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end*/
