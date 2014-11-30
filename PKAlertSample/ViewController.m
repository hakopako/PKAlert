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
//    [PKAlert showWithTitle:@"たいとるたいとる" text:@"hogehogehoghoe\nhugahuga\nIs this ok?\n\n\nhahahaha" cancelButtonText:@"O K" items:nil];
    
    [PKAlert showWithTitle:@"タイトルー"
                      text:@"hogehogehoghoe"
          cancelButtonText:@"O K"
                     items:@[
//                             [PKAlert generateButtonWithTitle:@"Add"
//                                                       action:^(){
//                                                           
//                                                       }
//                                                         type:UIButtonTypeSystem
//                                                    tintColor:[UIColor lightGrayColor]
//                                                    fontColor:[UIColor whiteColor]],
                             [PKAlert generateButtonWithTitle:@"Done"
                                                       action:^(){
                                                           NSLog(@"done is clicked.");
                                                       }
                                                         type:UIButtonTypeSystem],
                             [PKAlert generateButtonWithTitle:@"hoge"
                                                       action:^(){
                                                           NSLog(@"hoge is clicked.");
                                                       }
                                                         type:UIButtonTypeSystem]
                             ]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
