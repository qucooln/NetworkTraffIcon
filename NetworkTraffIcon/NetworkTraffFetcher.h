//
//  NetworkTraffFetcher.h
//  NetworkTraffIcon
//
//  Created by Qucooln on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "LoginHelper.h"
#import <CommonCrypto/CommonDigest.h>

@class StatusIcon;

@interface NetworkTraffFetcher : NSObject<NSURLConnectionDelegate>{
    NSMutableData* receiveData;
    NSString* TrafficData;
    NSStatusBar *bar;
    NSStatusItem *statusItem;
    NSMenu *theMenu;
    StatusIcon* statusIco;
    NSMutableDictionary* loginParaDictionary;
    NSString *username;
    NSString *password;
}

-(void) FetchNetworkTraffic;
-(void) UpdateTraffic;
-(void) handleTimer:(NSTimer*) Timer;

@property (retain, nonatomic) NSMutableData* receiveData;
@property (retain, nonatomic) NSString* TrafficData;
@property (retain, nonatomic) NSStatusItem *statusItem;
@property (retain, nonatomic) StatusIcon* statusIco;

@end
