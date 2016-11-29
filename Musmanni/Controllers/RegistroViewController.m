//
//  RegistroViewController.m
//  Musmanni
//
//  Created by Erick Pac on 26/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "RegistroViewController.h"
#import "SBPickerSelector.h"


@interface RegistroViewController ()<SBPickerSelectorDelegate>
@property (strong, nonatomic) SBPickerSelector *picker;

@end

@implementation RegistroViewController
@synthesize txtName, txtEmail, txtPassword, txtBirthday, dpBirthday, btnNewRecord, btnOpendpBirthDay, scGenere, fecha_nacimiento;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Registro";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
//    dpBirthday.hidden = YES;
//    
//    btnOpendpBirthDay.tag = 0;
//    dpBirthday.backgroundColor = [UIColor whiteColor];
    
    self.picker = [SBPickerSelector new];
    
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) pickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date {
    
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        fecha_nacimiento = [formatter stringFromDate:date];
        [txtBirthday setText:fecha_nacimiento];
    
}

-(IBAction)mostrarDatePicker:(UIButton *)sender{
    
    self.picker.pickerType = SBPickerSelectorTypeDate;
    self.picker.datePickerType = SBPickerSelectorDateTypeOnlyDay;

    self.picker.delegate = self;
    self.picker.doneButtonTitle = @"Elegir";
    self.picker.cancelButtonTitle = @"Cancelar";
    [self.picker showPickerOver:self];
    NSLog(@"MOSTRANDO PICKER");
//    if (sender.tag == 0) {
//        dpBirthday.hidden = NO;
//        btnOpendpBirthDay.tag = 1;
//    } else {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"dd-MM-yyyy"];
//        fecha_nacimiento = [formatter stringFromDate:[dpBirthday date]];
//        [txtBirthday setText:fecha_nacimiento];
//        
//        dpBirthday.hidden = YES;
//        btnOpendpBirthDay.tag = 0;
//    }
}

-(IBAction)crarRegistro:(UIButton *)sender{
    if ([txtName.text length] > 0 && [txtEmail.text length] > 0 && [txtPassword.text length] > 0) {
        [[Singleton getInstance] mostrarHud:self.navigationController.view];
        NSDictionary *datos = @{@"email":txtEmail.text,
                                @"password": txtPassword.text,
                                @"nombre": txtName.text,
                                @"fechanacimiento": [txtBirthday.text isEqualToString:@"dd-mm-aa"] ? @"" : fecha_nacimiento,
                                @"genero": scGenere.selectedSegmentIndex == 0 ? @"M" : @"F",
                                @"fb_id": @"",
                                @"devicetoken": [Singleton getInstance].token
                                };
        
        WSManager *consumo = [[WSManager alloc] init];
        [consumo useWebServiceWithMethod:@"POST" withTag:@"registro_usuario" withParams:datos withApi:@"registro_usuario" withDelegate:self];
    } else {
        [ISMessages showCardAlertWithTitle:@"Espera"
                                   message:@"Verifique que todos los campos esten llenos"
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
    if([callback.tag isEqualToString:@"registro_usuario"]){
        @try {
            if(callback.resultado){
                NSLog(@"Resultado: %@", [callback.respuesta objectForKey:@"registros"]);
                NSString *avatar = [Singleton getInstance].url; avatar = [avatar stringByAppendingString:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"avatar"]];
                NSDictionary *data_user = @{
                                            @"id": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"id"],
                                            @"nombre": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"nombre"],
                                            @"email": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"email"],
                                            @"notarjeta": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"notarjeta"],
                                            @"avatar": avatar,
                                            @"fb_id": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fb_id"],
                                            @"fechanacimiento": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"fechanacimiento"],
                                            @"fifcoone": @"",
                                            @"genero": [[callback.respuesta objectForKey:@"registros"] valueForKey:@"genero"],
                                            };
                
                [[NSUserDefaults standardUserDefaults] setValue:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"validado"] forKey:@"validado"];
                [[NSUserDefaults standardUserDefaults] setValue:[[callback.respuesta objectForKey:@"registros"] valueForKey:@"notarjeta"] forKey:@"notarjeta"];
                [[NSUserDefaults standardUserDefaults] setObject:data_user forKey:@"data_user"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                [self dismissViewControllerAnimated:TRUE completion:nil];
            } else{
                [self dismissViewControllerAnimated:TRUE completion:nil];
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
            NSLog(@"Ocurrió un problema en la ejecución : %@", [exception reason]);
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
