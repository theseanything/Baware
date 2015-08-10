//
//  Recording.m
//  Baware
//
//  Created by Sean Rankine on 06/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "Recording.h"

@implementation Recording

@dynamic duration,  dateCreated, accCounter, gyrCounter, accData, gyrData;

-(void)setData:(float **)accData gyrData:(float **)gyrData{
    self.accData = [[NSMutableArray alloc]initWithCapacity:1000];
    for (int i = 0; i < 1000; i++) {
        NSNumber *aX = [[NSNumber alloc] initWithDouble:accData[i][0]];
        NSNumber *aY = [[NSNumber alloc] initWithDouble:accData[i][1]];
        NSNumber *aZ = [[NSNumber alloc] initWithDouble:accData[i][2]];
        
        NSArray *dataInstance = [[NSArray alloc] initWithObjects:aX, aY, aZ, nil];
        [self.accData addObject:dataInstance];
    }
    
    self.gyrData = [[NSMutableArray alloc]initWithCapacity:1000];
    for (int i = 0; i < 1000; i++) {
        NSNumber *gX = [[NSNumber alloc] initWithDouble:gyrData[i][0]];
        NSNumber *gY = [[NSNumber alloc] initWithDouble:gyrData[i][1]];
        NSNumber *gZ = [[NSNumber alloc] initWithDouble:gyrData[i][2]];
        
        NSArray *dataInstance = [[NSArray alloc] initWithObjects:gX, gY, gZ, nil];
        [self.gyrData addObject:dataInstance];
    }
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
