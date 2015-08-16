//
//  RecordingDetailViewController.h
//  Baware
//
//  Created by Sean Rankine on 13/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Recording.h"
#import "Event.h"
#import "EventsController.h"

@interface RecordingDetailViewController :  UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property Recording* recording;

@end
