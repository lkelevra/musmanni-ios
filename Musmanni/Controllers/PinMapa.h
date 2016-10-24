//
//  PinMapa.h
//  Envase Virtual
//
//  Created by Luis Gonzalez on 18/11/15.
//  Copyright © 2015 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface PinMapa : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    int pos;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic) int pos;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
