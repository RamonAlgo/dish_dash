import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/Components/platoCard.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/pagines/menus/pagina_menu_client.dart';
import 'package:dish_dash/pagines/primersplats/pagina_primers_plats.dart';
import 'package:provider/provider.dart';

class PaginaPostres extends StatelessWidget {
  const PaginaPostres({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaMenuClient()));
                },
                child: Text('Fruita', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaPrimersPlats()));
                },
                child: Text('Gelats ', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaPrimersPlats()));
                },
                child: Text('Freds ', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaPrimersPlats()));
                },
                child: Text('Semifreds ', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaPrimersPlats()));
                },
                child: Text('Calents ', style: TextStyle(color: Colors.white)),
              ),
            ),
            // añadir más aquí
          ],
        ),
        actions: <Widget>[],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('postres').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay postres disponibles'));
          }

          List<Plat> plats = snapshot.data!.docs.map((DocumentSnapshot doc) {
            return Plat.fromFirestore(doc);
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: plats.length,
            itemBuilder: (context, index) {
              final plato = plats[index];
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