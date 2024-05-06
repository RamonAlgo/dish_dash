import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/pagines/primersplats/pagina_carn.dart';
import 'package:dish_dash/pagines/primersplats/pagina_celiacs.dart';
import 'package:dish_dash/pagines/primersplats/pagina_pasta.dart';
import 'package:dish_dash/pagines/primersplats/pagina_peix.dart';
import 'package:dish_dash/pagines/primersplats/pagina_pizza.dart';
import 'package:dish_dash/pagines/primersplats/pagina_vega.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/Components/platoCard.dart';
import 'package:provider/provider.dart';

class PaginaPrimersPlats extends StatelessWidget {
  final String domain;
  const PaginaPrimersPlats({super.key,required this.domain});

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
                        MaterialPageRoute(builder: (context) => PaginaPizza()));
                  },
                  child: Text('Pizza', style: TextStyle(color: Colors.white)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PaginaPasta()));
                  },
                  child: Text('Pasta', style: TextStyle(color: Colors.white)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PaginaPeix()));
                  },
                  child: Text('Peix', style: TextStyle(color: Colors.white)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PaginaCarn()));
                  },
                  child: Text('Carn', style: TextStyle(color: Colors.white)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PaginaVega()));
                  },
                  child: Text('Vegà', style: TextStyle(color: Colors.white)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaginaCeliacs()));
                  },
                  child: Text('Celìacs', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          actions: <Widget>[],
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('primersPlats').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No hay platos disponibles'));
            }
            List<Plat> plats = snapshot.data!.docs
                .where((doc) => doc.id != 'counter')
                .map((DocumentSnapshot doc) {
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
                    Provider.of<ModelDades>(context, listen: false)
                        .agregarAlCarrito(plato);
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
        ));
  }
}
