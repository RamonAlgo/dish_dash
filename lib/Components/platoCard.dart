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
              fit: BoxFit.cover,
            ),
          ),
          if (plato.descripcion.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                plato.descripcion,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Precio: \$${plato.precio.toString()}'),
          ),
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
   
            ),
            child: const Text('Demanar'),
          ),
        ],
      ),
    );
  }
}
