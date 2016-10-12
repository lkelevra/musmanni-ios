//
//  ContactenosViewController.m
//  Musmanni
//
//  Created by Erick Pac on 12/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "ContactenosViewController.h"

@interface ContactenosViewController ()

@end

@implementation ContactenosViewController
@synthesize tablaDatosContacto;

- (void)viewDidLoad {
    [super viewDidLoad];
    tablaDatosContacto.delegate = self;
    tablaDatosContacto.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identificador = @"ContactenosTableViewCell";
    ContactenosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identificador];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:identificador bundle:nil] forCellReuseIdentifier:identificador];
        cell = [tableView dequeueReusableCellWithIdentifier:identificador];
    }
    
    if(indexPath.row == 0){
        [cell.ivIcono setImage:[UIImage imageNamed:@"Contacto"]];
        [cell.lblName setText:@"Call center"];
        [cell.lblDetail setText:@"+22406868"];
    }
    else if (indexPath.row == 1){
        [cell.ivIcono setImage:[UIImage imageNamed:@"Mail"]];
        [cell.lblName setText:@"Correo electrónico"];
        [cell.lblDetail setText:@"info@musmanni.com"];
    }
    else if (indexPath.row == 2){
        [cell.ivIcono setImage:[UIImage imageNamed:@"Web"]];
        [cell.lblName setText:@"Página web"];
        [cell.lblDetail setText:@"www.musmanni.com"];
    }
    else if (indexPath.row == 3){
        [cell.ivIcono setImage:[UIImage imageNamed:@"Facebook"]];
        [cell.lblName setText:@"Facebook"];
        [cell.lblDetail setText:@"facebook.com/musi"];
    }

    
    return cell;
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
