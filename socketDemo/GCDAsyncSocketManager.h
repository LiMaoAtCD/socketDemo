//
//  GCDAsyncSocketManager.h
//  socketDemo
//
//  Created by AlienLi on 15/4/15.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>

#import <CocoaSSDP/SSDPServiceBrowser.h>
#import <CocoaSSDP/SSDPService.h>
#import <CocoaSSDP/SSDPServiceTypes.h>

#define kRemoteHost @"10.0.0.19"
#define kPort   10099

typedef void(^ConnectBlock)(BOOL success);

@interface GCDAsyncSocketManager : NSObject<GCDAsyncSocketDelegate,SSDPServiceBrowserDelegate>
{
    GCDAsyncSocket *socket;
    SSDPServiceBrowser *_browser;
    NSMutableArray *IP_Items;
    ConnectBlock connectBlock;
    
    NSMutableArray * Target_IP_Addresses;
    
}



+(instancetype)DefaultManager;

//-(void)connect;
-(void)connectToIPAddress:(NSString *)IP;
@end
