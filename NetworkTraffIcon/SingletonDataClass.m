//
//  SingletonDataClass.m
//  Guide for Chongqing
//
//  Created by Qucooln on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingletonDataClass.h"

@implementation SingletonDataClass

@synthesize settingWindow;
@synthesize TextFieldUserName;
@synthesize TextFieldPassword;

#pragma  mark Singleton Methods

static SingletonDataClass *sharedInstanceManager = nil;

+ (SingletonDataClass*)sharedManager
{
    static dispatch_once_t pred;
    static SingletonDataClass * ShareData;
    dispatch_once(&pred , ^{
        ShareData = [[SingletonDataClass alloc] init]; 
    });
    
    return ShareData;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstanceManager == nil) {
            sharedInstanceManager = [super allocWithZone:zone];
            return sharedInstanceManager;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}

@end
