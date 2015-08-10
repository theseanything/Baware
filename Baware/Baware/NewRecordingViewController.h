//
//  NewRecordingViewController.h
//  Baware 2
//
//  Created by Sean Rankine on 04/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MicrosoftBandKit_iOS/MicrosoftBandKit_iOS.h>
#import <CoreData/CoreData.h>
#import "Recording.h"
#import "RawData.h"

@protocol RecordingAddDelegate;

@interface NewRecordingViewController : UIViewController<MSBClientManagerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) Recording *recording;

@end

