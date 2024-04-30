import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Components/platoCard.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dish_dash/pagines/menus/pagina_menu_client.dart';
import 'package:dish_dash/pagines/primersplats/pagina_primers_plats.dart';

class PaginaEntrants extends StatelessWidget {
  const PaginaEntrants({super.key});

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
                child: Text('Amanides', style: TextStyle(color: Colors.white)),
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
                child: Text('Fregits', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('entrants').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay entrants disponibles'));
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
