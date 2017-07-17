//
//  AppDelegate.m
//  Musmanni
//
//  Created by Erick Pac on 5/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "AppDelegate.h"
#import "Singleton.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ValidarDatosExternosViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"Oswald-Regular" size:20.0]}];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.99 green:0.15 blue:0.18 alpha:1.0]];
    
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.99 green:0.15 blue:0.18 alpha:1.0]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.44 green:0.05 blue:0.09 alpha:1.0]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        [[UITabBar appearance] setUnselectedItemTintColor:[UIColor whiteColor]];
    }
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [self clearNotifications];
    [FIRApp configure];

    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [Singleton getInstance].token = token;
    NSLog(@"El token es: (%@)", token);
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([pref objectForKey:@"data_user"]) {
        WSManager *consumo = [[WSManager alloc] init];
        [consumo useWebServiceWithMethod:@"POST" withTag:@"validar_tarjeta" withParams:@{
                                                                                         @"email":[[pref objectForKey:@"data_user"] valueForKey:@"email"],
                                                                                         @"devicetoken":[Singleton getInstance].token
                                                                                         } withApi:@"validar_tarjeta" withDelegate:nil];
        
    }

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Falló al registrar el token: %@, %@", error, error.localizedDescription);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"NOTIFICACION RECIBIDA %@",userInfo);
    NSDictionary *contenido = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"loc-args"];
    if ([[contenido objectForKey:@"tarjeta"] isEqualToString:@"1"]) {
//        [[NSUserDefaults standardUserDefaults] setValue:@"270000000434" forKey:@"notarjeta"];
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"validado"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"validado"];
        [[NSUserDefaults standardUserDefaults] setValue:[contenido valueForKey:@"notarjeta"] forKey:@"notarjeta"];

        [[NSUserDefaults standardUserDefaults]  synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatetarjeta" object:contenido];
    }
    else if ([[[contenido objectForKey:@"tipo"] stringValue] isEqualToString:@"5"]) {
        
        [ISMessages showCardAlertWithTitle:@"Notificación de recarga"
                                   message:[contenido valueForKey:@"msg"]
                                 iconImage:nil
                                  duration:10.0
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeInfo
                             alertPosition:ISAlertPositionTop];
        
    }
    else if ([[[contenido objectForKey:@"tipo"] stringValue] isEqualToString:@"4"]) {
        
        [ISMessages showCardAlertWithTitle:@"Notificación de recarga"
                                   message:[contenido valueForKey:@"msg"]
                                 iconImage:nil
                                  duration:10.0
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeSuccess
                             alertPosition:ISAlertPositionTop];
        
    }
}

-(void)clearNotifications{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    // Check the calling application Bundle ID
    if ([sourceApplication isEqualToString:@"lg.AprobacionesFifco"])
    {
        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
        NSLog(@"URL scheme:%@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
        NSLog(@"URL %@ ", url);
        NSDictionary *dict = [self parseQueryString:[url query]];
        NSLog(@"query dict: %@", dict);//// esta variable almaccenena en un diccionario todos los parametros que vienen en la url
        NSLog(@"***************** SESION INICIADA : %s ",[Singleton getInstance].session_usuario ? "SI" : "NO");
        //
        
        NSDictionary *valor = [[NSDictionary alloc] init];
        valor = dict;
        
        [Singleton getInstance].datos_usuario_externo = valor;
        NSLog(@"Singleton DATOS EXTETRNOS %@ ",[Singleton getInstance].datos_usuario_externo);
        
        if([Singleton getInstance].session_usuario)
        {
            [Singleton getInstance].session_externo = YES;
            ValidarDatosExternosViewController *validar = [[ValidarDatosExternosViewController alloc] init];
            [validar cerrarSession];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UIViewController *vc =[storyboard instantiateInitialViewController];
            
                // Set root view controller and make windows visible
                self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                self.window.rootViewController = vc;
                [self.window makeKeyAndVisible];

        }
        else
        {
            [Singleton getInstance].session_externo = NO;
        }
        
        NSString *Mensaje = [valor valueForKey:@"uid_usuario"];//[NSString stringWithFormat:@"Usuario logueado en fifco es : %@ ",[[[Singleton getInstance] datosEXTERNO] valueForKey:@"uid_usuario"] ];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FifcoOne" message:Mensaje delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
       //[alert show];
        
        
        return YES;
    }
    else
        return NO;
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
    


}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Musmanni"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
