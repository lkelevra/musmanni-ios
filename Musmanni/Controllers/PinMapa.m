//
//  PinMapa.m
//  UbicarAgencias
//
//  Created by Luis Gonzalez on 5/03/15.
//  Copyright (c) 2015 Luis Gonzalez. All rights reserved.
//

#import "PinMapa.h"

@implementation PinMapa

@synthesize coordinate=_coordinate;
@synthesize title=_title;
@synthesize subtitle=_subtitle;
@synthesize url=_url;
@synthesize idPunto = _idPunto;
@synthesize posicion = _posicion;
-(id) initWithTitle:(NSString *) title subtitle:(NSString*)sub AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    _title = title;
    _coordinate = coordinate;
    _subtitle = sub;
    return self;
}
@end
