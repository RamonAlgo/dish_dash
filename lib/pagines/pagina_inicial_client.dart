import 'package:dish_dash/Clases/Plat.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/Components/platoCard.dart';

class PaginaInicialClient extends StatelessWidget {
  const PaginaInicialClient({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Plat> platos = [
      Plat(
        imageUrl: 'assets/images/pizzamargarita.png',
        nombrePlato: 'Pizza Margarita',
        descripcion: 'Pizza Margarita',
      ),
      Plat(
        imageUrl: 'assets/images/pizza4formatges.png',
        nombrePlato: 'Pizza 4 formatges',
        descripcion: 'Pizza 4 formatges',
      ),
      Plat(
        imageUrl: 'assets/images/pizzacarbonara.png',
        nombrePlato: 'Pizza Carbonara',
        descripcion: 'Pizza Carbonara',
      ),
      Plat(
        imageUrl: 'assets/images/pizza4estacions.png',
        nombrePlato: 'Pizza 4 estacions ',
        descripcion: 'Pizza 4 estacions',
      ),
      Plat(
        imageUrl: 'assets/images/pizzabolonyesa.png',
        nombrePlato: 'Pizza bolonyesa',
        descripcion: 'Pizza bolonyesa',
      ),
      Plat(
        imageUrl: 'assets/images/pizzaambpinya.png',
        nombrePlato: 'Pizza amb pinya',
        descripcion: 'Pizza amb pinya',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pizzes'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
