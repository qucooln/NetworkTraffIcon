//
//  NetworkTraffFetcher.m
//  NetworkTraffIcon
//
//  Created by Qucooln on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkTraffFetcher.h"
#import "StatusIcon.h"

@implementation NetworkTraffFetcher

@synthesize receiveData;
@synthesize TrafficData;
@synthesize statusItem;
@synthesize statusIco;

-(void) FetchNetworkTraffic
{
    // Create the request.

    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gate.cqu.edu.cn/"]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receiveData = [[NSMutableData data] retain];
    } else {
        // Inform the user that the connection failed.
    }
    
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    if(self.TrafficData!=nil)
        return;
    [self.receiveData appendData:data];
    NSString* HttpContent=[[NSString alloc] initWithData: self.receiveData encoding:NSASCIIStringEncoding];
    NSRange startrang = [HttpContent rangeOfString:@"flow"];
    if (startrang.length==0) {
        self.TrafficData=@"Not Connected";
        [self.statusIco ShowStatusIcon:bar: self.statusItem : theMenu: self.TrafficData];
        return;
    }
    NSRange endrang = [HttpContent rangeOfString:@"fsele"];
    NSRange rang = NSMakeRange(startrang.location+6, endrang.location-2-startrang.location-6);
    self.TrafficData=[HttpContent substringWithRange:rang];
    double longTraff=[self.TrafficData doubleValue];
    longTraff=longTraff/1024;
    self.TrafficData=[NSString stringWithFormat:@"%.3f",longTraff];
    self.TrafficData=[self.TrafficData stringByAppendingFormat:@"%@",@" MB"];
    [self.statusIco ShowStatusIcon:bar: self.statusItem : theMenu: self.TrafficData];
    
    [HttpContent release];
    
}

-(void)handleTimer:(NSTimer*) Timer
{
    self.TrafficData=nil;
    [self FetchNetworkTraffic];
}

-(void)UpdateTraffic
{
    self.statusIco=[[StatusIcon alloc] init];
    self.statusItem=[[NSStatusItem alloc] init];
    bar = [NSStatusBar systemStatusBar];
    self.statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem retain];

    NSTimer *timer;
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 5
                                             target: self
                                           selector: @selector(handleTimer:)
                                           userInfo: nil
                                            repeats: YES];
    
}
@end
