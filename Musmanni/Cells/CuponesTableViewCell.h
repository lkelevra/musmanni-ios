//
//  CuponesTableViewCell.h
//  Musmanni
//
//  Created by Erick Pac on 12/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuponesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewDescrip;
@property (weak, nonatomic) IBOutlet UIImageView *ivPicture;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescrip;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
