//
//  MonederoViewController.m
//  Musmanni
//
//  Created by Erick Pac on 7/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "MonederoViewController.h"
#import "LoginViewController.h"

@interface MonederoViewController ()

@end

@implementation MonederoViewController
@synthesize viewInfoPerfil, viewUserData, viewBarCode, ivProfilePicture, lblSaldo, lblNombre, btnFormaCanje, btnTerminosCondiciones;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ivProfilePicture.layer.cornerRadius = 50;
    ivProfilePicture.clipsToBounds = YES;
    ivProfilePicture.layer.borderWidth = 7.0f;
    ivProfilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnTerminosCondiciones.layer.cornerRadius = 16;
    btnTerminosCondiciones.layer.borderWidth = 2;
    btnTerminosCondiciones.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnFormaCanje.layer.cornerRadius = 16;
    btnFormaCanje.layer.borderWidth = 2;
    btnFormaCanje.layer.borderColor = [UIColor whiteColor].CGColor;
}
    
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)prueba:(UIButton *)sender{
//    [self dismissViewControllerAnimated:TRUE completion:nil];
    LoginViewController *__weak loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];
    [self presentViewController:nav animated:TRUE completion:nil];
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
