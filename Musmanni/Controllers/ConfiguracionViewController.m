//
//  ConfiguracionViewController.m
//  Musmanni
//
//  Created by Erick Pac on 27/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "ConfiguracionViewController.h"

@interface ConfiguracionViewController ()

@end

@implementation ConfiguracionViewController
@synthesize btnChangePass, btnCloseSesion, swNotifications;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Configuraciones";
    
    btnCloseSesion.layer.cornerRadius = 16;
    btnCloseSesion.layer.borderWidth = 2;
    btnCloseSesion.layer.borderColor = [UIColor colorWithRed:0.72 green:0.12 blue:0.11 alpha:1.0].CGColor;
    [swNotifications setOnTintColor:[UIColor colorWithRed:0.72 green:0.12 blue:0.11 alpha:1.0]];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([pref valueForKey:@"notificaciones"] != nil) {
        if ([[pref valueForKey:@"notificaciones"] isEqualToString:@"1"]) {
            [swNotifications setOn:YES];
        } else {
            [swNotifications setOn:NO];
        }
    } else {
        [swNotifications setOn:YES];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)activarNotificaciones:(UISwitch *)sender{
    if (sender.on) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"notificaciones"];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"notificaciones"];
    }
    
    [[NSUserDefaults standardUserDefaults]  synchronize];
}

-(IBAction)cerrarSesion:(UIButton *)sender{
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"data_user"];
    [userDefaults removeObjectForKey:@"validado"];
    [userDefaults removeObjectForKey:@"saldo"];
    [userDefaults removeObjectForKey:@"notarjeta"];
    
    [userDefaults synchronize];
    [self dismissViewControllerAnimated:true completion:nil];

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
