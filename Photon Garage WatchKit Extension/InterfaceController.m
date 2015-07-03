//
//  InterfaceController.m
//  Photon Garage WatchKit Extension
//
//  Created by Christopher White on 6/29/15.
//  Copyright (c) 2015 Logical Elegance. All rights reserved.
//

#import "InterfaceController.h"
#import "Spark-SDK.h"

@interface InterfaceController()
- (void)loginAndEnumerate;
@end


@implementation InterfaceController
@synthesize connectingLabel;

- (void)loginAndEnumerate
{
    
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
                    NSLog(@"Error: %@", error);
                }
                
                // search for a specific device by name
                for (SparkDevice *device in sparkDevices)
                {
                    if ([device.name isEqualToString:@"garage_project"])
                        myPhoton = device;
                    
                    if ([myPhoton connected]) {
                        [connectingLabel setText:@""];
                        [connectingLabel setHidden:true];
                    }
                }
                if (myPhoton == nil) {
                    NSLog(@"Couldn't find requested device");
                }
            }];
        }
        else {
            NSLog(@"Wrong credentials or no internet connectivity, please try again");
        }
    }];
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self loginAndEnumerate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [[SparkCloud sharedInstance] logout];
}

- (IBAction)garageButton:(id)sender {
    
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



