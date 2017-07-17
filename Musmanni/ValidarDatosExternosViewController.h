//
//  ValidarDatosExternosViewController.h
//  Musmanni
//
//  Created by Julio Lemus on 6/04/17.
//  Copyright © 2017 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "WSManager.h"


@interface ValidarDatosExternosViewController : UIViewController <WSManagerDelegateF>

-(void)cerrarSession;

@end
