//
//  MapaViewController.m
//  Musmanni
//
//  Created by Erick Pac on 12/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "MapaViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface MapaViewController ()
@end

@implementation MapaViewController
@synthesize mapView, locationManager, ubico, items, itemSeleccionado;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    #endif
    
    [locationManager startUpdatingLocation];
    mapView.showsUserLocation = YES;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    if(self.locationManager.location.coordinate.longitude != 0){
        MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
        region.center.latitude = locationManager.location.coordinate.latitude;
        region.center.longitude = locationManager.location.coordinate.longitude;
        region.span.longitudeDelta = 0.005f;
        region.span.longitudeDelta = 0.005f;
        [mapView setRegion:region animated:YES];
    }
    else{
        MKCoordinateRegion region = { { 9.990491, -83.979492 }, { 9.990491, -83.979492 } };
        region.span.longitudeDelta = 0.005f;
        region.span.longitudeDelta = 0.005f;
        [mapView setRegion:region animated:YES];
    }
    [[Singleton getInstance] mostrarHud:self.navigationController.view];
    WSManager *consumo = [[WSManager alloc] init];
    [consumo useWebServiceWithMethod:@"GET" withTag:@"puntos" withParams:@{} withApi:@"puntos" withDelegate:self];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if(!ubico){
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        ubico = YES;
    }
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}

- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}

- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}

- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}

-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if([callback.tag isEqualToString:@"puntos"]){
        @try {
            if(callback.resultado){
                int pos = 0;
                items = [[NSMutableArray alloc] initWithArray:(NSArray*)[callback.respuesta valueForKey:@"registros"]];
                for (NSDictionary *punto in items) {
                    CLLocation *coordenadas = [[CLLocation alloc] initWithLatitude:[[punto valueForKey:@"latitud"] floatValue] longitude:[[punto valueForKey:@"longitud"] floatValue]];
                    PinMapa *annotation = [[PinMapa alloc] initWithLocation:coordenadas.coordinate];
                    annotation.title = [punto valueForKey:@"nombre"];
                    annotation.subtitle = [punto valueForKey:@"direccion"];
                    annotation.pos = pos;
                    pos++;
                    [mapView addAnnotation:annotation];
                }
            } else {
                [ISMessages showCardAlertWithTitle:@"Espera"
                                           message:callback.mensaje
                                         iconImage:nil
                                          duration:3.f
                                       hideOnSwipe:YES
                                         hideOnTap:YES
                                         alertType:ISAlertTypeError
                                     alertPosition:ISAlertPositionTop];
            }
        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución: %@", exception);
        } @finally { }    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
