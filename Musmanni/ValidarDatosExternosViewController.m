//
//  ValidarDatosExternosViewController.m
//  Musmanni
//
//  Created by Julio Lemus on 6/04/17.
//  Copyright © 2017 Florida Bebidas. All rights reserved.
//

#import "ValidarDatosExternosViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LoginViewController.h"

@interface ValidarDatosExternosViewController ()

@end

@implementation ValidarDatosExternosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cerrarSession{
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
    //[self.navigationController popViewControllerAnimated:YES];
 }

-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
   if ([callback.tag isEqualToString:@"cerrar_sesion"]){
        @try {
            if(callback.resultado){
                NSLog(@"Sesión cerrada");
                [Singleton getInstance].session_usuario = NO;
                NSLog(@"Sesión USUARIO %s",[Singleton getInstance].session_usuario ? "SI" : "NO");
                 NSLog(@"Sesión EXTERNO %s",[Singleton getInstance].session_externo ? "SI" : "NO");
            } else{
                NSLog(@"Error al cerrar sesión");
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución en WS cambiar_password: %@", exception);
        } @finally { }
    }
}


@end
