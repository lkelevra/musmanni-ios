//
//  PuntoTableViewCell.h
//  Musmanni
//
//  Created by Luis Gonzalez on 27/11/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuntoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *direccion;
@property (weak, nonatomic) IBOutlet UILabel *distancia;
@property (weak, nonatomic) IBOutlet UIImageView *icono;

@end
