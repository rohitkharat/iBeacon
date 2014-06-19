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
    // Beacon found!
    self.label1.text = @"Welcome to";
    self.label2.text = @"Rohit's Desk";
    
    CLBeacon *foundBeacon = [beacons firstObject];
    
    // You can retrieve the beacon data from its properties
    NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
    NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
    
    NSLog(@"UUID: %@", uuid);
    NSLog(@"major: %@", major);
    NSLog(@"minor: %@", minor);
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
    self.label1.text = @"Searching again...";
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    [self.locManager startRangingBeaconsInRegion:self.beaconRegion];
}

@end
