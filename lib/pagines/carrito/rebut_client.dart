import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginaCarrito extends StatefulWidget {
  const PaginaCarrito({Key? key}) : super(key: key);

  @override
  State<PaginaCarrito> createState() => _PaginaCarritoState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
                  subtitle:
                      Text('Precio: ${plato.precio * plato.cantidad}' + ' €'),
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
                            print(Provider.of<ModelDades>(context,
                                listen: false));
                          }
                        },
                      ),
                      Text('${plato.cantidad}'),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 32, 
          child: ElevatedButton(
            onPressed: () {
              insertarDatos();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0), 
            ),
            child: Text(
              'Confirmar pedido',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  obtenerYProcesarEmail() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? usuario = auth.currentUser;

    if (usuario != null && usuario.email != null) {
      String email = usuario.email!;

      return procesarEmail(email);
    } else {
      print("No hay usuario logueado o el usuario no tiene un email.");
    }
  }

  procesarEmail(String email) {
    List<String> partes = email.split('@');

    if (partes.isNotEmpty) {
      String parteDeseada = partes[0];
      return (parteDeseada);
      // llamada a insertarDatos
    } else {}
  }

  void insertarDatos() {
    final carrito =
        Provider.of<ModelDades>(context, listen: false).carritoGlobal;
    String idmesa = obtenerYProcesarEmail();
    print(idmesa);
    if (carrito.isNotEmpty) {
      final List<Map<String, dynamic>> platosData = carrito.map((plato) {
        return {
          'idPlat': plato.idPlat,
          'nom': plato.nombrePlato,
          'cantitat': plato.cantidad,
          'preu': plato.precio,
          'entregado':false
        };
      }).toList();
      print(platosData);
      firestore
          .collection('mesas')
          .doc(idmesa)
          .set({'platos': platosData}).then((_) {
        print('Datos insertados correctamente');
      }).catchError((error) {
        print('Error al insertar datos: $error');
      });
    } else {
      print('El carrito está vacío');
    }
  }
}
