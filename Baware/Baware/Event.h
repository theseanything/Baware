//
//  Event.h
//  Baware
//
//  Created by Sean Rankine on 09/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * timeOccured;
@property (nonatomic, retain) NSNumber * duration;

@end
