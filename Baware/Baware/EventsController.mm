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
    self.windowDuration = 1.6;
    
    
    // using recording to create windowSet
    WindowSet* windowSet = [[WindowSet alloc] init:recording windowSize:[self windowSizeFromDuration:self.windowDuration] percent_overlap:0];
    
    // constuct a classifier
    Classifier* classifier = [[Classifier alloc]init];
    
    // pass the windowsSet to the classifier    // return results of classifier
    std::vector<float> array = [classifier classify:windowSet];
    
    int elmNum = 1, start = 0, stop = 0;
    
    int prevType = 1;
    
    for (float &currType : array )
    {
        if (currType == 1 && prevType == 1 ){
            elmNum++;
            continue;
        }
        
        if (currType != 1 && prevType == 1) {
            prevType = currType;
            start = elmNum;
        }
        
        else if (currType != 1 && prevType == currType){
            stop = elmNum;
        }
        
        else if (currType == 1 && prevType != currType) {
            
            if (prevType == 2) {
                Event *newEvent = (Event *) [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
                newEvent.type = @"Brushing";
                
                newEvent.timeOccured = [recording.dateCreated dateByAddingTimeInterval:(windowSet.windowTimeInterval*(start-1))];
                
                newEvent.duration = @(self.windowDuration*(stop-start));
                
                newEvent.recording = recording;
                [recording addEventsObject:newEvent];
                
                
                NSError *error = nil;
                if (![newEvent.managedObjectContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
            else if (prevType == 3) {
                Event *newEvent = (Event *) [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
                newEvent.type = @"Hitting";
                
                newEvent.timeOccured = [recording.dateCreated dateByAddingTimeInterval:(windowSet.windowTimeInterval*(start-1))];
                
                newEvent.duration = @(self.windowDuration*(stop-start));
                
                newEvent.recording = recording;
                [recording addEventsObject:newEvent];
                
                
                NSError *error = nil;
                if (![newEvent.managedObjectContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
            prevType = currType;
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

-(BOOL)classifyEvent:(RawData*)rawData{
    static Classifier* classifier;
    if (classifier == nil) classifier = [[Classifier alloc]init];
    
    WindowSet* windowSet = [[WindowSet alloc] init:rawData];
    
    std::vector<float> array = [classifier classify:windowSet];
    
    if (array[0] == 1) return YES;
    
    return NO;
}


-(int)windowSizeFromDuration:(NSTimeInterval)durationInSecs{
    return durationInSecs*1000/32;
}


// ---- delete rawData ----


@end
