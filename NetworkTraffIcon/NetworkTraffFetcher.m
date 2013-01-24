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
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    username=[userPrefs stringForKey:@"username"];
    password=[userPrefs stringForKey:@"password"];
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://gate.cqu.edu.cn/"]] autorelease];
    [request setDelegate:self];
	[request startSynchronous];
    NSString *htmlSource;
    if ([request error]) {
		htmlSource = [[request error] localizedDescription];
	} else if ([request responseString]) {
		htmlSource = [request responseString];
        [self connectionSuccess:htmlSource];
	}
}

- (void)connectionSuccess:(NSString*)HttpContent
{
    if(self.TrafficData!=nil)
        return;
    NSRange startrang = [HttpContent rangeOfString:@"flow"];
    
    if (startrang.length==0) {//If not logged in, show info in statusbar and try to login.
        
        self.TrafficData=@"Not Logged In";
        [self.statusIco ShowStatusIcon:bar: self.statusItem : theMenu: self.TrafficData];
        
        //Fetch parameters
        NSRange range;
        
        //Parameter:R1
        NSString *R1=@"0";
        NSRange R1range = [HttpContent rangeOfString:@"onClick=\"cc("];
        range.location = R1range.location+12;
        range.length = 1;
        R1 = [HttpContent substringWithRange:range];
        
        //Parameter:R2
        NSString *R2=@"0";
        NSRange R2range = [HttpContent rangeOfString:@"f0.R2.value="];
        range.location = R2range.location+12;
        range.length = 1;
        R2 = [HttpContent substringWithRange:range];
        
        //Parameter:para
        NSString *para=@"00";
        NSRange pararange = [HttpContent rangeOfString:@"name=\"para\""];
        range.location = pararange.location+19;
        range.length = 2;
        para = [HttpContent substringWithRange:range];

        //Parameter:0MKKey
        NSString *_0MKKey=@"123456";
        NSRange _0MKKeyrange = [HttpContent rangeOfString:@"input type=\"hidden\" name=\"0MKKey\""];
        range.location = _0MKKeyrange.location+41;
        range.length = 20;
        NSString *tempstr = [HttpContent substringWithRange:range];
        NSRange temprange = [tempstr rangeOfString:@"\""];
        range = NSMakeRange(range.location, temprange.location);
        _0MKKey = [HttpContent substringWithRange:range];
        
        //argv for upass:ps
        NSString *ps=@"1";
        NSRange psrange = [HttpContent rangeOfString:@"ps"];
        range.location = psrange.location+3;
        range.length = 1;
        ps = [HttpContent substringWithRange:range];
        
        //argv for upass:pid
        NSString *pid=@"1";
        NSRange pidrange = [HttpContent rangeOfString:@"pid"];
        range.location = pidrange.location+5;
        range.length = 1;
        pid = [HttpContent substringWithRange:range];
        
        //argv for upass:calg
        NSString *calg=@"12345678";
        NSRange calgrange = [HttpContent rangeOfString:@"calg"];
        range.location = calgrange.location+6;
        range.length = 20;
        tempstr = [HttpContent substringWithRange:range];
        temprange = [tempstr rangeOfString:@"\'"];
        range = NSMakeRange(range.location, temprange.location);
        calg = [HttpContent substringWithRange:range];

        //Get encrypted password for form submittion
        NSString *MD5password=[[NSString alloc] init];
        if([ps isEqualToString:@"0"]){
            MD5password = [self xproc1:password];
            R2=@"0";
        }
        else{
            NSString *tempstr=[[pid stringByAppendingString:password] stringByAppendingString:calg];
            MD5password= [self MD5StringOfString:tempstr];
            MD5password = [[MD5password stringByAppendingString:calg] stringByAppendingString:pid];
        }

        //Set parameter
        loginParaDictionary=[[NSMutableDictionary alloc] init];
        [loginParaDictionary setObject:R1 forKey:@"R1"];
        [loginParaDictionary setObject:R2 forKey:@"R2"];
        [loginParaDictionary setObject:para forKey:@"para"];
        [loginParaDictionary setObject:_0MKKey forKey:@"0MKKey"];
        [loginParaDictionary setObject:username forKey:@"username"];
        [loginParaDictionary setObject:MD5password forKey:@"password"];
        
        //Trying Login
        [LoginHelper Login:loginParaDictionary];
        [loginParaDictionary release];
        
        return;
    }
    else{//If logged in, show network traffic in statusbar.
        
        NSRange endrang = [HttpContent rangeOfString:@"fsele"];
        NSRange range = NSMakeRange(startrang.location+6, endrang.location-2-startrang.location-6);
        self.TrafficData=[HttpContent substringWithRange:range];
        double longTraff=[self.TrafficData doubleValue];
        longTraff=longTraff/1024;
        if(longTraff/1024<1){
            self.TrafficData=[NSString stringWithFormat:@"%.3f",longTraff];
            self.TrafficData=[self.TrafficData stringByAppendingFormat:@"%@",@" MB"];
        }
        else{
            longTraff/=1024;
            self.TrafficData=[NSString stringWithFormat:@"%.3f",longTraff];
            self.TrafficData=[self.TrafficData stringByAppendingFormat:@"%@",@" GB"];
        }
        [self.statusIco ShowStatusIcon:bar: self.statusItem : theMenu: self.TrafficData];
    }
    
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

-(NSString*) MD5StringOfString:(NSString*) inputStr
{
	NSData* inputData = [inputStr dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char outputData[CC_MD5_DIGEST_LENGTH];
	CC_MD5([inputData bytes], [inputData length], outputData);
	
	NSMutableString* hashStr = [NSMutableString string];
	int i = 0;
	for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
		[hashStr appendFormat:@"%02x", outputData[i]];
	
	return hashStr;
}

-(NSString*) xproc1:(NSString*) str
{
    NSString *EChars=@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    NSString *outstr;
    NSInteger i=0,len,c1,c2,c3;
    len=str.length;
    
    outstr =[NSString stringWithFormat:@""];
    while(i<len){
        //c1=str.charCodeAt(i++)&0xff;
        c1=[str characterAtIndex:i++]&0xff;
        if(i==len){
            //outstr+=EChars.charAt(c1>>2);
            outstr = [outstr stringByAppendingString:[EChars substringWithRange:NSMakeRange(c1>>2, 1)]];
            //outstr+=EChars.charAt((c1&0x3)<<4);
            outstr = [outstr stringByAppendingString:[EChars substringWithRange:NSMakeRange((c1&0x03)<<4, 1)]];
            //outstr+= "==";
            outstr = [outstr stringByAppendingString:@"=="];
            break;
        }
        //c2=str.charCodeAt(i++);
        c2=[str characterAtIndex:i++];
        if(i==len){
            //outstr+=EChars.charAt(c1>>2);
            outstr = [outstr stringByAppendingString:[EChars substringWithRange:NSMakeRange(c1>>2, 1)]];
            //outstr+=EChars.charAt(((c1&0x3)<<4)|((c2&0xF0)>>4));
            outstr = [outstr stringByAppendingString:[EChars substringWithRange:NSMakeRange(((c1&0x3)<<4)|((c2&0xF0)>>4), 1)]];
            //outstr+=EChars.charAt((c2&0xF)<<2);
            outstr = [outstr stringByAppendingString:[EChars substringWithRange:NSMakeRange((c2&0xF)<<2, 1)]];
            //outstr+="=";
            outstr = [outstr stringByAppendingString:@"="];
            break;
        }
        //c3=str.charCodeAt(i++);
        c3=[str characterAtIndex:i++];
        //outstr+=EChars.charAt(c1>>2);
        outstr = [outstr stringByAppendingString:[EChars substringWithRange:NSMakeRange(c1>>2, 1)]];
        //outstr+=EChars.charAt(((c1&0x3)<<4)|((c2&0xF0)>>4));
        outstr = [outstr stringByAppendingString:[EChars substringWithRange:NSMakeRange(((c1&0x3)<<4)|((c2&0xF0)>>4), 1)]];
        //outstr+=EChars.charAt(((c2&0xF)<<2)|((c3&0xC0)>>6));
        outstr = [outstr stringByAppendingString:[EChars substringWithRange:NSMakeRange(((c2&0xF)<<2)|((c3&0xC0)>>6), 1)]];
        //outstr+=EChars.charAt(c3&0x3F);
        outstr = [outstr stringByAppendingString:[EChars substringWithRange:NSMakeRange(c3&0x3F, 1)]];

    }
    return outstr;
}

@end
