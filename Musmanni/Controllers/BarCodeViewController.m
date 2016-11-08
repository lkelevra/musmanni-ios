//
//  BarCodeViewController.m
//  Musmanni
//
//  Created by Erick Pac on 30/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "BarCodeViewController.h"

@interface BarCodeViewController ()

@end

@implementation BarCodeViewController
@synthesize ivBarCode, barCodeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Código de barras";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    NSString *bar_code = @"0"; bar_code = [bar_code stringByAppendingString:[pref valueForKey:@"notarjeta"]];
    [barCodeView setBarCode:bar_code];
    
    UIImage *imagenCodigo =[CodeGen genCodeWithContents:[NSString stringWithFormat:@"0%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"notarjeta"]] machineReadableCodeObjectType:AVMetadataObjectTypeEAN13Code];
    
    UIImage *PortraitImage = [[UIImage alloc] initWithCGImage: imagenCodigo.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationRight];
    
    [ivBarCode setImage:PortraitImage];
    
//    UILabel *label = [[UILabel alloc] init];
//    [label setText:[pref valueForKey:@"notarjeta"]];
//    label.transform=CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
//    [label setFrame:CGRectMake(20, ivBarCode.frame.origin.y, label.frame.size.width, ivBarCode.frame.size.height)];
//    [label sizeToFit];
//    [self.view addSubview:label];
}


-(void) viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
