import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/Components/platoCard.dart';
import 'package:dish_dash/pagines/begudes/cocktails.dart';
import 'package:dish_dash/pagines/begudes/pagina_refrescs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class PaginaBegudes extends StatelessWidget {
  const PaginaBegudes({super.key});

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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Refrescs()));
                },
                child: Text('Refrescs ', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cocktails()));
                },
                child: Text('Cocktails ', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('bebidas').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay platos disponibles'));
          }

          List<Plat> plats = snapshot.data!.docs.map((DocumentSnapshot doc) {
            if (doc.id == "counter") {
              return null;
            }
            return Plat.fromFirestore(doc);
          }).whereType<Plat>().toList();

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
      )
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