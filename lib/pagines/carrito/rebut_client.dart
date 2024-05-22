import 'package:dish_dash/Clases/Menu.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/pagines/carrito/paginacomandes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
          title: const Text("Eliminar producto"),
          content: const Text("¿Estás seguro?"),
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

  void mostrarAlertaAntesDeEliminarMenu(Menu menu) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar menú"),
          content: const Text("¿Estás seguro?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Sí"),
              onPressed: () {
                Provider.of<ModelDades>(context, listen: false)
                    .reducirCantidadMenu(menu);
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
    final carrito2 = Provider.of<ModelDades>(context).menusGlobal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              String mesaId = await obtenerYProcesarEmail();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaginaMenjarDemanat(mesaId: mesaId),
                ),
              );
            },
          ),
        ],
      ),
      body: carrito.isEmpty && carrito2.isEmpty
          ? const Center(child: Text('El carrito está vacío'))
          : ListView.builder(
              itemCount: carrito.length + carrito2.length,
              itemBuilder: (context, index) {
                if (index < carrito.length) {
                  final plato = carrito[index];
                  return ListTile(
                    title: Text(plato.nombrePlato),
                    subtitle:
                        Text('Precio: ${plato.precio * plato.cantidad} €'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (plato.cantidad == 1) {
                              mostrarAlertaAntesDeEliminar(plato);
                            } else {
                              Provider.of<ModelDades>(context, listen: false)
                                  .reducirCantidad(plato);
                            }
                          },
                        ),
                        Text('${plato.cantidad}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Provider.of<ModelDades>(context, listen: false)
                                .aumentarCantidad(plato);
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  final menuIndex = index - carrito.length;
                  final menu = carrito2[menuIndex];
                  return ListTile(
                    title: Text(menu.nombreMenu),
                    subtitle:
                        Text('Precio: ${menu.precio * menu.cantidad} €'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (menu.cantidad == 1) {
                              mostrarAlertaAntesDeEliminarMenu(menu);
                            } else {
                              Provider.of<ModelDades>(context, listen: false)
                                  .reducirCantidadMenu(menu);
                            }
                          },
                        ),
                        Text('${menu.cantidad}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Provider.of<ModelDades>(context, listen: false)
                                .aumentarCantidadMenu(menu);
                          },
                        ),
                      ],
                    ),
                  );
                }
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
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text(
              'Confirmar pedido',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> obtenerYProcesarEmail() async {
    final User? usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null && usuario.email != null) {
      String email = usuario.email!;
      List<String> partes = email.split('@');
      if (partes.isNotEmpty) {
        return partes[0];
      }
    }
    return 'defaultMesaId'; 
  }

  void insertarDatos() async {
    final carrito = Provider.of<ModelDades>(context, listen: false).carritoGlobal;
    final carrito2 = Provider.of<ModelDades>(context, listen: false).menusGlobal;
    String idmesa = await obtenerYProcesarEmail(); 

    DocumentSnapshot snapshot = await firestore.collection('mesas').doc(idmesa).get();

    final List<Map<String, dynamic>> platosData = carrito.map((plato) {
      return {
        'idPlat': plato.idPlat,
        'nom': plato.nombrePlato,
        'cantitat': plato.cantidad,
        'preu': plato.precio,
        'entregado': false
      };
    }).toList();

    final List<Map<String, dynamic>> menusData = carrito2.map((menu) {
      return {
        'menuId': menu.id, 
        'Descripcion': menu.descripcion,
        'IDsPlatos': menu.idsPlatos,
        'NombreMenu': menu.nombreMenu,
        'Precio': menu.precio,
        'Cantidad': menu.cantidad,
        'Entregado': false
      };
    }).toList();

    if (snapshot.exists) {
      firestore.collection('mesas').doc(idmesa).update({
        'platos': FieldValue.arrayUnion(platosData),
        'menus': FieldValue.arrayUnion(menusData),
        'timestamp': Timestamp.now()
      }).then((_) {
        Provider.of<ModelDades>(context, listen: false).vaciarCarrito();
        showAwesomeSnackbar(context, 'Pedido confirmado.', ContentType.success);
      }).catchError((error) {
        print('Error al insertar datos: $error');
        showAwesomeSnackbar(context, 'Error al confirmar pedido: $error', ContentType.failure);
      });
    } else {
      firestore.collection('mesas').doc(idmesa).set({
        'platos': platosData,
        'menus': menusData,
        'mesaId': idmesa,
        'timestamp': Timestamp.now()
      }).then((_) {
        Provider.of<ModelDades>(context, listen: false).vaciarCarrito();
        showAwesomeSnackbar(context, 'Pedido confirmado.', ContentType.success);
      }).catchError((error) {
        print('Error al insertar datos: $error');
        showAwesomeSnackbar(context, 'Error al confirmar pedido: $error', ContentType.failure);
      });
    }
  }

  void showAwesomeSnackbar(BuildContext context, String message, ContentType contentType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        content: AwesomeSnackbarContent(
          title: contentType == ContentType.success ? 'Éxito' : 'Error',
          message: message,
          contentType: contentType,
        ),
      ),
    );
  }
}
