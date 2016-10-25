//
//  CuponesViewController.m
//  Musmanni
//
//  Created by Erick Pac on 12/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "CuponesViewController.h"

@interface CuponesViewController ()

@end

@implementation CuponesViewController
@synthesize table, items;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0];
}


-(void) viewDidAppear:(BOOL)animated{
    [[Singleton getInstance] mostrarHud:self.navigationController.view];
    WSManager *consumo = [[WSManager alloc] init];
    [consumo useWebServiceWithMethod:@"POST" withTag:@"promociones" withParams:@{} withApi:@"promociones" withDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item =  [items  objectAtIndex:indexPath.row];
    static NSString *identificador = @"CuponesTableViewCell";
    CuponesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identificador];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:identificador bundle:nil] forCellReuseIdentifier:identificador];
        cell = [tableView dequeueReusableCellWithIdentifier:identificador];
    }
    
//    NSString *foto = [Singleton getInstance].url; foto = [foto stringByAppendingString:[item valueForKey:@"url_foto"]];
//    cell.ivPicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:foto]]];
    
    [cell.lblTitle setText:[item valueForKey:@"descripcion" ]];
    [cell.lblDescrip setText:[item valueForKey:@"descripcion" ]];
    
    return cell;
}

-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if([callback.tag isEqualToString:@"promociones"]){
        @try {
            if(callback.resultado){
                items = [[callback respuesta] objectForKey:@"registros"];
                [table reloadData];
            } else{
                [ISMessages showCardAlertWithTitle:@"Espera"
                                           message:callback.mensaje
                                         iconImage:nil
                                          duration:3.f
                                       hideOnSwipe:YES
                                         hideOnTap:YES
                                         alertType:ISAlertTypeError
                                     alertPosition:ISAlertPositionTop];
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Ocurrió un problema en la ejecución del WS promociones: %@", exception);
        } @finally { }
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
