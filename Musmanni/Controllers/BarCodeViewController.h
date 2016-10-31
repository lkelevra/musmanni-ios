//
//  BarCodeViewController.h
//  Musmanni
//
//  Created by Erick Pac on 30/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "WSManager.h"
#import "BarCodeView.h"
#import "BarCodeEAN13.h"

@interface BarCodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewBarCode;
@property (strong, nonatomic) BarCodeView *barCodeView;
@end
