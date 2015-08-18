//
//  NewRecordingViewController.m
//  Baware 2
//
//  Created by Sean Rankine on 04/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "NewRecordingViewController.h"

@interface NewRecordingViewController ()
@property (nonatomic, weak) MSBClient *client;

- (IBAction)startButton:(id)sender;
- (IBAction)stopButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextView *console;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *accCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyrCounterLabel;

@property int a;
@property int g;
@property NSDate *startRecordingTime;

@property RawData *rawData;

@end

@implementation NewRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Connect to band
    [MSBClientManager sharedManager].delegate = self;
    NSArray *clients = [[MSBClientManager sharedManager]attachedClients];
    self.client = [clients firstObject];
    if (_client == nil) {
        [self output:@"No bands attached."];
        return;
    }
    [[MSBClientManager sharedManager] connectClient:_client];
    [self output:@"Please wait. Connecting to Band..."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startButton:(id)sender {
    [self output:@"Start button pressed."];
    
    if (self.client && self.client.isDeviceConnected)
    {
        [self output:@"Starting Accelerometer updates..."];
        self.stopButton.enabled = YES;
        self.startButton.enabled = NO;
        
        if(self.rawData == nil) {
            self.rawData = [[RawData alloc] init];
        }
        
        self.a = 0;
        self.g = 0;
        
        self.startRecordingTime = [NSDate date];
        
        [self.client.sensorManager startAccelerometerUpdatesToQueue:nil errorRef:nil withHandler:^(MSBSensorAccelerometerData *accelerometerData, NSError *error) {
            
            self.rawData.accDataArray[self.a][0] = accelerometerData.x;
            self.rawData.accDataArray[self.a][1] = accelerometerData.y;
            self.rawData.accDataArray[self.a][2] = accelerometerData.z;
            self.a++;
            
        }];
        
        [self.client.sensorManager startGyroscopeUpdatesToQueue:nil errorRef:nil withHandler:^(MSBSensorGyroscopeData *gyroscopeData, NSError *error) {
            
            self.rawData.gyrDataArray[self.g][0] = gyroscopeData.x;
            self.rawData.gyrDataArray[self.g][1] = gyroscopeData.y;
            self.rawData.gyrDataArray[self.g][2] = gyroscopeData.z;
            self.g++;
            
        }];

    }
    else
    {
        [self output:@"Band is not connected. Please wait...."];
    }
    
    
}


- (IBAction)stopButton:(id)sender {
    [self stopUpdates];
    [self createRecording];
    [self displayRecordingInfo];
    
    self.stopButton.enabled = NO;
    self.startButton.enabled = YES;
    self.saveButton.enabled = YES;
}

- (void)output:(NSString *)message {
    self.console.text = [NSString stringWithFormat:@"%@\n%@", self.console.text, message];
    CGPoint p = [self.console contentOffset];
    [self.console setContentOffset:p animated:NO];
    [self.console scrollRangeToVisible:NSMakeRange([self.console.text length], 0)];
}


- (void)stopUpdates
{
    [self output:@"Stopping updates..."];
    [self.client.sensorManager stopGyroscopeUpdatesErrorRef:nil];
    [self.client.sensorManager stopAccelerometerUpdatesErrorRef:nil];
    [self output:@"Updates stopped."];
}

-(void)createRecording
{
    if(self.recording == nil) {
        self.recording = (Recording *)[NSEntityDescription insertNewObjectForEntityForName:@"Recording" inManagedObjectContext:self.managedObjectContext];
    }
    
    self.recording.dateCreated = self.startRecordingTime;
    
    self.recording.accCounter = [[NSNumber alloc] initWithInt:self.a];
    self.recording.gyrCounter = [[NSNumber alloc] initWithInt:self.g];
    
    self.recording.duration = [self calculateDuration:self.a gyrCounter:self.g];
    
    [self.recording setData:self.rawData.accDataArray gyrData:self.rawData.gyrDataArray];
    
}

-(void)displayRecordingInfo
{
    self.accCounterLabel.text = [NSString stringWithFormat:@"%@", self.recording.accCounter];
    self.gyrCounterLabel.text = [NSString stringWithFormat:@"%@", self.recording.gyrCounter];
    self.durationLabel.text = [NSString stringWithFormat:@"%@ s", [self calculateDuration:self.a gyrCounter:self.g]];
    
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    }
    
    self.timeLabel.text = [dateFormatter stringFromDate:self.recording.dateCreated];
    
}

-(NSNumber*)calculateDuration:(int)aCount gyrCounter:(int)gCount{
    if(aCount>gCount) return [[NSNumber alloc] initWithInt:(self.g*32/1000)];
    return[[NSNumber alloc] initWithInt:(self.a*32/1000)];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [[MSBClientManager sharedManager] cancelClientConnection:_client];
    if (sender != self.saveButton){
        [self cancelData];
        return;
    }
    if (self.recording != nil) {
        [self saveData];
    }
}

- (void)saveData{
    NSError *error = nil;
    if (![self.recording.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    //[self.delegate newRecordingViewController:self didAddRecording:self.recording];
}

-(void)cancelData{
    [self.recording.managedObjectContext deleteObject:self.recording];
    
//    NSError *error = nil;
//    if (![self.recording.managedObjectContext save:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
    //[self.delegate newRecordingViewController:self didAddRecording:nil];
}





#pragma mark - Client Manager Delegates

- (void)clientManager:(MSBClientManager *)clientManager clientDidConnect:(MSBClient *)client
{
    [self output:@"Band connected."];
    self.startButton.enabled = YES;
    
}

- (void)clientManager:(MSBClientManager *)clientManager clientDidDisconnect:(MSBClient *)client
{
    [self output:@"Band disconnected."];
    self.startButton.enabled = NO;
    self.stopButton.enabled = NO;
    
}

- (void)clientManager:(MSBClientManager *)clientManager client:(MSBClient *)client didFailToConnectWithError:(NSError *)error
{
    [self output:@"Failed to connect to Band."];
    [self output:error.description];
    self.startButton.enabled = NO;
    self.stopButton.enabled = NO;
    
}

@end

