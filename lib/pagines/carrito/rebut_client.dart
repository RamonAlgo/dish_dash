import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaCarrito extends StatefulWidget {
  const PaginaCarrito({Key? key}) : super(key: key);

  @override
  State<PaginaCarrito> createState() => _PaginaCarritoState();
}

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
    );
  }
}
