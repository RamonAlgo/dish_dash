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
        borderRadius: BorderRadius.circular(20),
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
              fit: BoxFit.fill,
            ),
          ),

          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Precio: \€${plato.precio.toString()}'),
          ),*/

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${plato.precio.toString()}' + '€'),
              ),
              ElevatedButton(
                onPressed: () {
                  onAdd();
                  _mostrarPopup(context);
                },
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

 void _mostrarPopup(BuildContext context) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          width: MediaQuery.of(context).size.width, 
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              'Plat afegit al carrito',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.yellow),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 1)).then((value) => overlayEntry.remove());
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
