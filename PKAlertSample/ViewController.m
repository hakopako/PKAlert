//
//  ViewController.m
//  PKAlert
//
//  Created by hakopako on 2014/11/29.
//  Copyright (c) 2014年 hakopako. All rights reserved.
//

#import "ViewController.h"
#import "PKAlert.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)simpleAlertButtonDown:(id)sender {
    [PKAlert showWithTitle:@"Notice"
                      text:@"hogehogehoghoe\nhugahuga\nIs this ok?\n\n\nhahahahahahaha"
          cancelButtonText:@"O K"
                     items:nil
                     style:PKAlertStyleDefault
                 tintColor:[UIColor colorWithRed:0.3 green:0.649 blue:0.7 alpha:1.0]];
}

- (IBAction)twoOptionsAlertButtonDown:(id)sender {
    [PKAlert showWithTitle:@"Success!!"
                      text:@"XXXX is completed successfuly.\n check ooooo now!"
          cancelButtonText:@"Cancel"
                     items:@[
                             [PKAlert generateButtonWithTitle:@"Bar" //backgoundColor button is generated.
                                                       action:^(){
                                                           NSLog(@"Bar is clicked.");
                                                       }
                                                         type:UIButtonTypeSystem
                                                    tintColor:[UIColor colorWithRed:0.7 green:0.649 blue:0.3 alpha:1.0]]
                             ]
                     style:PKAlertStyleDefault
                 tintColor:nil];
}

- (IBAction)optionAlertButtonDown:(id)sender {
    [PKAlert showWithTitle:@"Success!!"
                      text:@"XXXX is completed successfuly.\n check ooooo now!"
          cancelButtonText:@"Cancel"
                     items:@[
                             [PKAlert generateButtonWithTitle:@"Bar" //backgoundColor button is generated.
                                                       action:^(){
                                                           NSLog(@"Bar is clicked.");
                                                       }
                                                         type:UIButtonTypeSystem
                                                    tintColor:[UIColor colorWithRed:0.3 green:0.649 blue:0.7 alpha:1.0]],
                             [PKAlert generateButtonWithTitle:@"Foo" //tintColor button is generated.
                                                       action:^(){
                                                           NSLog(@"Foo is clicked.");
                                                       }
                                                         type:UIButtonTypeSystem]
                             ]
                     style:PKAlertStyleDefault
                 tintColor:nil];
}

- (IBAction)rectSimpleAlertButtonDown:(id)sender {
    [PKAlert showWithTitle:@"Notice"
                      text:@"hogehogehoghoe\nhugahuga\nIs this ok?\n\n\nhahahahahahaha"
          cancelButtonText:@"O K"
                     items:nil
                     style:PKAlertStyleRectangle
                 tintColor:[UIColor colorWithRed:0.5 green:0.849 blue:0.9 alpha:1.0]];
}

- (IBAction)rectTwoOptionsAlertButtonDown:(id)sender {
    [PKAlert showWithTitle:@"Success!!"
                      text:@"XXXX is completed successfuly.\n check ooooo now!"
          cancelButtonText:@"Cancel"
                     items:@[
                             [PKAlert generateButtonWithTitle:@"Bar" //backgoundColor button is generated.
                                                       action:^(){
                                                           NSLog(@"Bar is clicked.");
                                                       }
                                                         type:UIButtonTypeSystem
                                                    tintColor:[UIColor colorWithRed:0.5 green:0.849 blue:0.9 alpha:1.0]]
                             ]
                     style:PKAlertStyleRectangle
                 tintColor:nil];
}

- (IBAction)rectOptionsAlertButtonDown:(id)sender {
    [PKAlert showWithTitle:@"Success!!"
                      text:@"XXXX is completed successfuly.\n check ooooo now!"
          cancelButtonText:@"Cancel"
                     items:@[
                             [PKAlert generateButtonWithTitle:@"Bar" //backgoundColor button is generated.
                                                       action:^(){
                                                           NSLog(@"Bar is clicked.");
                                                       }
                                                         type:UIButtonTypeSystem
                                                    tintColor:[UIColor colorWithRed:0.5 green:0.849 blue:0.9 alpha:1.0]],
                             [PKAlert generateButtonWithTitle:@"Foo" //tintColor button is generated.
                                                       action:^(){
                                                           NSLog(@"Foo is clicked.");
                                                       }
                                                         type:UIButtonTypeSystem]
                             ]
                     style:PKAlertStyleRectangle
                 tintColor:nil];
}

@end
