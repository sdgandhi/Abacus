//
//  AbacusTests.m
//  AbacusTests
//
//  Created by Sidhant Gandhi on 1/24/14.
//  Copyright (c) 2014 Sidhant Gandhi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OBDragDropManager.h"

@interface AbacusTests : XCTestCase

@end

@implementation AbacusTests

NSArray *ovums;
BOOL waitingForBlock = YES;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    OBOvum *ovum1 = [[OBOvum alloc] initWithType:@"add"];
    OBOvum *ovum2 = [[OBOvum alloc] initWithType:@"val"];
    OBOvum *ovum3 = [[OBOvum alloc] initWithType:@"val"];
    [ovum2 setInput: [NSArray arrayWithObjects:@5, nil]];
    [ovum3 setInput: [NSArray arrayWithObjects:@10, nil]];
    [ovum1 setInput: [NSArray arrayWithObjects:ovum2,ovum3, nil]];
    ovums = [[NSArray alloc] initWithObjects:ovum1, ovum2, ovum3, nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSONOutput
{
    // Set the flag to YES
    waitingForBlock = YES;
    
    NSLog(@"JSON output \n\n%@",[ovums[0] toJSON]);
    NSString *jsonRequest = [ovums[0] toJSON];
    
    NSURL *url = [NSURL URLWithString:@"http://default-environment-c3nuuemgkx.elasticbeanstalk.com/"];
    //NSURL *url = [NSURL URLWithString:@"10.55.51.229:8080"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    /*
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([data length] >0 && connectionError == nil)
            {
                NSMutableData *d = [[NSMutableData data] alloc];
                [d appendData:data];
                
                NSString *a = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
                
                NSLog(@"Response Data: %@", a);
                waitingForBlock = NO;
                
            }
            else if ([data length] == 0 && connectionError == nil)
            {
                NSLog(@"Nothing was downloaded.");
                waitingForBlock = NO;
            }
            else if (connectionError != nil){
                NSLog(@"Error = %@", connectionError);
                waitingForBlock = NO;
            }
        }];
    // Run the loop
    while(waitingForBlock) {
        //do nothing.
    }
     */
    
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData *d = [[NSMutableData data] alloc];
    [d appendData:data];
    
    NSString *a = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
    
    NSLog(@"Response Data: %@", a);
    waitingForBlock = NO;
    
}

@end
