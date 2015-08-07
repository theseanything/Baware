//
//  RecordingsListTableViewController.h
//  Baware 2
//
//  Created by Sean Rankine on 04/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MicrosoftBandKit_iOS/MicrosoftBandKit_iOS.h>
#import <CoreData/CoreData.h>
#import "NewRecordingViewController.h"

@interface RecordingsListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
