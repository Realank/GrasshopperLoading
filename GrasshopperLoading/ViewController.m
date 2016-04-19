//
//  ViewController.m
//  GrasshopperLoading
//
//  Created by Realank on 16/4/18.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "ViewController.h"
#import "GrasshopperLoadingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    GrasshopperLoadingView *view = [[GrasshopperLoadingView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:view];
    
}

@end
