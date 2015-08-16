//
//  EventsController.h
//  Baware
//
//  Created by Sean Rankine on 10/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recording.h"
#import "WindowSet.h"
#import "Classifier.h"
#import "Event.h"
#import <Accelerate/Accelerate.h>

//#import "Classifier.h"
//#import "WindowSet.h"

@interface EventsController : NSObject

-(void)generateEvents:(Recording*) recording;

@end
