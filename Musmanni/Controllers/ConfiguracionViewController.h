//
//  ConfiguracionViewController.h
//  Musmanni
//
//  Created by Erick Pac on 27/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Singleton.h"
#import "WSManager.h"

@interface ConfiguracionViewController : UIViewController <WSManagerDelegateF>
@property (weak, nonatomic) IBOutlet UIButton *btnChangePass;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseSesion;
@property (weak, nonatomic) IBOutlet UISwitch *swNotifications;
@property (weak, nonatomic) IBOutlet UIView *viewModal;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPass;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPass;
@property (weak, nonatomic) IBOutlet UIButton *btnAceptPass;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelPass;

@end
