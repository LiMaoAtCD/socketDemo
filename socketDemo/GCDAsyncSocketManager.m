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
    });
    
    return manager;
}

-(void)connectToIPAddress:(NSString *)IP{
    
    NSError *error;
    [socket disconnect];
    if (![socket connectToHost:IP onPort:kPort error:&error]) {
        NSLog(@"%@",error);
    }
    
    //    NSString *test = @"test";
    //  NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];
    //    [socket readDataWithTimeout:-1 tag:1];
    //    [socket writeData:data withTimeout:-1 tag:1];
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
    NSString *test = @"test";
    NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];
    [sock readDataWithTimeout:-1 tag:1];
    [sock writeData:data withTimeout:-1 tag:1];
    [sock disconnect];

}



-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"disconnected");
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




@end
