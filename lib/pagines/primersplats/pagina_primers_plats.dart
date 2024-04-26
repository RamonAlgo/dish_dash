import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/pagines/menus/pagina_menu_client.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/Components/platoCard.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


class PaginaPrimersPlats extends StatelessWidget {
  const PaginaPrimersPlats({super.key});

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
                child: Text('Pizza', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaMenuClient()));
                },
                child: Text('Pasta', style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaMenuClient()));
                },
                child: Text('Peix', style: TextStyle(color: Colors.white)),
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
                child: Text('Carn', style: TextStyle(color: Colors.white)),
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
                child: Text('Vegà', style: TextStyle(color: Colors.white)),
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
                child: Text('Celìacs', style: TextStyle(color: Colors.white)),
              ),
            ),

            // añadir mas aqui
          ],
        ),
        actions: <Widget>[],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('primersPlats').doc('Pp2').snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Text('No data available'); // Maneja el caso en que no hay datos disponibles
          }

          // Convierte los datos a un tipo Map<String, dynamic>
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          // Crea un objeto Plat con los datos del documento "Pp1"
          Plat plat = Plat(
            idPlat: snapshot.data!.id,
            imageUrl: data['ImageUrl'] ?? '',
            nombrePlato: data['NombrePlato'] ?? '',
            descripcion: data['Descripcion'] ?? '',
            ingredientes: List<String>.from(data['Ingredientes'] ?? []),
            precio: (data['Precio'] ?? 0.0).toDouble(),
            cantidad: 1,
            carn: data['Carn'] ?? false,
            celiacs: data['Celiacs'] ?? false,
            pasta: data['Pasta'] ?? false,
            peix: data['Peix'] ?? false,
            pizza: data['Pizza'] ?? false,
            vega: data['Vega'] ?? false,
          );

          // Muestra el nombre del plato en la pantalla
          return Center(
            child: Text(plat.getNombre),
          );
        },
      ),
    );
  }
}