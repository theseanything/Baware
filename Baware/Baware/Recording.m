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

-(void)setData:(RawData*)rawData{;
    /*
    NSMutableArray *aX = [[NSMutableArray alloc] initWithCapacity:rawData.size];
    NSMutableArray *aY = [[NSMutableArray alloc] initWithCapacity:rawData.size];
    NSMutableArray *aZ = [[NSMutableArray alloc] initWithCapacity:rawData.size];
    NSMutableArray *gX = [[NSMutableArray alloc] initWithCapacity:rawData.size];
    NSMutableArray *gY = [[NSMutableArray alloc] initWithCapacity:rawData.size];
    NSMutableArray *gZ = [[NSMutableArray alloc] initWithCapacity:rawData.size];
    
    for (int i = 0; i < rawData.size; i++) {
        [aX addObject: [[NSNumber alloc] initWithFloat:rawData.accDataArray[0][i]]];
        [aY addObject: [[NSNumber alloc] initWithFloat:rawData.accDataArray[1][i]]];
        [aZ addObject: [[NSNumber alloc] initWithFloat:rawData.accDataArray[2][i]]];
        [gX addObject: [[NSNumber alloc] initWithFloat:rawData.gyrDataArray[0][i]]];
        [gY addObject: [[NSNumber alloc] initWithFloat:rawData.gyrDataArray[1][i]]];
        [gZ addObject: [[NSNumber alloc] initWithFloat:rawData.gyrDataArray[2][i]]];
    }
    
    self.sensorData = [[NSArray alloc] initWithObjects:aX, aY, aZ, gX, gY, gZ, nil];
    
    for (int i = 0; i < 7; i++) {
        NSLog(@"rawDataOUT: %f", rawData.accDataArray[2][i]);
        NSLog(@"sensorDataIN: %f", [[[self.sensorData objectAtIndex:i]objectAtIndex:2]floatValue]);
    }*/
    
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

-(RawData*)getData{
    RawData* rawData = [[RawData alloc] initWithArray:self.sensorData];
    return rawData;
};


@end

#pragma mark -

/*
 -(float*)getAxis:(int) axisN{
 if (axisN > 6 || axisN <0) return nil;
 
 float* data = malloc(sizeof(float)*1000);
 for (int i = 0; i < 1000; i++)
 {
 data[i] = [[[self.sensorData objectAtIndex:i] objectAtIndex:axisN] floatValue];
 }
 return data;
 };*/

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
