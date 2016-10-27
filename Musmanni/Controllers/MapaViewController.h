//
//  MapaViewController.h
//  Musmanni
//
//  Created by Erick Pac on 12/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "Singleton.h"
#import "WSManager.h"
#import "BusquedaMapaTableViewCell.h"
#import "PinMapa.h"
#import "AFURLSessionManager.h"

@interface MapaViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, WSManagerDelegateF>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *iconos;
@property (nonatomic, strong) NSDictionary *itemSeleccionado;
@property BOOL ubico;

@end
