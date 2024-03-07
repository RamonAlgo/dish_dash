import 'package:flutter/material.dart';

class menuCard extends StatelessWidget {
  final String imageUrl;
  final String nombrePlato;
  final String descripcion;
  final List<String> ingredientes; // Nuevo parámetro para los ingredientes

  const menuCard({
    Key? key,
    required this.imageUrl,
    required this.nombrePlato,
    this.descripcion = "",
    required this.ingredientes, // Inicializar en el constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              nombrePlato,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.green),
            ),
          ),
          Expanded(
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          if (descripcion.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                descripcion,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _mostrarDialogoIngredientes(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Continguts'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Implementar funcionalidad para realizar un pedido
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Demanar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoIngredientes(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0.85),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints(maxHeight: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nombrePlato,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                SizedBox(height: 10),
                Text(
                  "Ingredientes:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...ingredientes.map((ingrediente) => Text(ingrediente)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}