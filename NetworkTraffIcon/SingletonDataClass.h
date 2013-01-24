//
//  SingletonDataClass.h
//  Guide for Chongqing
//
//  Created by Qucooln on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonDataClass : NSObject

@property (strong, nonatomic) NSWindow *settingWindow;
@property (strong, nonatomic) NSTextField *TextFieldUserName;
@property (strong, nonatomic) NSSecureTextField *TextFieldPassword;
+ (id)sharedManager;
+ (id)allocWithZone:(NSZone *)zone;
-(id)copyWithZone:(NSZone *)zone;
-(id)retain;
-(unsigned)retainCount;
-(id)autorelease;

@end
