//
//  DetalleRecargasViewController.h
//  Musmanni
//
//  Created by Erick Pac on 24/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "WSManager.h"
#import "SBPickerSelector.h"

@interface DetalleRecargasViewController : UIViewController <WSManagerDelegateF,SBPickerSelectorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblTelco;
@property (weak, nonatomic) IBOutlet UIImageView *ivTelco;
@property (weak, nonatomic) IBOutlet UIImageView *ivTel1;

@property (strong, nonatomic) NSMutableArray *montos;
@property (weak, nonatomic) IBOutlet UILabel *lblMonto;
@property (weak, nonatomic) IBOutlet UIButton *btnPicker;
@property (weak, nonatomic) IBOutlet UILabel *lblSaldo;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumberRepeat;
@property NSInteger monto_seleccionado;

@end
