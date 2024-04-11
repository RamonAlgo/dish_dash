import 'package:dish_dash/Clases/Plat.dart';
import 'package:dish_dash/Clases/model_dades.dart';
import 'package:dish_dash/pagines/menus/pagina_menu_client.dart';
import 'package:flutter/material.dart';
import 'package:dish_dash/Components/platoCard.dart';
import 'package:provider/provider.dart';

class PaginaPrimersPlats extends StatelessWidget {
  const PaginaPrimersPlats({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Plat> platos = [
     Plat(
        idPlat: 'p1',
        imageUrl: 'images/pizzamargarita.png',
        nombrePlato: 'Pizza Margarita',
        descripcion: 'Pizza Margarita',
        ingredientes: ['Tomate', 'Queso', 'Piña'],
        precio: 10,
      ),
      Plat(
        idPlat: 'p2',
        imageUrl: 'images/pizza4quesos.png',
        nombrePlato: 'Pizza 4 formatges',
        descripcion: 'Pizza 4 formatges',
        ingredientes: ['Tomate', 'Queso', 'Piña'],
        precio: 10,
      ),
      Plat(
        idPlat: 'p3',
        imageUrl: 'images/pizzacarbonara.png',
        nombrePlato: 'Pizza Carbonara',
        descripcion: 'Pizza Carbonara',
        ingredientes: ['Tomate', 'Queso', 'Piña'],
        precio: 10,
      ),
      Plat(
        idPlat: 'p4',
        imageUrl: 'images/pizza4estacions.png',
        nombrePlato: 'Pizza 4 estacions ',
        descripcion: 'Pizza 4 estacions',
        ingredientes: ['Tomate', 'Queso', 'Piña'],
        precio: 10,
      ),
      Plat(
        idPlat: 'p5',
        imageUrl: 'images/pizzabolonyesa.png',
        nombrePlato: 'Pizza bolonyesa',
        descripcion: 'Pizza bolonyesa',
        ingredientes: ['Tomate', 'Queso', 'Piña'],
        precio: 10,
      ),
      Plat(
        idPlat: 'p6',
        imageUrl: 'images/pizzaambpinya.png',
        nombrePlato: 'Pizza amb pinya',
        descripcion: 'Pizza amb pinya',
        ingredientes: ['Tomate', 'Queso', 'Piña'],
        precio: 10,
      ),
    ];

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
            plato: plato,
            onAdd: () {
              Provider.of<ModelDades>(context, listen: false)
                  .agregarAlCarrito(plato);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${plato.nombrePlato} añadido')),
              );
            },
          );
        },
      ),
    );
  }
}

