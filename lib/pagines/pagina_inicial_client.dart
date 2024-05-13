import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/pagines/begudes/pagina_begudes.dart';
import 'package:dish_dash/pagines/carrito/rebut_client.dart';
import 'package:dish_dash/pagines/menus/pagina_menu_client.dart';
import 'package:dish_dash/pagines/postres/pagina_postres.dart';
import 'package:dish_dash/pagines/primersplats/pagina_primers_plats.dart';
import 'package:dish_dash/pagines/entrants/pagina_entrants.dart';
import 'package:provider/provider.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/Components/platoCard.dart'; // Asegúrate de importar el archivo donde está definido PlatoCard

class PaginaInicialClient extends StatelessWidget {
  const PaginaInicialClient({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentYear = DateTime.now().year;
    final String currentMonth = DateTime.now().month.toString().padLeft(2, '0');

    Future<List<Plat>> fetchDocuments(List<String> documentIDs) async {
      List<Plat> plats = [];

      for (String docID in documentIDs) {
        String collection = '';

        if (docID.contains('En')) {
          collection = 'entrants';
        } else if (docID.contains('Pp')) {
          collection = 'primersPlats';
        } else if (docID.contains('Po')) {
          collection = 'postres';
        } else if (docID.contains('Be')) {
          collection = 'bebidas';
        }

        if (collection.isNotEmpty) {
          DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
              .collection(collection)
              .doc(docID)
              .get();

          if (docSnapshot.exists) {
            Plat plat = Plat.fromFirestore(docSnapshot);
            plats.add(plat);
          }
        }
      }

      return plats;
    }

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
                child: Text('Menús', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaginaBegudes()));
                },
                child: Text('Begudes', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaEntrants()));
                },
                child: Text('Entrants', style: TextStyle(color: Colors.white)),
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
                child: Text('Primers Plats',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaginaPostres()));
                },
                child: Text('Postres', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaginaCarrito()));
                },
                child: Text('Carrito', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        actions: <Widget>[],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('estadisticas')
            .doc(currentYear.toString())
            .collection('meses')
            .doc(currentMonth)
            .collection('platos')
            .orderBy('cantidad', descending: true) // Ordena por 'cantidad' descendente
            .limit(6) // Limita la consulta a 6 documentos
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<String> documentIDs = snapshot.data!.docs.map((doc) => doc.id).toList();

            return FutureBuilder<List<Plat>>(
              future: fetchDocuments(documentIDs),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Plat>> innerSnapshot) {
                if (innerSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (innerSnapshot.hasError) {
                  return Center(child: Text('Error: ${innerSnapshot.error}'));
                }

                if (innerSnapshot.hasData && innerSnapshot.data!.isNotEmpty) {
                  List<Plat> plats = innerSnapshot.data!;

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
                } else {
                  return Center(child: Text('No hay datos disponibles'));
                }
              },
            );
          } else {
            return Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }
}
