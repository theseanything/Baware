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

-(void)setData:(RawData*)rawData{
    self.sensorData = [[NSMutableArray alloc]initWithCapacity:rawData.size];
    for (int i = 0; i < rawData.size; i++) {
        NSNumber *aX = [[NSNumber alloc] initWithFloat:rawData.accDataArray[0][i]];
        NSNumber *aY = [[NSNumber alloc] initWithFloat:rawData.accDataArray[1][i]];
        NSNumber *aZ = [[NSNumber alloc] initWithFloat:rawData.accDataArray[2][i]];
        NSNumber *gX = [[NSNumber alloc] initWithFloat:rawData.gyrDataArray[0][i]];
        NSNumber *gY = [[NSNumber alloc] initWithFloat:rawData.gyrDataArray[1][i]];
        NSNumber *gZ = [[NSNumber alloc] initWithFloat:rawData.gyrDataArray[2][i]];
        
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
            data[i][n] = [[[self.sensorData objectAtIndex:i] objectAtIndex:n] floatValue];
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
