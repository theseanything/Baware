//
//  Recording.h
//  Baware
//
//  Created by Sean Rankine on 06/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ArrayToDataTransformer : NSValueTransformer
@end

@interface Recording : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * accCounter;
@property (nonatomic, retain) NSNumber * gyrCounter;
@property (nonatomic, retain) id accData;
@property (nonatomic, retain) id gyrData;


@end
