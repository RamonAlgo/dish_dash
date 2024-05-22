import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/pagines/begudes/pagina_begudes.dart';
import 'package:dish_dash/pagines/carrito/rebut_client.dart';
import 'package:dish_dash/pagines/menus/pagina_menu_client.dart';
import 'package:dish_dash/pagines/postres/pagina_postres.dart';
import 'package:dish_dash/pagines/primersplats/pagina_primers_plats.dart';
import 'package:dish_dash/pagines/entrants/pagina_entrants.dart';
import 'package:flutter/material.dart';

class PaginaInicialClient extends StatelessWidget {
  const PaginaInicialClient({super.key});

  @override
  Widget build(BuildContext context) {

    final int currentYear = DateTime.now().year;
    final String currentMonth = DateTime.now().month.toString().padLeft(2, '0');
    
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
                      MaterialPageRoute(builder: (context) => PaginaMenuClient()));
                },
                child: Text('Menús', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaginaPostres()));
                },
                child: Text('Postres', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
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
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

            return ListView(
              children: documents.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(doc.id),
                  subtitle: Text(data.toString()),
                );
              }).toList(),
            );
          } else {
            return Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }
}
