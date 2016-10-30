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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.ivIcono setImage:[UIImage imageNamed:@"Contacto"]];
        [cell.lblName setText:@"Call center"];
        [cell.lblDetail setText:[[Singleton getInstance].redes_sociales valueForKey:@"telefono"]];
    }
    else if (indexPath.row == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.ivIcono setImage:[UIImage imageNamed:@"Mail"]];
        [cell.lblName setText:@"Correo electrónico"];
        [cell.lblDetail setText:[[Singleton getInstance].redes_sociales valueForKey:@"email"]];
    }
    else if (indexPath.row == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.ivIcono setImage:[UIImage imageNamed:@"Web"]];
        [cell.lblName setText:@"Página web"];
        [cell.lblDetail setText:[[Singleton getInstance].redes_sociales valueForKey:@"web"]];
    }
    else if (indexPath.row == 3){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *facebook = @"facebook.com/";
        facebook = [facebook stringByAppendingString:[[Singleton getInstance].redes_sociales valueForKey:@"facebook"]];
        [cell.ivIcono setImage:[UIImage imageNamed:@"Facebook"]];
        [cell.lblName setText:@"Facebook"];
        [cell.lblDetail setText:facebook];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        NSString *tel = @"tel://";
        tel = [tel stringByAppendingString:[[Singleton getInstance].redes_sociales valueForKey:@"telefono"]];
        NSURL* telURL = [NSURL URLWithString:tel];
        if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
            [[UIApplication sharedApplication] openURL:telURL];
        }
    }
    else if ([indexPath row] == 1){
        NSString *mail = @"message://";
        mail = [mail stringByAppendingString:[[Singleton getInstance].redes_sociales valueForKey:@"email"]];
        NSURL* mailURL = [NSURL URLWithString:mail];
        if ([[UIApplication sharedApplication] canOpenURL:mailURL]) {
            [[UIApplication sharedApplication] openURL:mailURL];
        }
    }
    else if ([indexPath row] == 2){
        NSString *web = @"http://";
        web = [web stringByAppendingString:[[Singleton getInstance].redes_sociales valueForKey:@"web"]];
        NSURL* webURL = [NSURL URLWithString:web];
        if ([[UIApplication sharedApplication] canOpenURL:webURL]) {
            [[UIApplication sharedApplication] openURL:webURL];
        }
    }
    else if ([indexPath row] == 3){
        NSString *fb = @"https://facebook.com/";
        fb = [fb stringByAppendingString:[[Singleton getInstance].redes_sociales valueForKey:@"facebook"]];
        NSURL* fbURL = [NSURL URLWithString:fb];
        if ([[UIApplication sharedApplication] canOpenURL:fbURL]) {
            [[UIApplication sharedApplication] openURL:fbURL];
        }
    }
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
