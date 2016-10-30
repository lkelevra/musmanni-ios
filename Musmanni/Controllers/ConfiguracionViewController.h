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

@interface ConfiguracionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnChangePass;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseSesion;
@property (weak, nonatomic) IBOutlet UISwitch *swNotifications;

@end
