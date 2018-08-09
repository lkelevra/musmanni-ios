//
//  DetalleRecargasViewController.m
//  Musmanni
//
//  Created by Erick Pac on 24/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "DetalleRecargasViewController.h"



@interface DetalleRecargasViewController ()
@property (strong, nonatomic) SBPickerSelector *picker;
@end

@implementation DetalleRecargasViewController
@synthesize lblTelco, ivTelco, montos, lblMonto, btnPicker, lblSaldo, txtPhoneNumber, txtPhoneNumberRepeat, monto_seleccionado;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Recargas";
    
    
    btnPicker.tag = 1;
    
    [lblTelco setText:[[Singleton getInstance].datos_telco valueForKey:@"nombre_telco"]];
    
    ivTelco.layer.cornerRadius = 40;
    ivTelco.clipsToBounds = YES;
    ivTelco.layer.borderWidth = 7.0f;
    ivTelco.layer.borderColor = [UIColor whiteColor].CGColor;
    [ivTelco setImage:[UIImage imageNamed:[[Singleton getInstance].datos_telco valueForKey:@"image"]]];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    
    self.picker = [SBPickerSelector picker];
    
    //classic picker display
    
    //[self.picker showPickerIpadFromRect:CGRectZero inView:self.view]; //if you whant a popover picker in ipad, set the view an point target(if you set this and opens in iphone, picker shows normally)
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    if([pref valueForKey:@"notarjeta"]){
        [[Singleton getInstance] mostrarHud:self.navigationController.view];
        [lblSaldo setText:[NSString stringWithFormat:@"%@", [pref objectForKey:@"saldo"]]];
        
        WSManager *consumo = [[WSManager alloc] init];
        [consumo useWebServiceWithMethod:@"GET" withTag:@"montos_recarga" withParams:@{
                                                                                       @"pAutorizador_Id":[[Singleton getInstance].datos_telco valueForKey:@"autorizador_id"],
                                                                                       @"pServicio_Id":[[Singleton getInstance].datos_telco valueForKey:@"servicio_id"],
                                                                                       @"pMonedero_Tarjeta":[pref valueForKey:@"notarjeta"]
                                                                                       } withApi:@"montos_recarga" withDelegate:self];
        
    } else {
        [self dismissViewControllerAnimated:TRUE completion:nil];
        
        [ISMessages showCardAlertWithTitle:@"Espera"
                                   message:@"Aún no tienes validada tu tarjeta, no puedes realizar una recarga hasta que sea validada"
                                  duration:3.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeWarning
                             alertPosition:ISAlertPositionTop
                                   didHide:nil];
    }
}

- (void)goBack {
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(IBAction)mostrarPicker:(UIButton *)sender{
    [self.picker showPickerOver:self];
    //    if (sender.tag == 1) {
    //        btnPicker.tag = 2;
    //        pvMontos.hidden = NO;
    //    }
    //    else if (sender.tag == 2){
    //        btnPicker.tag = 1;
    //        pvMontos.hidden = YES;
    //    }
}

-(IBAction)realizarRecarga:(UIButton *)sender{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    float saldo = [[pref objectForKey:@"saldo"] floatValue];
    if ([txtPhoneNumber.text length] == 8 && [txtPhoneNumberRepeat.text length] == 8) {
        if ([txtPhoneNumber.text isEqualToString:txtPhoneNumberRepeat.text]) {
            if ( monto_seleccionado <= saldo) {
                
                //[[Singleton getInstance] mostrarHud:self.navigationController.view];
                if( monto_seleccionado > 0)
                {
                    
                    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                    if ([pref objectForKey:@"data_user"]) {
                        WSManager *consumo = [[WSManager alloc] init];
                        [consumo useWebServiceWithMethod:@"POST" withTag:@"realizar_recarga"
                                              withParams:@{
                                                           
                                                           @"pAutorizador_Id":[[Singleton getInstance].datos_telco valueForKey:@"autorizador_id"],
                                                           @"pServicio_Id":[[Singleton getInstance].datos_telco valueForKey:@"servicio_id"],
                                                           @"pMonedero_Tarjeta":[pref valueForKey:@"notarjeta"],
                                                           @"pMonto":[NSString stringWithFormat:@"%d", (int)monto_seleccionado],
                                                           @"celular":txtPhoneNumber.text,
                                                           @"usuario_id":[[pref objectForKey:@"data_user"] valueForKey:@"id"] ,
                                                           
                                                           } withApi:@"realizar_recarga" withDelegate:self];
                        
                        
                        [ISMessages showCardAlertWithTitle:@"En proceso"
                                                   message:@"Tu recarga esta en proceso, en unos momentos recibirás una confirmación"
                                                  duration:5.0
                                               hideOnSwipe:YES
                                                 hideOnTap:YES
                                                 alertType:ISAlertTypeSuccess
                                             alertPosition:ISAlertPositionTop
                                                   didHide:nil];
                        [self dismissViewControllerAnimated:TRUE completion:nil];
                    } else {
                        
                    }
                    
                }
                else{
                    [ISMessages showCardAlertWithTitle:@"Espera"
                                               message:@"Elije un monto a recargar"
                                              duration:3.f
                                           hideOnSwipe:YES
                                             hideOnTap:YES
                                             alertType:ISAlertTypeError
                                         alertPosition:ISAlertPositionTop
                                               didHide:nil];
                }
            } else {
                [ISMessages showCardAlertWithTitle:@"Espera"
                                           message:@"El monto seleccionado es mayor al saldo disponible"
                                          duration:3.f
                                       hideOnSwipe:YES
                                         hideOnTap:YES
                                         alertType:ISAlertTypeError
                                     alertPosition:ISAlertPositionTop
                                           didHide:nil];
            }
        } else {
            [ISMessages showCardAlertWithTitle:@"Espera"
                                       message:@"Verifica que el número de celular y el número de celular de confirmación sean iguales"
                                      duration:3.f
                                   hideOnSwipe:YES
                                     hideOnTap:YES
                                     alertType:ISAlertTypeError
                                 alertPosition:ISAlertPositionTop
                                       didHide:nil];
        }
    } else{
        [ISMessages showCardAlertWithTitle:@"Espera"
                                   message:@"Verifica que el número de celular y/o el número de celular de confirmación tenga 8 dígitos"
                                  duration:3.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeError
                             alertPosition:ISAlertPositionTop
                                   didHide:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSDictionary *item = [montos objectAtIndex:row];
    monto_seleccionado = [[item objectForKey:@"Monto"] intValue];
    NSString *title = [NSString stringWithFormat:@"%@", [item valueForKey:@"Monto"]];
    [lblMonto setText:title];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *item = [montos objectAtIndex:row];
    NSString *title = [NSString stringWithFormat:@"%@", [item valueForKey:@"Monto"]];
    return title;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSDictionary *item = [montos objectAtIndex:row];
    UILabel* lbl = (UILabel*)view;
    
    if (lbl == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 70, 30);
        lbl = [[UILabel alloc] initWithFrame:frame];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setFont:[UIFont fontWithName:@"Oswald-Regular" size:20.0]];
    }
    NSString *title = [NSString stringWithFormat:@"%@", [item valueForKey:@"Monto"]];
    [lbl setText:title];
    
    return lbl;
}

-(void) pickerSelector:(SBPickerSelector *)selector intermediatelySelectedValues:(NSArray<NSString *> *)values atIndexes:(NSArray<NSNumber *> *)idxs{
    if(![[values objectAtIndex:0] isEqualToString:@"Elije"]){
        monto_seleccionado = [[values objectAtIndex:0] intValue];
        [lblMonto setText:[values objectAtIndex:0]];
    }
    
}
-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if([callback.tag isEqualToString:@"montos_recarga"]){
        @try {
            if([[callback.respuesta valueForKey:@"result"] boolValue]){
                
                montos = [[NSMutableArray alloc] init];
                [montos addObject:@"Elije"];
                
                for (NSDictionary* item in [callback.respuesta objectForKey:@"records"]) {
                    [montos addObject:[NSString stringWithFormat:@"%@",[item valueForKey:@"Monto"]]];
                }
                self.picker.pickerData = [montos mutableCopy]; //picker content
                self.picker.pickerType = SBPickerSelectorTypeText;
                self.picker.delegate = self;
                self.picker.doneButtonTitle = @"Elegir";
                self.picker.cancelButtonTitle = @"Cancelar";
            } else{
                [self dismissViewControllerAnimated:TRUE completion:nil];
                [ISMessages showCardAlertWithTitle:@"Espera"
                                           message:[callback.respuesta objectForKey:@"message"]
                                          duration:3.f
                                       hideOnSwipe:YES
                                         hideOnTap:YES
                                         alertType:ISAlertTypeError
                                     alertPosition:ISAlertPositionTop
                                           didHide:nil];
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución : %@", [exception reason]);
        } @finally { }
    }
    else if([callback.tag isEqualToString:@"realizar_recarga"]){
        @try {
            if([[callback.respuesta valueForKey:@"result"] boolValue]){
                //                [self dismissViewControllerAnimated:TRUE completion:nil];
                if([[Singleton getInstance].token isEqualToString:@"NO"]){
                    [ISMessages showCardAlertWithTitle:@"Éxito"
                                               message:[callback.respuesta objectForKey:@"message"]
                                              duration:3.f
                                           hideOnSwipe:YES
                                             hideOnTap:YES
                                             alertType:ISAlertTypeSuccess
                                         alertPosition:ISAlertPositionTop
                                               didHide:nil];
                }
            } else{
                //                [self dismissViewControllerAnimated:TRUE completion:nil];
                if([[Singleton getInstance].token isEqualToString:@"NO"]){
                    [ISMessages showCardAlertWithTitle:@"Espera"
                                               message:[callback.respuesta objectForKey:@"message"]
                                              duration:3.f
                                           hideOnSwipe:YES
                                             hideOnTap:YES
                                             alertType:ISAlertTypeError
                                         alertPosition:ISAlertPositionTop
                                               didHide:nil];
                }
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución : %@", [exception reason]);
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
