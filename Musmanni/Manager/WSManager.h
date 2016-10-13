//
//  WSManager.h
//  Aprobaciones
//
//  Created by Luis Gonzalez on 6/04/15.
//  Copyright (c) 2015 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSManager;

@protocol WSManagerDelegateF <NSObject>
-(void)webServiceTaskComplete:(WSManager *)callback;
@end

@interface WSManager: NSObject;

@property id<WSManagerDelegateF>  delegate;                        
@property (nonatomic, strong          ) NSString  *servicio;
@property (nonatomic, strong          ) NSString  *servidor;
@property (nonatomic, strong          ) NSString  *metodo;
@property (nonatomic                  ) BOOL      certificado;
@property (nonatomic, strong          ) NSNumber  *timeout;
@property (nonatomic, strong, readonly) id        respuesta;
@property (nonatomic, strong, readonly) NSString  *mensaje;
@property (nonatomic,         readonly) BOOL      resultado;
@property (nonatomic, strong, readonly) NSString  *tag;
@property (nonatomic, strong, readonly) NSMutableDictionary  *parametros;
@property (nonatomic, strong, readonly) NSString  *apiKey;


// Metodo para asignarle la api que se va usar
-(void) useApi:(NSString *)identificador;
// agregar un parámetro a la llamada del WS
- (void)setPostValue:(id<NSObject>)value forKey:(NSString*)key;

// agregar un conjunto de parámetros a la llamada del WS
- (void)setPostValues:(NSDictionary *)parametersDictionary;

// ejecutar el WS
- (void)useWebService;
-(void)useWebServiceWithMethod:(NSString *)method withTag:(NSString *)identificador withParams:(NSDictionary*)parms withApi:(NSString*)api withDelegate:(id<WSManagerDelegateF>)delegate;
-(void)useWebServiceImageWithTag:(NSString *)identificador withParams:(NSDictionary*)parms withApi:(NSString*)api imagen:(NSData*)imagenData parametro:(NSString *)nombreParametro withDelegate:(id<WSManagerDelegateF>)delegado;
-(void)useWebServiceImageWithTag:(NSString *)identificador withParams:(NSDictionary*)parms withApi:(NSString*)api archivo:(NSData*)imagenData nombre:(NSString*) name parametro:(NSString *)nombreParametro withDelegate:(id<WSManagerDelegateF>)delegado;


@end



