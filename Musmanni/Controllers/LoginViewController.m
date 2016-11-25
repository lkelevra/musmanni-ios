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
    @synthesize txtEmail, txtPassword, btnIngresar, btnIngresarFacebook, btnRegistro, pictureURL, okAction;
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnIngresar.layer.cornerRadius = 17;
    btnIngresarFacebook.layer.cornerRadius = 17;
    btnRegistro.layer.cornerRadius = 17;
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

-(IBAction)hacerLoginFacebook:(UIButton *)sender{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_birthday"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if(error){
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
            [ISMessages showCardAlertWithTitle:@"Espera"
                                       message:@"Ocurrió un error al tratar de iniciar con Facebook, intenta de nuevo"
                                     iconImage:nil
                                      duration:3.f
                                   hideOnSwipe:YES
                                     hideOnTap:YES
                                     alertType:ISAlertTypeError
                                 alertPosition:ISAlertPositionTop];
        } else if (result.isCancelled) {
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
            [ISMessages showCardAlertWithTitle:@"Espera"
                                       message:@"Debes darnos permisos para poder registrarte con Facebook, de lo contrario lo puedes realizar de forma manual"
                                     iconImage:nil
                                      duration:3.f
                                   hideOnSwipe:YES
                                     hideOnTap:YES
                                     alertType:ISAlertTypeError
                                 alertPosition:ISAlertPositionTop];
        } else {
            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
            [parameters setValue:@"id,name,email,gender,birthday" forKey:@"fields"];
            
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    
                    NSDictionary *userData = (NSDictionary *)result;
                    pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userData[@"id"]];
                    [[Singleton getInstance] mostrarHud:self.navigationController.view];
                    
                    NSString *birthday = [[NSString alloc] init];
                    
                    if (userData[@"birthday"]) {
                        birthday = userData[@"birthday"];
                    } else {
                        birthday = @"";
                    }
                    
                    NSDictionary *datos = @{@"email":           userData[@"email"],
                                            @"password":        @"",
                                            @"nombre":          userData[@"name"],
                                            @"fechanacimiento": birthday,
                                            @"genero":          userData[@"gender"],
                                            @"fb_id":           userData[@"id"],
                                            @"devicetoken":     [Singleton getInstance].token
                                            };
                    
                    WSManager *consumo = [[WSManager alloc] init];
                    [consumo useWebServiceWithMethod:@"POST" withTag:@"registro_usuario_f" withParams:datos withApi:@"registro_usuario_f" withDelegate:self];
                }
            }];
        }
    }];
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{

}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

- (IBAction)olvidoContrasena:(id)sender {
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Para recuperar  la contraseña se validará el correo electrónico y se enviará una contraseña temporal al correo ingresado en su registro para poder ingresar."  message:nil  preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = self;
    }];
    
    okAction =  [UIAlertAction actionWithTitle:@"Reiniciar contraseña" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[Singleton getInstance] mostrarHud:self.view];
        WSManager *consumo = [[WSManager alloc] init];
        [consumo useWebServiceWithMethod:@"POST" withTag:@"recuperar_pass" withParams:@{ @"email":[alertController.textFields.firstObject text] } withApi:@"recuperar_pass" withDelegate:self];
    }];
    
    
    UIAlertAction *close = [UIAlertAction actionWithTitle:@"Cerrar"
                                                    style:UIAlertActionStyleCancel
                                                  handler:nil];
    okAction.enabled = NO;
    [alertController addAction:okAction];
    [alertController addAction:close];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [okAction setEnabled:(finalString.length >= 5)];
    return YES;
}

-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if([callback.tag isEqualToString:@"login"]){
        @try {
            if(callback.resultado){
                [txtEmail setText:@""];
                [txtPassword setText:@""];
                NSString *avatar = [Singleton getInstance].url; avatar = [avatar stringByAppendingString:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"avatar"]];
                NSDictionary *data_user = @{
                                            @"id": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"id"],
                                            @"nombre": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"nombre"],
                                            @"email": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"email"],
                                            @"notarjeta": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"notarjeta"],
                                            @"avatar": avatar,
                                            @"fb_id": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fb_id"],
                                            @"fechanacimiento": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fechanacimiento"],
                                            @"fifcoone": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fifcoone"],
                                            @"genero": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"genero"],
                                            };
                [[NSUserDefaults standardUserDefaults] setValue:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"validado"] forKey:@"validado"];
                [[NSUserDefaults standardUserDefaults] setValue:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"notarjeta"] forKey:@"notarjeta"];
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
    else if ([callback.tag isEqualToString:@"registro_usuario_f"]){
        @try {
            if(callback.resultado){
                NSDictionary *data_user = @{
                                            @"id": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"id"],
                                            @"nombre": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"nombre"],
                                            @"email": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"email"],
                                            @"notarjeta": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"notarjeta"],
                                            @"avatar": pictureURL,
                                            @"fb_id": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fb_id"],
                                            @"fechanacimiento": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fechanacimiento"],
                                            @"fifcoone": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fifcoone"],
                                            @"genero": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"genero"],
                                            };
                
                [[NSUserDefaults standardUserDefaults] setValue:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"validado"] forKey:@"validado"];
                [[NSUserDefaults standardUserDefaults] setValue:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"notarjeta"] forKey:@"notarjeta"];
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
            NSLog(@"Ocurrió un problema en la ejecución en WS enviar_token: %@", exception);
        } @finally { }
    }
    
    else if ([callback.tag isEqualToString:@"recuperar_pass"]){
        @try {
            if(callback.resultado){
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
