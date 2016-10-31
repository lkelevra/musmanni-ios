//
//  BarCodeViewController.m
//  Musmanni
//
//  Created by Erick Pac on 30/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "BarCodeViewController.h"

@interface BarCodeViewController ()

@end

@implementation BarCodeViewController
@synthesize viewBarCode, barCodeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Código de barras";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    NSString *bar_code = @"0"; bar_code = [bar_code stringByAppendingString:[pref valueForKey:@"notarjeta"]];
    CGSize size = viewBarCode.bounds.size;
    NSInteger width = size.width;
    float coordenada = width - 113;
    CGRect kBarCodeFrame = {{coordenada/2, 10.0},{113.0, 100.0}};
    barCodeView = [[BarCodeView alloc] initWithFrame:kBarCodeFrame];
    [viewBarCode addSubview:barCodeView];
    [barCodeView setBarCode:bar_code];
}

-(void) viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft; // or Right of course
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
