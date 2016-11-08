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
#import <RSBarcodes/RSBarcodes.h>

@interface BarCodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ivBarCode;
@property (nonatomic, weak) IBOutlet BarCodeView *barCodeView;

@end
