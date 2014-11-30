//
//  ViewController.m
//  PKAlert
//
//  Created by shimada on 2014/11/29.
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
    [PKAlert showWithTitle:@"Notice" text:@"hogehogehoghoe\nhugahuga\nIs this ok?\n\n\nhahahaha" cancelButtonText:@"O K" items:nil tintColor:[UIColor colorWithRed:0.5 green:0.849 blue:0.9 alpha:1.000]];
}

- (IBAction)optionAlertButtonDown:(id)sender {
    [PKAlert showWithTitle:@"Success!!"
                      text:@"XXXX is completed successfuly.\n check ooooo now!"
          cancelButtonText:@"Cancel"
                     items:@[
                             [PKAlert generateButtonWithTitle:@"Bar"
                                                       action:^(){
                                                           NSLog(@"Bar is clicked.");
                                                       }
                                                         type:UIButtonTypeSystem],
                             [PKAlert generateButtonWithTitle:@"Foo"
                                                       action:^(){
                                                           NSLog(@"Foo is clicked.");
                                                       }
                                                         type:UIButtonTypeSystem]
                             ]
                 tintColor:nil];
}
@end
