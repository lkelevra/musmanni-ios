//
//  RegistroViewController.h
//  Musmanni
//
//  Created by Erick Pac on 26/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSManager.h"
#import "Singleton.h"

@interface RegistroViewController : UIViewController <WSManagerDelegateF>
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthday;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpBirthday;
@property (weak, nonatomic) IBOutlet UIButton *btnNewRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnOpendpBirthDay;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scGenere;
@property (strong, nonatomic) NSString *fecha_nacimiento;
@end
