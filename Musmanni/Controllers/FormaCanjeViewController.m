//
//  FormaCanjeViewController.m
//  Musmanni
//
//  Created by Erick Pac on 8/11/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "FormaCanjeViewController.h"

@interface FormaCanjeViewController ()

@end

@implementation FormaCanjeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeModal:(id)sender{
    [[SRMModalViewController sharedInstance] hide];
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
