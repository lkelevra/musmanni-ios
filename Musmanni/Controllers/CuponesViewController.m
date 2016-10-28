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
    
    UIButton *conf = [UIButton buttonWithType:UIButtonTypeCustom];
    [conf setBackgroundImage:[UIImage imageNamed:@"Configuraciones"] forState:UIControlStateNormal];
    [conf addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    conf.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *confButton = [[UIBarButtonItem alloc] initWithCustomView:conf] ;
    self.navigationItem.rightBarButtonItem = confButton;
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
    
    NSURL *picture = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", [item valueForKey:@"url_foto"]] stringByRemovingPercentEncoding]];
    NSString *descripcion = [NSString stringWithFormat:@"Promoción válida hasta: %@", [item valueForKey:@"fin"]];
    
    cell.ivPicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:picture]];
    [cell.lblTitle setText:[item valueForKey:@"descripcion" ]];
    [cell.lblDescrip setText:descripcion];
    [cell.btnShare setTag:indexPath.row];
    
    UITapGestureRecognizer *tapImageConfigure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(compartirPromocion:)];
    [tapImageConfigure setNumberOfTapsRequired:1];
    
    [cell.btnShare setUserInteractionEnabled:true];
    [cell.btnShare addGestureRecognizer:tapImageConfigure];
    
    return cell;
}


-(IBAction)compartirPromocion:(UITapGestureRecognizer *)sender{
    NSDictionary *item = [[Singleton getInstance].listaPromociones objectAtIndex:[[sender view] tag]];
    NSURL *picture = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", [item valueForKey:@"url_foto"]] stringByRemovingPercentEncoding]];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:picture]];
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
}

-(void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
}

-(void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    
}

-(void)webServiceTaskComplete:(WSManager *)callback{
    [[Singleton getInstance] ocultarHud];
    if([callback.tag isEqualToString:@"promociones"]){
        @try {
            if(callback.resultado){
                [Singleton getInstance].listaPromociones = (NSMutableArray *)[[callback respuesta] objectForKey:@"registros"];
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
