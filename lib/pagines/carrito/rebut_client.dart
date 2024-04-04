import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaCarrito extends StatefulWidget {
  const PaginaCarrito({Key? key}) : super(key: key);

  @override
  State<PaginaCarrito> createState() => _PaginaCarritoState();
}
  final FirebaseAuth auth = FirebaseAuth.instance;


class _PaginaCarritoState extends State<PaginaCarrito> {
  void mostrarAlertaAntesDeEliminar(Plat plato) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar producte"),
          content: const Text("Estas segur?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Sí"),
              onPressed: () {
                Provider.of<ModelDades>(context, listen: false)
                    .removerDelCarrito(plato);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<ModelDades>(context).carritoGlobal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              final TextEditingController _usernameController =
                  TextEditingController();
              final TextEditingController _passwordController =
                  TextEditingController();

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Accés Administratiu"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Usuari',
                          ),
                        ),
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Contrasenya',
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text("Confirmar"),
                        onPressed: () {
                          if (_usernameController.text == 'admin' &&
                              _passwordController.text == 'admin') {
                            Provider.of<ModelDades>(context, listen: false)
                                .vaciarCarrito();

                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Credencials incorrectes"),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: carrito.isEmpty
          ? Center(child: Text('El carrito está vacío'))
          : ListView.builder(
              itemCount: carrito.length,
              itemBuilder: (context, index) {
                final plato = carrito[index];
                return ListTile(
                  title: Text(plato.nombrePlato),
                  subtitle: Text('Precio: ${plato.precio*plato.cantidad }'+ ' €'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (plato.cantidad == 1) {
                            mostrarAlertaAntesDeEliminar(plato);
                          } else {
                            Provider.of<ModelDades>(context, listen: false)
                                .reducirCantidad(plato);
                          }
                        },
                      ),
                      Text(
                          '${plato.cantidad}'), 
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Provider.of<ModelDades>(context, listen: false)
                              .aumentarCantidad(plato);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí llamas a la función para obtener y procesar el email del usuario
          obtenerYProcesarEmail();
        },
        child: Icon(Icons.visibility),
        tooltip: 'Ver Usuario',
      ),
    );
  }
  void obtenerYProcesarEmail() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? usuario = auth.currentUser;

  if (usuario != null && usuario.email != null) {
    String email = usuario.email!; 

    procesarEmail(email);
  } else {
    print("No hay usuario logueado o el usuario no tiene un email.");
  }
}
void procesarEmail(String email) {
  List<String> partes = email.split('@');

  if (partes.isNotEmpty) {
    String parteDeseada = partes[0];
    print(parteDeseada);
    // llamada a insertarDatos
  } else {
    print("El email no se pudo procesar correctamente.");
  }
}

  void insertarDatos() {

  User? usuario = auth.currentUser;
  String idusuario;
 //interaccionar con una coleccion o otra en funcion del usuario que sea.
}
}
