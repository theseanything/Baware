//
//  NewRecordingViewController.h
//  Baware 2
//
//  Created by Sean Rankine on 04/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MicrosoftBandKit_iOS/MicrosoftBandKit_iOS.h>
#import "RecordingItem.h"

@interface NewRecordingViewController : UIViewController<MSBClientManagerDelegate>

@property RecordingItem *recording;
- (IBAction)startButton:(id)sender;
- (IBAction)stopButton:(id)sender;

@end
