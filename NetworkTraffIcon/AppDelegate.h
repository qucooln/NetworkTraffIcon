//
//  AppDelegate.h
//  NetworkTraffIcon
//
//  Created by Qucooln on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SingletonDataClass.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSWindow *settingWindow;
    NSString *username;
    NSString *password;
}
@property (assign) IBOutlet NSTextField *TextFieldUserName;
@property (assign) IBOutlet NSSecureTextField *TextFieldPassword;

@property (assign) IBOutlet NSWindow *settingWindow;

@end
