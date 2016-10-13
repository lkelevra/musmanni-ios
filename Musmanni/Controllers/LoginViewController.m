//
//  LoginViewController.m
//  Musmanni
//
//  Created by Erick Pac on 5/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
    @synthesize txtEmail, txtPassword, btnIngresar, btnIngresarFacebook;
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnIngresar.layer.cornerRadius = 17;
    btnIngresarFacebook.layer.cornerRadius = 17;
    txtPassword.delegate = self;
    UIView *statusBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 21)];
    statusBG.backgroundColor = [UIColor colorWithRed:0.85 green:0.36 blue:0.15 alpha:1.0];
    [self.view addSubview:statusBG];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
    
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}
    
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)hacerLogin:(id)sender {
    if([[txtEmail text] length] > 0 & [[txtPassword text] length] > 0 ){
        [[Singleton getInstance] mostrarHud:self.view];
        WSManager *consumo = [[WSManager alloc] init];
        [consumo useWebServiceWithMethod:@"POST" withTag:@"login" withParams:@{
                                                                               @"email":[self.txtEmail text],
                                                                               @"password":[self.txtPassword text],
                                                                               @"devicetoken":[Singleton getInstance].token
                                                                               } withApi:@"login" withDelegate:self];
    } else {
        [[Singleton getInstance] mostrarNotificacion:@"info" mensaje:@"Todos los campos son obligatorios" titulo:@"" enVista:self.navigationController.view];
    }
}

-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if([callback.tag isEqualToString:@"login"]){
        @try {
            if([callback.respuesta valueForKey:@"resultado"]){
                [txtEmail setText:@""];
                [txtPassword setText:@""];
                [Singleton getInstance].itemUsuario = [[NSMutableDictionary alloc] initWithDictionary:[callback.respuesta objectForKey:@"registros"]];
                NSDictionary *data_user = @{
                                            @"id": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"id"],
                                            @"nombre": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"nombre"],
                                            @"email": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"email"]
                                            };
                [[NSUserDefaults standardUserDefaults] setObject:data_user forKey:@"data_user"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                [self dismissViewControllerAnimated:TRUE completion:nil];
            }
            else{
                [[Singleton getInstance] mostrarNotificacion:@"error" mensaje:[callback.respuesta objectForKey:@"mensaje"] titulo:@"" enVista:self.navigationController.view];
            }

        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problme a en la ejecución: %@", exception);
        } @finally { }
    }
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
