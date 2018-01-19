//
//  UsuariosTableViewController.m
//  PruebasJSON
//
//  Created by cice on 18/1/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

#import "UsuariosTableViewController.h"
#import "FacturasTableViewController.h"
#import "BaseDeDatos.h"

@interface UsuariosTableViewController ()

@property (nonatomic) NSMutableArray * usuarios;

@property (nonatomic) UIAlertAction * accionCrearUsuario;
@property (nonatomic) UITextField * campoTextoNombreUsuario;
@property (nonatomic) UITextField * campoTextoEmailUsuario;

@end

@implementation UsuariosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// Esto era el dummie para cargar el fichero interno del bundle al principio siempre.
    /// Ahora lo hacemos sólo una vez y si no existe un fichero de datos externo.
    /*NSURL *jsonURL = [[NSBundle mainBundle]
                      URLForResource:@"datos"
                     withExtension:@"json"];*/
    
    /// Y así es como se usa un singlenton, queridos niños.
    self.usuarios = [[BaseDeDatos instanciaUnica] usuarios];
    
    /// NSLog(@"%@", basededatos.rutaFichero.path);
    NSLog(@"%@", [[[BaseDeDatos instanciaUnica] rutaFichero] path]);

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
    return self.usuarios.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celdaUsuario" forIndexPath:indexPath];
    
    cell.textLabel.text = self.usuarios[indexPath.row][@"usuario"];
    cell.detailTextLabel.text = self.usuarios[indexPath.row][@"email"];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"verFacturas"])
    {
        FacturasTableViewController * escenaDestino = segue.destinationViewController;
        
        NSIndexPath *celdaSeleccionada = self.tableView.indexPathForSelectedRow;
        
        NSDictionary *jsonUsuario= self.usuarios[celdaSeleccionada.row];
        NSArray *jsonFacturas = jsonUsuario[@"facturas"];
        
        
        escenaDestino.facturas = jsonFacturas;
        escenaDestino.usuario = jsonUsuario[@"usuario"];
    }

}

#pragma mark - Navigation

- (IBAction)botonAnadirContactoPulsado:(id)sender {
    
    /// CREAMOS UNA ALERTA PARA GENERAR UN MENU DESPLEGABLE
    
    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:@"Add usuario"
                                                                    message:@"Introducir los datos del nuevo usuario"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    self.accionCrearUsuario = [UIAlertAction actionWithTitle:@"Aceptar"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action)
                               {
                                   [self crearNuevoUsuario];
                               }
                               ];
    
    
    
    self.accionCrearUsuario.enabled = false;
    
    /////////////////////////////////////
    /// ENTRADAS DEL MENU DESPLEGABLE ///
    /////////////////////////////////////
    /// Cancelar
    [alerta addAction:self.accionCrearUsuario];
    
    [alerta addAction:[UIAlertAction actionWithTitle:@"Cancelar"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    
    /// La propia alerta un campo de texto autoincrustado. Con este bloque de código
    /// puedo gestionar ese campo.
    [alerta addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.campoTextoNombreUsuario = textField;
        /// Texto en gris de ejemplo que aparece en el campo.
        self.campoTextoNombreUsuario.placeholder = @"Nombre de usuario";
        [self.campoTextoNombreUsuario addTarget:self
                                         action:@selector(campoTextoEditado:)
                               forControlEvents:UIControlEventEditingChanged]; /// Evento de control
    }];

    [alerta addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.campoTextoEmailUsuario = textField;
        self.campoTextoEmailUsuario.placeholder = @"EmailUsuario";
        [self.campoTextoEmailUsuario addTarget:self
                                        action:@selector(campoTextoEditado:)
                              forControlEvents:UIControlEventEditingChanged]; /// Evento de control
    }];
    
    [self presentViewController:alerta animated:true completion:nil];
    
}

-(void)campoTextoEditado:(UITextField*)textField
{
    /// Habilitamos el te
    self.accionCrearUsuario.enabled = self.campoTextoNombreUsuario.text.length > 0 && self.campoTextoEmailUsuario.text.length > 0;
}

-(void)crearNuevoUsuario
{
    /// FORMA BRUTA DE HACERLO
    /// NSDictionary * nuevoUsuario = [NSDictionary dictionaryWithObjectsAndKeys:self.campoTextoNombreUsuario.text, @"usuario", self.campoTextoEmailUsuario.text, @"email", [NSMutableArray array], @"facturas", nil];
    /// Sintaxis moderna de creacion de diccionarios en la implementación del método.
    
    NSDictionary * nuevoUsuario = @{ @"usuario" : self.campoTextoNombreUsuario.text,
                                     @"email" : self.campoTextoEmailUsuario.text,
                                     @"facturas" : [NSMutableArray array]};
        [self.usuarios addObject:nuevoUsuario];
        /// LE PASAMOS UN ARRAY DE UNA POSICIÓN USAMOS UNA SINtaXIS moderna de arrays
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.usuarios.count-1
                                                                    inSection:0] ]
                              withRowAnimation:UITableViewRowAnimationRight];
    
    /// LLAMAR A LA BASE DE DATOS a través del síngleton
    [[BaseDeDatos instanciaUnica] guardarCambios];
}

@end
