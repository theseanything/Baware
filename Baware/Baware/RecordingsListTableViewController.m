//
//  RecordingsListTableViewController.m
//  Baware 2
//
//  Created by Sean Rankine on 04/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import "RecordingsListTableViewController.h"
#import "NewRecordingViewController.h"
#import "RecordingItem.h"

@interface RecordingsListTableViewController ()
@property NSMutableArray *recordings;
@property NSDateFormatter *dateFormatter;
@property (nonatomic, weak) MSBClient *client;

@end

@implementation RecordingsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateFormatter =[[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    self.recordings = [[NSMutableArray alloc] init];
    
    NSArray *clients = [[MSBClientManager sharedManager]attachedClients];
    self.client = [clients firstObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    NewRecordingViewController *source = [segue sourceViewController];
    RecordingItem *item = source.recording;
    if (item != nil) {
        [self.recordings addObject:item];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recordings count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    RecordingItem *recording = [self.recordings objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [self.dateFormatter stringFromDate:recording.dateCreated];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //Pass the band controller
    if ([segue.identifier isEqualToString:@"newRecordingSegue"]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        NewRecordingViewController* newRecording = (NewRecordingViewController *)navController.topViewController;
        newRecording.client = self.client;
    }
    
}


@end
