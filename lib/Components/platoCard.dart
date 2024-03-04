import 'package:flutter/material.dart';

class PlatoCard extends StatelessWidget {
  final String imageUrl;
  final String nombrePlato;
  final String descripcion;

  const PlatoCard({
    Key? key,
    required this.imageUrl,
    required this.nombrePlato,
    this.descripcion = "",
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
              style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.green),
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
                style: TextStyle(color: Colors.grey), // Puedes ajustar este color según tu preferencia
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Implementar funcionalidad para mostrar ingredientes
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Fondo del botón
                    onPrimary: Colors.white, // Color del texto
                  ),
                  child: const Text('Info'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Implementar funcionalidad para realizar un pedido
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Fondo del botón
                    onPrimary: Colors.white, // Color del texto
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
}
