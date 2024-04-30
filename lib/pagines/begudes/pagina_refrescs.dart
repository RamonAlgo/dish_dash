import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/Components/platoCard.dart';

class Refrescs extends StatelessWidget {
  const Refrescs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Refrescs'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('bebidas').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay refrescs disponibles'));
          }

          List<Plat> platos = snapshot.data!.docs.map((DocumentSnapshot doc) {
            var data = doc.data() as Map<String, dynamic>;
            if (data['Refrescs'] == true) {
              return Plat.fromFirestore(doc);
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
