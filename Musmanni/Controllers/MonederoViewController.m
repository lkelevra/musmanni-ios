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
@synthesize viewInfoPerfil, viewUserData, viewBarCode, ivProfilePicture, lblSaldo, lblNombre, lblPuntos, btnFormaCanje, btnTerminosCondiciones;

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
    
    UIButton *conf = [UIButton buttonWithType:UIButtonTypeCustom];
    [conf setBackgroundImage:[UIImage imageNamed:@"Configuraciones"] forState:UIControlStateNormal];
    [conf addTarget:self action:@selector(abrirConfiguraciones) forControlEvents:UIControlEventTouchUpInside];
    conf.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *confButton = [[UIBarButtonItem alloc] initWithCustomView:conf] ;
    self.navigationItem.rightBarButtonItem = confButton;
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([pref objectForKey:@"data_user"]) {
        NSString *nombre = @"Hola "; nombre = [nombre stringByAppendingString:[[pref objectForKey:@"data_user"] valueForKey:@"nombre"]];
        ivProfilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[pref objectForKey:@"data_user"] valueForKey:@"avatar"]]]];
        [lblNombre setText:nombre];
        
        WSManager *consumo = [[WSManager alloc] init];
        [consumo useWebServiceWithMethod:@"POST" withTag:@"validar_tarjeta" withParams:@{ @"email":[[pref objectForKey:@"data_user"] valueForKey:@"email"] } withApi:@"validar_tarjeta" withDelegate:self];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            WSManager *consumo = [[WSManager alloc] init];
            [consumo useWebServiceWithMethod:@"GET" withTag:@"datos_empresa" withParams:@{} withApi:@"datos_empresa" withDelegate:self];
        });
    } else {
        LoginViewController *__weak loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];
        [self presentViewController:nav animated:TRUE completion:nil];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)abrirConfiguraciones{
    ConfiguracionViewController *__weak configuracionesView = [self.storyboard instantiateViewControllerWithIdentifier:@"confView"];
    [self presentViewController:configuracionesView animated:TRUE completion:nil];
}

-(IBAction)mostrarFormaCanje:(UIButton *)sender {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"";
    page1.desc = @"";
    page1.bgImage = [UIImage imageNamed:@"canjes"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.tabBarController.view.bounds andPages:@[page1]];
    [intro.skipButton setTitle:@"Entendido" forState:UIControlStateNormal];
    [intro showInView:self.tabBarController.view animateDuration:0.0];
}

-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if([callback.tag isEqualToString:@"obtener_saldo"]){
        @try {
            if(callback.resultado){
                [lblPuntos setText:[NSString stringWithFormat:@"%@", [[callback.respuesta objectForKey:@"registros"] valueForKey:@"Saldo"]]];
                [[NSUserDefaults standardUserDefaults] setObject:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"Saldo"] forKey:@"saldo"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
            } else{
                [Singleton getInstance].redes_sociales = [[NSMutableDictionary alloc] initWithDictionary: @{
                                                                                                            @"email": @"",
                                                                                                            @"facebook": @"",
                                                                                                            @"web": @"",
                                                                                                            @"telefono": @"",
                                                                                                            @"twitter": @"",
                                                                                                            @"fbid": @""
                                                                                                            }];
                NSLog(@"Problema que devuelve el WS: %@", [callback.respuesta valueForKey:@"mensaje"]);
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución: %@", exception);
        } @finally { }
    }
    
    else if([callback.tag isEqualToString:@"validar_tarjeta"]) {
        @try {
            if(callback.resultado){
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"saldo"];
                [[NSUserDefaults standardUserDefaults] setValue:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"validado"] forKey:@"validado"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                if ([[pref valueForKey:@"validado"] isEqualToString:@"0"]) {
                    [ISMessages showCardAlertWithTitle:@"Información"
                                               message:@"Aún no has confirmado tu tarjeta, revisa tu correo"
                                             iconImage:nil
                                              duration:3.f
                                           hideOnSwipe:YES
                                             hideOnTap:YES
                                             alertType:ISAlertTypeInfo
                                         alertPosition:ISAlertPositionTop];
                    
                } else {
                    [[Singleton getInstance] mostrarHud:self.navigationController.view];
                    WSManager *consumo = [[WSManager alloc] init];
                    [consumo useWebServiceWithMethod:@"POST" withTag:@"obtener_saldo" withParams:@{ @"notarjeta":[[pref objectForKey:@"data_user"] valueForKey:@"notarjeta"] } withApi:@"obtener_saldo" withDelegate:self];
                    
                    NSString *bar_code = @"0"; bar_code = [bar_code stringByAppendingString:[[pref objectForKey:@"data_user"] valueForKey:@"notarjeta"]];
                    CGSize size = viewBarCode.bounds.size;
                    NSInteger width = size.width;
                    float coordenada = width - 113.0;
                    CGRect kBarCodeFrame = {{coordenada/2, 10.0},{113.0, 100.0}};
                    BarCodeView *barCodeView = [[BarCodeView alloc] initWithFrame:kBarCodeFrame];
                    [viewBarCode addSubview:barCodeView];
                    [barCodeView setBarCode:bar_code];
                }
                
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
    
    else if([callback.tag isEqualToString:@"datos_empresa"]) {
        @try {
            if(callback.resultado){
                [Singleton getInstance].redes_sociales = [[NSMutableDictionary alloc] initWithDictionary: @{
                                                                                                            @"email": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"email"],
                                                                                                            @"facebook": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"facebook"],
                                                                                                            @"web": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"web"],
                                                                                                            @"telefono": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"telefono"],
                                                                                                            @"twitter": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"twitter"],
                                                                                                            @"fbid": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fbid"]
                                                                                                            }];
            } else{
                NSLog(@"Problema que devuelve el WS: %@", callback.mensaje);
                [Singleton getInstance].redes_sociales = [[NSMutableDictionary alloc] initWithDictionary: @{
                                                                                                            @"email": @"",
                                                                                                            @"facebook": @"",
                                                                                                            @"web": @"",
                                                                                                            @"telefono": @"",
                                                                                                            @"twitter": @"",
                                                                                                            @"fbid": @""
                                                                                                            }];

            }
            
        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución: %@", exception);
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
