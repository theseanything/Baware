//
//  Recording.h
//  Baware
//
//  Created by Sean Rankine on 06/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RawData.h"

//@interface ArrayToDataTransformer : NSValueTransformer
//@end

@class Event;

@interface Recording : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * accCounter;
@property (nonatomic, retain) NSNumber * gyrCounter;
@property (nonatomic, retain) NSNumber * analysed;
@property (nonatomic, retain) id sensorData;
@property (nonatomic, retain) NSSet *events;

-(void)setData:(RawData*)rawData;
-(float**)getData;
-(float*)getAxis:(int)axisN;


@end

@interface Recording (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
