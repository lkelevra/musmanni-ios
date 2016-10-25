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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)hacerLogin:(id)sender {
    if([[txtEmail text] length] > 0 & [[txtPassword text] length] > 0 ){
        [[Singleton getInstance] mostrarHud:self.navigationController.view];
        WSManager *consumo = [[WSManager alloc] init];
        [consumo useWebServiceWithMethod:@"POST" withTag:@"login" withParams:@{
                                                                               @"email":[txtEmail text],
                                                                               @"password":[txtPassword text],
                                                                               @"devicetoken":[Singleton getInstance].token
                                                                               } withApi:@"login" withDelegate:self];
    } else {
        [ISMessages showCardAlertWithTitle:@"Espera"
                                   message:@"Todos los campos son obligatorios"
                                 iconImage:nil
                                  duration:3.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeWarning
                             alertPosition:ISAlertPositionTop];
    }
}


-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if([callback.tag isEqualToString:@"login"]){
        @try {
            if(callback.resultado){
                [txtEmail setText:@""];
                [txtPassword setText:@""];
                NSDictionary *data_user = @{
                                            @"id": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"id"],
                                            @"nombre": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"nombre"],
                                            @"email": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"email"],
                                            @"notarjeta": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"notarjeta"],
                                            @"avatar": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"avatar"],
                                            @"fb_id": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fb_id"],
                                            @"fechanacimiento": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fechanacimiento"],
                                            @"fifcoone": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fifcoone"],
                                            @"genero": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"genero"],
                                            @"validado": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"validado"]
                                            };
                [[NSUserDefaults standardUserDefaults] setObject:data_user forKey:@"data_user"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                [self dismissViewControllerAnimated:TRUE completion:nil];
            } else{
                [ISMessages showCardAlertWithTitle:@"Espera"
                                           message:callback.mensaje
                                         iconImage:nil
                                          duration:3.f
                                       hideOnSwipe:YES
                                         hideOnTap:YES
                                         alertType:ISAlertTypeError
                                     alertPosition:ISAlertPositionTop];
            }

        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución: %@", exception);
        } @finally { }
    }
    
    else if ([callback.tag isEqualToString:@"enviar_token"]){
        @try {
            if(callback.resultado){
                
            } else{
                
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución en WS enviar_token: %@", exception);
        } @finally { }

    }
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
