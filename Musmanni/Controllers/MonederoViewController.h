//
//  MonederoViewController.h
//  Musmanni
//
//  Created by Erick Pac on 7/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "WSManager.h"
#import "BarCodeView.h"
#import "BarCodeEAN13.h"

static const CGRect kLabelFrame = {{0.0, 20.0},{320.0, 30.0}};
static const CGRect kButtonFrame = {{85.0, 220.0},{150.0, 30.0}};
static const CGRect kTextFieldFrame = {{60.0, 170.0},{200.0, 30.0}};

@interface MonederoViewController : UIViewController <WSManagerDelegateF>
@property (weak, nonatomic) IBOutlet UIView *viewInfoPerfil;
@property (weak, nonatomic) IBOutlet UIView *viewBarCode;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *lblNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblSaldo;
@property (weak, nonatomic) IBOutlet UILabel *lblPuntos;
@property (weak, nonatomic) IBOutlet UIButton *btnTerminosCondiciones;
@property (weak, nonatomic) IBOutlet UIView *viewUserData;
@property (weak, nonatomic) IBOutlet UIButton *btnFormaCanje;

@end
