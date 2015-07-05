//
//  ViewController.m
//  Photon Garage
//
//  Created by Christopher White on 6/28/15.
//  Copyright (c) 2015 Logical Elegance. All rights reserved.
//
#import "ViewController.h"
#import "Spark-SDK.h"

@interface ViewController ()
- (void)loginAndEnumerate;
@end

@implementation ViewController
@synthesize connectedLabel;
@synthesize garageButton;
@synthesize connectionSpinner;

- (void)loginAndEnumerate {
    [[SparkCloud sharedInstance] logout];
    myPhoton = nil;
    
    // Do any additional setup after loading the view, typically from a nib.
    // logging in
    [[SparkCloud sharedInstance] loginWithUser:@"chris@logicalelegance.com" password:@"zxsaqw21" completion:^(NSError *error) {
        if (!error) {
            
            // Find the particular device
            NSLog(@"Logged in to cloud");
            [[SparkCloud sharedInstance] getDevices:^(NSArray *sparkDevices, NSError *error) {
                if (!error)
                    NSLog(@"%@",sparkDevices.description); // print all devices claimed to user
                else {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connection error"
                                                                                   message:@"Failed to get device list."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    NSLog(@"Error: %@", error);
                    [connectedLabel setText:@"Not connected"];
                }
                
                // search for a specific device by name
                for (SparkDevice *device in sparkDevices)
                {
                    if ([device.name isEqualToString:@"garage_project"])
                        myPhoton = device;
                }
                if (myPhoton == nil) {
                    NSLog(@"Couldn't find requested device");
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connection error"
                                                                                   message:@"Failed to find device."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    [connectedLabel setText:@"Connected (missing device)"];

                } else {
                    
                    if ([myPhoton connected]) {
                        [connectedLabel setText:@"Connected"];
                    } else {
                        [connectedLabel setText:@"Connected (device offline)"];
                    }
                }
            }];
        }
        else {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connection error"
                                                                           message:@"Failed to log in to cloud."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"Wrong credentials or no internet connectivity, please try again");
        }
    }];
    [connectionSpinner stopAnimating];
    [connectionSpinner setHidden:true];
}

- (void)viewDidLoad
{
    [connectedLabel setText:@"Not Connected"];
    [super viewDidLoad];
    [connectionSpinner setHidden:false];

    [connectionSpinner startAnimating];
    [self performSelector:@selector(loginAndEnumerate) withObject:nil afterDelay:0.1];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkDoorStatus) userInfo:nil repeats:YES];

}

- (void)checkDoorStatus
{
    if ((myPhoton == nil) || ([myPhoton connected] == false)) {
        return;
    }
    [myPhoton getVariable:@"doorOpen" completion:^(id result, NSError *error) {
        if (!error) {
            NSNumber *val = (NSNumber *)result;
            NSLog(@"Garage door is %s", val.intValue ? "open" : "closed");
            if (val.intValue == 1) {
                UIImage *openImage = [UIImage imageNamed:@"Button-open"];
                [garageButton setImage:openImage forState:UIControlStateNormal];
            } else {
                UIImage *closedImage = [UIImage imageNamed:@"Button"];
                [garageButton setImage:closedImage forState:UIControlStateNormal];
            }
        }
        else {
            NSLog(@"Failed to read garage status");
        }
    }
    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)garageButtonDown:(id)sender {
}

- (IBAction)garageButtonUp:(id)sender {
    
    if (myPhoton == nil) {
        NSLog(@"myPhoton is nil!");
    }
    [myPhoton callFunction:@"trigger" withArguments: nil completion:^(id result, NSError *error) {
        if (!error) {
            NSLog(@"Triggered garage door");
        }
        else {
            NSLog(@"Failed to trigger garage door");
        }
    }];
}

@end
