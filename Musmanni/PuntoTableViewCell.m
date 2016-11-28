//
//  PuntoTableViewCell.m
//  Musmanni
//
//  Created by Luis Gonzalez on 27/11/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "PuntoTableViewCell.h"

@implementation PuntoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titulo setFont:[UIFont fontWithName:@"Oswald-Regular" size:14.0]];
    [self.distancia setFont:[UIFont fontWithName:@"Oswald-Regular" size:14.0]];
    [self.direccion setFont:[UIFont fontWithName:@"Oswald-Regular" size:12.0]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
