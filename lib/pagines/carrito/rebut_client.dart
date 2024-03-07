import 'package:flutter/material.dart';

class PaginaCarrito extends StatefulWidget {
  const PaginaCarrito({super.key});

  @override
  State<PaginaCarrito> createState() => _PaginaCarritoState();
}

class _PaginaCarritoState extends State<PaginaCarrito> {
  final List<Map<String, dynamic>> productosEnCarrito = [
    {'nombre': 'Pizza', 'cantidad': 1, 'precio': 9.99},
    {'nombre': 'Pasta', 'cantidad': 2, 'precio': 19.99},
  ];

  void eliminarDelCarrito(int index) {
    setState(() {
      productosEnCarrito.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu Compra'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                productosEnCarrito.clear();
              });
            },
          ),
        ],
      ),
      body: productosEnCarrito.isEmpty
          ? Center(child: Text('Carro buit '))
          : ListView.builder(
              itemCount: productosEnCarrito.length,
              itemBuilder: (context, index) {
                final producto = productosEnCarrito[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text(producto['nombre']),
                    subtitle: Text('Cantidad: ${producto['cantidad']}'),
                    trailing: Text('\€${producto['precio']}'),
                    onLongPress: () => eliminarDelCarrito(index),
                  ),
                );
              },
            ),
      bottomNavigationBar: productosEnCarrito.isNotEmpty
          ? SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {


                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  child: Text('Finalizar Compra '),
                ),
              ),
            )
          : null,
    );
  }
}
