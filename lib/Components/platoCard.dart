import 'package:flutter/material.dart';
import 'package:dish_dash/Clases/Plat.dart'; // Asegúrate de que la ruta de importación sea correcta

class PlatoCard extends StatelessWidget {
  final Plat plato;
  final VoidCallback onAdd;

  const PlatoCard({
    Key? key,
    required this.plato,
    required this.onAdd,
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
              plato.nombrePlato,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.green),
            ),
          ),
          Expanded(
            child: Image.asset(
              plato.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          if (plato.descripcion.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                plato.descripcion,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Precio: \€${plato.precio.toString()}'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _mostrarDialogoIngredientes(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('Info'),
              ),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('Demanar'),
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
                  plato.nombrePlato,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                SizedBox(height: 10),
                const Text(
                  "Ingredientes:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...plato.ingredientes
                    .map((ingrediente) => Text(ingrediente))
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
