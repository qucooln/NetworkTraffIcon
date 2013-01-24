//
//  StatusIcon.m
//  NetworkTraffIcon
//
//  Created by Qucooln on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusIcon.h"

@implementation StatusIcon


-(void)ShowStatusIcon:(NSStatusBar *)bar :(NSStatusItem *)statusItem :(NSMenu *)theMenu: (NSString*) Traff
{
        
    [statusItem setTitle: NSLocalizedString(Traff,@"")];
    [statusItem setHighlightMode:YES];
    
    NSMenuItem *item;
    theMenu = [[NSMenu alloc] initWithTitle:@""];
    item = [theMenu addItemWithTitle:@"Setting" action:@selector(Setting:) keyEquivalent:@"S"];
    [item setTarget:self];
    [theMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"Q"];
    
    [statusItem setMenu:theMenu];
    [theMenu release];
    
}

-(void) Setting:(id)sender
{
    SingletonDataClass* shareDataManager=[SingletonDataClass sharedManager];
    [shareDataManager.settingWindow makeKeyAndOrderFront:self];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    [shareDataManager.TextFieldUserName setStringValue:[userPrefs stringForKey:@"username"]];
    [shareDataManager.TextFieldPassword setStringValue:[userPrefs stringForKey:@"password"]];
}


-(void)dealloc
{
    [super dealloc];
}

@end
