//
//  ContactenosViewController.h
//  Musmanni
//
//  Created by Erick Pac on 12/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactenosTableViewCell.h"
#import "Singleton.h"
#import "WSManager.h"
#import <MessageUI/MessageUI.h>

@interface ContactenosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tablaDatosContacto;

@end
