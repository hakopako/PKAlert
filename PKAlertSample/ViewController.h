//
//  ViewController.h
//  PKAlert
//
//  Created by hakopako on 2014/11/29.
//  Copyright (c) 2014年 hakopako. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{

    __weak IBOutlet UIButton *simpleAlertButton;
    __weak IBOutlet UIButton *twoOptionsAlertButton;
    __weak IBOutlet UIButton *optionAlertButton;
}

- (IBAction)simpleAlertButtonDown:(id)sender;
- (IBAction)twoOptionsAlertButtonDown:(id)sender;
- (IBAction)optionAlertButtonDown:(id)sender;
- (IBAction)rectSimpleAlertButtonDown:(id)sender;
- (IBAction)rectTwoOptionsAlertButtonDown:(id)sender;
- (IBAction)rectOptionsAlertButtonDown:(id)sender;

@end

