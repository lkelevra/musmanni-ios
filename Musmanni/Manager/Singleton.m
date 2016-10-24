//
//  Singleton.m
//  UbicarAgencias
//
//  Created by Luis Gonzalez on 3/03/15.
//  Copyright (c) 2015 Luis Gonzalez. All rights reserved.
//

#import "Singleton.h"


@implementation Singleton
@synthesize hud                 = _hud;
@synthesize spinner             = _spinner;
@synthesize usuario             = _usuario;
@synthesize password            = _password;
@synthesize url                 = _url;
@synthesize token               = _token;
@synthesize minimalNotification = _minimalNotification;
@synthesize isNotification      = _isNotification;
@synthesize itemUsuario         = _itemUsuario;
@synthesize redes_sociales      = _redes_sociales;
@synthesize datos_telco         = _datos_telco;

+ (instancetype)getInstance
{
static Singleton *instance      = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance                        = [[Singleton alloc] init];
        instance->_url                  = @"http://54.165.243.221/";
        instance->_token                = @"NO";
        instance->_itemUsuario          = [[NSMutableDictionary alloc] init];
        instance->_redes_sociales       = [[NSMutableDictionary alloc] init];
        instance->_datos_telco          = [[NSMutableDictionary alloc] init];
    });
    return instance;
}

- (id) init {
    return self;
}

-(void)mostrarHud:(UIView *)vista{
    RTSpinKitView *spinner          = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave color:[UIColor whiteColor]];
    _hud                            = [MBProgressHUD showHUDAddedTo:vista animated:YES];
    _hud.square                     = YES;
    _hud.mode                       = MBProgressHUDModeCustomView;
    _hud.customView                 = spinner;
    _hud.labelText                  = @"Cargando";
    [spinner startAnimating];
}

-(void)ocultarHud{
    [_hud setHidden:YES];
}
@end
