import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/Components/platoCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class PaginaPizza extends StatelessWidget {
  const PaginaPizza ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pizza'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('primersPlats').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay amanides disponibles'));
          }

          List<Plat> platos = snapshot.data!.docs.map((DocumentSnapshot doc) {
            if (doc.id == "counter") {
              return null;
            }
            var data = doc.data() as Map<String, dynamic>;
            if (data['Caracteristicas'] != null) {
              var caracteristicas = data['Caracteristicas'] as Map<String, dynamic>;
              if (caracteristicas['Pizza'] == true) {
                return Plat.fromFirestore(doc);
              }
            }
            return null;
          }).whereType<Plat>().toList();

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: platos.length,
            itemBuilder: (context, index) {
              final plato = platos[index];
              return PlatoCard(
                plato: plato,
                onAdd: () {
                  Provider.of<ModelDades>(context, listen: false).agregarAlCarrito(plato);
                  showAwesomeSnackbar(
                    context,
                    '${plato.nombrePlato} añadido al carrito',
                    ContentType.success,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
  void showAwesomeSnackbar(BuildContext context, String message, ContentType contentType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: AwesomeSnackbarContent(
          title: contentType == ContentType.success ? 'Éxito' : 'Error',
          message: message,
          contentType: contentType,
        ),
      ),
    );
  }
}
