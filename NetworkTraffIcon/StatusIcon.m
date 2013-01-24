//
//  StatusIcon.m
//  NetworkTraffIcon
//
//  Created by Qucooln on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusIcon.h"
#import "ASIHTTPRequest.h"

@implementation StatusIcon

-(void)ShowStatusIcon:(NSStatusBar *)bar :(NSStatusItem *)statusItem :(NSMenu *)theMenu: (NSString*) Traff
{
        
    [statusItem setTitle: NSLocalizedString(Traff,@"")];
    [statusItem setHighlightMode:YES];
    
    NSMenuItem *item;
    theMenu = [[NSMenu alloc] initWithTitle:@""];
    item = [theMenu addItemWithTitle:@"Login" action:@selector(Login) keyEquivalent:@"L"];
    [item setTarget:self];
    [theMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"Q"];
    
    [statusItem setMenu:theMenu];
    [theMenu release];
    
}

-(void) Login
{
    NSLog(@"login");
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://gate.cqu.edu.cn/"]];
    //[request setPostValue:@"1" forKey:@"go"];
    [request setRequestMethod:@"POST"];
    /*[request setPostValue:@"20111402046" forKey:@"DDDDD"];
    [request setPostValue:@"56352439" forKey:@"upass"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];*/
    [request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    // response contains the HTML response from the form.
    NSLog(response);
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    // Do something with the error.
    NSLog(error.description);
}

-(void)dealloc
{
    [super dealloc];
}

@end
