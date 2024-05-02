import 'package:flutter/material.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlatoCard extends StatelessWidget {
  final Plat plato;
  final VoidCallback onAdd;

  const PlatoCard({
    Key? key,
    required this.plato,
    required this.onAdd,
  }) : super(key: key);

  String _getCollectionName(String tipoPlato) {
  switch (tipoPlato) {
    case 'Bebidas':
      return 'bebidas';
    case 'Entrants':
      return 'entrants';
    case 'PrimersPlats':
      return 'primersPlats';
    case 'Postre':
      return 'postres';
    default:
      return 'unknown';
  }
}

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
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
              .collection(_getCollectionName(plato.tipoPlato))
              .doc(plato.idPlat)
              .get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return Expanded(child: Center(child: Text("Error al cargar datos: ${snapshot.error}")));
              }
              if (snapshot.hasData && snapshot.data!.exists) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                String imageUrl = data['ImageUrl'];
                if (imageUrl == null) {
                  return Expanded(child: Center(child: Text("Imagen no disponible")));
                }
                return Expanded(
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;  
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Text(exception.toString());
                    },
                  ),
                );
              }
              return Expanded(child: Center(child: Text("Imagen no disponible")));
            },
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${plato.precio.toString()}' + '€'),
              ),
              ElevatedButton(
                onPressed: () {
                  onAdd();
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
      )
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