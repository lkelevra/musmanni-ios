//
//  PinMapa.m
//  Envase Virtual
//
//  Created by Luis Gonzalez on 18/11/15.
//  Copyright © 2015 Luis Gonzalez. All rights reserved.
//

#import "PinMapa.h"

@implementation PinMapa

@synthesize coordinate,title,subtitle;
@synthesize pos;

- (id)initWithLocation:(CLLocationCoordinate2D)coord{
    
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

@end
