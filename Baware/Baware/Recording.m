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

@end

#pragma mark -

@implementation ArrayToDataTransformer

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

@end
