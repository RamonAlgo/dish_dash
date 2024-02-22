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
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded( // Hace que la imagen ocupe todo el espacio disponible hasta los botones
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
                  child: const Text('Info'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Implementar funcionalidad para realizar un pedido
                  },
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

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Menú'),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Ajusta esto para que la tarjeta tenga más espacio
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1, // Ajusta la proporción para que la imagen y el texto se muestren correctamente
          ),
          itemCount: 6, // Ajusta según la cantidad de elementos que desees mostrar
          itemBuilder: (context, index) {
            return PlatoCard(
              imageUrl: 'images/plato${index + 1}.png', // Asegúrate de que la ruta coincide con la estructura de tu proyecto
              nombrePlato: 'Nom del plat ${index +1 }',
              descripcion: 'Descripció del plat $index',
            );
          },
        ),
      ),
    ),
  );
}
