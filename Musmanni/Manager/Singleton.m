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
@synthesize itemUsuario = _itemUsuario;
@synthesize inventario = _inventario;

+ (instancetype)getInstance
{
static Singleton *instance      = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance                        = [[Singleton alloc] init];
        instance->_url                  = @"http://fifcoone.com/envases/public/";
        instance->_token                = @"NO";
        instance->_itemUsuario          = [[NSMutableDictionary alloc] init];
        instance->_inventario           = [[NSMutableArray alloc] init];
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

- (void) mostrarNotificacion:(NSString *)type mensaje:(NSString *)message titulo:(NSString *)title enVista:(UIView*)view {
    if([type isEqualToString:@"warning"]){
        _minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleWarning
                                                                      title:title
                                                                   subTitle:message dismissalDelay:2.0];
    }
    else if([type isEqualToString:@"success"]){
        _minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess
                                                                      title:title
                                                                   subTitle:message dismissalDelay:2.0];
    }
    else if([type isEqualToString:@"info"]){
        _minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleInfo
                                                                      title:title
                                                                   subTitle:message dismissalDelay:2.0];
    }
    else if([type isEqualToString:@"error"]){
        _minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError
                                                                      title:title
                                                                   subTitle:message dismissalDelay:2.0];
    }
    else{
        _minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleDefault
                                                                      title:title
                                                                   subTitle:message dismissalDelay:2.0];
    }
    @try {
        [view addSubview:_minimalNotification];
        [_minimalNotification setPresentFromTop:YES];
        [_minimalNotification show];

    } @catch (NSException *exception) {
        @try {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cerrar"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } @catch (NSException *exception) {
            NSLog(@"NO SE PUEDE MOSTRAR ALERTA %@",[exception description]);
        } @finally { }

    } @finally {}
}
@end
