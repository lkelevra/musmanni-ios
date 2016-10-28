//
//  CuponesViewController.h
//  Musmanni
//
//  Created by Erick Pac on 12/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CuponesTableViewCell.h"
#import "Singleton.h"
#import "WSManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

@interface CuponesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WSManagerDelegateF, FBSDKSharingDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSArray *items;
@end
