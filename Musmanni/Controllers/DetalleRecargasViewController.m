//
//  DetalleRecargasViewController.m
//  Musmanni
//
//  Created by Erick Pac on 24/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "DetalleRecargasViewController.h"

@interface DetalleRecargasViewController ()

@end

@implementation DetalleRecargasViewController
@synthesize lblTelco, ivTelco, pvMontos, montos, lblMonto, btnPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Recargas";
    pvMontos.delegate = self;
    pvMontos.dataSource = self;
    pvMontos.hidden = YES;
    [pvMontos setBackgroundColor:[UIColor whiteColor]];
    
    montos = @[@"500", @"1000", @"1500", @"2000"];
    btnPicker.tag = 1;
    
    [lblTelco setText:[[Singleton getInstance].datos_telco valueForKey:@"nombre_telco"]];
    
    ivTelco.layer.cornerRadius = 40;
    ivTelco.clipsToBounds = YES;
    ivTelco.layer.borderWidth = 7.0f;
    ivTelco.layer.borderColor = [UIColor whiteColor].CGColor;
    [ivTelco setImage:[UIImage imageNamed:[[Singleton getInstance].datos_telco valueForKey:@"image"]]];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}


- (void)goBack {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(IBAction)mostrarPicker:(UIButton *)sender{
    if (sender.tag == 1) {
        btnPicker.tag = 2;
        pvMontos.hidden = NO;
    }
    else if (sender.tag == 2){
        btnPicker.tag = 1;
        pvMontos.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [montos count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [lblMonto setText:[montos objectAtIndex:row]];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return montos[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* lbl = (UILabel*)view;
    
    if (lbl == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 70, 30);
        lbl = [[UILabel alloc] initWithFrame:frame];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setFont:[UIFont fontWithName:@"Oswald-Regular" size:20.0]];
    }
    
    [lbl setText:[montos objectAtIndex:row]];
    
    return lbl;
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
