//
//  RecordingItem.h
//  Baware 2
//
//  Created by Sean Rankine on 04/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordingItem : NSObject

@property NSDate *dateCreated;
@property NSNumber *duration;
@property NSNumber *accCount;
@property NSNumber *gyrCount;

@property float **accData;
@property float **gyrData;

@end
