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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [PKAlert showWithTitle:@"たいとるたいとる" text:@"hogehogehoghoe\nhugahuga\nIs this ok?\n\n\nhahahaha" cancelButtonText:@"O K"];
   
//    UIButton *addButton = [PKAlert generateButtonWithTitle:@"Add"
//                                                    action:^(){
//                                                    
//                                                    }
//                                                      type:UIButtonTypeSystem
//                                                  tintColor:[UIColor lightGrayColor]
//                                                 fontColor:[UIColor whiteColor]];
//    
//    UIButton *doneButton = [PKAlert generateButtonWithTitle:@"Done"
//                                                    action:^(){
//                                                        
//                                                    }
//                                                      type:UIButtonTypeSystem];
//    
//    [PKAlert showWithTitle:@"タイトルー" text:@"hogehogehoghoe" cancelButtonText:@"O K" items:@[addButton, doneButton]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
