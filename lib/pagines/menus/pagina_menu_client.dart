import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/Components/menuCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:dish_dash/Clases/Menu.dart';
import 'package:provider/provider.dart'; 

class PaginaMenuClient extends StatelessWidget {
  const PaginaMenuClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menús'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menus').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Menu> menus = [];
            snapshot.data!.docs.forEach((DocumentSnapshot doc) {
              if (doc.id != 'counter') {
                final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                final Menu menu = Menu(
                  descripcion: data['Descripcion'],
                  idsPlatos: List<String>.from(data['IDsPlatos']),
                  nombreMenu: data['NombreMenu'],
                  precio: data['Precio'].toDouble(), id: '',
                );
                menus.add(menu);
              }
            });
            return Container(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: menus.length,
                itemBuilder: (BuildContext context, int index) {
                  return MenuWidget(
                    imageUrl: menus[index].imageUrl,
                    nombreMenu: menus[index].nombreMenu, 
                    precio: menus[index].precio, 
                    idsPlatos: menus[index].idsPlatos, 
                    onAdd: () {
                      Provider.of<ModelDades>(context, listen: false).agregarMenuAlCarrito(Menu(
                        nombreMenu: menus[index].nombreMenu, 
                        descripcion: menus[index].descripcion, 
                        idsPlatos: menus[index].idsPlatos, 
                        precio: menus[index].precio,
                        id: menus[index].id,
                      ));
                      final snackBar = SnackBar(
                        backgroundColor: Color.fromARGB(255, 92, 174, 99),
                        content: Text('${menus[index].nombreMenu} añadido al carrito'),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
