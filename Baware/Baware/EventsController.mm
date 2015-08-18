//
//  EventsController.m
//  Baware
//
//  Created by Sean Rankine on 10/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "EventsController.h"

@implementation EventsController

-(void)generateEvents:(Recording*) recording{
    self.windowDuration = 6.4;
    
    
    // using recording to create windowSet
    WindowSet* windowSet = [[WindowSet alloc] init:recording windowSize:[self windowSizeFromDuration:self.windowDuration] percent_overlap:0];
    
    // constuct a classifier
    Classifier* classifier = [[Classifier alloc]init];
    
    // pass the windowsSet to the classifier    // return results of classifier
    std::vector<float> array = [classifier classify:windowSet];
    
    int elmNum = 1;
    
    for (float &i : array )
    {
        if (i != 0) {
            Event *newEvent = (Event *) [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
            newEvent.type = @"Brushing";
            
            newEvent.timeOccured = [recording.dateCreated dateByAddingTimeInterval:(windowSet.windowTimeInterval*elmNum)];
            
            newEvent.duration = @1;
            
            newEvent.recording = recording;
            [recording addEventsObject:newEvent];
            
            NSError *error = nil;
            if (![newEvent.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        
        elmNum++;
    }
    
    
    
    // create event based results of classifer - label and time occurred
    //Event* newEvent = [[Event alloc] init];
    
    // newEvent.timeOccured = self.recording.dateCreated + (arrayRef * 32 /1000)
    // newEvent.duration =
    //newEvent.type = @"Brushing Teeth";
    
    
    // create set of events
    //[setOfEvents addObject:newEvent];
    
    // save to recording
    

    
}

-(int)windowSizeFromDuration:(NSTimeInterval)durationInSecs{
    return durationInSecs*1000/32;
}

// ---- delete rawData ----


@end
