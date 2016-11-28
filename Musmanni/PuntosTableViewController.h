//
//  PuntosTableViewController.h
//  Musmanni
//
//  Created by Luis Gonzalez on 27/11/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/uiimageview+afnetworking.h>
#import "Singleton.h"
#import "WSManager.h"
#import "BusquedaMapaTableViewCell.h"
#import "PinMapa.h"
#import "AFURLSessionManager.h"


@interface PuntosTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *iconos;
@property (nonatomic, strong) NSDictionary *itemSeleccionado;
@property BOOL ubico;

@end
