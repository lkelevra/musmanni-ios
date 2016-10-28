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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, WSManagerDelegateF, FBSDKLoginButtonDelegate>
    @property (weak, nonatomic) IBOutlet UIButton *btnIngresar;
    @property (weak, nonatomic) IBOutlet UIButton *btnIngresarFacebook;
    @property (weak, nonatomic) IBOutlet UITextField *txtEmail;
    @property (weak, nonatomic) IBOutlet UIButton *btnRegistro;
    @property (weak, nonatomic) IBOutlet UITextField *txtPassword;
    @property (strong, nonatomic) NSString *pictureURL;
    @property(nonatomic, strong)UIAlertAction *okAction;
@end
