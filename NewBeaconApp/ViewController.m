//
//  ViewController.m
//  NewBeaconApp
//
//  Created by Kharat, Rohit on 6/19/14.
//  Copyright (c) 2014 Kharat, Rohit. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@end


@implementation ViewController
@synthesize locManager, beaconRegion,label1,label2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:@"com.rk.testregion"];
    
    [self.locManager startMonitoringForRegion:self.beaconRegion];
    [self locationManager:self.locManager didStartMonitoringForRegion:self.beaconRegion];
    
    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]; [alert show]; return;
    }
    
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    CLBeacon *foundBeacon = [beacons firstObject];
    
    if (foundBeacon.proximity == CLProximityNear || foundBeacon.proximity == CLProximityImmediate)
    {
        
        // Beacon found!
        self.label1.text = @"Welcome to";
//        self.label2.text = @"Rohit's Desk";
        
        
        // You can retrieve the beacon data from its properties
        NSString *uuid = foundBeacon.proximityUUID.UUIDString;
        NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
        NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
        
        NSLog(@"UUID: %@", uuid);
        NSLog(@"major: %@", major);
        NSLog(@"minor: %@", minor);
        
//        web-service call
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.40.113:8080/TestWebService/rest/UserInfoService/json/%@",minor]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response,
                                                    NSData *data, NSError *connectionError)
             {
                 if (data.length > 0 && connectionError == nil)
                 {
                     NSLog(@"received response!!!");
                     NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:0
                                                                                    error:NULL];
//                     NSLog(@"location = %@",[[jsonResponse objectForKey:@"locationName"] stringValue]);
                     self.label2.text = [jsonResponse objectForKey:@"locationName"] ;
                 }
             }];
    }
    
    else
    {
        self.label1.text = @"Searching...";
        self.label2.text = @"";
    }
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.locManager stopRangingBeaconsInRegion:self.beaconRegion];
    
    [super viewDidDisappear:animated];
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    [self.locManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    [self.locManager stopRangingBeaconsInRegion:self.beaconRegion];
    

    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    [self.locManager startRangingBeaconsInRegion:self.beaconRegion];
}

@end
