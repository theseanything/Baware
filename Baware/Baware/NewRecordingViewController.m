//
//  NewRecordingViewController.m
//  Baware 2
//
//  Created by Sean Rankine on 04/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "NewRecordingViewController.h"

@interface NewRecordingViewController ()


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

@property RecordingItem *tempRecording;

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
        
        if(self.tempRecording == nil) self.tempRecording = [[RecordingItem alloc] init];
        
        self.a = 0;
        self.g = 0;
        
        [self.client.sensorManager startAccelerometerUpdatesToQueue:nil errorRef:nil withHandler:^(MSBSensorAccelerometerData *accelerometerData, NSError *error) {
            
            self.tempRecording.accData[self.a][0] = accelerometerData.x;
            self.tempRecording.accData[self.a][1] = accelerometerData.y;
            self.tempRecording.accData[self.a][2] = accelerometerData.z;
            self.a++;
            
        }];
        
        [self.client.sensorManager startGyroscopeUpdatesToQueue:nil errorRef:nil withHandler:^(MSBSensorGyroscopeData *gyroscopeData, NSError *error) {
            
            self.tempRecording.gyrData[self.g][0] = gyroscopeData.x;
            self.tempRecording.gyrData[self.g][1] = gyroscopeData.y;
            self.tempRecording.gyrData[self.g][2] = gyroscopeData.z;
            self.g++;
            
        }];

    }
    else
    {
        [self output:@"Band is not connected. Please wait...."];
    }
    
    
}

- (void)output:(NSString *)message
{
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
    
    self.tempRecording.dateCreated = [NSDate date];
    
    self.tempRecording.accCount = [[NSNumber alloc] initWithInt:self.a];
    self.tempRecording.gyrCount = [[NSNumber alloc] initWithInt:self.g];
    
    if(self.a>self.g) self.tempRecording.duration = [[NSNumber alloc] initWithInt:(self.g*32/1000)];
    else self.tempRecording.duration = [[NSNumber alloc] initWithInt:(self.a*32/1000)];
    
    self.stopButton.enabled = NO;
    self.startButton.enabled = YES;
    self.saveButton.enabled = YES;
    
}

-(void)displayRecordingInfo
{
    self.accCounterLabel.text = [NSString stringWithFormat:@"%@", self.tempRecording.accCount];
    self.gyrCounterLabel.text = [NSString stringWithFormat:@"%@", self.tempRecording.gyrCount];
    self.durationLabel.text = [NSString stringWithFormat:@"%@ s", self.tempRecording.duration];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    self.timeLabel.text = [dateFormatter stringFromDate:self.tempRecording.dateCreated];
    
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [[MSBClientManager sharedManager] cancelClientConnection:_client];
    if (sender != self.saveButton) return;
    if (self.tempRecording != nil) {
        self.recording = [[RecordingItem alloc] init];
        self.recording = self.tempRecording;
    }
}




- (IBAction)stopButton:(id)sender {
    [self stopUpdates];
    [self displayRecordingInfo];
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

