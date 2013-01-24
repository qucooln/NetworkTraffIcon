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

@synthesize settingWindow;
@synthesize TextFieldUserName;
@synthesize TextFieldPassword;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [settingWindow orderOut:self];
    SingletonDataClass* shareDataManager=[SingletonDataClass sharedManager];
    shareDataManager.settingWindow=settingWindow;
    shareDataManager.TextFieldUserName=TextFieldUserName;
    shareDataManager.TextFieldPassword=TextFieldPassword;
    
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    username=[userPrefs stringForKey:@"username"];
    if([username length]==0){//First Run App
        username=[NSString stringWithFormat:@"noctest5"];
        password=[NSString stringWithFormat:@"cqu2011"];
        [userPrefs setObject:username forKey:@"username"];
        [userPrefs setObject:password forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NetworkTraffFetcher* NetFetcher=[[NetworkTraffFetcher alloc] init];
    [NetFetcher UpdateTraffic];
}
- (IBAction)toggleCancelBtn:(id)sender {
    [settingWindow orderOut:self];
}

- (IBAction)toggleConfirmBtn:(id)sender {
    username=[TextFieldUserName stringValue];
    password=[TextFieldPassword stringValue];
    
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    [userPrefs setObject:username forKey:@"username"];
    [userPrefs setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://gate.cqu.edu.cn/F.htm"]] autorelease];
	[request startSynchronous];
    if ([request responseString]) {
        ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://gate.cqu.edu.cn/"]] autorelease];
        [request startSynchronous];
	}
    
    [settingWindow orderOut:self];
}

@end
