//
//  RecargasViewController.m
//  Musmanni
//
//  Created by Erick Pac on 12/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "RecargasViewController.h"

@interface RecargasViewController ()

@end

@implementation RecargasViewController
@synthesize viewMovistar, viewClaro, viewKolbi;

- (void)viewDidLoad {
    [super viewDidLoad];
    viewMovistar.layer.borderWidth = 1.5;
    viewMovistar.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] CGColor];
    viewClaro.layer.borderWidth = 1.5;
    viewClaro.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] CGColor];
    viewKolbi.layer.borderWidth = 1.5;
    viewKolbi.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)irRecargas:(UIButton *)sender{
    if (sender.tag == 1) {
        NSDictionary *datos_telco = @{
                                      @"nombre_telco": @"Movistar",
                                      @"servicio_id": @"1",
                                      @"autorizador_id": @"3",
                                      @"image": @"movistar"
                                      };
        [Singleton getInstance].datos_telco = [[NSMutableDictionary alloc] initWithDictionary:datos_telco];
    }
    else if (sender.tag == 2){
        NSDictionary *datos_telco = @{
                                      @"nombre_telco": @"Claro",
                                      @"servicio_id": @"2",
                                      @"autorizador_id": @"3",
                                      @"image": @"claro"
                                      };
        [Singleton getInstance].datos_telco = [[NSMutableDictionary alloc] initWithDictionary:datos_telco];
    }
    else if (sender.tag == 3){
        NSDictionary *datos_telco = @{
                                      @"nombre_telco": @"Kolbi",
                                      @"servicio_id": @"1",
                                      @"autorizador_id": @"1",
                                      @"image": @"kolbi"
                                      };
        [Singleton getInstance].datos_telco = [[NSMutableDictionary alloc] initWithDictionary:datos_telco];
    }
    
    DetalleRecargasViewController *__weak detalleRecargasView = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleRecargasView"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detalleRecargasView];
    [self presentViewController:nav animated:TRUE completion:nil];
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
