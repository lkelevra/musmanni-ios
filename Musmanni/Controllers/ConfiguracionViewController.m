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
@synthesize btnChangePass, btnCloseSesion, swNotifications, viewModal, txtNewPass, txtOldPass, btnAceptPass, btnCancelPass;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Configuraciones";
    viewModal.hidden = YES;
    
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

-(IBAction)cambiarContrasena:(UIButton *)sender{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([[[pref objectForKey:@"data_user"] valueForKey:@"fb_id"] isEqualToString:@"0"] ) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
        viewModal.hidden = NO;
    } else {
        [ISMessages showCardAlertWithTitle:@"Espera"
                                   message:@"Ha iniciado sesión con facebook, esta opción no está permitida en este método de inicio de sesión"
                                 iconImage:nil
                                  duration:3.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeError
                             alertPosition:ISAlertPositionTop];
    }
}

-(IBAction)aceptarCambiarContrasena:(UIButton *)sender{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([txtNewPass.text length] > 0 && [txtOldPass.text length] > 0) {
        [self.view endEditing:YES];
        [[Singleton getInstance] mostrarHud:self.navigationController.view];
        WSManager *consumo = [[WSManager alloc] init];
        [consumo useWebServiceWithMethod:@"POST" withTag:@"cambiar_password" withParams:@{@"email":         [[pref objectForKey:@"data_user"] valueForKey:@"email"],
                                                                                          @"pass_actual":   txtOldPass.text,
                                                                                          @"pass_nueva":    txtNewPass.text,
                                                                                          } withApi:@"cambiar_password" withDelegate:self];
    } else {
        [ISMessages showCardAlertWithTitle:@"Espera"
                                   message:@"Verifique que los campos esten ingresados correctamente"
                                 iconImage:nil
                                  duration:3.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeWarning
                             alertPosition:ISAlertPositionTop];
    }
}

-(IBAction)cancelarCambio:(UIButton *)sender{
    [self.view endEditing:YES];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    viewModal.hidden = YES;
}


-(IBAction)cerrarSesion:(UIButton *)sender{
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    WSManager *consumo = [[WSManager alloc] init];
    [consumo useWebServiceWithMethod:@"POST" withTag:@"cerrar_sesion" withParams:@{@"email": [[pref objectForKey:@"data_user"] valueForKey:@"email"]} withApi:@"cerrar_sesion" withDelegate:self];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"data_user"];
    [userDefaults removeObjectForKey:@"validado"];
    [userDefaults removeObjectForKey:@"saldo"];
    [userDefaults removeObjectForKey:@"notarjeta"];
    [userDefaults removeObjectForKey:@"notificaciones"];
    
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if ([callback.tag isEqualToString:@"cambiar_password"]){
        @try {
            if(callback.resultado){
                txtOldPass.text = @"";
                txtNewPass.text = @"",
                viewModal.hidden = YES;
                
                UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
                [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
                backBtn.frame = CGRectMake(0, 0, 30, 30);
                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
                self.navigationItem.leftBarButtonItem = backButton;
                
                [self resignFirstResponder];
                
                [ISMessages showCardAlertWithTitle:@"Éxito"
                                           message:callback.mensaje
                                         iconImage:nil
                                          duration:3.f
                                       hideOnSwipe:YES
                                         hideOnTap:YES
                                         alertType:ISAlertTypeSuccess
                                     alertPosition:ISAlertPositionTop];
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
            NSLog(@"Ocurrió un problema en la ejecución en WS cambiar_password: %@", exception);
        } @finally { }
    }
    else if ([callback.tag isEqualToString:@"cerrar_sesion"]){
        @try {
            if(callback.resultado){
                NSLog(@"Sesión cerrada");
            } else{
                NSLog(@"Error al cerrar sesión");
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución en WS cambiar_password: %@", exception);
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
