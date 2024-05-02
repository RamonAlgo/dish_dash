import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/Components/platoCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaCeliacs extends StatelessWidget {
  const PaginaCeliacs ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Celiacs'),
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
              if (caracteristicas['Celiacs'] == true) {
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
                  final snackBar = SnackBar(
                    backgroundColor: Color.fromARGB(255, 92, 174, 99),
                    content: Text('${plato.nombrePlato} añadido al carrito'),
                  );
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                },
              );
            },
          );
        },
      ),
    );
  }
}