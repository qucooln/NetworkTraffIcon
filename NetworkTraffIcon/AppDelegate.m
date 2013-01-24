//
//  AppDelegate.m
//  NetworkTraffIcon
//
//  Created by Qucooln on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkTraffFetcher.h"

@implementation AppDelegate

//@synthesize window = _window;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NetworkTraffFetcher* NetFetcher=[[NetworkTraffFetcher alloc] init];
    [NetFetcher UpdateTraffic];
}

@end
