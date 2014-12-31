//
//  AppDelegate.m
//  fitbitWeight
//
//  Created by Chris Whong on 12/21/14.
//  Copyright (c) 2014 Chris Whong. All rights reserved.
//


#import "AppDelegate.h"

@interface AppDelegate ()


@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [self getWeight];
    [NSTimer
     scheduledTimerWithTimeInterval:3600
     target:self
     selector:@selector(getWeight)
     userInfo:nil
     repeats:YES];
    
}

- (void)getWeight {
    
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    //_statusItem.image = [NSImage imageNamed:@"switchIcon.png"];
    //[_statusItem.image setTemplate:YES];
    
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    NSString *jsonUrlString = [NSString stringWithFormat:@"http://fitbit-weight.herokuapp.com/weight"];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //
    
    NSMutableDictionary *attributes = [result valueForKey:@"_attributes"];
    
    
    
    NSMutableArray *weight = [attributes objectForKey:@"weight"];
    
    NSLog(@"Result = %@",weight);
    
    NSMutableDictionary *latestWeight = [weight lastObject];
    
    NSLog(@"%@",latestWeight);
    
    NSNumber *myWeight = [latestWeight valueForKey:@"weight"];
    
    NSLog(@"%@",myWeight);
    
    _statusItem.title = [[myWeight stringValue] stringByAppendingString:@" lbs"];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end