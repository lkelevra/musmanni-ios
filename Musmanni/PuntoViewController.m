//
//  PuntoViewController.m
//  Musmanni
//
//  Created by Luis Gonzalez on 27/11/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "PuntoViewController.h"
#import <AFNetworking/uiimageview+afnetworking.h>
@interface PuntoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *fotoPunto;
@property (weak, nonatomic) IBOutlet UILabel *nombrePunto;
@property (weak, nonatomic) IBOutlet UILabel *direccionPunto;
@property (weak, nonatomic) IBOutlet UILabel *distanciaPunto;
@property (weak, nonatomic) IBOutlet UILabel *telefonoPunto;
@property (weak, nonatomic) IBOutlet UILabel *lunesaviernes;
@property (weak, nonatomic) IBOutlet UILabel *sabado;
@property (weak, nonatomic) IBOutlet UILabel *domingo;
@property (weak, nonatomic) IBOutlet UILabel *labelHorario;
@property (weak, nonatomic) IBOutlet UILabel *labelTelefono;
@property (weak, nonatomic) IBOutlet UILabel *lablelunesaviernes;
@property (weak, nonatomic) IBOutlet UILabel *labelsabado;
@property (weak, nonatomic) IBOutlet UILabel *labeldomingo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintAlto;

@end

@implementation PuntoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *picture = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", [self.itemPunto objectForKey:@"foto"] ] stringByRemovingPercentEncoding]];
    [self.fotoPunto setImageWithURL:picture];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
        self.constraintAlto.constant = screenHeight-420;

        
//        [self.fotoPunto setFrame:CGRectMake(
//                                            0,
//                                            0,
//                                            screenWidth,
//                                            screenHeight-300)];
        [self updateViewConstraints];
        [self.view layoutIfNeeded];
    }];
    
    
    
    
    
    [self.nombrePunto setText:[self.itemPunto valueForKey:@"nombre"]];
    [self.direccionPunto setText:[self.itemPunto valueForKey:@"direccion"]];
    if([self.itemPunto valueForKey:@"distancia"] != NULL )
    {
     [self.distanciaPunto setText:[NSString stringWithFormat:@"%@ KM",[self.itemPunto valueForKey:@"distancia"] ]];
    }
    else{
        [self.distanciaPunto setText:@""];
    }
    [self.telefonoPunto setText:[self.itemPunto valueForKey:@"telefono"]];
    [self.lunesaviernes setText:[self.itemPunto valueForKey:@"lunesviernes"]];
    [self.sabado setText:[self.itemPunto valueForKey:@"sabados"]];
    [self.domingo setText:[self.itemPunto valueForKey:@"domingos"]];
    
    [self.direccionPunto setFont:[UIFont fontWithName:@"Oswald-Regular" size:14.0]];
    [self.distanciaPunto setFont:[UIFont fontWithName:@"Oswald-Regular" size:14.0]];
    [self.telefonoPunto setFont:[UIFont fontWithName:@"Oswald-Regular" size:14.0]];
    [self.lunesaviernes setFont:[UIFont fontWithName:@"Oswald-Regular" size:14.0]];
    [self.sabado setFont:[UIFont fontWithName:@"Oswald-Regular" size:14.0]];
    [self.domingo setFont:[UIFont fontWithName:@"Oswald-Regular" size:14.0]];
    [self.nombrePunto setFont:[UIFont fontWithName:@"Oswald-Regular" size:16.0]];
    [self.labelTelefono setFont:[UIFont fontWithName:@"Oswald-Regular" size:16.0]];
    [self.labelHorario setFont:[UIFont fontWithName:@"Oswald-Regular" size:16.0]];
    [self.lablelunesaviernes setFont:[UIFont fontWithName:@"Oswald-Regular" size:16.0]];
    [self.labelsabado setFont:[UIFont fontWithName:@"Oswald-Regular" size:16.0]];
    [self.labeldomingo setFont:[UIFont fontWithName:@"Oswald-Regular" size:16.0]];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    

    

}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
