//
//  ViewController.h
//  NewBeaconApp
//
//  Created by Kharat, Rohit on 6/19/14.
//  Copyright (c) 2014 Kharat, Rohit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, strong) CLBeaconRegion   *beaconRegion;
@property (nonatomic, strong) CLLocationManager *locManager;

@property (nonatomic, strong) IBOutlet UILabel *label1;
@property (nonatomic, strong) IBOutlet UILabel *label2;

@end
