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
@synthesize mapView, locationManager, ubico, items, itemSeleccionado, iconos;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    self.itemsJSON = [[NSMutableArray alloc] init];
    
    [Singleton getInstance].listaIconos = [[NSMutableDictionary alloc] init];
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
-(IBAction)abrirUbicaciones:(id)sender{
    [self performSegueWithIdentifier:@"ubicacionesSegue" sender:nil];
}
-(void)viewDidAppear:(BOOL)animated {
    [[Singleton getInstance] ocultarHud];
    [[Singleton getInstance] mostrarHud:self.navigationController.view];
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

    WSManager *consumo = [[WSManager alloc] init];
    [consumo useWebServiceWithMethod:@"GET" withTag:@"puntos" withParams:@{@"idempresa": @"1"} withApi:@"puntos" withDelegate:self];
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

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(PinMapa *)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    else{
        MKAnnotationView *pinView = (MKAnnotationView*)[map dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        pinView.canShowCallout = YES;
        [self downloadImageForAnnotation:pinView withUrl:annotation.url];
        pinView.tag = annotation.posicion;
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        detailButton.tag = annotation.posicion;
        [detailButton addTarget:self
                         action:@selector(goDetailView:)
               forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = detailButton;

        
        return pinView;
    }
    return nil;
}
-(void) goDetailView:(id) sender {
    
    NSLog(@"DETALLE %ld",(long)[(MKAnnotationView*)sender tag]);
    self.itemSeleccionado = [self.itemsJSON objectAtIndex:[(MKAnnotationView*)sender tag]];
    NSLog(@"DETALLE %@",self.itemSeleccionado);
    
    [self performSegueWithIdentifier:@"verPuntoSegue" sender:nil];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"verPuntoSegue"]) {
        PuntoViewController *vc = [segue destinationViewController];
        vc.itemPunto = self.itemSeleccionado;
        
    }
}

- (void)downloadImageForAnnotation:(MKAnnotationView *)annotation withUrl:(NSString *) urlString {
    
    if([[Singleton getInstance].listaIconos objectForKey:urlString]){
        [annotation setImage: [UIImage imageWithContentsOfFile:[[Singleton getInstance].listaIconos valueForKey:urlString]]];
    }
    else{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                                  {
                                                      NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                      
                                                      return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                  } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                                  {

                                                      [[Singleton getInstance].listaIconos setValue:filePath.path forKey:urlString];

                                                      [annotation setImage: [UIImage imageWithContentsOfFile:filePath.path]];
                                                  }];
        [downloadTask resume];
    }
}



- (NSMutableArray *)crearArrayPines:(NSArray *)pines {
    NSMutableArray *arrayPines = [[NSMutableArray alloc] init];
    int contador = 0;
    for (NSDictionary *row in pines) {
        NSNumber *latitude = [row valueForKey:@"latitud"];
        NSNumber *longitude = [row valueForKey:@"longitud"];
        NSString *title = [row valueForKey:@"nombre"];
        NSString *subtitle = [row valueForKey:@"direccion"];
        NSString *urlIcono = [[row objectForKey:@"tipo_punto"] valueForKey:@"icono"];
        NSString *idPunto = [row objectForKey:@"id"];
        CLLocationCoordinate2D coord;
        coord.latitude = latitude.doubleValue;
        coord.longitude = longitude.doubleValue;
        PinMapa *annotation = [[PinMapa alloc] initWithTitle:title subtitle:subtitle AndCoordinate:coord];
        annotation.url = urlIcono;
        annotation.idPunto = [idPunto intValue];
        annotation.posicion = contador;
        [arrayPines addObject:annotation];
        [self.itemsJSON addObject:row];
        contador++;
    }
    return arrayPines;
}

-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if([callback.tag isEqualToString:@"puntos"]){
        @try {
            if(callback.resultado){
                [Singleton getInstance].listaPuntos = [callback.respuesta valueForKey:@"registros"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    items = [self crearArrayPines:(NSArray*)[callback.respuesta valueForKey:@"registros"]];
                    [mapView addAnnotations:items];
                });

                UIButton *conf = [UIButton buttonWithType:UIButtonTypeCustom];
                [conf setBackgroundImage:[UIImage imageNamed:@"find"] forState:UIControlStateNormal];
                [conf addTarget:self action:@selector(abrirUbicaciones:) forControlEvents:UIControlEventTouchUpInside];
                conf.frame = CGRectMake(0, 0, 30, 30);
                UIBarButtonItem *confButton = [[UIBarButtonItem alloc] initWithCustomView:conf] ;
                self.navigationItem.rightBarButtonItem = confButton;
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
