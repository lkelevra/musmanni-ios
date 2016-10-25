//
//  WSManager.m
//  Aprobaciones
//
//  Created by Luis Gonzalez on 6/04/15.
//  Copyright (c) 2015 Luis Gonzalez. All rights reserved.
//

#import "WSManager.h"
#import "Singleton.h"
#import "AFHTTPRequestOperationManager.h"

@implementation WSManager


@synthesize servidor;
@synthesize servicio;
@synthesize metodo;
@synthesize certificado;
@synthesize timeout;
@synthesize parametros;
@synthesize respuesta;
@synthesize mensaje;
@synthesize resultado;
@synthesize tag;
@synthesize apiKey;
@synthesize delegate;

- (id)init {
    if (self = [super init]) {
        servidor        = [Singleton getInstance].url;
        metodo          = @"GET";
        certificado     = YES;
        timeout         = [NSNumber numberWithInt:60];
        servicio        = @"";
        parametros      = [[NSMutableDictionary alloc] init];
        apiKey          = @"pab7OmVgyR0oW1NSaUlOUoaJDRUD7SU5";
    }
    
    return self;
}

-(void)useWebServiceWithMethod:(NSString *)method withTag:(NSString *)identificador withParams:(NSDictionary*)parms withApi:(NSString*)api withDelegate:(id<WSManagerDelegateF>)delegado {
    self.delegate = delegado;
    metodo  = method;
    tag = identificador;
    [self useApi:api];
    [self setPostValues:parms];
    [self useWebService];
}


- (void)setPostValue:(id<NSObject>)value forKey:(NSString*)key {
    [parametros addEntriesFromDictionary:[NSDictionary dictionaryWithObject:value forKey:key]];
}

-(void) useApi:(NSString *)identificador{
    @try {
        NSDictionary* api = @{
                              @"login":         @"ws/movil/login",
                              @"enviar_token":  @"ws/movil/gcm/crear",
                              @"obtener_saldo": @"ws/tarjeta/consultar",
                              @"puntos":        @"ws/movil/puntos/obtenerporempresa",
                              @"promociones":   @"ws/movil/promociones/obtenerporempresa",
                              @"montos_recarga":@"ws/recargas/detallerecargas"
                              };
        
        servicio = [api objectForKey:identificador];
    } @catch (NSException *exception) {
        resultado       =   TRUE;
        respuesta       =   @"";
        mensaje         =   @"Servicio no encontrado";
        [delegate webServiceTaskComplete:self];
    } @finally{ }
    
}

- (void)setPostValues:(NSDictionary *)parametersDictionary {
    for (NSString *key in parametersDictionary) {
        if ([key isEqualToString:@"imagen"]) {
            //            NSLog(@"KEY:%@ VALOR:%@",key,@"Si va la foto");
        }else {
            //          NSLog(@"KEY:%@ VALOR:%@",key,[parametersDictionary objectForKey:key]);
        }
        
        [self setPostValue:[parametersDictionary objectForKey:key] forKey:key];
    }
    
    NSLog(@"-----------------------------------------------------------------");
    NSLog(@"Enviando en: %@: %@",self.servicio,parametersDictionary);
    NSLog(@"-----------------------------------------------------------------");
    [self setPostValue:@"1" forKey:@"idempresa"];
    [self setPostValue:apiKey forKey:@"app_key"];
}

-(void)useWebServiceWithTag:(NSString *)identificador{
    tag = identificador;
    [self useWebService];
}

-(void)useWebServiceImageWithTag:(NSString *)identificador withParams:(NSDictionary*)parms withApi:(NSString*)api imagen:(NSData*)imagenData parametro:(NSString *)nombreParametro withDelegate:(id<WSManagerDelegateF>)delegado{
    
    self.delegate = delegado;
    metodo  = @"POST";
    tag = identificador;
    [self useApi:api];
    [self setPostValues:parms];
    tag = identificador;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", servidor, servicio];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    AFHTTPRequestOperation *op = [manager POST:URL parameters:parametros constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagenData name:nombreParametro fileName:@"foto.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        resultado       =   [[responseObject objectForKey:@"resultado"] boolValue];
        mensaje         =   [responseObject objectForKey:@"mensaje"];
        respuesta       =   (NSDictionary*)responseObject;
        [delegate webServiceTaskComplete:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ==== %@", operation ,error);
        resultado       =   FALSE;
        mensaje         =   @"Tenemos problemas al subir la imagen, intenta de nuevo.";
        respuesta       =   nil;
        [delegate webServiceTaskComplete:self];
    }];
    
    [op start];
}


-(void)useWebServiceImageWithTag:(NSString *)identificador withParams:(NSDictionary*)parms withApi:(NSString*)api archivo:(NSData*)imagenData nombre:(NSString*) name  parametro:(NSString *)nombreParametro withDelegate:(id<WSManagerDelegateF>)delegado{
    
    self.delegate = delegado;
    metodo  = @"POST";
    tag = identificador;
    [self useApi:api];
    [self setPostValues:parms];
    tag = identificador;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@", servidor, servicio];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    AFHTTPRequestOperation *op = [manager POST:URL parameters:parametros constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagenData name:nombreParametro fileName:name mimeType:@"application/pdf"];
        NSLog(@"FORM DATA %@",formData);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultado       =   [[responseObject objectForKey:@"resultado"] boolValue];
        mensaje         =   [responseObject objectForKey:@"mensaje"];
        respuesta       =   (NSDictionary*)responseObject;
        [delegate webServiceTaskComplete:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ==== %@", operation ,error);
        resultado       =   FALSE;
        mensaje         =   @"Tenemos problemas al acceder a tus datos, intenta más tarde.";
        respuesta       =   nil;
        [delegate webServiceTaskComplete:self];
    }];
    
    [op start];
}


- (void)useWebService{
    
    @try {
        NSString *URL = [NSString stringWithFormat:@"%@/%@", servidor, servicio];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        
        if([metodo  isEqual: @"GET"] ) {
            [manager GET:URL parameters:parametros success:^(AFHTTPRequestOperation *operation, id responseObject) {
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
                NSLog(@"JSON: %@", responseObject);
                resultado       =   [[responseObject objectForKey:@"resultado"] boolValue];
                mensaje         =   [responseObject objectForKey:@"mensaje"];
                respuesta       =   (NSDictionary*)responseObject;
                [delegate webServiceTaskComplete:self];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@ ==== %@", operation ,error);
                resultado       =   FALSE;
                mensaje         =   @"Tenemos problemas al acceder a tus datos, intenta más tarde.";
                respuesta       =   nil;
                [delegate webServiceTaskComplete:self];
            }];
        }
        else if([metodo isEqual: @"POST"]) {
            [manager POST:URL parameters:parametros success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                resultado       =   [[responseObject objectForKey:@"resultado"] boolValue];
                mensaje         =   [responseObject objectForKey:@"mensaje"];
                respuesta       =   (NSDictionary*)responseObject;
                [delegate webServiceTaskComplete:self];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@ ==== %@", operation ,error);
                resultado       =   FALSE;
                mensaje         =   @"Red inaccesible, revisa tu conexión";
                respuesta       =   nil;
                [delegate webServiceTaskComplete:self];
            }];
        }
    } @catch (NSException *exception) {
        resultado       =   FALSE;
        mensaje         =   @"Red inaccesible, revisa tu conexión";
        respuesta       =   nil;
        [delegate webServiceTaskComplete:self];
        NSLog(@"USANDO WS");
    }
}
@end
