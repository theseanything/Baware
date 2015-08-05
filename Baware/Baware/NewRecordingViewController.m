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
@property BOOL recordingCompleted;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextView *console;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *accCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyrCounterLabel;


@property float **accData;
@property float **gyrData;
@property int a;
@property int g;
@property RecordingItem *tempRecording;

@end

@implementation NewRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recordingCompleted = NO;
    
    //Change to the tempRecording
    self.accData = malloc(sizeof(double*)*1000);
    for (int i = 0; i < 1000; i++) {
        self.accData[i] = malloc(sizeof(double)*3);
        for (int n = 0; n < 3; n++) { self.accData[i][n] = 0; }
    }
    
    self.gyrData = malloc(sizeof(double*)*1000);
    for (int i = 0; i < 1000; i++) {
        self.gyrData[i] = malloc(sizeof(double)*3);
        for(int n = 0; n < 3; n++) { self.gyrData[i][n] = 0; }
    }
    // Do any additional setup after loading the view.
    
    //Connect to band
    [MSBClientManager sharedManager].delegate = self;
    NSArray *clients = [[MSBClientManager sharedManager]attachedClients];
    _client = [clients firstObject];
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
    
    self.tempRecording = [[RecordingItem alloc] init];
    
    self.tempRecording.dateCreated = [NSDate date];
    self.tempRecording.accData = self.accData;
    self.tempRecording.gyrData = self.gyrData;
    
    self.tempRecording.accCount = [[NSNumber alloc] initWithInt:self.a];
    self.tempRecording.gyrCount = [[NSNumber alloc] initWithInt:self.g];
    
    if(self.a>self.g) self.tempRecording.duration = [[NSNumber alloc] initWithInt:(self.g*32/1000)];
    else self.tempRecording.duration = [[NSNumber alloc] initWithInt:(self.a*32/1000)];
    
    self.recordingCompleted = YES;
    self.stopButton.enabled = NO;
    self.startButton.enabled = YES;
    
    
}

-(void)displayRecordingInfo
{
    self.accCounterLabel.text = [NSString stringWithFormat:@"%@", self.recording.accCount];
    self.gyrCounterLabel.text = [NSString stringWithFormat:@"%@", self.recording.gyrCount];
    self.durationLabel.text = [NSString stringWithFormat:@"%@ s", self.recording.duration];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    self.timeLabel.text = [dateFormatter stringFromDate:self.recording.dateCreated];
    
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender != self.saveButton) return;
    if (self.recordingCompleted) {
        self.recording = [[RecordingItem alloc] init];
        
        self.recording.dateCreated = [NSDate date];
        self.recording.accData = self.accData;
        self.recording.gyrData = self.gyrData;
        
        self.recording.accCount = [[NSNumber alloc] initWithInt:self.a];
        self.recording.gyrCount = [[NSNumber alloc] initWithInt:self.g];
        
        if(self.a>self.g) self.recording.duration = [[NSNumber alloc] initWithInt:(self.g*32/1000)];
        else self.recording.duration = [[NSNumber alloc] initWithInt:(self.a*32/1000)];
    }
}


- (IBAction)startButton:(id)sender {
    [self output:@"Start button pressed."];
    
    if (self.client && self.client.isDeviceConnected)
    {
        [self output:@"Starting Accelerometer updates..."];
        self.stopButton.enabled = YES;
        self.startButton.enabled = NO;
        //self.senseData = [[NSMutableArray alloc] initWithCapacity:100];
        
        self.a = 0;
        self.g = 0;
        
        [self.client.sensorManager startAccelerometerUpdatesToQueue:nil errorRef:nil withHandler:^(MSBSensorAccelerometerData *accelerometerData, NSError *error) {
            
            self.accData[self.a][0] = accelerometerData.x;
            self.accData[self.a][1] = accelerometerData.y;
            self.accData[self.a][2] = accelerometerData.z;
            self.a++;
            
        }];
        
        [self.client.sensorManager startGyroscopeUpdatesToQueue:nil errorRef:nil withHandler:^(MSBSensorGyroscopeData *gyroscopeData, NSError *error) {
            
            self.gyrData[self.g][0] = gyroscopeData.x;
            self.gyrData[self.g][1] = gyroscopeData.y;
            self.gyrData[self.g][2] = gyroscopeData.z;
            self.g++;
            
        }];
        
        //Stop Accel updates after 60 seconds
        //[self performSelector:@selector(stopAccelUpdates) withObject:0 afterDelay:5];
    }
    else
    {
        [self output:@"Band is not connected. Please wait...."];
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

