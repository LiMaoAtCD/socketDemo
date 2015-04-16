//
//  GCDAsyncSocketManager.m
//  socketDemo
//
//  Created by AlienLi on 15/4/15.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "GCDAsyncSocketManager.h"

@implementation GCDAsyncSocketManager



+(instancetype)DefaultManager{
    
    static GCDAsyncSocketManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager->socket = [[GCDAsyncSocket alloc] initWithDelegate:manager delegateQueue:dispatch_get_main_queue()];
        manager->IP_Items = [[NSMutableArray alloc] init];
        
        manager->_browser = [[SSDPServiceBrowser alloc] initWithServiceType:SSDPServiceType_All];
        manager->_browser.delegate = manager;
        [manager->_browser startBrowsingForServices];
        manager->Target_IP_Addresses =[[NSMutableArray alloc] init];
        
    });
    
    return manager;
}

-(void)connectToIPAddress:(NSString *)IP{
    
    NSError *error;
    [socket disconnect];
    if (![socket connectToHost:IP onPort:kPort error:&error]) {
        NSLog(@"%@",error);
    }
    
}

-(void)connectToIPAddress:(NSString *)IP withCompletionHandler:(ConnectBlock)completionHandler{
    
    NSError *error;
    [socket disconnect];
    if (![socket connectToHost:IP onPort:kPort error:&error]) {
        NSLog(@"%@",error);
    }
    connectBlock = completionHandler;

    
}


-(void)writeString:(NSString*)string withTimeout:(NSTimeInterval)timeout tag:(long)tag{
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    [socket writeData:data withTimeout:timeout tag:tag];
}

-(NSData*)stringToData:(NSString *)string {
    
    return [string dataUsingEncoding:NSASCIIStringEncoding];
}

#pragma mark - socket Delegates

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
   
    NSLog(@"connected");
    //TODO::
    
    connectBlock(YES);

}



-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"disconnected");
    if (connectBlock) {
        connectBlock(NO);
    }

}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (tag == 1)
        NSLog(@"First request sent");
    else if (tag == 2)
        NSLog(@"Second request sent");
}

-(NSString*)convertDataToString:(NSData*)data {
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    printf("tag::%ld\n",tag);
    NSLog(@"%@",[self convertDataToString:data]);
    
    
}
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
}


#pragma mark - SSDP browser delegate methods

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error {
    NSLog(@"SSDP Browser got error: %@", error);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [alert show];
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
//            [self.tableView beginUpdates];
            [IP_Items insertObject:service.location.host atIndex:0];
//            [self connectToIPAddress:service.location.host];
            [self connectToIPAddress:service.location.host withCompletionHandler:^(BOOL success) {
                if(success) {
                    
                    [Target_IP_Addresses addObject:service.location.host];
                    
#warning 这个IP地址数组中虽然可以支持Ip+port 但是还需要筛选出支持自己支持通信的IP
                    
                } else {
                    
                }
            }];
            
            NSLog(@"可用IP为：%@",Target_IP_Addresses);
            
        }
        
        
    }
    
    
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service {
    NSLog(@"SSDP Browser removed: %@", service);
}

-(void)isSupport:(GCDAsyncSocket*)sock{
        NSString *test = @"connect";
        NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];
        [sock readDataWithTimeout:-1 tag:1];
        [sock writeData:data withTimeout:-1 tag:1];
        [sock disconnect];

}




@end
