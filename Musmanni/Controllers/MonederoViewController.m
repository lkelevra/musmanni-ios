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
}

-(void) viewDidAppear:(BOOL)animated{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([pref objectForKey:@"data_user"]) {
        WSManager *consumo = [[WSManager alloc] init];
        [consumo useWebServiceWithMethod:@"POST" withTag:@"obtener_puntos" withParams:@{ @"notarjeta":[[pref objectForKey:@"data_user"] valueForKey:@"notarjeta"] } withApi:@"obtener_puntos" withDelegate:self];

        
        NSString *avatar = [Singleton getInstance].url; avatar = [avatar stringByAppendingString:[[pref objectForKey:@"data_user"] valueForKey:@"avatar"]];
        NSString *nombre = @"Hola "; nombre = [nombre stringByAppendingString:[[pref objectForKey:@"data_user"] valueForKey:@"nombre"]];
        NSString *bar_code = @"0"; bar_code = [bar_code stringByAppendingString:[[pref objectForKey:@"data_user"] valueForKey:@"notarjeta"]];
        
        CGSize size = viewBarCode.bounds.size;
        NSInteger width = size.width;
        float coordenada = width - 113.0;
        CGRect kBarCodeFrame = {{coordenada/2, 10.0},{113.0, 100.0}};
        BarCodeView *barCodeView = [[BarCodeView alloc] initWithFrame:kBarCodeFrame];
        [viewBarCode addSubview:barCodeView];
        [barCodeView setBarCode:bar_code];
        
        ivProfilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatar]]];
        [lblNombre setText:nombre];
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
    // Dispose of any resources that can be recreated.
}


-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if([callback.tag isEqualToString:@"obtener_puntos"]){
        @try {
            if([callback.respuesta valueForKey:@"resultado"]){
                [lblPuntos setText:[NSString stringWithFormat:@"%@", [[callback.respuesta objectForKey:@"registros"] valueForKey:@"Saldo"]]];
                [Singleton getInstance].redes_sociales = [[NSMutableDictionary alloc] initWithDictionary: @{
                                                                                                           @"email": [[callback.respuesta objectForKey:@"redes"] valueForKey:@"email"],
                                                                                                           @"facebook": [[callback.respuesta objectForKey:@"redes"] valueForKey:@"facebook"],
                                                                                                           @"web": [[callback.respuesta objectForKey:@"redes"] valueForKey:@"web"],
                                                                                                           @"telefono": [[callback.respuesta objectForKey:@"redes"] valueForKey:@"telefono"],
                                                                                                           @"twitter": [[callback.respuesta objectForKey:@"redes"] valueForKey:@"twitter"],
                                                                                                           @"fbid": [[callback.respuesta objectForKey:@"redes"] valueForKey:@"fbid"]
                                                                                                           }];
                
            } else{
                NSLog(@"Problema que devuelve el WS: %@", [callback.respuesta valueForKey:@"mensaje"]);
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
