//
//  PinMapa.h
//  UbicarAgencias
//
//  Created by Luis Gonzalez on 5/03/15.
//  Copyright (c) 2015 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface PinMapa : NSObject <MKAnnotation>
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property int idPunto;
@property int posicion;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id) initWithTitle:(NSString *) title subtitle:(NSString*)sub AndCoordinate:(CLLocationCoordinate2D)coordinate;
@end
