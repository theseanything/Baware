//
//  LiveViewController.m
//  Baware
//
//  Created by Sean Rankine on 19/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()
@property (nonatomic, weak) MSBClient *client;
@property (weak, nonatomic) IBOutlet UILabel *bandStatusLabel;
- (IBAction)startButton:(id)sender;
- (IBAction)stopButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@property int a;
@property int g;
@property NSDate *startRecordingTime;
@property NSNumber *timeLiveFor;
@property BOOL isBrushing;

@property RawData *rawData;

@end

@implementation LiveViewController

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
    self.timeLiveFor = @60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startButton:(id)sender {
    [self output:@"Start button pressed."];
    
    if (self.client && self.client.isDeviceConnected)
    {
        [self output:@"Collecting sensor readings..."];
        self.stopButton.enabled = YES;
        self.startButton.enabled = NO;
        
        int windowSize = [self.timeLiveFor intValue]*1000*32;
        int interval = 200;
        
        if(self.rawData == nil) {
            self.rawData = [[RawData alloc] init:windowSize];
        }
        
        self.a = 0;
        self.g = 0;
        
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        EventsController* eventsController = [[EventsController alloc] init];
        self.isBrushing = NO;
        
        
        self.startRecordingTime = [NSDate date];
        
        [self.client.sensorManager startAccelerometerUpdatesToQueue:nil errorRef:nil withHandler:^(MSBSensorAccelerometerData *accelerometerData, NSError *error) {
            
            self.rawData.accDataArray[0][self.a] = accelerometerData.x;
            self.rawData.accDataArray[1][self.a] = accelerometerData.y;
            self.rawData.accDataArray[2][self.a] = accelerometerData.z;
            self.a++;
            if (self.a%interval == 0){
                dispatch_async(myQueue, ^{
                    self.isBrushing = [eventsController classifyEvent:[self.rawData subData:interval*(self.a/interval)-1 period:interval]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.isBrushing) self.activityLabel.text = @"Brushing";
                        else self.activityLabel.text = @"Not Brushing";
                    });
                });
            }
            
            if (self.a >= windowSize){
                [self stopButton:nil];
            }
            
        }];
        
        [self.client.sensorManager startGyroscopeUpdatesToQueue:nil errorRef:nil withHandler:^(MSBSensorGyroscopeData *gyroscopeData, NSError *error) {
            
            self.rawData.gyrDataArray[0][self.g] = gyroscopeData.x;
            self.rawData.gyrDataArray[1][self.g] = gyroscopeData.y;
            self.rawData.gyrDataArray[2][self.g] = gyroscopeData.z;
            self.g++;
            if (self.g >= windowSize){
                [self stopButton:nil];
            }
        }];
        
    }
    else
    {
        [self output:@"Band is not connected. Please wait...."];
    }
    
    
}




- (IBAction)stopButton:(id)sender {
    [self stopUpdates];
    
    self.stopButton.enabled = NO;
    self.startButton.enabled = YES;
}

- (void)output:(NSString *)message {
    self.bandStatusLabel.text = message;
}


- (void)stopUpdates
{
    [self output:@"Stopping updates..."];
    [self.client.sensorManager stopGyroscopeUpdatesErrorRef:nil];
    [self.client.sensorManager stopAccelerometerUpdatesErrorRef:nil];
    [self output:@"Updates stopped."];
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

