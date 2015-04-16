//
//  TableViewController.m
//  socketDemo
//
//  Created by AlienLi on 15/4/16.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "TableViewController.h"

#import "GCDAsyncSocketManager.h"
#import <CocoaSSDP/SSDPServiceBrowser.h>
#import <CocoaSSDP/SSDPService.h>
#import <CocoaSSDP/SSDPServiceTypes.h>

@interface TableViewController ()<SSDPServiceBrowserDelegate>
{
    SSDPServiceBrowser *_browser;
    NSMutableArray *IP_Items;
}
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    IP_Items = [[NSMutableArray alloc] init];
    
    _browser = [[SSDPServiceBrowser alloc] initWithServiceType:SSDPServiceType_All];
    _browser.delegate = self;
    [_browser startBrowsingForServices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return IP_Items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = IP_Items[indexPath.row];
    
    return cell;
}


#pragma mark - SSDP browser delegate methods

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error {
    NSLog(@"SSDP Browser got error: %@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service {
    NSLog(@"SSDP Browser found: %@", service);
    
    if (service.location.host != nil) {
        
        BOOL shouldInsert = YES;
        if (IP_Items.count >0) {
            for (int index = 0; index < IP_Items.count; index++) {
                shouldInsert = YES;
                if ([IP_Items[index] isEqualToString:service.location.host]) {
                    shouldInsert = NO;
                    break;
                }
            }
        }
        if (shouldInsert) {
            [self.tableView beginUpdates];
            [IP_Items insertObject:service.location.host atIndex:0];
            
            [[GCDAsyncSocketManager DefaultManager] connectToIPAddress:service.location.host];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
        
        
    }
    
    
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service {
    NSLog(@"SSDP Browser removed: %@", service);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
