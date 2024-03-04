import 'package:dish_dash/Clases/Plat.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/Components/platoCard.dart';

class PaginaMenuClient extends StatelessWidget {
  const PaginaMenuClient({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Plat> platos = [
      Plat(
        imageUrl: 'assets/images/menuinfantil.png',
        nombrePlato: 'Menú Infantil ',
        descripcion: 'Pizza Margarita',
      ),
      Plat(
        imageUrl: 'assets/images/menuadult.png',
        nombrePlato: 'Menú adult ',
        descripcion: 'Menú adult',
      ),Plat(
        imageUrl: 'assets/images/menudenit.png',
        nombrePlato: 'Menú de nit ',
        descripcion: 'Menú de nit',
      ),Plat(
        imageUrl: 'assets/images/menudegustacio.png',
        nombrePlato: 'Menú degustació',
        descripcion: 'Menú degustació',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Menús'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: platos.length,
        itemBuilder: (context, index) {
          final plato = platos[index];
          return PlatoCard(
            imageUrl: plato.imageUrl,
            nombrePlato: plato.nombrePlato,
            descripcion: plato.descripcion,
          );
        },
      ),
    );
  }
}
