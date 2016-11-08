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
@synthesize viewInfoPerfil, viewUserData, viewBarCode, ivProfilePicture, lblSaldo, lblNombre, lblPuntos, btnFormaCanje, btnTerminosCondiciones, barCodeView;

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
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(disposeModalViewControllerNotification:) name:SRMModalViewWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(disposeModalViewControllerNotification:) name:SRMModalViewDidShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(disposeModalViewControllerNotification:) name:SRMModalViewWillHideNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(disposeModalViewControllerNotification:) name:SRMModalViewDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activarCuenta:) name:@"updatetarjeta" object:nil];
    
    WSManager *consumo = [[WSManager alloc] init];
    [consumo useWebServiceWithMethod:@"GET" withTag:@"datos_empresa" withParams:@{} withApi:@"datos_empresa" withDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [[Singleton getInstance] ocultarHud];
    [barCodeView removeFromSuperview];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([pref objectForKey:@"data_user"]) {
        [[Singleton getInstance] mostrarHud:self.navigationController.view];
        NSString *nombre = @"Hola "; nombre = [nombre stringByAppendingString:[[pref objectForKey:@"data_user"] valueForKey:@"nombre"]];
        
        [ivProfilePicture setImageWithURL:[NSURL URLWithString:[[pref objectForKey:@"data_user"] valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"blank-profile-picture-973460_960_720"]];
        [lblNombre setText:nombre];
        
        WSManager *consumo = [[WSManager alloc] init];
        [consumo useWebServiceWithMethod:@"POST" withTag:@"validar_tarjeta" withParams:@{ @"email":[[pref objectForKey:@"data_user"] valueForKey:@"email"] } withApi:@"validar_tarjeta" withDelegate:self];

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

- (IBAction)showModalView:(id)sender {
    [SRMModalViewController sharedInstance].delegate = self;
    [SRMModalViewController sharedInstance].enableTapOutsideToDismiss = YES;
    [SRMModalViewController sharedInstance].statusBarStyle = UIStatusBarStyleLightContent;
    FormaCanjeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"terminosCondicionesView"];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    viewController.view.frame = CGRectMake(0, 0, (screenWidth - 40), (screenHeight - 200));
    
    [[SRMModalViewController sharedInstance] showViewWithController:viewController];
}

- (void)modalViewWillShow:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)modalViewDidShow:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)modalViewWillHide:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)modalViewDidHide:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)disposeModalViewControllerNotification:(NSNotification *)notification {
    NSLog(@"%@", notification.name);
}


-(void)abrirViewBarCode:(UITapGestureRecognizer *)sender{
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConfiguracionViewController *viewController = [storybrd instantiateViewControllerWithIdentifier:@"barCodeView"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)abrirConfiguraciones{
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConfiguracionViewController *viewController = [storybrd instantiateViewControllerWithIdentifier:@"confView"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)activarCuenta:(NSNotification *)notification {
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    NSString *bar_code = @"0"; bar_code = [bar_code stringByAppendingString:[pref valueForKey:@"notarjeta"]];
    CGSize size = viewBarCode.bounds.size;
    NSInteger width = size.width;
    float coordenada = width - 113.0;
    CGRect kBarCodeFrame = {{coordenada/2, 10.0},{113.0, 100.0}};
    barCodeView = [[BarCodeView alloc] initWithFrame:kBarCodeFrame];
    [viewBarCode addSubview:barCodeView];
    [barCodeView setBarCode:bar_code];
    
    [ISMessages showCardAlertWithTitle:@"Éxito"
                               message:[NSString stringWithFormat:@"Tu tarjeta se a creado exitosamente, el número es: %@", [[notification object] valueForKey:@"notarjeta"]]
                             iconImage:nil
                              duration:5.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:ISAlertTypeSuccess
                         alertPosition:ISAlertPositionTop];
    
    [[Singleton getInstance] mostrarHud:self.navigationController.view];
    WSManager *consumo = [[WSManager alloc] init];
    [consumo useWebServiceWithMethod:@"POST" withTag:@"obtener_saldo" withParams:@{ @"notarjeta":[pref valueForKey:@"notarjeta"] } withApi:@"obtener_saldo" withDelegate:self];
}

-(IBAction)mostrarFormaCanje:(id)sender {
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
                NSLog(@"Problema que devuelve el WS: %@", [callback.respuesta valueForKey:@"mensaje"]);
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución: %@", exception);
        } @finally { }
    }
    
    else if([callback.tag isEqualToString:@"validar_tarjeta"]) {
        [[Singleton getInstance] ocultarHud];
        @try {
            if(callback.resultado){
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"saldo"];
                [[NSUserDefaults standardUserDefaults] setValue:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"validado"] forKey:@"validado"];
                [[NSUserDefaults standardUserDefaults] setValue:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"notarjeta"] forKey:@"notarjeta"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                if ([[pref valueForKey:@"validado"] isEqualToString:@"0"]) {
                    [lblPuntos setText:[pref valueForKey:@"saldo"]];
                    [ISMessages showCardAlertWithTitle:@"Información"
                                               message:@"Aún no has confirmado tu tarjeta, revisa tu correo"
                                             iconImage:nil
                                              duration:3.f
                                           hideOnSwipe:YES
                                             hideOnTap:YES
                                             alertType:ISAlertTypeInfo
                                         alertPosition:ISAlertPositionTop];
                    
                    [viewBarCode setUserInteractionEnabled:NO];
                } else {
                    WSManager *consumo = [[WSManager alloc] init];
                    [consumo useWebServiceWithMethod:@"POST" withTag:@"obtener_saldo" withParams:@{ @"notarjeta":[pref valueForKey:@"notarjeta"] } withApi:@"obtener_saldo" withDelegate:self];
                    
                    NSString *bar_code = @"0"; bar_code = [bar_code stringByAppendingString:[pref valueForKey:@"notarjeta"]];
                    CGSize size = viewBarCode.bounds.size;
                    NSInteger width = size.width;
                    float coordenada = width - 113.0;
                    CGRect kBarCodeFrame = {{coordenada/2, 10.0},{113.0, 100.0}};
                    barCodeView = [[BarCodeView alloc] initWithFrame:kBarCodeFrame];
                    [viewBarCode addSubview:barCodeView];
                    [barCodeView setBarCode:bar_code];
                    
                    [viewBarCode setUserInteractionEnabled:YES];
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(abrirViewBarCode:)];
                    tapGesture.cancelsTouchesInView = NO;
                    [viewBarCode addGestureRecognizer:tapGesture];
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
        [[Singleton getInstance] ocultarHud];
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
