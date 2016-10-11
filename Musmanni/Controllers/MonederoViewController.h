//
//  MonederoViewController.h
//  Musmanni
//
//  Created by Erick Pac on 7/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonederoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewInfoPerfil;
@property (weak, nonatomic) IBOutlet UIView *viewBarCode;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *lblNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblSaldo;
@property (weak, nonatomic) IBOutlet UIButton *btnTerminosCondiciones;
@property (weak, nonatomic) IBOutlet UIView *viewUserData;
@property (weak, nonatomic) IBOutlet UIButton *btnFormaCanje;
@end
