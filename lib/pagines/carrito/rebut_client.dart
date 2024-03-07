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

  void aumentarCantidad(int index) {
    setState(() {
      productosEnCarrito[index]['cantidad']++;
    });
  }

  void reducirCantidad(int index) {
    setState(() {
      productosEnCarrito[index]['cantidad']--;
      if (productosEnCarrito[index]['cantidad'] == 0) {
        mostrarAlertaAntesDeEliminar(index);
      }
    });
  }

  void vaciarCarritoConAutenticacion() {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible:
          false, 
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
                  setState(() {
                    productosEnCarrito.clear();
                  });
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
  }

  void eliminarDelCarrito(int index) {
    setState(() {
      productosEnCarrito.removeAt(index);
    });
  }

  void mostrarAlertaAntesDeEliminar(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar producte"),
          content: const Text("Estas segur que el vols eliminar?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
                aumentarCantidad(index);
              },
            ),
            TextButton(
              child: const Text("Sí"),
              onPressed: () {
                eliminarDelCarrito(index);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Resum'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed:vaciarCarritoConAutenticacion,
          ),
        ],
      ),
      body: productosEnCarrito.isEmpty
          ? Center(child: Text('Carretó buit'))
          : ListView.builder(
              itemCount: productosEnCarrito.length,
              itemBuilder: (context, index) {
                final producto = productosEnCarrito[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(Icons.fastfood),
                    title: Text(producto['nombre']),
                    subtitle: Text('${producto['precio']} \€ '),
                    trailing: FittedBox(
                      fit: BoxFit.fill,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => reducirCantidad(index),
                          ),
                          Text('${producto['cantidad']}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => aumentarCantidad(index),
                          ),
                        ],
                      ),
                    ),
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  child: Text('Finalizar Compra'),
                ),
              ),
            )
          : null,
    );
  }
}
