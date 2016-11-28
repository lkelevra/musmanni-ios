//
//  PuntosTableViewController.m
//  Musmanni
//
//  Created by Luis Gonzalez on 27/11/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "PuntosTableViewController.h"
#import "PuntoTableViewCell.h"
#import "PuntoViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface PuntosTableViewController ()
@property NSArray *resultadoBusqueda;
@property (nonatomic, strong) NSMutableArray *items;
@property BOOL isFiltered;
@property (nonatomic, strong) NSDictionary* itemTap;
@end

@implementation PuntosTableViewController
@synthesize  locationManager, ubico, items, itemSeleccionado, iconos, resultadoBusqueda,searchBar,tableView,isFiltered;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultadoBusqueda = [[NSArray alloc] init];
    self.itemTap = [[NSDictionary alloc] init];
    searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    [Singleton getInstance].listaIconos = [[NSMutableDictionary alloc] init];
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    #endif
    
    
    [locationManager startUpdatingLocation];
    [self fixItems];
    
    
}
-(void) fixItems {
    
    items = [[NSMutableArray alloc]init];
    for (NSDictionary *item in [Singleton getInstance].listaPuntos) {
        NSMutableDictionary * nuevoItem = [[NSMutableDictionary alloc] initWithDictionary:[item copy]];
        [nuevoItem setValue:[self calculateDistanceFromLatitude:[item valueForKey:@"latitud"] andLongitude:[item valueForKey:@"longitud"]] forKey:@"distancia"];
        [items addObject:nuevoItem];
    }
    [items sortUsingDescriptors:
     @[
       [NSSortDescriptor sortDescriptorWithKey:@"distancia" ascending:YES]
       ]];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isFiltered){
        return [resultadoBusqueda count];
    } else {
        return [items count];
    }
    return [[Singleton getInstance].listaPuntos count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item =  [items  objectAtIndex:indexPath.row];
    static NSString *identificador = @"PuntoTableViewCell";
    PuntoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identificador];
    if(!cell){
        [self.tableView registerNib:[UINib nibWithNibName:identificador bundle:nil] forCellReuseIdentifier:identificador];
        cell = [self.tableView dequeueReusableCellWithIdentifier:identificador];
    }
    
    if (isFiltered) {
        item = [resultadoBusqueda  objectAtIndex:indexPath.row];
    } else {
        item = [items  objectAtIndex:indexPath.row];
    }
    
    [cell.titulo setText:[item valueForKey:@"nombre"]];
    [cell.direccion setText:[item valueForKey:@"direccion"]];
    NSURL *picture = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", [[item objectForKey:@"tipo_punto"] valueForKey:@"icono"]] stringByRemovingPercentEncoding]];
    [cell.icono setImageWithURL:picture placeholderImage:[UIImage imageNamed:@"loader"]];
    [cell.distancia setText:[NSString stringWithFormat:@"%@ KM",[item valueForKey:@"distancia"]]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isFiltered) {
        self.itemTap = [resultadoBusqueda  objectAtIndex:indexPath.row];
    } else {
        self.itemTap = [items  objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:@"verPuntoSegue" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"verPuntoSegue"]) {
        PuntoViewController *vc = [segue destinationViewController];
        vc.itemPunto = self.itemTap;
        
    }
}


- (NSString *)calculateDistanceFromLatitude:(NSString*)latitude andLongitude:(NSString*)longitude {
    @try {
        
         if(locationManager.location.coordinate.latitude != 0){
            CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
            CLLocation *location2 = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [numberFormatter setGroupingSize:3];
            [numberFormatter setCurrencySymbol:@""];
            [numberFormatter setLocale:[NSLocale currentLocale]];
            [numberFormatter setMaximumFractionDigits:2];
            NSString *formattedString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:([location1 distanceFromLocation:location2]/1000)]];
            return formattedString;
        }
        else{
            return @"--";
        }
        
    } @catch (NSException *exception) {
        return @"";
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(![self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    
    if(searchText.length == 0){
        isFiltered = FALSE;
    } else {
        isFiltered = TRUE;
        resultadoBusqueda = nil;
        resultadoBusqueda = [[NSMutableArray alloc] init];
        
        NSPredicate *predicado = [NSPredicate predicateWithFormat:@"(nombre contains[c] %@ OR direccion contains[c] %@)", searchText, searchText];
        resultadoBusqueda =  [self.items filteredArrayUsingPredicate:predicado];
    }
    
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text = @"";
    [self searchBar:self.searchBar textDidChange: @""];
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    [self.tableView reloadData];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([self.searchBar isFirstResponder] && [touch view] != self.searchBar) {
        [self.searchBar resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}


@end
