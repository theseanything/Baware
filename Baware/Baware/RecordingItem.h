//
//  RecordingItem.h
//  Baware 2
//
//  Created by Sean Rankine on 04/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ArrayToDataTransformer : NSValueTransformer
@end

@interface RecordingItem : NSManagedObject

@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *accCount;
@property (nonatomic, strong) NSNumber *gyrCount;

@property float **accData;
@property float **gyrData;

-(void)initCArrays;

@end
