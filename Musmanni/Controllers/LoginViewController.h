//
//  LoginViewController.h
//  Musmanni
//
//  Created by Erick Pac on 5/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "WSManager.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, WSManagerDelegateF>
    @property (weak, nonatomic) IBOutlet UIButton *btnIngresar;
    @property (weak, nonatomic) IBOutlet UIButton *btnIngresarFacebook;
    @property (weak, nonatomic) IBOutlet UITextField *txtEmail;
    @property (weak, nonatomic) IBOutlet UIButton *btnRegistro;
    @property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@end
