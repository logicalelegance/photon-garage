//
//  InterfaceController.h
//  Photon Garage WatchKit Extension
//
//  Created by Christopher White on 6/29/15.
//  Copyright (c) 2015 Logical Elegance. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "Spark-SDK.h"
@interface InterfaceController : WKInterfaceController {
    IBOutlet __weak WKInterfaceLabel *connectingLabel;
    IBOutlet __weak WKInterfaceButton *garageButton;
}

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *connectingLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *garageButton;
@end

SparkDevice *myPhoton;
NSTimer *updateTimer;