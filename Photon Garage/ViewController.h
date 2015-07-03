//
//  ViewController.h
//  Photon Garage
//
//  Created by Christopher White on 6/28/15.
//  Copyright (c) 2015 Logical Elegance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spark-SDK.h"

@interface ViewController : UIViewController {
    IBOutlet UILabel *connectedLabel;
    IBOutlet UIButton *garageButton;
    IBOutlet UIActivityIndicatorView *connectionSpinner;
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *connectionSpinner;
@property (retain, nonatomic) IBOutlet UILabel *connectedLabel;
@property (retain, nonatomic) IBOutlet UIButton *garageButton;

@end

SparkDevice *myPhoton;
