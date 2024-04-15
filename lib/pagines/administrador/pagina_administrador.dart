import 'package:flutter/material.dart';

class PaginaAdministrador extends StatefulWidget {
  const PaginaAdministrador({Key? key}) : super(key: key);

  @override
  State<PaginaAdministrador> createState() => _PaginaAdministradorState();
}

class _PaginaAdministradorState extends State<PaginaAdministrador> {
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Plato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nombre:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  hintText: 'Introduce el nombre del plato',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              const Text(
                'Descripción:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  hintText: 'Introduce la descripción del plato',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              const Text(
                'Ingredientes:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _ingredientesController,
                decoration: const InputDecoration(
                  hintText: 'Introduce los ingredientes del plato',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              const Text(
                'Precio:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _precioController,
                decoration: const InputDecoration(
                  hintText: 'Introduce el precio del plato',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  //imagen
                },
                child: Text('Subir Imagen'),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String ingredientes = _ingredientesController.text;
                    String nombre = _nombreController.text;
                    String descripcion = _descripcionController.text;
                    double precio =
                        double.tryParse(_precioController.text) ?? 0.0;
                    //añadir plato a la bbdd
                  },
                  child: Text('Añadir Plato'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
