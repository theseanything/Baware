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
    // using recording to create windowSet
    
    
    // constructor of windowSet generates features
    WindowSet* windowSet = [[WindowSet alloc] init:recording windowSize:200 overlap:1];
    
    // constuct a classifier
    Classifier* classifier;
    
    // pass the windowsSet to the classifier    // return results of classifier
    NSMutableSet *setOfEvents = [classifier classify:windowSet];
    
    // create event based results of classifer - label and time occurred
    //Event* newEvent = [[Event alloc] init];
    
    // newEvent.timeOccured = self.recording.dateCreated + (arrayRef * 32 /1000)
    // newEvent.duration =
    //newEvent.type = @"Brushing Teeth";
    
    
    // create set of events
    //[setOfEvents addObject:newEvent];
    
    // save to recording
    recording.events = setOfEvents;
    
    
    
}



// ---- delete rawData ----


@end
