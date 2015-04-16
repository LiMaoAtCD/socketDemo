//
//  GCDAsyncSocketManager.h
//  socketDemo
//
//  Created by AlienLi on 15/4/15.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>

#define kRemoteHost @"10.0.0.19"
#define kPort   10099

@interface GCDAsyncSocketManager : NSObject<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *socket;
    
}

+(instancetype)DefaultManager;

//-(void)connect;
-(void)connectToIPAddress:(NSString *)IP;
@end
