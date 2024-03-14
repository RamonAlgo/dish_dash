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
                Provider.of<ModelDades>(context, listen: false).removerDelCarrito(plato);
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
            Provider.of<ModelDades>(context, listen: false).vaciarCarrito();
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
                subtitle: Text('Precio: ${plato.precio}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        //reduir cantitat de plats 
                      },
                    ),
                    Text('1'), 
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        //  aumentar  cantidad
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
