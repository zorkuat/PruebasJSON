//
//  BaseDeDatos.h
//  PruebasJSON
//
//  Created by cice on 19/1/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDeDatos : NSObject

/// Singleton de la base de datos.
+ (BaseDeDatos *)instanciaUnica;

- (void) cargarBaseDeDatos;
- (NSMutableArray*) usuarios;
- (NSURL *)rutaFichero;
- (void) guardarCambios;

@end
