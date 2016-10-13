//
//  RecargasViewController.m
//  Musmanni
//
//  Created by Erick Pac on 12/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "RecargasViewController.h"

@interface RecargasViewController ()

@end

@implementation RecargasViewController
@synthesize viewMovistar, viewClaro, viewKolbi;

- (void)viewDidLoad {
    [super viewDidLoad];
    viewMovistar.layer.borderWidth = 1.5;
    viewMovistar.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] CGColor];
    viewClaro.layer.borderWidth = 1.5;
    viewClaro.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] CGColor];
    viewKolbi.layer.borderWidth = 1.5;
    viewKolbi.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
