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

@interface DetalleRecargasViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblTelco;
@property (weak, nonatomic) IBOutlet UIImageView *ivTelco;
@property (weak, nonatomic) IBOutlet UIImageView *ivTel1;
@property (weak, nonatomic) IBOutlet UIPickerView *pvMontos;
@property (strong, nonatomic) NSArray *montos;
@property (weak, nonatomic) IBOutlet UILabel *lblMonto;
@property (weak, nonatomic) IBOutlet UIButton *btnPicker;

@end
