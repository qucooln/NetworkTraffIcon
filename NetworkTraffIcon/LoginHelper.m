//
//  Login.m
//  NetworkTraffIcon
//
//  Created by Qucooln on 1/24/13.
//
//

#import "LoginHelper.h"

@implementation LoginHelper

+ (void)Login:(NSMutableDictionary*) loginParaDic
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://gate.cqu.edu.cn/"]];

    [request setRequestMethod:@"POST"];
    [request setPostValue:[loginParaDic objectForKey:@"username"] forKey:@"DDDDD"];
    [request setPostValue:[loginParaDic objectForKey:@"password"] forKey:@"upass"];
    [request setPostValue:[loginParaDic objectForKey:@"R1"] forKey:@"R1"];
    [request setPostValue:[loginParaDic objectForKey:@"R2"] forKey:@"R2"];
    [request setPostValue:[loginParaDic objectForKey:@"para"] forKey:@"para"];
    [request setPostValue:[loginParaDic objectForKey:@"0MKKey"] forKey:@"0MKKey"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];

}

+ (void) requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"Logged in");
    //NSString *response = [request responseString];
    // response contains the HTML response from the form.
    //NSLog(response);
}

+ (void) requestFailed:(ASIHTTPRequest *)request
{
    //NSError *error = [request error];
    // Do something with the error.
    //NSLog(error.description);
}

@end
