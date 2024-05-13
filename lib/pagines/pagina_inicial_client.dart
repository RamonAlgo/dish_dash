import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/pagines/begudes/pagina_begudes.dart';
import 'package:dish_dash/pagines/carrito/rebut_client.dart';
import 'package:dish_dash/pagines/menus/pagina_menu_client.dart';
import 'package:dish_dash/pagines/postres/pagina_postres.dart';
import 'package:dish_dash/pagines/primersplats/pagina_primers_plats.dart';
import 'package:dish_dash/pagines/entrants/pagina_entrants.dart';

class PaginaInicialClient extends StatelessWidget {
  const PaginaInicialClient({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentYear = DateTime.now().year;
    final String currentMonth = DateTime.now().month.toString().padLeft(2, '0');

    Future<List<Map<String, dynamic>>> fetchDocuments(
        List<String> documentIDs) async {
      List<Map<String, dynamic>> documents = [];

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
            documents.add({
              'id': docSnapshot.id,
              'data': docSnapshot.data(),
              'collection': collection
            });
          }
        }
      }

      return documents;
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

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchDocuments(documentIDs),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> innerSnapshot) {
                if (innerSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (innerSnapshot.hasError) {
                  return Center(child: Text('Error: ${innerSnapshot.error}'));
                }

                if (innerSnapshot.hasData && innerSnapshot.data!.isNotEmpty) {
                  List<Map<String, dynamic>> documents = innerSnapshot.data!;

                  return ListView(
                    children: documents.map((doc) {
                      return ListTile(
                        title: Text(doc['id']),
                        subtitle: Text(
                            'Collection: ${doc['collection']}\nData: ${doc['data']}'),
                      );
                    }).toList(),
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
