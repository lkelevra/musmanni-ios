//
//  CuponesTableViewCell.m
//  Musmanni
//
//  Created by Erick Pac on 12/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "CuponesTableViewCell.h"

@implementation CuponesTableViewCell
@synthesize viewDescrip;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    viewDescrip.layer.shadowOffset = CGSizeMake(1.3, 3);
    viewDescrip.layer.shadowOpacity = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
