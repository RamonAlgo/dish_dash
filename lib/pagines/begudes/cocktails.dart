import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Components/platoCard.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Cocktails extends StatelessWidget {
  const Cocktails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktails'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cocktails').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay cocktails disponibles'));
          }

          List<Plat> platos = snapshot.data!.docs.map((DocumentSnapshot doc) {
            return Plat.fromFirestore(doc);
          }).toList();

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
