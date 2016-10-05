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

@property id<WSManagerDelegateF>  delegate;                          // el objeto que recibirá la notificación que la operación a finalizado
@property (nonatomic, strong          ) NSString  *servicio;        // protocolo://server:port
@property (nonatomic, strong          ) NSString  *servidor;        // protocolo://server:port
@property (nonatomic, strong          ) NSString  *metodo;          // GET o POST o PUT o DELETE
@property (nonatomic                  ) BOOL      certificado;      // usa ceritificado?
@property (nonatomic, strong          ) NSNumber  *timeout;         // tiempo máximo de espera
@property (nonatomic, strong, readonly) id        respuesta;        // respuesta de la operación del WS
@property (nonatomic, strong, readonly) NSString  *mensaje;         // descripción de falla al llamar al WS
@property (nonatomic,         readonly) BOOL      resultado;        // indica si se pudo ejecutar el WS o no
@property (nonatomic, strong, readonly) NSString  *tag;             // descripción de falla al llamar al WS
@property (nonatomic, strong, readonly) NSMutableDictionary  *parametros;      // parametros a enviar
@property (nonatomic, strong, readonly) NSString  *apiKey;             // descripción de falla al llamar al WS


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



