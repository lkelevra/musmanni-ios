//
//  LoginViewController.h
//  Musmanni
//
//  Created by Erick Pac on 5/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
    @property (weak, nonatomic) IBOutlet UIButton *btnIngresar;
    @property (weak, nonatomic) IBOutlet UIButton *btnIngresarFacebook;
    @property (weak, nonatomic) IBOutlet UITextField *txtEmail;
    @property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@end
