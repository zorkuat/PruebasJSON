//
//  BaseDeDatos.m
//  PruebasJSON
//
//  Created by cice on 19/1/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

#import "BaseDeDatos.h"

// Extensión de la Base
@interface BaseDeDatos()

@property (nonatomic) NSURL* rutaFichero;

// Muelle de carga de usuarios
@property (nonatomic) NSMutableArray* usuarios;

@end

@implementation BaseDeDatos

+ (BaseDeDatos *)instanciaUnica {
    static BaseDeDatos *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BaseDeDatos alloc] init];
    });
    
    return sharedInstance;
}

- (void)cargarBaseDeDatos
{
    NSURL * rutaLibreria = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory
                                                                   inDomains:NSUserDomainMask] firstObject];
    
    self.rutaFichero = [NSURL URLWithString:@"datos.json" relativeToURL:rutaLibreria];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:self.rutaFichero];
    
    NSError *error;
    self.usuarios = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    if (error != nil)
    {
        NSLog(@"Error: %@", error.description);
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.rutaFichero.path])
    {
        NSURL *rutaFicheroOriginal = [[NSBundle mainBundle] URLForResource:@"datos"
                                                             withExtension:@"json"];
        [[NSFileManager defaultManager] copyItemAtURL:rutaFicheroOriginal
                                                toURL:self.rutaFichero error:nil];
    }
}

- (NSMutableArray *)usuarios
{
    return self.usuarios;
}

- (NSURL *)rutaFichero
{
    return self.rutaFichero;
}

- (void)guardarCambios
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.usuarios options:NSJSONWritingPrettyPrinted error:nil];
    
    /// firstObject es para que te de el prier objeto del array que recupera URLsForDirectory
    [jsonData writeToURL:self.rutaFichero atomically:false];
}



@end
