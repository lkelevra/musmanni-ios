//
//  Singleton.h
//  UbicarAgencias
//
//  Created by Luis Gonzalez on 3/03/15.
//  Copyright (c) 2015 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CONF_DEFAULT @"datosUsuario"
#import <CoreLocation/CoreLocation.h>
#import <JFMinimalNotifications/JFMinimalNotification.h>
#import <ISMessages/ISMessages.h>
#import "MBProgressHUD.h"
#import "RTSpinKitView.h"


@interface Singleton : NSObject
@property (strong, nonatomic) MBProgressHUD         *hud;
@property (strong, nonatomic) RTSpinKitView         *spinner;
@property (nonatomic, strong) NSString              *usuario;
@property (nonatomic, strong) NSString              *password;
@property (nonatomic, strong) NSString              *url;
@property (nonatomic, strong) NSString              *token;
@property (nonatomic, strong) NSMutableDictionary   *itemUsuario;
@property (nonatomic, strong) JFMinimalNotification *minimalNotification;
@property (nonatomic, strong) ISMessages            *isNotification;
@property (nonatomic, strong) NSMutableDictionary   *redes_sociales;
@property (nonatomic, strong) NSMutableDictionary   *datos_telco;
@property (nonatomic, strong) NSMutableDictionary   *listaIconos;
@property (nonatomic, strong) NSMutableArray        *listaPromociones;
@property (nonatomic, strong) NSMutableArray        *listaPuntos;

+ (Singleton* )getInstance;
-(void)mostrarHud:(UIView *)vista;
-(void)ocultarHud;
@end





