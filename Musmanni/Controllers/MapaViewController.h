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


@interface MapaViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property BOOL ubico;

@end
